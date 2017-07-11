#!/bin/sh

PACKAGE_NAME=falinux_board_name

echo "[*] Building docker image for ${PACKAGE_NAME}"
docker build -t ${PACKAGE_NAME} .

echo "[*] Copying runner script ~/bin"
mkdir -p ~/bin/

for RUNNER in runner/*
do
    case $RUNNER in
    runner/docker-runner*)
        echo " = copy $RUNNER"
        cp --remove-destination $RUNNER ~/bin/
        ;;
    *)
        echo " = copy $RUNNER"
        cp -a --remove-destination $RUNNER ~/bin/
        ;;
    esac
done
