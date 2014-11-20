#! /bin/bash

# Expects the following variables:
# $CRN_SERVER 	(mandatory)		- if omitted - the script will ask and wait for input in console.
# $CRN_ORG		(conditional)	- mandatory for auto-approve, otherwise optional
# $CRN_TAGS		(optional)		- optional tags (space-separated)
# $CRN_NODE		(optional)		- node name, defaults to hostname
# $CRN_OVERWRITE(optional)		- overwrite existing config
# $PIDFILE 		(optional)		- modify the path to the service PID file

PKG_CMD=""
PKG_UPDATE=""
PKG_INSTALL=""
LIBS=""
PYTHON="$(which python)"

# Install requirements
if [ -n "$(which apt-get)" ]; then
	# Debian/Ubuntu
    PKG_CMD=$(which apt-get)
    LIBS="g++ python-dev libssl-dev git swig"
    PKG_UPDATE="$PKG_CMD update"
    PKG_INSTALL="$PKG_CMD install -y $LIBS"
elif [ -n "$(which yum)" ]; then
	# RedHat/Fedora/CentOS
    PKG_CMD=$(which yum)
    LIBS="gcc-c++ python-devel openssl-devel git swig"
    PKG_UPDATE=""
    PKG_INSTALL="$PKG_CMD install -y $LIBS"
elif [ -n "$(which zypper)" ]; then
	# SUSE Linux
    PKG_CMD=$(which zypper)
    LIBS="gcc-c++ python-devel openssl-devel git swig"
    PKG_UPDATE=""
    PKG_INSTALL="$PKG_CMD -n in $LIBS"
elif [ -n "$(which pacman)" ]; then
	# ArchLinux
    PKG_CMD=$(which pacman)
    LIBS="gcc python2 openssl git swig"
    PKG_UPDATE=""
    PKG_INSTALL="yes | $PKG_CMD -Sy $LIBS"
    PYTHON="$(which python2)"
elif [ -n "$(which emerge)" ]; then
	# Gentoo
    PKG_CMD=$(which emerge)
    LIBS="gcc python2 openssl dev-vcs/git swig"
    PKG_UPDATE=""
    PKG_INSTALL="$PKG_CMD $LIBS"
fi

if [ -z "$PKG_CMD" ]; then
	echo "No package manager detected! Exiting..."
	exit 1
fi

# Update repo data
$PKG_UPDATE

# Install requirements
$PKG_INSTALL

# Clean 'cloudrunner' dir if exists
rm -rf cloudrunner

# Clone cloudrunner stable branch
git clone -b v1.0 https://github.com/CloudRunnerIO/cloudrunner.git

cd cloudrunner

$PYTHON setup.py install

OPTS=""

if [[ ! $CRN_SERVER ]]; then
	echo "Enter CloudRunner Master Server IP:"
	read CRN_SERVER
fi

if [[ $CRN_ORG && ${CRN_ORG-x} ]]; then
	OPTS=" $OPTS --org $CRN_ORG"
fi

if [[ $CRN_OVERWRITE && ${CRN_OVERWRITE-x} ]]; then
	OPTS=" $OPTS --overwrite"
fi

if [[ $CRN_TAGS && ${CRN_TAGS-x} ]]; then
	OPTS=" $OPTS -t $CRN_TAGS"
fi

# Initial configuration
cloudrunner-node configure --mode server --id ${CRN_NODE:-$(hostname)} --server $CRN_SERVER $OPTS

# Run service
cloudrunner-node restart --pidfile ${PIDFILE:-/var/run/cloudrunner-node.pid}
