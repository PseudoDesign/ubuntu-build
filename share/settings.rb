# Variables that need to be defined in a settings file
LINUX_BRANCH = "toradex_4.9-1.0.x-imx"
LINUX_REPO = "https://github.com/PseudoDesign/linux-toradex-imx.git"

UBOOT_BRANCH = "2016.11-toradex"
UBOOT_REPO = "https://github.com/PseudoDesign/uboot-toradex-imx.git"

UBOOT_CONFIG = 'apalis_imx6_defconfig'
KERNEL_CONFIG = 'apalis_imx6_defconfig'

DTB_NAME = "imx6q-apalis-eval.dtb"

ENABLE_ROOT_ACCOUNT = true
ENABLE_IMX_SERIAL_CONSOLE = true
ROOT_PASSWORD = "12345"

UBOOT_BINARY_NAME = "u-boot.img"

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
