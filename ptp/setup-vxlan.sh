#!/bin/bash

# Create VXLAN interfaces and companion bridges for VNI 100
docker exec -it clab-ptp-r1 ip link add vxlan100 type vxlan id 100 dstport 4789 local 10.0.0.1 remote 10.0.0.2
docker exec -it clab-ptp-r1 brctl addbr br100
docker exec -it clab-ptp-r1 brctl addif br100 vxlan100
docker exec -it clab-ptp-r1 brctl stp br100 off
docker exec -it clab-ptp-r1 ip link set up dev br100
docker exec -it clab-ptp-r1 ip link set up dev vxlan100
docker exec -it clab-ptp-r1 brctl addif br100 eth2

docker exec -it clab-ptp-r2 ip link add vxlan100 type vxlan id 100 dstport 4789 local 10.0.0.2 remote 10.0.0.1
docker exec -it clab-ptp-r2 brctl addbr br100
docker exec -it clab-ptp-r2 brctl addif br100 vxlan100
docker exec -it clab-ptp-r2 brctl stp br100 off
docker exec -it clab-ptp-r2 ip link set up dev br100
docker exec -it clab-ptp-r2 ip link set up dev vxlan100
docker exec -it clab-ptp-r2 brctl addif br100 eth2
