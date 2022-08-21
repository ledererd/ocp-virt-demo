#!/bin/bash

oc create deployment toolbox1 --image quay.io/noseka1/toolbox-container:basic -n default
