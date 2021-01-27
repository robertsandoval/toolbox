#!/bin/bash
#REGISTRY PULL SECRETS
export REG_CREDS=/root/.docker/config.json
echo "Using Pull secret ${REG_CREDS}"

#LOGIN TO MY REGISTRY
echo "INFO: Login into ${MIRROR_REG}:5000  ...."
podman login ${MIRROR_REG}:5000 --authfile ${REG_CREDS}

#LOGIN TO QUAY.io
echo "INFO: Login into quay.io   ...."
podman login quay.io --authfile ${REG_CREDS}

#LOGIN TO registry.redhat.io
echo "INFO: Login into registry.redhat.io ...."
podman login registry.redhat.io  ${MIRROR_REG}:5000 --authfile ${REG_CREDS}


echo "INFO: Start Building Operators Catalog ...."

./oc version
./oc adm catalog build --filter-by-os='linux/amd64' \
    --appregistry-org redhat-operators \
    --from=registry.redhat.io/openshift4/ose-operator-registry:v4.5 \
    --to=bastion.ocp50.example.com:5000/olm/redhat-operators:v1 \
    -a ${REG_CREDS} \
    --insecure
