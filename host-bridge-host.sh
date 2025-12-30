#!/bin/sh

# Create three network namespaces
sudo ip netns add host1
sudo ip netns add host2
sudo ip netns add switch

# Create veth pairs (virtual ethernet cables)
sudo ip link add veth1 type veth peer name veth1-br
sudo ip link add veth2 type veth peer name veth2-br

# Move one end of each pair into the host namespaces
sudo ip link set veth1 netns host1
sudo ip link set veth2 netns host2

# Move the other ends into the switch namespace
sudo ip link set veth1-br netns switch
sudo ip link set veth2-br netns switch

# Create a bridge in the switch namespace
sudo ip netns exec switch ip link add name br0 type bridge

# Attach the veth interfaces to the bridge
sudo ip netns exec switch ip link set veth1-br master br0
sudo ip netns exec switch ip link set veth2-br master br0

# Bring up all interfaces in the switch namespace
sudo ip netns exec switch ip link set br0 up
sudo ip netns exec switch ip link set veth1-br up
sudo ip netns exec switch ip link set veth2-br up

# Configure host1
sudo ip netns exec host1 ip link set veth1 up
sudo ip netns exec host1 ip addr add 192.168.1.10/24 dev veth1

# Configure host2
sudo ip netns exec host2 ip link set veth2 up
sudo ip netns exec host2 ip addr add 192.168.1.20/24 dev veth2
