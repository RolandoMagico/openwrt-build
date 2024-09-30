#!/bin/bash
set -e

OPENWRT_BUILD_REPO=https://github.com/RolandoMagico/openwrt.git
OPENWRT_BUILD_BRANCH=E30
OPENWRT_BUILD_DIRECTORY=openwrt

OPENWRT_UPSTREAM_REPO=https://github.com/openwrt/openwrt.git
OPENWRT_UPSTREAM_BRANCH=main

# Remove build directory, if it exists
if [ -d "$OPENWRT_BUILD_DIRECTORY" ]; then rm -Rf $OPENWRT_BUILD_DIRECTORY; fi

git clone ${OPENWRT_BUILD_REPO} -b ${OPENWRT_BUILD_BRANCH} ${OPENWRT_BUILD_DIRECTORY}

cd ${OPENWRT_BUILD_DIRECTORY}
git remote add upstream ${OPENWRT_UPSTREAM_REPO}
git fetch upstream

git rebase upstream/${OPENWRT_UPSTREAM_BRANCH}
git push --force

./scripts/feeds update -a
./scripts/feeds install -a

# Write changes to .config
cp ./../diffconfig .config
 
# Expand to full config
make defconfig

# Number of jobs used for make: Use number of processors
OPENWRT_BUILD_JOB_COUNT=$(cat /proc/cpuinfo | grep processor | wc -l)

make -j${OPENWRT_BUILD_JOB_COUNT}
