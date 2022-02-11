#!/bin/sh

curl -sL https://github.com/kinvolk/inspektor-gadget/releases/download/v0.4.2/inspektor-gadget-darwin-amd64.tar.gz | sudo tar -C /usr/local/bin -xzf - kubectl-gadget
kubectl gadget version
kubectl gadget deploy | kubectl apply -f -

echo "Testing Inspektor Gadget Installation"
kubectl gadget execsnoop