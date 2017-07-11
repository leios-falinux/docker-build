FROM ubuntu:16.04

# Set the locale
RUN apt-get clean && apt-get update
RUN apt-get -y install locales
RUN locale-gen ko_KR.UTF-8

ENV LANG ko_KR.UTF-8
ENV LC_ALL ko_KR.UTF-8

RUN \
    apt-get update && \
    apt-get -y install \
        curl sudo \
        git-core build-essential gcc-arm-none-eabi libssl-dev \
        sed binutils patch gzip bzip2 perl tar cpio python unzip rsync wget \
        libz3-dev libncurses5-dev pkg-config libusb-1.0-0-dev \
        bc lzop u-boot-tools vim flex bison device-tree-compiler \
        && \
    rm -rf /var/lib/apt/lists/*

ENV BUILDROOT_VERSION 2016.08.1
env WORK_TOP_PATH /work

env FA_COMPANY falinux
env FA_CHIPSET falinux_chipset_name
env FA_PRODUCT falinux_board_name

env BR_TOOLCHAIN_PREFIX arm-buildroot-linux-gnueabihf
env BR_TOOLCHAIN_PATH /opt/toolchain/${FA_CHIPSET}/${FA_PRODUCT}

env CROSS_COMPILE ${BR_TOOLCHAIN_PREFIX}-
env ARCH arm

env PATH $PATH:${BR_TOOLCHAIN_PATH}/usr/bin
env WORK_LD_LIBRARY_PATH ${BR_TOOLCHAIN_PATH}/usr/lib

env BOOTLOADER_DIR u-boot-xlnx-xilinx-v2016.2
env BUILDROOT_DIR buildroot-2016.08.1
env KERNEL_DIR linux-xlnx-xilinx-v2016.2


RUN curl -o- https://buildroot.uclibc.org/downloads/buildroot-${BUILDROOT_VERSION}.tar.gz | tar xz -C /tmp
ADD files/* /tmp/buildroot-${BUILDROOT_VERSION}/
RUN \
    cd /tmp/buildroot-${BUILDROOT_VERSION} && \
    ./make.sh toolchain && \
    ./make.sh && \
    rm -Rf ../output-*

CMD ["/bin/bash"]

WORKDIR /work

