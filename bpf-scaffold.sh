#!/bin/zsh

docker exec -it k3d-foo-agent-0 mount bpffs /sys/fs/bpf -t bpf
docker exec -it k3d-foo-agent-0 mount --make-shared /sys/fs/bpf
# this needs to be done for every container (every agent and every server)
docker exec -it k3d-foo-server-0 mount bpffs /sys/fs/bpf -t bpf
docker exec -it k3d-foo-server-0 mount --make-shared /sys/fs/bpf

# bugged for cilium and needed to fix for falco
# TODO: still not working but 1.10.5 bypasses
docker exec -it k3d-foo-agent-0 mount cgroupfs-mount /sys/fs/cgroup -t cgroup
docker exec -it k3d-foo-agent-0 mount --make-shared /sys/fs/cgroup

docker exec -it k3d-foo-server-0 mount cgroupfs-mount /sys/fs/cgroup -t cgroup
docker exec -it k3d-foo-server-0 mount --make-shared /sys/fs/cgroup

# K3d is busybox so no package manager and wget doesn't support https public endpoints
# need falco's driver, k3s/k3d overrides the distro name to PRETTY_NAME="K3s dev"
# for falco
docker exec -it k3d-foo-agent-0 mkdir -p /host/dev/falco0
docker exec -it k3d-foo-agent-0 mount falco /host/dev/falco0 -t bpf
docker exec -it k3d-foo-agent-0 mount --make-shared /host/dev/falco0
docker exec -it k3d-foo-server-0 mkdir -p /host/dev/falco0
docker exec -it k3d-foo-server-0 mount falco /host/dev/falco0 -t bpf
docker exec -it k3d-foo-server-0 mount --make-shared /host/dev/falco0