#!/bin/sh


FREEDOS_INSTALLER_URL="http://www.freedos.org/download/download/FD12CD.iso"
set -e

errmsg() {
  echo $@ >&2
  exit 1
}

for p in 7z mtools wget xorriso; do
  which ${p} >/dev/null || errmsg "${p} is not on the path. Please install it first."
done

if [ ! -f build/freedos.iso ]; then
  echo "### Downloading FreeDOS CD-ROM image"
  wget -O build/freedos.iso ${FREEDOS_INSTALLER_URL}
fi

if [ ! -f build/pconline.iso ]; then
  wget -o build/pconline.iso 'https://www.pagetable.com/docs/btx/decoder/PC%20online%201&1%20BTX-COM%20Version%204.34.img'
fi

# tar="$(which bsdtar)"
# if [ -z "${tar}" ]; then
#   tar="which tar"
# fi
# ${tar} --help | grep -q 'bsdtar' || errmsg "${tar} does not seem to be bsdtar (supporting extracting from ISO images)"

rm -rf build/btx build/floppy build/freedos build/pconline
mkdir -p build/freedos
7z x build/freedos.iso -obuild/freedos

mkdir -p build/floppy/DOS/BIN
mkdir -p build/floppy/DOS/NLS
7z e build/freedos/BASE/COMMAND.ZIP BIN/COMMAND.COM -obuild/floppy/DOS/BIN
7z e build/freedos/BASE/DEVLOAD.ZIP BIN/DEVLOAD.COM -obuild/floppy/DOS/BIN
7z e build/freedos/BASE/HIMEMX.ZIP BIN/HIMEMX.EXE -obuild/floppy/DOS/BIN
7z e build/freedos/BASE/KERNEL.ZIP BIN/COUNTRY.SYS -obuild/floppy/DOS/BIN
7z e build/freedos/BASE/KEYB.ZIP BIN/KEYB.EXE -obuild/floppy/DOS/BIN
7z e build/freedos/BASE/KEYB_LAY.ZIP BIN/KEYBOARD.SYS -obuild/floppy/DOS/BIN
7z e build/freedos/BASE/KEYB_LAY.ZIP SOURCE/KEYB/LAYOUTS/GR.KEY -obuild/floppy/DOS/NLS
7z e build/freedos/BASE/MORE.ZIP BIN/MORE.EXE -obuild/floppy/DOS/BIN
7z e build/freedos/BASE/NLSFUNC.ZIP BIN/NLSFUNC.EXE -obuild/floppy/DOS/BIN
7z e build/freedos/BASE/SHSUCDX.ZIP BIN/SHSUCDX.COM -obuild/floppy/DOS/BIN
7z e build/freedos/UTIL/UDVD2.ZIP BIN/UDVD2.SYS -obuild/floppy/DOS/BIN

rm -rf build/btx
mkdir -p build/btx
cp -r build/freedos/ISOLINUX build/btx

7z x build/pconline.iso -obuild/pconline

mdeltree -i build/btx/ISOLINUX/FDBOOT.img ::FDSETUP SETUP.BAT
mcopy -i build/btx/ISOLINUX/FDBOOT.img -s build/floppy/* ::
mdir -i build/btx/ISOLINUX/FDBOOT.img
mcopy -i build/btx/ISOLINUX/FDBOOT.img -t -Do files/FDCONFIG.SYS ::
mcopy -i build/btx/ISOLINUX/FDBOOT.img -t -Do files/AUTOEXEC.BAT ::


cp files/ISOLINUX.CFG build/btx/ISOLINUX/ISOLINUX.CFG
mkdir -p build/btx/pconline
cp -r build/pconline build/btx/

xorriso -as mkisofs -o btx.iso \
        -c ISOLINUX/boot.cat -b ISOLINUX/ISOLINUX.BIN -no-emul-boot \
        -boot-load-size 4 -boot-info-table build/btx
