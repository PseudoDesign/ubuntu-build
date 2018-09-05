# ubuntu-build
Tool for generating embedded ubuntu-based BSPs.  Built using Docker.

Runs on Ubuntu Linux.  Windows is currently not supported.

## Setup

### Install Required Software

```
sudo apt-get update
sudo apt-get install rake apt-transport-https ca-certificates curl software-properties-common qemu-user-static libdevmapper-dev
```

### Install Docker

Follow the directions on the [Docker website](https://docs.docker.com/install/linux/docker-ce/ubuntu/).

Add yourself to the docker group by executing `sudo usermod -aG docker $USER`

### Build the Docker image

`rake docker_image`

## Usage

### Rake

Various parameters (such as the Linux source directory) are located in `.../rakefile.rb`.  Modify this as needed for your project.

#### List Commands

List the available rake commands by executing

`rake -T`

### Scripts

The scripts in the `.../scripts` directory provide wrappers for running commands in the docker image.

#### docker_execute

Executes a command on the image in a bash shell.  This also mounts the `.../source` directory at `/source`.

Example: `docker_execute gcc /source/hello_world.c`

#### crossmake

Executes a `make` command on the image in a bash shell.  Uses `docker_execute`

Example: `crossmake ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -C /source/linux menuconfig`

### Add Source Submodules

Add your Linux source tree to the `.../source/` directory by executing

`git submodule add `
