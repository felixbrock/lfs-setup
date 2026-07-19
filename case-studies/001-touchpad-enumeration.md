# Case study: the touchpad that insisted it was a mouse

*A diagnosis chain from operating an agent-maintained LFS daily driver.
Hardware specifics are kept at chip level — they are the reproducible
part; machine identity is not.*

## Symptom

On an Alder Lake-P laptop, freshly migrated from a mainstream distro to
a defconfig-based LFS kernel, the touchpad "worked" — the cursor moved —
but behaved like hardware from 2005: tap-to-click fired constantly from
palms hovering while typing, and two-finger scrolling did not exist.
libinput could not disable the tap behavior: its config options were
simply absent for the device.

## Stage 1: name the device, not the symptom

`/proc/bus/input/devices` showed the pointer as:

    N: Name="PS/2 Generic Mouse"
    P: Phys=isa0060/serio1/input0

Not a touchpad — a bare PS/2 relative mouse on the i8042 controller.
Everything downstream follows from that one line: "taps" were the
hardware's own click emulation (invisible to libinput), and multitouch
does not exist on the PS/2 fallback protocol. The lesson that repeats
through this whole chain: **the input stack was fine; the kernel was
handing it the wrong device.**

## Stage 2: why defconfig is not enough

`make defconfig` compiles in Synaptics PS/2 protocol detection but
**not Elantech** (`MOUSE_PS2_ELANTECH` defaults off), and none of the
SMBus/RMI4 handoff drivers that let psmouse upgrade a pad to its real
protocol. A kernel revision enabled the full protocol set for both
vendors. Result: no change. Useful negative — the pad was not a PS/2
Synaptics or Elantech device at all.

## Stage 3: find where the hardware actually lives

Two observations cracked it, both available without vendor docs:

- ACPI namespace: a device named `VEN_04F3:00` — 04F3 is ELAN, and the
  `VEN_xxxx` naming pattern is how HID-over-I²C touchpads appear.
- PCI: two Serial-IO I²C controllers (8086:51e8/51e9, class 0x0c8000)
  with **no driver bound**, and no designware adapters in
  `/sys/bus/i2c`.

So: an ELAN I²C-HID touchpad, sitting on Intel LPSS I²C buses that had
no bus driver. The EC's PS/2 mouse emulation was the only path left,
which is exactly what stage 1 showed. The stage-2 work wasn't wrong —
it was answering the wrong layer.

## Stage 4: the enablement set, and two Kconfig traps

The missing pieces:

    MFD_INTEL_LPSS_PCI          # the LPSS controllers themselves
    I2C_DESIGNWARE_CORE         # trap 1 (see below)
    I2C_DESIGNWARE_PLATFORM
    PINCTRL + PINCTRL_INTEL + PINCTRL_TIGERLAKE   # trap 2
    I2C_HID_ACPI + HID_MULTITOUCH

Trap 1: recent kernels gate the designware driver behind
`I2C_DESIGNWARE_CORE` — enabling only `_PLATFORM` gets silently dropped
at `olddefconfig`.

Trap 2: the Alder Lake-**P** pin controller is driven by
`PINCTRL_TIGERLAKE`, not `PINCTRL_ALDERLAKE` (that one covers the
HX/N/S desktop variants) — the driver's own Kconfig help text is the
authority. And the top-level `PINCTRL` gate is not in defconfig at all.

After this revision the device enumerated as
`VEN_04F3:00 04F3:320F Touchpad` on `i2c_designware.1`, libinput
classified it as a real touchpad, and its *defaults* — tap-to-click
off, two-finger scroll on, disable-while-typing on — were precisely the
desired behavior. Zero userspace configuration was needed at any point.

## Method notes (the transferable part)

- **A config-verify gate catches silent drops.** Every `scripts/config`
  addition is re-checked with `grep -qx` after `make olddefconfig`; a
  dependency-dropped option fails the build script instead of shipping
  a kernel that silently lacks it. Both traps above were caught by this
  gate or would have been.
- **Prove the config sequence before building.** The exact
  defconfig→config→olddefconfig→verify lines are extracted from the
  build script verbatim and run in a scratch tree (~2 minutes) before
  any 15-minute build is attempted.
- **Diagnose from `/sys` and `/proc` before touching configs.** The
  ACPI name and the driverless PCI class devices identified the real
  topology in two commands; every earlier guess was cheaper to discard
  because it had been cheap to make.
- **New kernels install additively** — own image, own boot entry with
  boot counting, the previous kernel untouched as an automatic
  fallback. Every revision in this chain was a reversible experiment.
