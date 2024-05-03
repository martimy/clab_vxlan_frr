#!/bin/bash

#docker exec -it clab-simple-r1 ip link add br0 type bridge
#docker exec -it clab-simple-r1 ip link set dev br0 up
#docker exec -it clab-simple-r1 ip link add vxlan10 type vxlan id 10 dstport 4789
#docker exec -it clab-simple-r1 ip link set dev vxlan10 up
#docker exec -it clab-simple-r1 ip link set vxlan10 master br0
#docker exec -it clab-simple-r1 ip link set eth2 master br0

#docker exec -it clab-simple-r3 ip link add br0 type bridge
#docker exec -it clab-simple-r3 ip link set dev br0 up
#docker exec -it clab-simple-r3 ip link add vxlan10 type vxlan id 10 dstport 4789
#docker exec -it clab-simple-r3 ip link set dev vxlan10 up
#docker exec -it clab-simple-r3 ip link set vxlan10 master br0
#docker exec -it clab-simple-r3 ip link set eth2 master br0


# Create VXLAN interfaces and companion bridges for VNI 100
docker exec -it clab-simple-r1 ip link add vxlan100 type vxlan id 100 dstport 4789 local 10.0.0.5 nolearning
docker exec -it clab-simple-r1 brctl addbr br100
docker exec -it clab-simple-r1 brctl addif br100 vxlan100
docker exec -it clab-simple-r1 brctl stp br100 off
docker exec -it clab-simple-r1 ip link set up dev br100
docker exec -it clab-simple-r1 ip link set up dev vxlan100
docker exec -it clab-simple-r1 brctl addif br100 eth2

docker exec -it clab-simple-r3 ip link add vxlan100 type vxlan id 100 dstport 4789 local 10.0.1.5 nolearning
docker exec -it clab-simple-r3 brctl addbr br100
docker exec -it clab-simple-r3 brctl addif br100 vxlan100
docker exec -it clab-simple-r3 brctl stp br100 off
docker exec -it clab-simple-r3 ip link set up dev br100
docker exec -it clab-simple-r3 ip link set up dev vxlan100
docker exec -it clab-simple-r3 brctl addif br100 eth2
