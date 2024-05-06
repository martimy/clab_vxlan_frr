#!/bin/bash

# Create VXLAN interfaces and companion bridges for VNI 100
docker exec -it clab-ring-r1 ip link add vxlan100 type vxlan id 100 dstport 4789 local 1.1.1.1 nolearning proxy
docker exec -it clab-ring-r1 brctl addbr br100
docker exec -it clab-ring-r1 brctl addif br100 vxlan100
docker exec -it clab-ring-r1 brctl stp br100 off
docker exec -it clab-ring-r1 ip link set up dev br100
docker exec -it clab-ring-r1 ip link set up dev vxlan100
docker exec -it clab-ring-r1 brctl addif br100 eth2

#docker exec -it clab-ring-r1 bridge fdb append 00:00:00:00:00:00 dev vxlan100 dst 1.1.1.2
#docker exec -it clab-ring-r1 bridge fdb append 00:00:00:00:00:00 dev vxlan100 dst 1.1.1.3
docker exec -it clab-ring-r1 bridge fdb append aa:bb:05:05:05:05 dev vxlan100 dst 1.1.1.2
docker exec -it clab-ring-r1 bridge fdb append aa:bb:06:06:06:06 dev vxlan100 dst 1.1.1.3
docker exec -it clab-ring-r1 ip neigh add 192.168.1.5 lladdr aa:bb:05:05:05:05 dev vxlan100
docker exec -it clab-ring-r1 ip neigh add 192.168.1.6 lladdr aa:bb:06:06:06:06 dev vxlan100

docker exec -it clab-ring-r2 ip link add vxlan100 type vxlan id 100 dstport 4789 local 1.1.1.2 nolearning proxy
docker exec -it clab-ring-r2 brctl addbr br100
docker exec -it clab-ring-r2 brctl addif br100 vxlan100
docker exec -it clab-ring-r2 brctl stp br100 off
docker exec -it clab-ring-r2 ip link set up dev br100
docker exec -it clab-ring-r2 ip link set up dev vxlan100
docker exec -it clab-ring-r2 brctl addif br100 eth2

#docker exec -it clab-ring-r2 bridge fdb append 00:00:00:00:00:00 dev vxlan100 dst 1.1.1.1
#docker exec -it clab-ring-r2 bridge fdb append 00:00:00:00:00:00 dev vxlan100 dst 1.1.1.3
docker exec -it clab-ring-r2 bridge fdb append aa:bb:04:04:04:04 dev vxlan100 dst 1.1.1.1
docker exec -it clab-ring-r2 bridge fdb append aa:bb:06:06:06:06 dev vxlan100 dst 1.1.1.3
docker exec -it clab-ring-r2 ip neigh add 192.168.1.4 lladdr aa:bb:04:04:04:04 dev vxlan100
docker exec -it clab-ring-r2 ip neigh add 192.168.1.6 lladdr aa:bb:06:06:06:06 dev vxlan100

docker exec -it clab-ring-r3 ip link add vxlan100 type vxlan id 100 dstport 4789 local 1.1.1.3 nolearning proxy
docker exec -it clab-ring-r3 brctl addbr br100
docker exec -it clab-ring-r3 brctl addif br100 vxlan100
docker exec -it clab-ring-r3 brctl stp br100 off
docker exec -it clab-ring-r3 ip link set up dev br100
docker exec -it clab-ring-r3 ip link set up dev vxlan100
docker exec -it clab-ring-r3 brctl addif br100 eth2

#docker exec -it clab-ring-r3 bridge fdb append 00:00:00:00:00:00 dev vxlan100 dst 1.1.1.1
#docker exec -it clab-ring-r3 bridge fdb append 00:00:00:00:00:00 dev vxlan100 dst 1.1.1.2
docker exec -it clab-ring-r3 bridge fdb append aa:bb:04:04:04:04 dev vxlan100 dst 1.1.1.1
docker exec -it clab-ring-r3 bridge fdb append aa:bb:05:05:05:05 dev vxlan100 dst 1.1.1.2
docker exec -it clab-ring-r3 ip neigh add 192.168.1.4 lladdr aa:bb:04:04:04:04 dev vxlan100
docker exec -it clab-ring-r3 ip neigh add 192.168.1.5 lladdr aa:bb:05:05:05:05 dev vxlan100
