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

# Install requirements
if [ -n "$(which apt-get)" ]; then
	# Debian/Ubuntu
    PKG_CMD=$(which apt-get)
    LIBS="g++ python-dev libssl-dev git-core m2crypto swig python-setuptools"
    PKG_UPDATE="$PKG_CMD update"
    PKG_INSTALL="$PKG_CMD install -y $LIBS"
elif [ -n "$(which yum)" ]; then
	# RedHat/Fedora/CentOS
    PKG_CMD=$(which yum)
    LIBS="gcc-c++ python-devel openssl-devel git swig python-setuptools m2crypto epel-release"
    PKG_UPDATE=""
    PKG_INSTALL="$PKG_CMD install -y $LIBS"
elif [ -n "$(which zypper)" ]; then
	# SUSE Linux
    PKG_CMD=$(which zypper)
    LIBS="gcc-c++ python-devel openssl-devel git swig python-m2crypto"
    PKG_UPDATE=""
    PKG_INSTALL="$PKG_CMD -n in $LIBS"
elif [ -n "$(which pacman)" ]; then
	# ArchLinux
    PKG_CMD=$(which pacman)
    LIBS="gcc python2 openssl git swig python2-m2crypto"
    PKG_UPDATE="$PKG_CMD -Syu --noconfirm"
    PKG_INSTALL="$PKG_CMD -Sy --noconfirm --needed $LIBS"
    PYTHON="$(which python2)"
    ADDS="$PKG_CMD -Sy --noconfirm --needed python2-pyzmq"
elif [ -n "$(which emerge)" ]; then
	# Gentoo
    PKG_CMD=$(which emerge)
    LIBS="openssl dev-vcs/git swig m2crypto"
    PKG_UPDATE="$PKG_CMD --sync"
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

if [ -n "$ADDS" ]; then
    $ADDS
fi

# Clean 'cloudrunner' dir if exists
rm -rf cloudrunner

# Clone cloudrunner stable branch
git clone https://github.com/CloudRunnerIO/cloudrunner.git

cd cloudrunner

$PYTHON setup.py install

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
