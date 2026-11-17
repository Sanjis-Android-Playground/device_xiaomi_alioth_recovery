# OrangeFox for alioth — Changelog

## 2026-11-17 — auto-DFE build

### The important stuff

- **Format Data no longer fails with "Unable to unmap dynamic partitions."**
  Recovery now treats a partition that was never mapped as already unmapped,
  instead of stopping the whole operation.

- **DFE is applied automatically after a ROM flash.**
  The tested DFE-NEO 2.5.1 zip is bundled inside recovery. After you flash a
  ROM, recovery reboots itself, installs DFE into the new ROM, and then returns
  to the recovery screen instead of forcing you into Android.

- **Recovery reflashes itself only after a real ROM zip.**
  Kernels, Magisk, GApps and other add-ons no longer trigger a recovery
  reflash or a DFE run. If recovery does not recognise an unusual ROM
  installer, tick **Reflash OrangeFox after flashing a ROM** before flashing
  as a fallback.

- **Auto-DFE builds are clearly named.**
  The image and zip have `auto-dfe` in the name:
  `OrangeFox-R12.0_auto-dfe-Unofficial-alioth.img/.zip`.

### How to flash a ROM with this build

**If your data is already unencrypted (DFE already in use):**

1. Flash the ROM zip.
2. Recovery reboots, DFE runs, and you land back in recovery.
3. Reboot to system. If you need GApps/Magisk, flash them in recovery first.

**If you are coming from an encrypted ROM and want to switch to DFE:**

1. Back up everything — Format Data erases apps, photos and internal storage.
2. Flash the ROM zip.
3. Let recovery reboot and run DFE.
4. **Format Data** in recovery (Manage Partitions → Format Data).
5. Flash GApps/Magisk if needed, then reboot to system.

> **Warning:** DFE turns off `/data` encryption. Anyone with the phone can read
> the data. Do not use it if you need encryption. Auto-DFE only runs for ROMs
> flashed through OrangeFox — not for fastboot flashes or system OTA updates.

### Other improvements

- **High-Speed Flash (HSF)**
  - Firmware flashing is now opt-in, with extra checks before writing.
  - Firmware is verified from storage after writing.
  - Faster `otaripper` build, including firmware readback support.
  - HSF options (flash / verify / firmware) remember their last state.
  - The HSF checkboxes are also available on the sideload page.

- **Recovery settings moved to `/sdcard/Fox`**
  - Settings and theme survive a normal factory reset.
  - They are still erased by Format Data, because that wipes internal storage.

- **Black theme is now the default** (Fox orange accent). You can still change
  it in Settings → Theme.

- **Minimum brightness lowered from 10% to 1%.**
  The screen can now be dimmed much further in a dark room.

- **Milder vibration defaults:** button 24, keyboard 24, action 160.

- **Magisk add-on updated to v31.1.**

- **Recovery hang fix:** removes a ROM-injected Health HAL manifest that could
  make recovery hang on some ROMs.

### Notes

- The old "Reflash OrangeFox after flashing a ROM" checkbox is now off by
  default. It is only a fallback for ROM zips that recovery does not detect.
- Recovery settings on `/sdcard/Fox` are wiped by Format Data. Back them up to
  an external SD card if you want to keep them.
