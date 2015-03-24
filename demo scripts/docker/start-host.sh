# This script should be run on a Docker server(CoreOS or Linux machine with Docker installed)
# Make sure to install docker on that container after starting it.
# You can choose a base images of your choice. As long as you mount
# /var/run/docker.sock to that image, it can play as a Docker host

docker run -d -i \
	--env SERVER_ID="master.cloudrunner.io" \
	-h my-docker-host \
	--name="my-docker-host" \
	-v /var/run/docker.sock:/var/run/docker.sock \
	--env ORG_ID="<YOUR-ORG-ID>" -t cloudrunnerio/ubuntu