# D-Link_EAGLE_PRO_AI_M32
Scripts to build an OpenWrt images for D-Link_EAGLE_PRO_AI_M32 with the latest OpenWrt main branch. Tested on Linux Mint.

HowTo:
- Clone the D-Link_EAGLE_PRO_AI_M32 branch
```
git clone https://github.com/RolandoMagico/openwrt-build.git -b D-Link_EAGLE_PRO_AI_M32
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
If nothing fails, there should be a "Build_YYYYMMDD_HHMM" directory which contains the built packages and images.
