#! /bin/sh

# Assume that something's copied the source tarball to this directory.

SRC=$(cd $(dirname "$0"); pwd)
. "${SRC}/versions.sh"
. "${SRC}/functions.sh"

mkdir -p "${SRC}/target"
curl -o "${SRC}/target/archive.zip" ${BASE_URL}/job/InterpreterVM/lastSuccessfulBuild/artifact/*zip*/archive.zip
cd "${SRC}/target/"
unzip -o archive.zip
mv archive/* .
TARBALL=`find . -name 'Squeak-vm-unix-*-src*.tar.gz' | grep -v Cog | head -1`
tar zxvf ${TARBALL}
SOURCE=`find . -name 'Squeak-vm-unix-*-src' | grep -v Cog | head -1`
mv $SOURCE $SOURCE-64
(cd $SOURCE-64/platforms/unix; make WIDTH=64)