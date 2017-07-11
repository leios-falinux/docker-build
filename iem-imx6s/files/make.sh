#!/bin/bash

if [ -z "${FA_PRODUCT}" ]
then
  echo Check environment variables...
  echo source ../../env-4.9.4.env
  exit 1
fi


DEFCONFIG_FILE=${FA_CHIPSET}_${FA_PRODUCT}_defconfig
DEFCONFIG_FILE=${DEFCONFIG_FILE/-/_}

TOOLCHAIN_DEFCONFIG_FILE=${FA_CHIPSET}_${FA_PRODUCT}_toolchain_defconfig
TOOLCHAIN_DEFCONFIG_FILE=${TOOLCHAIN_DEFCONFIG_FILE/-/_}

OUTPUT_DIR=../output-buildroot-2016.08.1
if [ ! -f ${OUTPUT_DIR}/.config ]
then
	echo ${DEFCONFIG_FILE}...
	make O=${OUTPUT_DIR} ${DEFCONFIG_FILE}
fi

case $1 in
	help)
		echo ""
		echo "[Help]"
		echo " ssh-key       : generate ssh key"
		echo " defconfig     : reload config"
		echo " toolchain     : apply config file for toolchain"
		echo " image         : generate ramdisk image file"
		echo " clean-target  : clean target directory"
		echo " distclean     : delete all non-source files (.config)"
		echo " savedefconfig : Save current config to BR2_DEFCONFIG (minimal config)"
		echo ""
		;;
	ssh-key)
		board/falinux/common/mk-ssh-key.sh
		;;
	toolchain)
                echo CONFIG: ${TOOLCHAIN_DEFCONFIG_FILE}
		make O=${OUTPUT_DIR} ${TOOLCHAIN_DEFCONFIG_FILE}
		;;
	defconfig)
                echo CONFIG: ${DEFCONFIG_FILE}
		make O=${OUTPUT_DIR} ${DEFCONFIG_FILE}
		;;
	image)
		shift
		board/falinux/common/generate-image.sh O=${OUTPUT_DIR} $@
		;;
	clean-target)
		rm -Rf ${OUTPUT_DIR}/target
		find ${OUTPUT_DIR}/build -name ".stamp_target_installed" -exec rm {} \;
		find ${OUTPUT_DIR}/build -name ".stamp_staging_installed" -exec rm {} \;
		;;
	distclean)
		rm -Rf ${OUTPUT_DIR}
		;;
	*)
		make O=${OUTPUT_DIR} $@
		;;
esac
