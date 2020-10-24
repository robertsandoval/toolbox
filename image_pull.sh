#!/bin/bash
MIRROR_ADDR=<your mirror repo address including port>
REG_AUTH=<your registry auth file or pull secret >
REG1=registry.redhat.io
REG2=registry.access.redhat.com
REG3=quay.io
IFS=$'\n'

# Get all the image stream names in openshift project
IMAGESTREAMS=( $(oc get is -n openshift | awk '{print $1}'|grep -v NAME))

for imagestream in "${IMAGESTREAMS[@]}"
do
    echo "Pulling images for $imagestream"
    IMAGES=( $(oc get is $imagestream -n openshift -o json | jq .spec.tags[].from.name | grep "$REG1\|$REG2\|$REG3" | tr -d '"'))

    echo "Pulling ${#IMAGES[@]} images for $imagestream"
    for image in "${IMAGES[@]}"
    do

	# Need to parse the image string to exclude the domain name
	IMAGESUBSTRING=`echo ${image} | perl -lane 'print "$2" if /(.*?\/)(.*)/' `
        if [ ${#IMAGES[@]} == 0  ]; 
        then 
		echo "		No images found for $imagestream-------------------------------------------------------------"
		continue
	fi
	oc image mirror $image ${MIRROR_ADDR}/${IMAGESUBSTRING} -a ${REG_AUTH}

    done
    echo "Done with $imagestream"
done



