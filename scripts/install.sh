#!/bin/bash
set -e
appdata="$APPDATA/devapps/"
bindir="$HOME/.devapps/bin"

function createDirIfDoesntExist {
    if [ ! -d "$1" ]; then
      mkdir "$1"
    fi
}
function downloadAppengine {
  curl --location \
    --progress-bar \
    --url "$1" \
    --output "${appdata}/deps/appengine.zip"
}
function downloadBuildFiles {
  curl --location \
    --progress-bar \
    --url "$1" \
    --output "${appdata}/deps/build.zip"
}
function downloadBuildserverFiles {
  curl --location \
    --progress-bar \
    --url "$1" \
    --output "${appdata}/deps/buildserver.zip"
}
function downloadUpgradeScript() {
    curl --location \
    --progress-bar \
    --url "https://raw.githubusercontent.com/Horizon3833/DevApps/master/scripts/update.sh" \
    --output "${appdata}/scripts/upgrade.sh"
}
function unpackFiles {
    # Unzip the downloaded files
    unzip -o -q "${appdata}/deps/appengine.zip" -d "${appdata}/deps/appengine"
    unzip -o -q "${appdata}/deps/build.zip" -d "${appdata}/deps"
    unzip -o -q "${appdata}/deps/buildserver.zip" -d "${appdata}/deps/buildserver"
    # So we don't take a large space
    rm "${appdata}/deps/appengine.zip"
    rm "${appdata}/deps/build.zip"
    rm "${appdata}/deps/buildserver.zip"
}
green="\033[32m"
yellow="\033[33m"
reset="\033[0m"

echo "Starting DevApps installation.."

appengineDownloadUrl=$(curl -s "https://devapps-7b02c-default-rtdb.firebaseio.com/appengine.json" | sed "s/\"//g")
buildDownloadUrl=$(curl -s "https://devapps-7b02c-default-rtdb.firebaseio.com/build.json" | sed "s/\"//g")
buildserverDownloadUrl=$(curl -s "https://devapps-7b02c-default-rtdb.firebaseio.com/buildserver.json" | sed "s/\"//g")

createDirIfDoesntExist "$HOME/.devapps"
createDirIfDoesntExist "${bindir}"
createDirIfDoesntExist "${appdata}"
createDirIfDoesntExist "${appdata}/deps"
createDirIfDoesntExist "${appdata}/scripts"

echo "Downloading Appengine java SDK.."
downloadAppengine "${appengineDownloadUrl}"
echo -e "${green}Done!${reset}"
echo "Downloading Build files.."
downloadBuildFiles "${buildDownloadUrl}"
echo -e "${green}Done!${reset}"
echo "Downloading Buildserver files.."
downloadBuildserverFiles "${buildserverDownloadUrl}"
echo -e "${green}Done!${reset}"
echo "Downloading Upgrade Script.."
downloadUpgradeScript
echo -e "${green}Done!${reset}"
echo "Extracting files.."
unpackFiles
echo -e "${green}Done!${reset}"
echo -e "${yellow}DevApps has been successfully installed on your device! Please add this path: ${bindir} to your PATH environment variable, then run devapps -v to verify the installation.${reset}"
