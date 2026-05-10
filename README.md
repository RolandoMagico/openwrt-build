# openwrt-build
Scripts to build OpenWrt images via GitHub Actions.

## Variants
There are currently two variants to build OpenWrt:
- Build development images based on a branch in https://github.com/RolandoMagico/openwrt
- Build release images based on a tag in https://github.com/openwrt/openwrt

Both variants require differnet configuration files in this repository. The configuration files are stored in a subfolder of the device specific folder. The device specific folders name is the device name and stored in the root directory of this repository.

### Building development images
Building development images is used for devices which are not yet supported in OpenWrt but supported in a branch of https://github.com/RolandoMagico/openwrt. The build is intended to be used to provide development images during the process of adding support for a new device in OpenWrt. 

The required configuration files must be stored in a subfolder of the device specific folder. The folder name must match the origin of the OpenWrt branch the build is based on. Usually it's the ```main``` branch.

Two configuration files are needed:
- ```device.settings``` contains device specific branch and file names for the build
- ```diffconfig``` contains the OpenWrt diffconfig which is applied before building the image

#### Example
During the process of adding support for the D-Link M30 in OpenWrt, a branch ```M30``` is created in https://github.com/RolandoMagico/openwrt which contains the modifications in OpenWrt to support the device. The name of the branch is stored in ```device.settings```:

```
OPENWRT_GIT_BRANCH=E30
```

Additionally, the OpenWrt target profile name is stored in ```device.settings```:

```
OPENWRT_TARGET_PROFILE=filogic-dlink_aquila-pro-ai-e30-a1
```

The target profile name is used to determine the name of all artifacts which are uploaded at the end of the pipeline run.

### Building release images
Building release images is used for devices which are not yet supported in OpenWrt but patches for a specific OpenWrt version are available to get the deivce supported. The build is intended to be used to provide the same state as OpenWrt released images for the device.

To get the same state as the official images, the build configuration from the OpenWrt release is used. Advantage is that it is possible to install kernel modules from the official OpenWrt package feeds, disadvantage is that images for all supported devices of the target must be built. Depending on the used runners, this can take several hours. Using the free GitHub runners, one build run currently takes around 4 hours.

The required configuration files must be stored in a subfolder of the device specific folder. The folder name must match the related OpenWrt version, for example ```24.10.4``` or ```25.12.3```.

Two configuration files are needed:
- ```device.patch``` contains the all Git patches which are required to add support for the device to the specific OpenWrt version.
- ```device.settings``` contains device specific branch and file names for the build.

#### Example
The following ```device.settings``` file is used to build images for the Linksys MR9000 using the OpenWrt tag v25.12.3:

```
OPENWRT_RELEASE_DIRECTORY=25.12.3
OPENWRT_TARGET_DIRECTORY=ipq40xx/generic
OPENWRT_TARGET_PROFILE=linksys_mr9000
OPENWRT_GIT_BRANCH=v25.12.3
```
