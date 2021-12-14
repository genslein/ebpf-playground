#!/bin/sh

docker exec -it k3d-foo-agent-0 mount bpffs /sys/fs/bpf -t bpf
docker exec -it k3d-foo-agent-0 mount --make-shared /sys/fs/bpf
# this needs to be done for every container (every agent and every server)
docker exec -it k3d-foo-server-0 mount bpffs /sys/fs/bpf -t bpf
docker exec -it k3d-foo-server-0 mount --make-shared /sys/fs/bpf

# for cilium
docker exec -it k3d-foo-agent-0 mount --make-shared /sys/fs/cgroup
docker exec -it k3d-foo-server-0 mount --make-shared /sys/fs/cgroup

# for falco
docker exec -it k3d-foo-agent-0 mkdir -p /host/dev/falco0
docker exec -it k3d-foo-agent-0 mount falco /host/dev/falco0 -t bpf
docker exec -it k3d-foo-agent-0 mount --make-shared /host/dev/falco0
docker exec -it k3d-foo-server-0 mkdir -p /host/dev/falco0
docker exec -it k3d-foo-server-0 mount falco /host/dev/falco0 -t bpf
docker exec -it k3d-foo-server-0 mount --make-shared /host/dev/falco0