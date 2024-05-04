#!/bin/bash

# Create VXLAN interfaces and companion bridges for VNI 100
docker exec -it clab-simple-r1 ip link add vxlan100 type vxlan id 100 dstport 4789 local 1.1.1.1 nolearning
docker exec -it clab-simple-r1 brctl addbr br100
docker exec -it clab-simple-r1 brctl addif br100 vxlan100
docker exec -it clab-simple-r1 brctl stp br100 off
docker exec -it clab-simple-r1 ip link set up dev br100
docker exec -it clab-simple-r1 ip link set up dev vxlan100
docker exec -it clab-simple-r1 brctl addif br100 eth2

docker exec -it clab-simple-r3 ip link add vxlan100 type vxlan id 100 dstport 4789 local 1.1.1.3 nolearning
docker exec -it clab-simple-r3 brctl addbr br100
docker exec -it clab-simple-r3 brctl addif br100 vxlan100
docker exec -it clab-simple-r3 brctl stp br100 off
docker exec -it clab-simple-r3 ip link set up dev br100
docker exec -it clab-simple-r3 ip link set up dev vxlan100
docker exec -it clab-simple-r3 brctl addif br100 eth2
