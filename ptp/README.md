# VxLAN Point-to-point Tunnel

This lab demonstrates the use of VxLAN to create a point-to-point Ethernet tunnel connecting two LAN segments across a layer 3 network. The network consists of two routers, serving as VxLAN VTEP. Each router is connected to a single host. T


![p2p](../img/ptp.png)

## Configuration overview

The network topology is specified in the containerlab file `vxlan-ptp.clab.yaml`. The file specifies the images needed for each node as well as any configuration files and startup commands. Consult [containerlab documentation](https://containerlab.dev/manual/topo-def-file/) for more information about the topology.

The router configuration files are in the *-frr.conf files. The configuration is minimal and it include defining the interfaces connecting the two routers and a static route.

The bulk of the configuration required to implement the tunnel reside on the Linux side. Here is a break down of the commands:

The following line creates a new virtual interface named `vxlan100` of type VXLAN (Virtual Extensible LAN) with an ID of 100. It specifies the destination port (4789), local IP address (10.0.0.1), and remote IP address (10.0.0.2) for communication.

```
ip link add vxlan100 type vxlan id 100 dstport 4789 local 10.0.0.1 remote 10.0.0.2`
```

The next lines add a new bridge interface named `br100`, then connect the `vxlan100` interface to it. The last disables Spanning Tree Protocol (STP) on the `br100` bridge, because it is not required. 

```
brctl addbr br100
brctl addif br100 vxlan100
brctl stp br100 off
```

The following lines bring the bridge interface `br100` and the VXLAN interface `vxlan100` up.

```
ip link set up dev br100
ip link set up dev vxlan100
```

Finally, this following line connects another interface, `eth2`, to the bridge `br100`. This interface connects the FRR router to the host.


```
brctl addif br100 eth2
```

Note that above commands need to be executed on each Frr router after initializing the containerlab topology. 

   
## Starting and ending the lab

Use the following command to start the lab:

```
$ cd ptp
$ sudo clab deploy [-t vxlan-ptp.clab.yaml]
```

Setup VxLAN:

```
$ sudo ./setup-vxlan.sh
```

To end the lab:

```
$ sudo clab destroy [-t vxlan-ptp.clab.yaml]
```


## Verification

You should be able to ping from one host to the other:

```
$ docker exec -it clab-ptp-host4 ping 192.168.1.5
```

To check the bridge forwarding database:

```
$ docker exec clab-ptp-r1 bridge fdb show dev vxlan100 | grep dst
```

```
00:00:00:00:00:00 dst 10.0.0.2 self permanent
2e:3b:77:13:85:45 dst 10.0.0.2 self
aa:c1:ab:53:dc:83 dst 10.0.0.2 self
```

## Suggestions

Add one or more routers between r1 and r2 and configure a routing protocol (e.g. OSPF) among the routers. Make sure that the VxLAN interface in the `setup-vxlan.sh` has correct local and remote IP addresses.
