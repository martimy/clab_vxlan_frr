#!/bin/bash

# Create VXLAN interfaces and companion bridges for VNI 100
docker exec -it clab-dc-l1 ip link add vxlan100 type vxlan id 100 dstport 4789 local 1.1.1.21 nolearning ttl 5
docker exec -it clab-dc-l1 brctl addbr br100
docker exec -it clab-dc-l1 brctl addif br100 vxlan100
docker exec -it clab-dc-l1 brctl stp br100 off
docker exec -it clab-dc-l1 ip link set up dev br100
docker exec -it clab-dc-l1 ip link set up dev vxlan100
docker exec -it clab-dc-l1 brctl addif br100 eth3

docker exec -it clab-dc-l2 ip link add vxlan100 type vxlan id 100 dstport 4789 local 1.1.1.22 nolearning ttl 5
docker exec -it clab-dc-l2 brctl addbr br100
docker exec -it clab-dc-l2 brctl addif br100 vxlan100
docker exec -it clab-dc-l2 brctl stp br100 off
docker exec -it clab-dc-l2 ip link set up dev br100
docker exec -it clab-dc-l2 ip link set up dev vxlan100
docker exec -it clab-dc-l2 brctl addif br100 eth3
docker exec -it clab-dc-l2 brctl addif br100 eth4

docker exec -it clab-dc-l3 ip link add vxlan100 type vxlan id 100 dstport 4789 local 1.1.1.23 nolearning ttl 5
docker exec -it clab-dc-l3 brctl addbr br100
docker exec -it clab-dc-l3 brctl addif br100 vxlan100
docker exec -it clab-dc-l3 brctl stp br100 off
docker exec -it clab-dc-l3 ip link set up dev br100
docker exec -it clab-dc-l3 ip link set up dev vxlan100
docker exec -it clab-dc-l3 brctl addif br100 eth3
