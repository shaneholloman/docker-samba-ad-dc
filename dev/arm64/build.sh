#!/usr/bin/env bash
# This line sets the shell to stop if any command fails (set -e),
# to exit if pipe commands fail (set -o pipefail), and to print each command before executing it (set -x).
set -eo pipefail
set -x

# This block checks if the SMB_VERSION variable is set.
# If it's not, it runs the latest-published-samba.sh script from the dev directory and assigns the output to SMB_VERSION.
if [[ -z "$SMB_VERSION" ]]; then
  SMB_VERSION=$(dev/latest-published-samba.sh)
fi

# This line exports the SMB_VERSION variable so it can be used by child processes.
export SMB_VERSION

# This line runs the docker buildx ls command, which lists all the builder instances,
# and filters the output for the string "arm64". If the command fails, it returns true to prevent the script from exiting.
ARM64=$(docker buildx ls | grep arm64) || true

# This block checks if the ARM64 variable is empty.
# If it is, it runs the tonistiigi/binfmt Docker image with the --install all option,
# which sets up QEMU emulation for all supported CPU architectures.
if [[ "$ARM64" == '' ]]; then
  docker run --privileged --rm \
    tonistiigi/binfmt --install all
fi

# This command builds a Docker image using the docker buildx build command.
# The --platform option specifies that the image should be built for the arm64 architecture.
# The -f option specifies the Dockerfile to use, which is located in the dockerfiles/ubuntu directory.
# The --build-arg option passes the SMB_VERSION variable to the Dockerfile.
# The --load option loads the built image into the Docker engine.
# The --tag option tags the built image with the tag samba:arm64.
docker buildx build \
  --platform linux/arm64 \
  -f dockerfiles/ubuntu \
  --build-arg SMB_VERSION="$SMB_VERSION" \
  --load --tag samba:arm64 .
