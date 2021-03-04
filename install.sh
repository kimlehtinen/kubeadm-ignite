#!/bin/bash

# Create master node
echo "Creating ignite master node..."
ignite run weaveworks/ignite-kubeadm:latest \
        --cpus 2 \
        --memory 2GB \
        --ssh \
        --name master
echo "Master node is running"

export MASTER_IP=$(ignite inspect vm master | jq -r ".status.network.ipAddresses[0]")
echo "export MASTER_IP=$MASTER_IP" > master_ip.sh

# Create n x workers 
echo "Creating ignite worker nodes..."
for i in {1..2}; do
        ignite run weaveworks/ignite-kubeadm:latest \
                --cpus 2 \
                --memory 1GB \
                --ssh \
                --name worker${i}
done
echo "Worker nodes are running"

echo "All nodes are running"

# Configure master
echo "Configuring master..."
cat common.sh | ignite exec master bash
cat master.sh | ignite exec master bash

# Configure workers
echo "Configuring workers..."
for i in {1..2}; do
        ignite cp master_ip.sh worker${i}:/root/master_ip.sh
        cat common.sh | ignite exec worker${i} bash
        cat worker.sh | ignite exec worker${i} bash
done
