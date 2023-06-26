#!/bin/bash
set -e

################################################################################
# Configuration Section
################################################################################
# OpenWrt Git references, not (yet) used
OPENWRT_BUILD_OPENWRT_GIT_URL=https://github.com/openwrt/openwrt.git
OPENWRT_BUILD_OPENWRT_GIT_BRANCH=main
OPENWRT_BUILD_OPENWRT_DIRECTORY=openwrt

# Number of jobs used for make: Use number of processors
OPENWRT_BUILD_JOB_COUNT=$(cat /proc/cpuinfo | grep processor | wc -l)

# Install required build packages
sudo apt update
sudo apt install build-essential clang flex bison g++ gawk gcc-multilib g++-multilib gettext git libncurses-dev libssl-dev python3-distutils rsync unzip zlib1g-dev file wget

# Cleanup before build
rm -R -f ${OPENWRT_BUILD_OPENWRT_DIRECTORY}

# Clone repositories
git clone ${OPENWRT_BUILD_OPENWRT_GIT_URL} -b ${OPENWRT_BUILD_OPENWRT_GIT_BRANCH} ${OPENWRT_BUILD_OPENWRT_DIRECTORY}

# Apply OpenWrt patches
for patch in patches/openwrt/*.patch; do
	git apply --ignore-space-change --directory=${OPENWRT_BUILD_OPENWRT_DIRECTORY} "$patch"
done

./${OPENWRT_BUILD_OPENWRT_DIRECTORY}/scripts/feeds update -a
./${OPENWRT_BUILD_OPENWRT_DIRECTORY}/scripts/feeds install -a

# Copy configuration to OpenWrt directory
cp .config ${OPENWRT_BUILD_OPENWRT_DIRECTORY}
make --directory=${OPENWRT_BUILD_OPENWRT_DIRECTORY} -j${OPENWRT_BUILD_JOB_COUNT}

# Create images and move output folder to local directory
mv ${OPENWRT_BUILD_OPENWRT_DIRECTORY}/bin .
