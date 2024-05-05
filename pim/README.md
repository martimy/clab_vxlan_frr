# VxLAN using Multicast

This lab demonstrates the use of VxLAN to link three across a layer 3 network.

The network consists of three routers, serving as VxLAN VTEP. Each router is connected to a single host. The routers are connected to a fourth router forming star topology. The routers rely on OSPF for routing. PIM and IGMP are used for VTEP discovery.  

![p2p](../img/pim.png)


Configuration Notes:
- PIM must be enabled on all interfaces facing multicast sources or multicast receivers, as well as on the interface where the RP address is configured.
- TTL must be increased from 1 to allow from packet to traverse the network.

## Starting and ending the lab

Use the following command to start the lab:

```
$ cd ptp
$ sudo clab deploy [-t vxlan-pim.clab.yaml]
```

Setup VxLAN:

```
$ sudo ./setup-vxlan.sh
```

To end the lab:

```
$ sudo clab destroy [-t vxlan-pim.clab.yaml]
```

## Verification

You should be able to ping from one host to the other:

```
$ docker exec -it clab-ring-host4 ping 192.168.1.5
```

To check the bridge forwarding database:

```
$ docker exec clab-ptp-r1 bridge fdb show dev vxlan100 | grep dst
```

```
00:00:00:00:00:00 dst 239.1.1.1 via eth1 self permanent
aa:bb:04:04:04:04 dst 1.1.1.1 self
96:3b:b5:09:3d:ec dst 1.1.1.1 self
aa:bb:06:06:06:06 dst 1.1.1.3 self
26:28:44:5c:e0:dc dst 1.1.1.3 self
```
