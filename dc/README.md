# VxLAN in a Spine-Leaf Data Centre

This lab extends a VxLAN over a spine-leaf topology consisting of two spine and three leaf routers. Four hosts are connected to the three leaf switches. The hosts belong to two VxLANs. The configuration allows each host to communicate with the others over L2 or L3, depending on the location of the destination host.

![DC](../img/dcvxlan.png)

## Configuration overview:

The network topology is specified in the containerlab file vxlan-dc.clab.yaml. The file specifies the images needed for each node as well as any configuration files and startup commands.

To enable BGP on the routers, the daemons file used by FRR must include the following line:

```
bgpd=yes
```

The router configuration files are in the *-frr.conf files. The files include the interface and BGP configurations for each router. This lab shares many similarities with the EVPN lab; however, it differs in the BGP configuration.

BGP configuration is organized as follows. The underlay BGP configuration builds a typical spine-leaf topology using eBGP by organizing the routers into three Autonomous Systems (AS). The two spine routers belong to AS65000 while each leaf router is in a separate AS (AS65001 to AS65003). Each leaf router peers with both spine routers using unnumbered interfaces (which rely on IPv6). The underlay configuration is responsible for advertising the loopback interface address of the leaf routers, which are used as VTEP addresses. The overlay BGP connects all routers using iBGP (AS100). To avoid full-mesh peering, the spine routers are used as router reflectors. Each leaf router connects to both spine routers. This overlay is responsible of advertising the VNIs. The overlay and underlay configuration are achieved using peer groups within the default VRF.

The VxLAN configuration reside in the setup-vxlan.sh script file and it is similar to the one in the EVPN lab. The configuration also assigns a user-defined MAC address and an IPv4 address to the bridge. The user-defined MAC address is needed to easily identify the bridge address. The assigned IP address is used as default gateway for the hosts (see the topology file).

```
docker exec -it clab-dc-l1 ip link set br100 addr aa:bb:cc:00:00:01
docker exec -it clab-dc-l1 ip addr add 192.168.1.100/24 dev br100
```


## Starting and ending the lab

Use the following command to start the lab:

```
$ sudo clab deploy [-t vxlan-dc.clab.yaml]
```

Setup VxLAN:

```
$ sudo ./setup-vxlan.sh
```

To end the lab:

```
sudo clab destroy [-t vxlan-dc.clab.yaml]
```


## Verification

You should be able to ping from one host to any other host in the network. The hosts that reside on the same subnet will connect over VxLAN tunnel, while hosts residing in different subnet will connect over IP. You can verify the connectivity using ping, traceroute, or mtr.


```
$ docker exec -it clab-dc-host1 mtr 192.168.2.3
```

```
My traceroute  [v0.95]
host1 (192.168.1.1) -> 192.168.2.3 (192.168.2.3)                                             2024-05-10T11:25:31+0000
Keys:  Help   Display mode   Restart statistics   Order of fields   quit
                             Packets               Pings
Host                                                                      Loss%   Snt   Last   Avg  Best  Wrst StDev
1. 192.168.1.100                                                           0.0%     7    0.2   0.1   0.1   0.2   0.1
2. 1.1.1.12                                                                0.0%     7    0.2   0.2   0.1   0.3   0.1
3. 1.1.1.23                                                                0.0%     7    0.1   0.1   0.1   0.2   0.0
4. 192.168.2.3                                                             0.0%     7    0.2   0.2   0.2   0.4   0.1
```

Notice that the traffic to 192.168.2.3, which is connected to router l2, is directed first towards the gateway 192.168.2.100, which on router l3. The packet captured below shows VxLAN packet from l3 to l2 carrying the ICMP packet from 192.168.1.1 to 192.168.2.3.

```
$ sudo ip netns exec clab-dc-l3 tshark -i eth1 -O vxlan
```

```
Frame 26: 128 bytes on wire (1024 bits), 128 bytes captured (1024 bits) on interface eth1, id 0
Ethernet II, Src: aa:c1:ab:7b:8a:eb (aa:c1:ab:7b:8a:eb), Dst: aa:c1:ab:db:5d:d5 (aa:c1:ab:db:5d:d5)
Internet Protocol Version 4, Src: 1.1.1.23, Dst: 1.1.1.22
User Datagram Protocol, Src Port: 58080, Dst Port: 4789
Virtual eXtensible Local Area Network
    Flags: 0x0800, VXLAN Network ID (VNI)
        0... .... .... .... = GBP Extension: Not defined
        .... .... .0.. .... = Don't Learn: False
        .... 1... .... .... = VXLAN Network ID (VNI): True
        .... .... .... 0... = Policy Applied: False
        .000 .000 0.00 .000 = Reserved(R): 0x0000
    Group Policy ID: 0
    VXLAN Network Identifier (VNI): 200
    Reserved: 0
Ethernet II, Src: aa:bb:cc:00:00:04 (aa:bb:cc:00:00:04), Dst: aa:bb:03:03:03:03 (aa:bb:03:03:03:03)
Internet Protocol Version 4, Src: 192.168.1.1, Dst: 192.168.2.3
Internet Control Message Protocol
```

Check BGP on the spine routers:

```
$ docker exec clab-dc-s1 vtysh -c "show bgp summary"
```

```
IPv4 Unicast Summary (VRF default):
BGP router identifier 1.1.1.11, local AS number 65000 vrf-id 0
BGP table version 7
RIB entries 13, using 1248 bytes of memory
Peers 6, using 79 KiB of memory
Peer groups 2, using 128 bytes of memory

Neighbor        V         AS   MsgRcvd   MsgSent   TblVer  InQ OutQ  Up/Down State/PfxRcd   PfxSnt Desc
*1.1.1.21       4        100        34        33        7    0    0 00:12:51            3        7 FRRouting/9.1_git
*1.1.1.22       4        100        34        33        7    0    0 00:12:53            2        7 FRRouting/9.1_git
*1.1.1.23       4        100        34        33        7    0    0 00:12:51            3        7 FRRouting/9.1_git
eth1            4      65001        34        34        7    0    0 00:12:54            3        7 N/A
eth2            4      65002        34        34        7    0    0 00:12:56            2        7 N/A
eth3            4      65003        34        34        7    0    0 00:12:54            3        7 N/A

Total number of neighbors 6
* - dynamic neighbor
3 dynamic neighbor(s), limit 100

L2VPN EVPN Summary (VRF default):
BGP router identifier 1.1.1.11, local AS number 65000 vrf-id 0
BGP table version 0
RIB entries 7, using 672 bytes of memory
Peers 6, using 79 KiB of memory
Peer groups 2, using 128 bytes of memory

Neighbor        V         AS   MsgRcvd   MsgSent   TblVer  InQ OutQ  Up/Down State/PfxRcd   PfxSnt Desc
*1.1.1.21       4        100        34        33        3    0    0 00:12:51            3       10 FRRouting/9.1_git
*1.1.1.22       4        100        34        33        3    0    0 00:12:53            4       10 FRRouting/9.1_git
*1.1.1.23       4        100        34        33        3    0    0 00:12:51            3       10 FRRouting/9.1_git
eth1            4      65001        34        34        3    0    0 00:12:54            3       10 N/A
eth2            4      65002        34        34        3    0    0 00:12:56            4       10 N/A
eth3            4      65003        34        34        3    0    0 00:12:54            3       10 N/A

Total number of neighbors 6
* - dynamic neighbor
3 dynamic neighbor(s), limit 100
```

Check BGP routes in each leaf router:

```
$ docker exec clab-dc-l1 vtysh -c "show ip route bgp"
```

```
Codes: K - kernel route, C - connected, S - static, R - RIP,
       O - OSPF, I - IS-IS, B - BGP, E - EIGRP, N - NHRP,
       T - Table, v - VNC, V - VNC-Direct, A - Babel, F - PBR,
       f - OpenFabric,
       > - selected route, * - FIB route, q - queued, r - rejected, b - backup
       t - trapped, o - offload failure

B>* 1.1.1.11/32 [20/0] via fe80::a8c1:abff:fece:49e6, eth1, weight 1, 00:02:53
B>* 1.1.1.12/32 [20/0] via fe80::a8c1:abff:fe11:3380, eth2, weight 1, 00:14:29
B>* 1.1.1.22/32 [20/0] via fe80::a8c1:abff:fe11:3380, eth2, weight 1, 00:02:53
  *                    via fe80::a8c1:abff:fece:49e6, eth1, weight 1, 00:02:53
B>* 1.1.1.23/32 [20/0] via fe80::a8c1:abff:fe11:3380, eth2, weight 1, 00:02:53
  *                    via fe80::a8c1:abff:fece:49e6, eth1, weight 1, 00:02:53
B>* 192.168.2.0/24 [20/0] via fe80::a8c1:abff:fe11:3380, eth2, weight 1, 00:02:53
  *                       via fe80::a8c1:abff:fece:49e6, eth1, weight 1, 00:02:53
```

*Note: The FRR image used in this lab does not seem to support ECMP. FRR needs to be compiled with `--enable-multipath=X` where X is the desired max ecmp allowed.*
