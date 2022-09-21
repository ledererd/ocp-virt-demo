# ocp-virt-demo

* Provision a "OpenShift 4.10 Workshop"
* Run "oc login ..."
* Run scripts/full-setup.sh

NOTE:  You _must_ clean up you Bare Metal machines manually (scale MachineSet to 0 + give time for machine to disappear) before destroying the environment.

CAVEATS/TO FIX:
* RHPDS doesn't provision RWX storage by default, so no live migration at this stage.
* RHPDS doesn't expose a datacentre network, so I don't have multus going.
* NodePort doesn't work either, so exposing services on VMs out via NodePort doesn't work.

