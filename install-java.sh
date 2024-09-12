#!/bin/bash


#------------------------------------------------------------------------------
#
#  Install Azul Zulu Build of OpenJDK
#  Version: 1.0
#
#  MIT License
#  Copyright (c) 2024 autumo GmbH
#
#------------------------------------------------------------------------------


#
# ROOT path; current directory
#
cd "$(dirname "$0")"
ROOT=`pwd`


#
# Variables
#
AZUL_URL="https://cdn.azul.com/zulu/bin/"
DIRECTORY="jvm"
# Define your Azul Zulu runtime in this configuration file
CFG_FILE="java.cfg"
ENV_FILE="java.env"
DOWNLOAD_LINK="none"
ARCHITECTURE="none"
JRE_ARCHIVE="none"
RUNTIME_DIR="none"
OS="none"
source $CFG_FILE


clear

echo ""
echo "----------------------------------------------------------------"
echo ""
echo "  Installing Java"
echo ""
echo "  JVM: ${ZULU_RUNTIME}"
echo ""
echo "  Azul Zulu Builds of OpenJDK Terms:"
echo "  https://www.azul.com/products/core/openjdk-terms-of-use"
echo ""
echo "  Azul Platform Core and Azul Zulu Third Party Licenses:"
echo "  https://docs.azul.com/core/tpl"
echo ""
echo "----------------------------------------------------------------"

echo ""
while true; do
    read -p "Do you wish to install this JVM and accept its terms (y/n)? " yn
    case $yn in
        [Yy] ) break;;
        [Nn] ) echo ""; exit;;
        * ) echo "Please answer with y (yes) or n (no).";;
    esac
done


echo ""
echo "Evaluating architecture..."

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	OS="Linux"
	if [ $(uname -m) == "aarch64" ]; then
		ARCHITECTURE="linux_aarch64"
	elif [ $(uname -m) == "x86_64" ]; then
		ARCHITECTURE="linux_x64"
	fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
	OS="macOS"
	if [ $(uname -m) == "arm64" ]; then
		ARCHITECTURE="macosx_aarch64"
	elif [ $(uname -m) == "x86_64" ]; then
		ARCHITECTURE="macosx_x64"
	fi
fi

if [ "$ARCHITECTURE" == "none" ]; then
	echo "No compatible architecture found! Exit."
	echo ""
	exit
fi


echo "Azul Zulu Runtime: ${ZULU_RUNTIME}"
echo "Operating system: ${OS}"
echo "Architecture: ${ARCHITECTURE}"


RUNTIME_DIR="${ZULU_RUNTIME}-${ARCHITECTURE}"
JRE_ARCHIVE="${ZULU_RUNTIME}-${ARCHITECTURE}.tar.gz"
DOWNLOAD_LINK="${AZUL_URL}${JRE_ARCHIVE}"

echo ""
echo "Creating directory '${DIRECTORY}'..."
mkdir $DIRECTORY

echo ""
echo "Downloading '${DOWNLOAD_LINK}' into directory '${DIRECTORY}'..."
cd $DIRECTORY
curl -LO $DOWNLOAD_LINK

echo ""
echo "Extracting '${JRE_ARCHIVE}'..."
tar -xvzf ${JRE_ARCHIVE}
echo "Removing '${JRE_ARCHIVE}'..."
rm ${JRE_ARCHIVE}
cd ..

echo ""
echo "Adding new JAVA_HOME to environment file '${ENV_FILE}'..."
echo "JAVA_HOME=\"${ROOT}/${DIRECTORY}/${RUNTIME_DIR}\"" >> $ENV_FILE
echo "PATH=\"${ROOT}/${DIRECTORY}/${RUNTIME_DIR}/bin:\$PATH\"" >> $ENV_FILE

echo ""
echo "Test Java environment:"
# Read this ENV file wherever you want to use the installed Azul Zulu runtime environment!
source $ENV_FILE
echo "Java Home: '${JAVA_HOME}'."
java --version

echo ""
echo "Done."
echo ""

