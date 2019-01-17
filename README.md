# Bootable CD image with Drews PC Online BTX Decoder

## Prerequisites

To be able to build the FreeDOS image, the following tools need to be installed locally:
* [mtools](https://www.gnu.org/software/mtools/manual/mtools.html) - `brew install mtools`, `apt install mtools`
* [p7zip](http://p7zip.sourceforge.net) - `brew install p7zip`, `apt install p7zip`
* [wget](https://www.gnu.org/software/wget/) - already installed on most systems
* [xorriso](https://www.gnu.org/software/xorriso/) - `brew install xorriso`, `apt install xorriso`, etc.

## Building

Run `./build.sh`. The ISO file will be placed in `web/btx.iso`.

## Serving The Files To A Web Browser

You need a Python environment. Make sure you have at least Python 3.6 installed, then:
```
python3 -m virtualenv .venv
. .venv/bin/activate
pip install -r requirements.txt
```

Copy the files in `web/` to a web server. To test quickly, you can run
```
./btxwebsocket.py
```

and access the files through http://localhost:8000/web/
