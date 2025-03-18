# Unofficial Emacs Appimage

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

These libraries from `/usr/lib/x86_64-linux-gnu/` or `/lib/x86_64-linux-gnu/` are included in `$APPDIR/usr/lib/` to ensure portability:

```
libncurses.so.6, libgnutls.so.30, libxml2.so.2, libjansson.so.4, libpcre2-8.so.0,
libsqlite3.so.0, libz.so.1, libtinfo.so.6, libunistring.so.5, libtasn1.so.6,
libnettle.so.8, libhogweed.so.6, libcap.so.2, libicudata.so.76, libicuuc.so.76,
libffi.so.8, libattr.so.1, liblzma.so.5, libdbus-1.so.3, libp11-kit.so.0,
libselinux.so.1, libidn2.so.0, libc.so.6, libm.so.6, libdl.so.2,
libpthread.so.0, librt.so.1
```

### Additional Tools

- **linuxdeployqt:** [Download from GitHub releases](https://github.com/probonopd/linuxdeployqt/releases)
- **appimagetool:** [Download from GitHub releases](https://github.com/AppImage/AppImageKit/releases)

### Notes

- **Emacs Source:** Downloaded from [GNU mirrors](https://mirrors.ocf.berkeley.edu/gnu/emacs/emacs-30.1.tar.gz).
- **Runtime:** All libraries are bundled to ensure the AppImage is fully standalone and portable.
- **System PATH:** The AppRun script preserves the system environment paths (`/bin`, `/usr/bin`, etc.) by appending `$PATH`, ensuring complete system access.

