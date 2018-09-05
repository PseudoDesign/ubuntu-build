require 'fileutils'

RAKEFILE_DIR = File.expand_path(File.dirname(__FILE__))

require File.join(RAKEFILE_DIR, "helper.rb")

IMAGE_NAME = "docker-ubuntu-arm"
DOCKER_DIR = File.join(RAKEFILE_DIR, IMAGE_NAME)
SCRIPTS_DIR = File.join(RAKEFILE_DIR, "scripts")
BUILD_DIR = File.join(RAKEFILE_DIR, "build")

# Modify this as needed by your project

# Linux Config

LINUX_CONFIG = "apalis_imx6_defconfig"
LINUX_REPO = "linux-toradex-imx"
LINUX_SRC_DIR = "/source/#{LINUX_REPO}"
LINUX_DEFCONFIG = "apalis_imx6_defconfig"
LINUX_HOST_BUILD_DIR = File.join(BUILD_DIR, "linux")
LINUX_DTB = "imx6q-apalis-eval.dtb"
LINUX_IMAGE = "zImage"

CROSSMAKE_ARCH = "arm"

# Rootfs Config

UBUNTU_VERSION = "xenial"

RFS_HOST_BUILD_DIR = File.join(BUILD_DIR, "rootfs")
RFS_GUEST_BUILD_DIR = "/build/rootfs"
RFS_ARCH="armhf"

CROSS_COMPILER="arm-linux-gnueabihf-"

THREADS=8

def docker_execute(cmd)
  sh "#{SCRIPTS_DIR}/docker_execute #{cmd}"
end

def crossmake(args)
   sh "#{SCRIPTS_DIR}/crossmake -j#{THREADS} ARCH=#{CROSSMAKE_ARCH} CROSS_COMPILE=#{CROSS_COMPILER} #{args}"
end

# Ubuntu Rootfs Commands

RFS_FIRST_STAGE_DIR = "/build/.rootfs/rfs_first"
RFS_FIRST_STAGE_HOST_DIR = File.join(BUILD_DIR, ".rootfs", "rfs_first")
RFS_SECOND_STAGE_DIR = "/build/.rootfs/rfs_second"
RFS_SECOND_STAGE_HOST_DIR = File.join(BUILD_DIR, ".rootfs", "rfs_second")

desc "Installs the .../sources/authorized_keys file for ssh access **DEBUG IMAGE ONLY**"
task :ssh_key do
  docker_execute("sudo mkdir -p /build/rootfs/root/.ssh")
  docker_execute("sudo cp /source/authorized_keys /build/rootfs/root/.ssh/.")
  docker_execute("sudo chmod 700 /build/rootfs/root/.ssh")
  docker_execute("sudo chmod 600 /build/rootfs/root/.ssh/authorized_keys")
end

desc "Remove the rootfs build directory"
task :rootfs_clean do
  docker_execute("sudo rm -rf #{RFS_GUEST_BUILD_DIR}")  
end

desc "Creates the first stage rootfs"
task :rootfs_first_stage do
  if File.exist?(RFS_FIRST_STAGE_HOST_DIR)
    puts "Rootfs first stage directory already exists."
  else
    docker_execute("sudo debootstrap --arch=#{RFS_ARCH} --foreign --include=ubuntu-keyring,apt-transport-https,ca-certificates,openssl #{UBUNTU_VERSION} \"#{RFS_FIRST_STAGE_DIR}\" http://ports.ubuntu.com")
  end
end

desc "Run the second stage of the rootfs install"
task :rootfs_second_stage => [:rootfs_first_stage] do
  if File.exist?(RFS_SECOND_STAGE_HOST_DIR)
    puts "Rootfs second stage directory already exists."
  else
    docker_execute("sudo cp -r --preserve #{RFS_FIRST_STAGE_DIR} #{RFS_SECOND_STAGE_DIR}")
    docker_execute("sudo cp /usr/bin/qemu-arm-static #{RFS_SECOND_STAGE_DIR}/usr/bin")
    docker_execute("sudo cp /source/debootstrap_second_stage.sh #{RFS_SECOND_STAGE_DIR}/.debootstrap.sh && sync")
    docker_execute("sudo /usr/sbin/chroot #{RFS_SECOND_STAGE_DIR} /bin/bash -c ./.debootstrap.sh")
  end
end

desc "copy the application to the /root directory, build the default rootfs and execute the bootstrap script on it"
task :rootfs => [:rootfs_second_stage] do
   if File.exist?(RFS_HOST_BUILD_DIR)
    puts "Rootfs directory already exists."
  else
    docker_execute("sudo cp -r --preserve #{RFS_SECOND_STAGE_DIR} #{RFS_GUEST_BUILD_DIR}")
  end
    docker_execute("sudo cp /source/bootstrap.sh #{RFS_GUEST_BUILD_DIR}/.bootstrap.sh && sync")
    docker_execute("sudo HOME=/root /usr/sbin/chroot #{RFS_GUEST_BUILD_DIR} /bin/bash -c ./.bootstrap.sh")
end 

task :rootfs_shell do
  docker_execute("sudo HOME=/root /usr/sbin/chroot #{RFS_GUEST_BUILD_DIR} /bin/bash -i ")
end

# Docker Image Commands

desc "builds the docker image located in the .../#{IMAGE_NAME} directory and tags it as #{IMAGE_NAME}"
task :docker_image do
  sh "docker build -t #{IMAGE_NAME} #{DOCKER_DIR}"
end

desc "opens a shell into the #{IMAGE_NAME} docker image"
task :shell do
  sh "#{SCRIPTS_DIR}/docker_execute "
end

# Linux Commands

def linux_crossmake(args)
  crossmake("-C #{LINUX_SRC_DIR} #{args}")
end

desc "initialize the kernel with the provided config file #{LINUX_DEFCONFIG}"
task :linux_defconfig do
  linux_crossmake(LINUX_DEFCONFIG)
end

desc "brings up the menuconfig screen for linux"
task :linux_menuconfig do
  linux_crossmake("menuconfig")
end

desc "cross compiles linux for the '#{CROSSMAKE_ARCH}' platform using the cc prefix '#{CROSS_COMPILER}'"
task :linux do
  linux_crossmake("#{LINUX_IMAGE} modules dtbs")
  FileUtils.mkdir_p LINUX_HOST_BUILD_DIR
  FileUtils.cp File.join(RAKEFILE_DIR, "source", LINUX_REPO, "arch", CROSSMAKE_ARCH, "boot", LINUX_IMAGE), LINUX_HOST_BUILD_DIR
  FileUtils.cp File.join(RAKEFILE_DIR, "source", LINUX_REPO, "arch", CROSSMAKE_ARCH, "boot", "dts", LINUX_DTB), LINUX_HOST_BUILD_DIR
end

desc "performs a make clean on the provided linux directory"
task :linux_clean do
  linux_crossmake("clean")
end
