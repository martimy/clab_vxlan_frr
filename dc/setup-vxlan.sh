#!/bin/bash

# Create VXLAN interfaces and companion bridges for VNI 100 on leaf1
docker exec -it clab-dc-l1 ip link add vxlan100 type vxlan id 100 dstport 4789 local 1.1.1.21 nolearning ttl 5
docker exec -it clab-dc-l1 brctl addbr br100
docker exec -it clab-dc-l1 brctl addif br100 vxlan100
docker exec -it clab-dc-l1 brctl stp br100 off
docker exec -it clab-dc-l1 ip link set up dev br100
docker exec -it clab-dc-l1 ip link set up dev vxlan100
docker exec -it clab-dc-l1 brctl addif br100 eth3

docker exec -it clab-dc-l1 ip link set br100 addr aa:bb:cc:00:00:01
docker exec -it clab-dc-l1 ip link set vxlan100 type bridge_slave neigh_suppress on learning off
docker exec -it clab-dc-l1 ip addr add 192.168.1.100/24 dev br100

# Create VXLAN interfaces and companion bridges for VNI 100 on leaf2
docker exec -it clab-dc-l2 ip link add vxlan100 type vxlan id 100 dstport 4789 local 1.1.1.22 nolearning ttl 5
docker exec -it clab-dc-l2 brctl addbr br100
docker exec -it clab-dc-l2 brctl addif br100 vxlan100
docker exec -it clab-dc-l2 brctl stp br100 off
docker exec -it clab-dc-l2 ip link set up dev br100
docker exec -it clab-dc-l2 ip link set up dev vxlan100
docker exec -it clab-dc-l2 brctl addif br100 eth3

docker exec -it clab-dc-l2 ip link set br100 addr aa:bb:cc:00:00:02
docker exec -it clab-dc-l2 ip link set vxlan100 type bridge_slave neigh_suppress on learning off

# Create VXLAN interfaces and companion bridges for VNI 200 on leaf2
docker exec -it clab-dc-l2 ip link add vxlan200 type vxlan id 200 dstport 4789 local 1.1.1.22 nolearning ttl 5
docker exec -it clab-dc-l2 brctl addbr br200
docker exec -it clab-dc-l2 brctl addif br200 vxlan200
docker exec -it clab-dc-l2 brctl stp br200 off
docker exec -it clab-dc-l2 ip link set up dev br200
docker exec -it clab-dc-l2 ip link set up dev vxlan200
docker exec -it clab-dc-l2 brctl addif br200 eth4

docker exec -it clab-dc-l2 ip link set br200 addr aa:bb:cc:00:00:03
docker exec -it clab-dc-l2 ip link set vxlan200 type bridge_slave neigh_suppress on learning off

# Create VXLAN interfaces and companion bridges for VNI 200 on leaf3
docker exec -it clab-dc-l3 ip link add vxlan200 type vxlan id 200 dstport 4789 local 1.1.1.23 nolearning ttl 5
docker exec -it clab-dc-l3 brctl addbr br200
docker exec -it clab-dc-l3 brctl addif br200 vxlan200
docker exec -it clab-dc-l3 brctl stp br200 off
docker exec -it clab-dc-l3 ip link set up dev br200
docker exec -it clab-dc-l3 ip link set up dev vxlan200
docker exec -it clab-dc-l3 brctl addif br200 eth3

docker exec -it clab-dc-l3 ip link set br200 addr aa:bb:cc:00:00:04
docker exec -it clab-dc-l3 ip link set vxlan200 type bridge_slave neigh_suppress on learning off
docker exec -it clab-dc-l3 ip addr add 192.168.2.100/24 dev br200
