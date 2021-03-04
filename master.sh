#!/bin/bash

# source code partially taken from https://github.com/justmeandopensource/kubernetes

echo "pull config images"
kubeadm config images pull >/dev/null 2>&1

echo "init k8s cluster"
kubeadm init --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors=all >> /root/kubeinit.log 2>&1

echo "cp config to .kube"
mkdir /root/.kube
cp /etc/kubernetes/admin.conf /root/.kube/config  

echo "install weave"
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

echo "save join sh file"
JOIN_COMMAND=$(kubeadm token create --print-join-command 2>/dev/null) 
echo "$JOIN_COMMAND --ignore-preflight-errors=all" > /join.sh
