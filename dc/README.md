# VxLAN in a Spine-Leaf Data Centre

This lab extends a VxLAN over a spine-leaf topology consisting of two spine and three leaf routers. Four hosts are connected to the three lead switches. The hosts belong to two VxLANs. The configuration allows each host to communicate with the others over L2 or L3, depending on the location of the destination host.

![DC](../img/dcvxlan.png)

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
