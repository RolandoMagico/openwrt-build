# D-Link COVR-X1860
Scripts to build OpenWrt images for D-Link COVR-X1860. Tested on Linux Mint.

HowTo:
- Clone the D-Link_COVR-X1860 branch
```
git clone https://github.com/RolandoMagico/openwrt-build.git -b D-Link_COVR-X1860
```

- Goto the new directory
```
cd openwrt-build
```

- Run the build
```
./buid.sh
```

The script will install the required build tools via apt so it will prompt for your password.
The build will take some time depending on your environment.
If nothing fails, there should be a "bin" directory which contains the built packages and images.
