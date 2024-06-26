# VxLAN Labs

This repository includes multiple lab setups that illustrate several VxLAN deployment scenarios:

- VxLAN over point-to-point connection
- VxLAN over a ring topology using several VTEP discovery methods
- VxLAN over a hub-and-spoke topology using multicast
- VxLAN over a hub-and-spoke topology using BGP-EVPN
- VxLAN over a spine-leaf topology using BGP-EVPN


Note: These labs have been created using the following:

- Containerlab version: 0.54.2
- Docker version: 26.1.1
- FRRouting Docker image: quay.io/frrouting/frr:9.1.0 (FRR version: 9.1.0 running on Alpine Linux with Linux kernel 5.4.0-91-generic x86_64)
- Linux image (for hosts): wbitt/network-multitool:alpine-minimal or wbitt/network-multitool:alpine-extra

## Usage

Clone this repository:

```
$ git clone https://github.com/martimy/clab_vxlan_frr [vxlan]
```

Change to the directory of the lab you choose. For example

```
$ cd clab_vxlan_frr
$ cd ptp
```

For more information, read the lab the documentation.

## VxLAN

Virtual eXtensible Local-Area Network (VxLAN) is a standard network virtualization technology defined by the Internet Engineering Task Force (IETF) in [RFC 7348](https://datatracker.ietf.org/doc/html/rfc7348). VXLANs encapsulates Ethernet frames within UDP packets and transport them over IP networks, making the underlying network transport between the VXLAN Tunnel Endpoint (VTEP) devices.

VTEPs are responsible for encapsulating and encapsulating Ethernet frames into VXLAN packets. When two hosts exchange Ethernet frames within the same VXLAN segment but on a different physical network, the packet is encapsulated with a VXLAN header by the source VTEP. This header includes information such as the VXLAN Network Identifier (VNI) and the destination VTEP's IP address. When a VXLAN packet arrives at the destination VTEP, it is decapsulated to retrieve the original Ethernet frame, which is then forwarded to the destination VM.

Similar to VLANs, each VXLAN network identifier (VNI) uniquely identifies a Layer 2 subnet or segment, enabling communication between virtual machines within the same VNI without requiring routing, while communication across different VNIs requires a router. Unlike VLANs, VXLANs expand the Layer 2 network address space significantly, from 4K to more than 16 million.


### VTEP Discovery

VxLAN is essentially a tunnelling scheme but it is not limited to point to point tunnels. VXLAN does not provide a control plane to discover other VTEPs in the network, instead address learning is performed either dynamically, in a manner similar to a learning bridge, or using statically-configured forwarding entries. The VTEP discovery strategies include:

- BUM (broadcast, unknown unicast, and multicast) flooding and address learning
- Static L2/L3 entries
- Multicast
- EVPN


### FRRouting

These labs use FRRouting (FRR) to deploy VxLAN in several scenarios where each scenario implements one of the VTEP discovery strategies listed above. FRR is an open source routing protocol suite based on Linux. In all of the labs, the FRR is used as a VTEP responsible for encapsulating/encapsulating the VxLAN packets from connected hosts. The FRR relies on Linux implementation of the Linux bridge and the VxLAN interface as shown in the figure below:

![VTEP](img/vtep.png)

FRR does not manage network interfaces directly. Instead it learns about the interface configuration from the Linux kernel. Therefore, the configuration of the bridge and the VxLAN interface shown in the figure must be handled by Linux.

## Useful Links

- [FRRouting documentation](https://docs.frrouting.org/en/latest/index.html)
- [Linux ip command manual](https://man7.org/linux/man-pages/man8/ip.8.html)
- [Linux brctl command manual](https://man7.org/linux/man-pages/man8/brctl.8.html)
- [Containerlab](https://containerlab.dev/)
- [VxLAN & Linux](https://vincent.bernat.ch/en/blog/2017-vxlan-linux)
- [VxLAN: BGP EVPN with FRR](https://vincent.bernat.ch/en/blog/2017-vxlan-bgp-evpn)
