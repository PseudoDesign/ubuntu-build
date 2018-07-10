# Variables that need to be defined in a settings file
LINUX_BRANCH = "4.1-2.0.x-imx"
LINUX_REPO = "https://github.com/Freescale/linux-fslc.git"

IMPORT_KERNEL_DEFCONFIG = "/share/imx_v7_with_fhandle"

UBOOT_BRANCH = "imx_v2016.03_4.1.15_2.0.0_ga"
UBOOT_REPO = "git://git.freescale.com/imx/uboot-imx.git"

UBOOT_CONFIG = 'mx6ull_14x14_evk_defconfig'
KERNEL_CONFIG = 'imx_v7_defconfig'

DTB_NAME = "imx6ull-14x14-evk.dtb"

ENABLE_ROOT_ACCOUNT = true
ENABLE_IMX_SERIAL_CONSOLE = true
ROOT_PASSWORD = "12345"

UBOOT_BINARY_NAME = "u-boot.imx"

PARTITION_INFO = [
  {
    partition_name: "boot",
    partition_start_sector: 2048,
    partition_length_sectors: (1024 * 1024 * 500 / 4)/512,
    fdisk_type: "6", # FAT16
    mkfs_command: "mkfs.vfat"
  },
  {
    partition_name: "rootfs1",
    partition_start_sector: 280000,
    partition_length_sectors: (1024 * 1024 * 500)/512,
    mkfs_command: "mkfs.ext3"
  }
]
