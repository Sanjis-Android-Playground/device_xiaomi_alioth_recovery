# OrangeFox device tree for alioth (Xiaomi Mi 11X / Redmi K40 / POCO F3)
This tree is for building OrangeFox Recovery for the _alioth_ devices

The Xiaomi Mi 11X (codenamed _"aliothin"_), Redmi K40 / POCO F3 (codenamed _"alioth"_) is a mid range smartphone from Xiaomi.

# Device specifications

| Device       | Xiaomi Mi 11X / Redmi K40 / POCO F3                        |
| -----------: | :----------------------------------------------------------|
| SoC          | Qualcomm SM8250 Snapdragon 870 5G                          |
| CPU          | 8x Qualcomm® Kryo™ 585 up to 2.84GHz                       |
| GPU          | Adreno 650                                                 |
| Memory       | 8GB / 6GB  (LPDDR 5)                                       |
| Shipped Android version | 11                    			    |
| Storage      | 128GB  (UFS 3.1)                                           |
| Battery      | Li-Po 4520 mAh, non-removable                              |
| Dimensions   | 163.7 x 76.4 x 7.8 mm                                      |
| Display      | 1080 x 2400 (20:9), 6.67 inches                            |

## Features

**Works**

- Booting
- **Decryption** (Android 12+)
- ADB
- MTP
- OTG
- vA/B partition functions
- Vibration

The Mi 11X / Redmi K40 / POCO F3 devices use a Virtual A/B Partition Scheme!

## Building

You can find a full compile guide for OrangeFox [Here](https://wiki.orangefox.tech/en/dev/building)

_Lunch_ command :
```
lunch twrp_alioth-eng && mka adbd bootimage
```

## High-Speed Flash (BETA)

This tree includes a port of the **High-Speed Flash** feature from
[khargosxh18's peridot tree](https://github.com/khargosxh18/twrp_device_tree_peridot)
(`16` branch), which pairs with the patched OrangeFox recovery sources
(`17` branch of `android_bootable_recovery_fox`).

When the Install-page checkbox **"High-speed flash (BETA)"** is enabled, a full
OTA payload is decoded in parallel by `otaripper` and written **directly** to
the inactive slot's block devices, instead of being handed to `update_engine`.
The Super group for the target slot is rebuilt in a single atomic pass first,
so the `dm-N` nodes already exist at their final size.

* The checkbox is **off by default**.
* Firmware partitions (`xbl`, `abl`, `tz`, `modem`, `devcfg`, `bluetooth`,
  `dsp`, ...) are in a hard-coded exclusion set and are **never** written by
  this path. Unknown partitions abort *before* any write.
* Full (non-delta) payloads only.
* Failures leave the booted slot and the active slot untouched, but the target
  slot can be left incomplete — re-flash it with the normal method.

### alioth-specific notes

Unlike peridot, alioth is **recovery-as-boot** (`BOARD_USES_RECOVERY_AS_BOOT`),
so the ROM's `boot.img` written by this path *is* the recovery partition.
OrangeFox is preserved by the existing `tw_auto_reflashtwrp` →
`Flash_Current_Twrp()` repack path, which runs after the slot flip. For the
`FOX_VENDOR_BOOT_RECOVERY=1` (vBaR) variant, `pre_rom_flash.sh` /
`post_rom_flash_completion.sh` back up and restore `vendor_boot` instead.

**Always verify OrangeFox survives on both slots after an HSF flash.**

`otaripper` is a prebuilt, statically-linked aarch64 binary
(`recovery/root/system/bin/otaripper`, 2.0 MB, no runtime dependencies).

## Credits
- [Original alioth tree by Nebrassy](https://github.com/TeamWin/android_device_xiaomi_alioth)
- [Kernel](https://github.com/AOSPA/android_kernel_xiaomi_sm8250.git)
- [High-Speed Flash by Khargosxh18](https://github.com/khargosxh18/twrp_device_tree_peridot)

### Copyright
 ```
  /*
  *  Copyright (C) 2022-2024 The OrangeFox Recovery Project
  *
  * This program is free software: you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation, either version 3 of the License, or
  * (at your option) any later version.
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  *
  */
  ```
