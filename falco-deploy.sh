#!/bin/zsh

helm repo add falcosecurity https://falcosecurity.github.io/charts
helm repo update

curl -L -O https://download.falco.org/packages/bin/x86_64/falco-0.31.0-x86_64.tar.gz
helm install falco falcosecurity/falco
