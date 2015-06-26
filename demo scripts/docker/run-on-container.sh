# Follow the tutorial at: https://docs.docker.com/articles/https/ how to configure docker to accept remote SSL connections.
# Then get the client cert and key and add them as a CloudProfile in your CloudRunner.IO profile: https://my.cloudrunner.io/clouds

# Then create a new automation, using for target a new server, deployed on the newly created Cloud Profile
# You can use some of the cloudrunner-enabled imagesm, like:
#  - cloudrunnerio/debian
#  - cloudrunnerio/centos
#  - cloudrunnerio/ubuntu
#  - cloudrunnerio/opensuse
#  - cloudrunnerio/arch

# Or you can manually start the node as a Docker container:

# docker run -d -i \
#	--env SERVER_ID="master.cloudrunner.io" \
#	--hostname $NAME \
#	--name=$NAME \
#	--env ORG_ID=$ORG_ID -t $IMAGE

# Find your ORG_ID at: https://my.cloudrunner.io/apikeys

uname -a

cloudrunner-node details
