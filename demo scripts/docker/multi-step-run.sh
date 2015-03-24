#! switch [my-docker-host]

# Make sure to create the container my-docker-host, using the script 'start-host.sh'
# before running this workflow.


# Uncomment and run this only the first time:
# apt-get install -y docker

# You can specify custom container name when running the Workflow with setting the NAME=xxxx env variable.
if [ -n "$NAME" ]; then
	HOSTNAME="--env HOSTNAME=$$NAME"
fi

if [ -z "$ORG_ID" ]; then
	echo "ORG_ID env variable should be passed"
	exit 1
fi

# See more available images from hub.docker.com/u/cloudrunnerio/
# You can build your custom images, using any of the CloudRunner.IO images as BASE
IMAGE_TYPE=${IMAGE_TYPE:-cloudrunnerio/debian}

# By default mark container as auto_cleanup=true. This will force the container registration
# to be automatically removed when the container detaches from the Master server.
# This way you don't need to manually revoke the node registration from the Dashboard.
AUTO_CLEANUP={AUTO_CLEANUP:-'-l'}

HOST=$(docker run -d -i --env SERVER_ID="master.cloudrunner.io" \
	$HOSTNAME $AUTO_CLEANUP --env ORG_ID="$ORG_ID" $IMAGE_TYPE)

# Sleep for 4 sec to allow the server to connect and register at the Master server.
sleep 4


#! switch [$HOST]

uname -a

cloudrunner-node details

SUCCESS=1

# Run scripts of your choice here...


#! switch [my-docker-host]

if [ -n "$SUCCESS"]; then
	# Perform cleanup of the container, after a successful run,
	# otherwise keep the instance for debugging
	docker rm -f $HOST
fi
