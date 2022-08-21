#!/bin/bash

# Create bare metal machine set, and 1 BM machine
./create-bm-machine-set.sh

# Wait for metal machine to come up
echo "Created the BM machine.  Waiting for it to come online..."
NUMRUNNING=$( oc get machines -n openshift-machine-api | grep "c5.metal" | grep Running | wc -l )
while [ $NUMRUNNING -lt 1 ]; do
    sleep 60
    NUMRUNNING=$( oc get machines -n openshift-machine-api | grep "c5.metal" | grep Running | wc -l )
    echo "  still waiting..."
done

# Install the OCP Virt operator
oc apply -f ../yaml/virt-operator.yaml

sleep 60

echo "Waiting for the operator to install..."
STATUS=$( oc get csv -n openshift-cnv -o json | jq -r '.items[].status.phase' )
while [ "${STATUS}" != "Succeeded" ]; do
    sleep 30
    STATUS=$( oc get csv -n openshift-cnv -o json | jq -r '.items[].status.phase' )
    echo "  still waiting..."
done

oc apply -f ../yaml/hyperconverged.yaml


