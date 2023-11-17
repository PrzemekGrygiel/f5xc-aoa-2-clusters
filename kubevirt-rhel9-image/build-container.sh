#!/bin/bash

# Get KVM qcow2 RHEL image from the official public website https://docs.cloud.f5.com/docs/images
#
URL=https://vesio.blob.core.windows.net/releases/rhel/9/x86_64/images/qemu/rhel-9.2023.23-20231026195206.qcow2
CONTAINER="vesio-ver9-ce"

IMAGE=$(basename $URL)
VERSION=$(echo $IMAGE | cut -d- -f2)

if ! test -f $IMAGE; then
  echo downloading $URL ...
  curl -o $IMAGE $URL
else
  echo using local image $IMAGE ...
fi

echo "resizing image to 50G ..."
qemu-img resize $IMAGE 50G

echo ""
echo "building docker container $CONTAINER:$VERSION ..."
docker build -t $CONTAINER:$VERSION .

# cross platform build 
#	docker buildx build --platform linux/amd64 -t vesio-ver9-ce --load .
#
echo ""
docker image ls $CONTAINER:$VERSION

