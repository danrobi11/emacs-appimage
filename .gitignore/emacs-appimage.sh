#!/bin/bash
# emacs-appimage.sh
# Purpose: Build a portable, terminal-only Emacs AppImage based on Debian Sid, fully self-contained, with emacsclient disabled and no sandbox.

set -e

# Variables
APP="emacs"
VERSION="30.1"  # Emacs 30.1
WORKDIR="$HOME/appimage-workdir"
APPDIR="$WORKDIR/$APP.AppDir"
OUTPUT="$HOME/$APP-$VERSION-x86_64.AppImage"
# Use user's home directory for log file, not hardcoded /home/danrobi
LOGFILE="\$HOME/emacs-appimage-run.log"
SOURCE_TARBALL="https://mirrors.ocf.berkeley.edu/gnu/emacs/emacs-$VERSION.tar.gz"

# Clean up previous workdir
[ -d "$WORKDIR" ] && { echo "Cleaning up previous workdir..."; rm -rf "$WORKDIR"; }
mkdir -p "$WORKDIR" "$APPDIR"

# Install system dependencies
echo "Installing system dependencies..."
sudo apt update
sudo apt install -y \
    build-essential git wget libfuse3-dev \
    libncurses-dev libgnutls28-dev \
    libxml2-dev libjansson-dev libpcre2-dev \
    libsqlite3-dev zlib1g-dev texinfo \
    nettle-dev libhogweed6t64 libcap-dev \
    libicu-dev libffi-dev libattr1-dev liblzma-dev libdbus-1-dev libselinux1-dev libidn2-dev \
    xterm  # For terminal fallback

# Check FUSE setup
echo "Ensuring FUSE is installed and loaded..."
sudo apt install -y fuse3
if ! lsmod | grep -q fuse; then
    echo "Error: FUSE module not loaded. Please enable it or reboot."
    exit 1
fi

# Download tools (latest versions)
echo "Downloading linuxdeployqt and appimagetool..."
wget -c "https://github.com/probonopd/linuxdeployqt/releases/download/continuous/linuxdeployqt-continuous-x86_64.AppImage" -O "$WORKDIR/linuxdeployqt"
wget -c "https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage" -O "$WORKDIR/appimagetool"
chmod +x "$WORKDIR/linuxdeployqt" "$WORKDIR/appimagetool"

# Download and extract Emacs source
echo "Downloading Emacs $VERSION source from $SOURCE_TARBALL..."
wget -c "$SOURCE_TARBALL" -O "$WORKDIR/emacs-$VERSION.tar.gz"
tar -xzf "$WORKDIR/emacs-$VERSION.tar.gz" -C "$WORKDIR"
cd "$WORKDIR/emacs-$VERSION"

# Configure Emacs with custom arguments
echo "Configuring Emacs with custom arguments..."
./configure \
    --with-sound=no \
    --with-native-compilation=no \
    --without-imagemagick \
    --with-gnutls \
    --without-x \
    --prefix="$APPDIR/usr"

# Bootstrap and build Emacs
echo "Bootstrapping Emacs build..."
make bootstrap
echo "Building Emacs..."
make -j$(nproc)

# Install Emacs into AppDir
echo "Installing Emacs into AppDir..."
make install
# Remove emacsclient to disable it
rm -f "$APPDIR/usr/bin/emacsclient"

# Bundle additional data files (avoid redundant copies)
echo "Bundling Emacs data files..."
mkdir -p "$APPDIR/usr/share/emacs/$VERSION"
[ -d "$APPDIR/usr/libexec/emacs" ] || cp -r "$APPDIR/usr/libexec" "$APPDIR/usr/"
[ -d "$APPDIR/usr/share/emacs/$VERSION/etc" ] || cp -r "$APPDIR/usr/share/emacs/$VERSION/etc" "$APPDIR/usr/share/emacs/$VERSION/"
[ -d "$APPDIR/usr/share/emacs/$VERSION/lisp" ] || cp -r "$APPDIR/usr/share/emacs/$VERSION/lisp" "$APPDIR/usr/share/emacs/$VERSION/"

# Bundle libraries
echo "Bundling libraries..."
mkdir -p "$APPDIR/usr/lib"
for lib in \
    libncurses.so.6 libgnutls.so.30 libxml2.so.2 libjansson.so.4 \
    libpcre2-8.so.0 libsqlite3.so.0 libz.so.1 libtinfo.so.6 \
    libunistring.so.5 libtasn1.so.6 libnettle.so.8 libhogweed.so.6 \
    libcap.so.2 libicudata.so.76 libicuuc.so.76 libffi.so.8 \
    libattr.so.1 liblzma.so.5 libdbus-1.so.3 libp11-kit.so.0 \
    libselinux.so.1 libidn2.so.0 libc.so.6 libm.so.6 libdl.so.2 \
    libpthread.so.0 librt.so.1 libacl.so.1 libsystemd.so.0; do
    cp -v /usr/lib/x86_64-linux-gnu/$lib "$APPDIR/usr/lib/" 2>/dev/null || \
    cp -v /lib/x86_64-linux-gnu/$lib "$APPDIR/usr/lib/" 2>/dev/null || \
    echo "Warning: $lib not found; may need manual addition."
done

# Create home/bin directory
mkdir -p "$APPDIR/home/bin"

# Create AppRun with dynamic log path and debug output
echo "Creating AppRun with custom PATH and terminal enforcement..."
cat << EOF > "$APPDIR/AppRun"
#!/bin/bash
HERE="\$(dirname "\$(readlink -f "\${0}")")"
export PATH="\$HERE/usr/local/bin:\$HERE/usr/bin:\$HERE/bin:\$HERE/usr/games:\$HERE/sbin:\$HERE/usr/sbin:\$HERE/home/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:\$PATH"
export LD_LIBRARY_PATH="\$HERE/usr/lib:\$LD_LIBRARY_PATH"
LOGFILE="\$HOME/emacs-appimage-run.log"
export EMACSDATA="\$HERE/usr/share/emacs/$VERSION/etc"
export EMACSLOADPATH="\$HERE/usr/share/emacs/$VERSION/lisp"
export EMACSDOC="\$HERE/usr/share/emacs/$VERSION/etc"
echo "Starting Emacs..." >> "\$LOGFILE"
echo "PATH: \$PATH" >> "\$LOGFILE"
echo "LD_LIBRARY_PATH: \$LD_LIBRARY_PATH" >> "\$LOGFILE"
echo "LOGFILE: \$LOGFILE" >> "\$LOGFILE"
echo "EMACSDATA: \$EMACSDATA" >> "\$LOGFILE"
echo "EMACSLOADPATH: \$EMACSLOADPATH" >> "\$LOGFILE"
echo "EMACSDOC: \$EMACSDOC" >> "\$LOGFILE"
echo "Checking data directory contents at \$HERE/usr/share/emacs/$VERSION..." >> "\$LOGFILE"
ls -l "\$HERE/usr/share/emacs/$VERSION" >> "\$LOGFILE" 2>&1
ls -l "\$HERE/usr/share/emacs/$VERSION/etc" >> "\$LOGFILE" 2>&1
ls -l "\$HERE/usr/share/emacs/$VERSION/lisp" >> "\$LOGFILE" 2>&1
ls -l "\$HERE/usr/libexec/emacs/$VERSION" >> "\$LOGFILE" 2>&1
echo "Checking dependencies..." >> "\$LOGFILE"
ldd "\$HERE/usr/bin/emacs" >> "\$LOGFILE" 2>&1
if [ -t 0 ]; then
    echo "Running in existing terminal..." >> "\$LOGFILE"
    "\$HERE/usr/bin/emacs" "\$@" >> "\$LOGFILE" 2>&1
else
    echo "No TTY detected; launching in xterm..." >> "\$LOGFILE"
    xterm -e "\$HERE/usr/bin/emacs" "\$@" >> "\$LOGFILE" 2>&1
fi
EXIT_CODE=\$?
echo "Emacs exited with code \$EXIT_CODE" >> "\$LOGFILE"
exit \$EXIT_CODE
EOF
chmod +x "$APPDIR/AppRun"

# Create desktop file with improved categories
echo "Creating desktop file..."
cat << EOF > "$APPDIR/emacs.desktop"
[Desktop Entry]
Name=Emacs (Terminal)
Exec=emacs
Type=Application
Icon=emacs
Categories=Utility;TextEditor;TerminalEmulator;
Terminal=true
EOF

# Copy icon from source
echo "Copying icon from Emacs source..."
cp "$WORKDIR/emacs-$VERSION/etc/images/emacs_48x48.png" "$APPDIR/emacs.png" 2>/dev/null || \
{ echo "Icon not found; downloading fallback..."; \
  wget -O "$APPDIR/emacs.png" "https://www.gnu.org/software/emacs/images/emacs.png" || \
  echo "Fallback icon download failed; proceeding without it..."; }

# Bundle with linuxdeployqt, bypassing glibc check
echo "Bundling dependencies with linuxdeployqt..."
"$WORKDIR/linuxdeployqt" "$APPDIR/usr/bin/emacs" -bundle-non-qt-libs -unsupported-allow-new-glibc -verbose=2

# Package AppImage with verbosity and no AppStream
echo "Packaging AppImage..."
"$WORKDIR/appimagetool" --no-appstream -v "$APPDIR" "$OUTPUT"

# Clean up (optional; uncomment if desired)
echo "Cleaning up..."
# rm -rf "$WORKDIR"

echo "Done! Your Emacs AppImage is at: $OUTPUT"
echo "Check the debug log at \$HOME/emacs-appimage-run.log"
