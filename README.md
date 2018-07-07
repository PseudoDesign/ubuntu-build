# ubuntu-build

## Docker Image
Built using the [docker-ubuntu-arm](https://hub.docker.com/r/pseudodesign/docker-ubuntu-arm/) image.  See documentation for that container for info on how to use it.

## Setup

### Windows 10

* Install [Docker for Windows](https://www.docker.com/docker-windows)
* Install [Ruby](https://rubyinstaller.org)
* Install rake by running this on the command prompt: `gem install rake`

## Usage

### System Configuration

Set the variables in `/share/settings.rb` that match your system's settings.  For eval kits, this should generally be the uboot and kernel projects released by the manufacturer.

### Commands

#### Generate an SD Card image

Execute: `rake sd_card`

#### Open a shell into a new container

Execute: `rake shell`

Note that this does **not** save the system state after it's shut down.  Every time this command is run, a new container is generated.
