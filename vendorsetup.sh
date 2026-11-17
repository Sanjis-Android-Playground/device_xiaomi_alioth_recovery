#
#	This file is part of the OrangeFox Recovery Project
# 	Copyright (C) 2021-2026 The OrangeFox Recovery Project
#
#	OrangeFox is free software: you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation, either version 3 of the License, or
#	any later version.
#
#	OrangeFox is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	GNU General Public License for more details.
#
# 	This software is released under GPL version 3 or any later version.
#	See <http://www.gnu.org/licenses/>.
#
# 	Please maintain this if you use this script or any part of it
#

#set -o xtrace
FDEVICE="alioth"
THIS_DEVICE="${THIS_DEVICE:-${BASH_ARGV[2]:-$FDEVICE}}"
FOX_BUILD_DEVICE="${FOX_BUILD_DEVICE:-$THIS_DEVICE}"

fox_get_target_device() {
  if echo "$BASH_SOURCE" | grep -q "/$FDEVICE/"; then
      FOX_BUILD_DEVICE="$FDEVICE";
  elif set | grep BASH_ARGV | grep -w \"$FDEVICE\"; then
      FOX_BUILD_DEVICE="$FDEVICE";
  elif echo "${BASH_SOURCE[0]}" | grep -q "/$FDEVICE/"; then
      FOX_BUILD_DEVICE="$FDEVICE";
  elif echo "$0" | grep -q "$FDEVICE"; then
      FOX_BUILD_DEVICE="$FDEVICE";
  fi
}

if [ "$THIS_DEVICE" = "alioth" -o "$THIS_DEVICE" = "munch" ]; then
	FDEVICE="$THIS_DEVICE"
	[ -z "$FOX_BUILD_DEVICE" ] && FOX_BUILD_DEVICE="$THIS_DEVICE"
fi

if [ -z "$1" -a -z "$FOX_BUILD_DEVICE" -a -z "$FDEVICE" ]; then
   fox_get_target_device
fi

if [ "$1" = "$FDEVICE" -o "$FOX_BUILD_DEVICE" = "$FDEVICE" ]; then

	if [ -z "$THIS_DEVICE" ]; then
		echo "ERROR! This script requires bash. Run '/bin/bash' and build again."
		exit 1
	fi

	export FOX_USE_SPECIFIC_MAGISK_ZIP=~/Magisk/Magisk-v31.1.zip
        export FOX_VANILLA_BUILD=1
    	export FOX_ENABLE_APP_MANAGER=1
	export FOX_VIRTUAL_AB_DEVICE=1
	export FOX_RECOVERY_SYSTEM_PARTITION="/dev/block/mapper/system"
	export FOX_RECOVERY_VENDOR_PARTITION="/dev/block/mapper/vendor"
	export FOX_USE_BASH_SHELL=1
	export FOX_ASH_IS_BASH=1
	export FOX_USE_TAR_BINARY=1
	export FOX_USE_XZ_UTILS=1
	export FOX_USE_LZ4_BINARY=1
	export FOX_USE_ZSTD_BINARY=1
	export FOX_USE_DATE_BINARY=1
    	export FOX_DELETE_AROMAFM=1
	export TARGET_DEVICE_ALT="aliothin,alioth"

	export FOX_USE_FSCK_EROFS_BINARY=1
	export FOX_USE_BUSYBOX_BINARY=1

	# instruct magiskboot v24+ to always patch the vbmeta header when patching the recovery/boot image; do *not* remove!
        export FOX_PATCH_VBMETA_FLAG="1"

	# use the latest magiskboot binary
	export FOX_USE_UPDATED_MAGISKBOOT=1

	export FOX_SETTINGS_ROOT_DIRECTORY=/sdcard
	export FOX_MISCELLANEOUS_ROOT_DIRECTORY=/sdcard

	# vendor_boot-as-recovery
	if [ "$FOX_VENDOR_BOOT_RECOVERY" = "1" ]; then
		export FOX_VARIANT="vBaR"
		export FOX_INSTALLER_VENDOR_BOOT_RAMDISK_INSTALL=1
	fi

	# OF_AUTO_DFE=1 -> auto-DFE build and name; OF_AUTO_DFE=0 -> normal build and name
	export OF_AUTO_DFE="${OF_AUTO_DFE:-1}"

	# drop any auto-dfe suffix left over from a previous build in this shell
	while true; do
		case "$FOX_VARIANT" in
			auto-dfe) export FOX_VARIANT="" ;;
			*-auto-dfe) export FOX_VARIANT="${FOX_VARIANT%-auto-dfe}" ;;
			*) break ;;
		esac
	done

	if [ "$OF_AUTO_DFE" = "1" ]; then
		if [ -n "$FOX_VARIANT" ] && [ "$FOX_VARIANT" != "default" ]; then
			export FOX_VARIANT="${FOX_VARIANT}-auto-dfe"
		else
			export FOX_VARIANT="auto-dfe"
		fi
	elif [ -z "$FOX_VARIANT" ]; then
		export FOX_VARIANT="default"
	fi

	# patchelf
	export FOX_USE_PATCHELF_BINARY=1

	# magisk to ramdisk
	export FOX_MOVE_MAGISK_INSTALLER_TO_RAMDISK=1
else
	if [ -z "$FOX_BUILD_DEVICE" -a -z "$BASH_SOURCE" ]; then
		echo "I: This script requires bash. Not processing the $FDEVICE $(basename $0)"
	fi
fi
#
