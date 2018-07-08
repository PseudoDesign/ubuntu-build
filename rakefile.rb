RAKEFILE_DIR = File.expand_path(File.dirname(__FILE__))
HOST_SHARE_DIR = File.join(RAKEFILE_DIR, "share")
TARGET_SHARE_DIR = "/share"
DOCKER_IMAGE = "pseudodesign/docker-ubuntu-arm:0.0.1"
USERNAME = "appuser"

task :fetch_image do

end

task :shell do
  sh "docker run -u #{USERNAME} -it -v #{HOST_SHARE_DIR}:#{TARGET_SHARE_DIR} --privileged #{DOCKER_IMAGE} /bin/bash"
end

task :sd_card do
  sh "docker run -u #{USERNAME} -it -v #{HOST_SHARE_DIR}:#{TARGET_SHARE_DIR} --privileged #{DOCKER_IMAGE} /bin/bash -c \"rake sd_card\""
end
