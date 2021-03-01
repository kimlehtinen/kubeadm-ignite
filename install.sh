#!/bin/bash

# Create master node
ignite run weaveworks/ignite-kubeadm:latest \
        --cpus 2 \
        --memory 2GB \
        --ssh \
        --name master

# Create n x workers 
for i in {1..2}; do
        ignite run weaveworks/ignite-kubeadm:latest \
                --cpus 2 \
                --memory 1GB \
                --ssh \
                --name worker${i}
done

