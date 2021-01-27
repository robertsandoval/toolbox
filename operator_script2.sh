#LOGIN TO MY REGISTRY
export MIRROR_REG=
export REG_CREDS=/root/.docker/config.json

echo "INFO: Login into ${MIRROR_REG}"
podman login ${MIRROR_REG}:5000 --authfile=${REG_CREDS}

#LOGIN TO QUAY.io
echo "INFO: Login into quay.io   ...."
podman login quay.io --authfile=${REG_CREDS}

#LOGIN TO registry.redhat.io
echo "INFO: Login into registry.redhat.io ...."
podman login registry.redhat.io --authfile=${REG_CREDS}

echo "INFO: Start Building Operators Catalog ...."

exit 0

oc adm catalog mirror \
    ${MIRROR_REG}:5000/olm/redhat-operators:v1 \
    ${MIRROR_REG}:5000 \
    -a ${REG_CREDS} \
    --insecure
