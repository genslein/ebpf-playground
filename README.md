# k3d cilium local install

* [enable hubble UI port forward](https://docs.cilium.io/en/v1.9/gettingstarted/kind/#enable-hubble-for-cluster-wide-visibility)
  * run `make hubble-forward`
  * navigate in browser to http://localhost:12000/
  * Check out [Hubble service map](https://docs.cilium.io/en/stable/gettingstarted/hubble/)
* [deploying falco security to k3d cluster](https://github.com/falcosecurity/charts/tree/master/falco#introduction)
  * [falco ebpf security](https://github.com/falcosecurity/falco)
* [Inspektor Gadget](https://github.com/kinvolk/inspektor-gadget)

### Active bugs

* working on wiring cgroupsv2 in k3d may need to work through debug
* Current active issue on Docker-For-Mac https://github.com/docker/for-mac/issues/4454
* Working on bug with Falco Security being unable to install
  * unable to install drivers
  ```bash
  Fri Feb 11 03:44:28 2022: Unable to load the driver.
  Fri Feb 11 03:44:28 2022: Runtime error: error opening device /host/dev/falco0. Make sure you have root credentials and that the falco module is loaded.. Exiting.
  ```