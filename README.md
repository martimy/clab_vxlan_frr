# VxLAN Labs

This repository includes multiple lab setups that illustrate several VxLAN deployment scenarios:

- VxLAN over point-to-point connection
- VxLAN over a ring topology using several VTEP discovery methods
- VxLAN over a start topology with multicast
- VxLAN over hub-and-spoke using BGP-EVPN
- VxLAN over a spine-leaf topology using BGP-EVPN

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

Virtual eXtensible Local-Area Network (VxLAN) is a standard network virtualization technology defined by the Internet Engineering Task Force (IETF) in [RFC 7348](https://datatracker.ietf.org/doc/html/rfc7348). VXLANs encapsulats Ethernet frames within UDP packets and transport them over IP networks, making the underlying network transport between the VXLAN Tunnel Endpoint (VTEP) devices.

VTEPs are responsible for encapsulating and decapsulating Ethernet frames into VXLAN packets. When two hosts exchange Ethernet frames within the same VXLAN segment but on a different physical network, the packet is encapsulated with a VXLAN header by the source VTEP. This header includes information such as the VXLAN Network Identifier (VNI) and the destination VTEP's IP address. When a VXLAN packet arrives at the destination VTEP, it is decapsulated to retrieve the original Ethernet frame, which is then forwarded to the destination VM.

Similar to VLANs, each VXLAN network identifier (VNI) uniquely identifies a Layer 2 subnet or segment, enabling communication between virtual machines within the same VNI without requiring routing, while communication across different VNIs requires a router. Unlike VLANs, VXLANs expand the Layer 2 network address space significantly, from 4K to more than 16 million.

### VTEP Discovery

VXLAN does not provide a control plane, and VTEP discovery and host information (IP and MAC addresses, VNIs, and gateway VTEP IP address) learning are implemented using several [strategies](https://vincent.bernat.ch/en/blog/2017-vxlan-linux), including:

- BUM (broadcast, unknown unicast, and multicast) flooding and address learning.
- Static L2/L3 entries
- Multicast
- EVPN

The latter strategy uses EVPN as the control plane. EVPN allows VTEPs to exchange BGP EVPN routes to implement automatic VTEP discovery and host information advertisement, preventing unnecessary traffic flooding.

### FRRouting

This labs use FRRouting (FRR) to deploy VxLAN in several scenarios where each scenario implement one of the VTEP discovery strategy list above. FRR is an open source Internet routing protocol suite based on Linux. In all of the lab scenarios, the FRR is used as VTEP responsible for encapsulating/decapsulating the VxLAN packets from connected hosts. The FRR relies on Linux implementation of the Linux bridge and VxLAN interfaces as shown in the figure below:

![VTEP](img/vtep.png)

## Notes

- This lab uses Dokcer image: quay.io/frrouting/frr:9.1.0
  - FRR version: 9.1.0 running on Alpine Linux with Linux kernel 5.4.0-91-generic x86_64
