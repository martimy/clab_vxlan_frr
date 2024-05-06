# VxLAN in a Spine-Leaf Data Centre

This lab extends a VxLAN over a spine-leaf topology consisting of two spine and three leaf routers. 

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
