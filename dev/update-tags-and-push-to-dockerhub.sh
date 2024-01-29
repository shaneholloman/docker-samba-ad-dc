#!/usr/bin/env bash
set -eo pipefail
set -x

repo="shaneholloman/samba-ad-dc"

# Get samba version from last ubuntu
if [[ -z "$SMB_VERSION" ]]; then
  SMB_VERSION=$(docker run --rm samba:ubuntu samba --version | awk '{ print $2 }')
fi
version=$SMB_VERSION


# Update arm64
docker tag samba:arm64 "${repo}:arm64"
docker push "${repo}:arm64"
docker rmi "${repo}:arm64"

# Update ubuntu (main) tags
for tag in amd64 ubuntu "${version}"; do
  docker tag samba:ubuntu "${repo}:${tag}"
  docker push "${repo}:${tag}"
  docker rmi "${repo}:${tag}"
done

# Update manifest to accept amd64 and arm64 as latest
docker manifest rm shaneholloman/samba-ad-dc:latest || true
docker manifest create \
  shaneholloman/samba-ad-dc:latest \
  shaneholloman/samba-ad-dc:amd64 \
  shaneholloman/samba-ad-dc:arm64
docker manifest push shaneholloman/samba-ad-dc:latest
docker manifest rm shaneholloman/samba-ad-dc:latest

# Cleanup
docker image prune -f
docker images
