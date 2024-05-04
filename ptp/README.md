# VxLAN over Point-to-point L3 Network

This lab demonstrates the use of VxLAN to create an Ethernet tunnel connecting two LAN segments across a layer 3 network.

The network consists of two routers, serving as VxLAN VTEP. Each router is connected to a single host. The routers rely on static routing for connectivity.  

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
