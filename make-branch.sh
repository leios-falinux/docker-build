#/bin/bash
if [ -z "$1" ]
then
  echo "Usage: $0 <PROJECT NAME>"
  exit 1
fi

PROJECT_NAME=$1

PROJECT_NAME_LOWER=$(echo ${PROJECT_NAME} | tr '[:upper:]' '[:lower:]')
PROJECT_NAME_UPPER=$(echo ${PROJECT_NAME} | tr '[:lower:]' '[:upper:]')

PROJECT_NAME_LOWER_UNDERBAR=${PROJECT_NAME_LOWER/-/_}
PROJECT_NAME_LOWER_DASH=${PROJECT_NAME_LOWER/_/-}

PROJECT_NAME_UPPER_UNDERBAR=${PROJECT_NAME_UPPER/-/_}
PROJECT_NAME_UPPER_DASH=${PROJECT_NAME_UPPER/_/-}

echo ""
echo "  FALINUX BSP"
echo ""
echo " 1) imx6"
echo " 2) ez-zynq"
echo " 3) ti"
echo ""
echo -n "SELECT: "
read PLATFORM_SELECTION


case $PLATFORM_SELECTION in
    1)
        PLATFORM=iem-imx6s
	echo ""
	echo " 1) imx6s"
	echo " 2) imx6dl"
	echo " 3) imx6d"
	echo " 4) imx6q"
	echo ""
	echo -n "SELECT: "
	read CHIPSET_SELECTION
	case $CHIPSET_SELECTION in
		1)
			CHIPSET_NAME=imx6s
			;;
		2)
			CHIPSET_NAME=imx6dl
			;;
		3)
			CHIPSET_NAME=imx6d
			;;
		4)
			CHIPSET_NAME=imx6q
			;;

	esac
        ;;
    2)
	CHIPSET_NAME=zynq
        PLATFORM=ez-zynq
        ;;
    3)
        PLATFORM=ti
	echo ""
	echo " 1) am335x"
	echo ""
	echo -n "SELECT: "
	read CHIPSET_SELECTION
	case $CHIPSET_SELECTION in
		1)
			CHIPSET_NAME=am335x
			;;
	esac
        ;;
esac

if [ -z "$PLATFORM" ]
then
  echo "Unknown platform!"
  exit
fi
CHIPSET_NAME_LOWER=$(echo ${CHIPSET_NAME} | tr '[:upper:]' '[:lower:]')
CHIPSET_NAME_UPPER=$(echo ${CHIPSET_NAME} | tr '[:lower:]' '[:upper:]')

git checkout -b ${PROJECT_NAME_LOWER_UNDERBAR}

echo " [*] Rename files..."
find . -type d -name *ricecooker* -exec rename "s/ricecooker/${PROJECT_NAME_LOWER_UNDERBAR}/g" {} \; 2>/dev/null
find . -type f -name *ricecooker* -exec rename "s/ricecooker/${PROJECT_NAME_LOWER_UNDERBAR}/g" {} \; 2>/dev/null
find . -type l -name *ricecooker* -exec rename "s/ricecooker/${PROJECT_NAME_LOWER_UNDERBAR}/g" {} \; 2>/dev/null

echo " [*] Replace files..."
FILE_LIST=$(grep -lRIie "falinux[_-]board[_-]name" . 2>/dev/null)

sed -ri "s/ricecooker/${PROJECT_NAME_LOWER_UNDERBAR}/g" ${FILE_LIST}
sed -ri "s/RICECOOKER/${PROJECT_NAME_UPPER_UNDERBAR}/g" ${FILE_LIST}
sed -ri "s/ricecooker/${PROJECT_NAME_LOWER_DASH}/g" ${FILE_LIST}
sed -ri "s/RICECOOKER/${PROJECT_NAME_UPPER_DASH}/g" ${FILE_LIST}

FILE_LIST=$(grep -lRIie "am335x" . 2>/dev/null)

sed -ri "s/am335x/${CHIPSET_NAME_LOWER}/g" ${FILE_LIST}
sed -ri "s/AM335X/${CHIPSET_NAME_UPPER}/g" ${FILE_LIST}
