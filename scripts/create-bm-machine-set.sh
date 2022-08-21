#!/bin/bash

############################################################################


# Dump the existing machineset
EXISTING=$( oc get machinesets -n openshift-machine-api -o json  | jq -r '.items[].metadata.name' )
oc get machineset ${EXISTING} -n openshift-machine-api -o yaml > /tmp/existing-machineset.yaml

# Remove all the extra lines that we don't want
cat /tmp/existing-machineset.yaml | \
    sed '/^status:/,$d' | \
    grep -v "  creationTimestamp: " | \
    grep -v "  generation: " | \
    grep -v "  resourceVersion: " | \
    grep -v "  uid: " > /tmp/temp-machineset.yaml

# Now we need to figure out the new machineset name
EXISTING_MS=$( grep "machine.openshift.io/cluster-api-cluster" /tmp/temp-machineset.yaml | \
    awk '{print $2}' | head -1 ) 
STRIP=$( echo "${EXISTING_MS}" | awk -F- '{print $3}' )
NEW_MS=$( echo "${EXISTING_MS}" | sed "s/${STRIP}/bm/g" )

# Incidentally, let's scale down the VM machineset - we don't need it
oc scale machineset ${EXISTING} -n openshift-machine-api --replicas=1


# Modify the values that need modifying
cat /tmp/temp-machineset.yaml | \
    sed 's/replicas:.*/replicas: 1/g' | \
    sed "s/instanceType:.*/instanceType: c5.metal/g" | \
    sed 's^machine.openshift.io/memoryMb:.*^machine.openshift.io/memoryMb: "196608"^g' | \
    sed 's^machine.openshift.io/vCPU:.*^machine.openshift.io/vCPU: "96"^g' | \
    sed "s^machine.openshift.io/cluster-api-machineset:.*^machine.openshift.io/cluster-api-machineset: ${NEW_MS}^g" | \
    sed "s/^  name: .*/  name: ${NEW_MS}/g" > /tmp/new-machineset.yaml

oc create -n openshift-machine-api -f /tmp/new-machineset.yaml
