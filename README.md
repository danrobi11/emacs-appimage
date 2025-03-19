# Unofficial Emacs Appimage

![emacs.png](https://www.gnu.org/software/emacs/images/emacs.png)

[![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)](https://github.com/danrobi11/emacs-appimage/actions)  
Welcome to the unofficial Emacs AppImage—a portable, terminal-only build of [Emacs 30.1](https://www.gnu.org/software/emacs/), crafted for Debian Sid and beyond. This AppImage is designed to run anywhere on Linux with no sandbox restrictions, no `emacsclient`, and a full system `PATH`—making it the most versatile Emacs AppImage available!

## Features
- **Portable**: Single executable, no installation required—just download and run.
- **Terminal-Only**: Built with `--without-x` for a lean, TUI-focused experience.
- **No Sandbox**: Full system access, no isolation constraints.
- **No emacsclient**: Client-server functionality disabled for simplicity.
- **Full PATH**: Preserves system paths (`/bin`, `/usr/bin`, etc.) for seamless command access (e.g., `dircolors`, `xdg-user-dir`).
- **Bundled Utilities**: Includes `etags`, `ctags`, `ebrowse`, and more.

## Usage

1. **Download the AppImage**:
   - Grab it from the [Releases page](https://github.com/danrobi11/emacs-appimage/releases).

2. **Make it Executable**:
   ```bash
   chmod +x emacs-30.1-x86_64.AppImage

## Acknowledgments

- Emacs - The legendary editor that powers this project.
- linuxdeployqt & AppImageKit - Tools that made packaging possible.

## Dependencies for Building Emacs AppImage

Below are the complete dependencies required to build `emacs-30.1-x86_64.AppImage` on Debian Sid as of **March 18, 2025**.

### System Dependencies (via `apt`)

Install these with:

```bash
sudo apt update
sudo apt install -y build-essential git wget \
libncurses-dev libgnutls28-dev libxml2-dev libjansson-dev libpcre2-dev \
libsqlite3-dev zlib1g-dev texinfo nettle-dev libhogweed6t64 libcap-dev \
libicu-dev libffi-dev libattr1-dev liblzma-dev libdbus-1-dev \
libselinux1-dev libidn2-dev libfuse3-dev fuse3 xterm
```

### Explanation of Dependencies

**Core Build Tools:**
- `build-essential`: Includes essential compilation tools (gcc, g++, make).
- `git`: Version control (common practice).
- `wget`: Downloading source files and tools.

**Emacs Build Requirements:**
- `libncurses-dev`: Terminal handling library (includes libtinfo).
- `libgnutls28-dev`: TLS/SSL for secure connections.
- `libxml2-dev`: XML parsing support.
- `libjansson-dev`: JSON support.
- `libpcre2-dev`: Regular expression handling.
- `libsqlite3-dev`: SQLite database support.
- `zlib1g-dev`: Data compression.
- `texinfo`: For generating info manuals (`makeinfo`).
- `nettle-dev`: Cryptographic functions.
- `libhogweed6t64`: Complement to nettle for crypto.
- `libcap-dev`: POSIX capabilities.
- `libicu-dev`: Unicode support via ICU.
- `libffi-dev`: Foreign Function Interface.
- `libattr1-dev`: Extended file attributes.
- `liblzma-dev`: XZ compression.
- `libdbus-1-dev`: D-Bus messaging integration.
- `libselinux1-dev`: SELinux security integration (optional).
- `libidn2-dev`: Internationalized domain names support.

**AppImage Tools:**
- `libfuse3-dev` & `fuse3`: For mounting and packaging AppImages.

**Terminal Fallback:**
- `xterm`: Fallback terminal emulator for non-TTY environments.

### Runtime Libraries (Bundled)

These libraries are copied into `$APPDIR/usr/lib/` to ensure the AppImage runs standalone. They’re sourced from `/usr/lib/x86_64-linux-gnu/` or `/lib/x86_64-linux-gnu/`:

- `libncurses.so.6` - Terminal handling.
- `libgnutls.so.30` - TLS/SSL support.
- `libxml2.so.2` - XML parsing.
- `libjansson.so.4` - JSON support.
- `libpcre2-8.so.0` - Regular expressions.
- `libsqlite3.so.0` - SQLite database.
- `libz.so.1` - Compression.
- `libtinfo.so.6` - Terminal info (part of ncurses).
- `libunistring.so.5` - Unicode string handling.
- `libtasn1.so.6` - ASN.1 parsing (for GnuTLS).
- `libnettle.so.8` - Cryptographic functions.
- `libhogweed.so.6` - More crypto (part of nettle).
- `libcap.so.2` - POSIX capabilities.
- `libicudata.so.76` - ICU data.
- `libicuuc.so.76` - ICU Unicode support.
- `libffi.so.8` - Foreign Function Interface.
- `libattr.so.1` - File attributes.
- `liblzma.so.5` - XZ compression.
- `libdbus-1.so.3` - D-Bus messaging.
- `libp11-kit.so.0` - PKCS#11 support (for GnuTLS).
- `libselinux.so.1` - SELinux integration.
- `libidn2.so.0` - Internationalized domain names.
- `libc.so.6` - C standard library.
- `libm.so.6` - Math library.
- `libdl.so.2` - Dynamic linking.
- `libpthread.so.0` - POSIX threads.
- `librt.so.1` - Realtime extensions.
- `libacl.so.1` - Access control list support.
- `libsystemd.so.0` - Systemd integration.

### Additional Tools

- **linuxdeployqt:** [Download from GitHub releases](https://github.com/probonopd/linuxdeployqt/releases)
- **appimagetool:** [Download from GitHub releases](https://github.com/AppImage/AppImageKit/releases)

### Notes

- **Emacs Source:** Downloaded from [GNU mirrors](https://mirrors.ocf.berkeley.edu/gnu/emacs/emacs-30.1.tar.gz).
- **Runtime:** All libraries are bundled to ensure the AppImage is fully standalone and portable.
- **System PATH:** The AppRun script preserves the system environment paths (`/bin`, `/usr/bin`, etc.) by appending `$PATH`, ensuring complete system access.

Disclaimer

This repository contains a script for building the emacs-30.1-x86_64.AppImage. The script was created with assistance from Grok 3, an AI developed by xAI (https://grok.com). While efforts have been made to ensure the script functions correctly, it is provided "as is" without any warranties or guarantees of performance, reliability, or compatibility. Users are responsible for testing and verifying the script's output before use. Neither the repository owner nor xAI is liable for any issues, damages, or data loss that may arise from using this script or the resulting AppImage.

