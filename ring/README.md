# VxLAN over L3 Network

The lab builds a network of three routers, serving as VxLAN VTEPs. The routers form a ring topology. Each router is connected to a single host. The routers rely on OSPF routing for connectivity.  

![p2p](../img/ring.png)

VTEP discovery is done using two strategies:

- Unicast with static flooding: All the remote VTEPs are associated with the all-zero address. A BUM frame will be replicated to all these destinations. The VXLAN device will still learn remote addresses automatically using source-address learning.

- Unicast with static MAC entries: If the MAC addresses of VTEPs are known, it is possible to pre-populate the FDB and disable learning. The all-zero entries are still needed for broadcast and multicast traffic (e.g. ARP and IPv6 neighbor discovery). Also, if a MAC is missing, the frame will always be sent using the all-zero entries.


## Starting and ending the lab

Use the following command to start the lab:

```
$ cd ptp
$ sudo clab deploy [-t vxlan-ring.clab.yaml]
```

Setup VxLAN:

- For Unicast with static flooding:

  ```
  $ sudo ./setup-vxlan.sh
  ```

- For Unicast with static MAC entries:

  ```
  $ sudo ./setup-vxlan-static.sh
  ```

To end the lab:

```
$ sudo clab destroy [-t vxlan-ring.clab.yaml]
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
00:00:00:00:00:00 dst 1.1.1.2 self permanent
00:00:00:00:00:00 dst 1.1.1.3 self permanent
aa:c1:ab:d4:91:6e dst 1.1.1.3 self
aa:bb:06:06:06:06 dst 1.1.1.3 self
fa:84:3d:1c:89:dc dst 1.1.1.3 self
aa:bb:05:05:05:05 dst 1.1.1.2 self
```
