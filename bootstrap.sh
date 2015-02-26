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
ADDS=""
PIP="pip"

# Install requirements
if [ -n "$(which apt-get)" ]; then
	# Debian/Ubuntu
    PKG_CMD=$(which apt-get)
    LIBS="g++ python-dev python-pip m2crypto msgpack-python python-psutil python-zmq"
    PKG_UPDATE="$PKG_CMD update"
    PKG_INSTALL="$PKG_CMD install -y $LIBS"
elif [ -n "$(which yum)" ]; then
	# RedHat/Fedora/CentOS
    PKG_CMD=$(which yum)
    LIBS="python-pip m2crypto python-zmq python-psutil"
    PKG_UPDATE="yum install -y epel-release"
    PKG_INSTALL="$PKG_CMD install -y $LIBS"
elif [ -n "$(which zypper)" ]; then
	# SUSE Linux
    PKG_CMD=$(which zypper)
    LIBS="gcc-c++ python-pip python-devel python-m2crypto"
    PKG_UPDATE=""
    PKG_INSTALL="$PKG_CMD -n in $LIBS"
elif [ -n "$(which pacman)" ]; then
	# ArchLinux
    PKG_CMD=$(which pacman)
    PIP="pip2"   
    LIBS="gcc python2 python2-pip python2-m2crypto"
    PKG_UPDATE="$PKG_CMD -Syu --noconfirm"
    PKG_INSTALL="$PKG_CMD -Sy --noconfirm --needed $LIBS"
    PYTHON="$(which python2)"
    ADDS="$PKG_CMD -Sy --noconfirm --needed python2-pyzmq"
fi

if [ -z "$PKG_CMD" ]; then
	echo "No package manager detected! Exiting..."
	exit 1
fi

# Update repo data
$PKG_UPDATE

# Install requirements
$PKG_INSTALL

if [ -n "$ADDS" ]; then
    $ADDS
fi

$PIP install cloudrunner

OPTS=""

if [[ ! $CRN_SERVER ]]; then
	echo "Enter CloudRunner Master Server IP:"
	read CRN_SERVER
fi

if [[ $CRN_KEY && ${CRN_KEY-x} ]]; then
	OPTS=" $OPTS --org $CRN_KEY"
fi

if [[ $CRN_OVERWRITE && ${CRN_OVERWRITE-x} ]]; then
	OPTS=" $OPTS --overwrite"
fi

if [[ $CRN_TAGS && ${CRN_TAGS-x} ]]; then
	OPTS=" $OPTS -t $CRN_TAGS"
fi

HOST=""
if [ -n "$(which hostid)" ]; then
    HOST=$(hostid)
else
    HOST=$(hostname)
fi

# Initial configuration
cloudrunner-node configure --id ${CRN_NODE:-$HOST} --server $CRN_SERVER $OPTS

cloudrunner-node details

if [[ ! $CRN_NORUN ]]; then
    cloudrunner-node restart --pidfile ${PIDFILE:-/var/run/cloudrunner-node.pid}
fi
