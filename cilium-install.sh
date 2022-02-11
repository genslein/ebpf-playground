#!/bin/zsh

CILIUM_NAMESPACE=kube-system

# from the link
# https://sandstorm.de/de/blog/post/running-cilium-in-k3s-and-k3d-lightweight-kubernetes-on-mac-os-for-development.html

helm repo add cilium https://helm.cilium.io

helm install cilium cilium/cilium --version 1.10.5 \
   --namespace kube-system \
   --set kubeProxyReplacement=partial \
   --set hostServices.enabled=false \
   --set externalIPs.enabled=true \
   --set nodePort.enabled=true \
   --set hostPort.enabled=true \
   --set bpf.masquerade=false \
   --set image.pullPolicy=IfNotPresent \
   --set ipam.mode=kubernetes \
   --set cgroup.hostRoot=/sys/fs/cgroup

# cgroupv2 is required in cilium 1.10+
# see https://docs.cilium.io/en/v1.10/gettingstarted/kubeproxy-free/#quick-start

helm upgrade cilium cilium/cilium --version 1.10.5 \
   --namespace kube-system \
   --reuse-values \
   --set hubble.listenAddress=":4244" \
   --set hubble.relay.enabled=true \
   --set hubble.ui.enabled=true

# access hubble UI locally
# kubectl port-forward -n $CILIUM_NAMESPACE svc/hubble-ui --address 0.0.0.0 --address :: 12000:80 &
