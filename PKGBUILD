# Maintainer: WMDE <https://wmde.fun>
# Contributor: System76 <info@system76.com> (original cosmic-session)
#
# Builds our fork Lin-WMDE/wmde-session (branch wmde). Standalone WMDE component:
# ships the wmde-session binary, start-wmde, the wmde-session[-pre] systemd target,
# the wayland-session entry (wmde.desktop, DesktopNames=WMDE), wmde-mimeapps.list and
# the dconf `wmde` profile. Own D-Bus name fun.wmde.Session. SOLE owner of the session
# files (wmde-comp installs none of them), so NO conflicts/replaces cosmic-session.
pkgname=wmde-session
pkgver=1.2.0
pkgrel=2
pkgdesc="WMDE session (fork of cosmic-session) - launches the WMDE desktop"
arch=('x86_64')
url="https://wmde.fun"
license=('GPL-3.0-only')
# Runtime components the session spawns (minimal WMDE edition: comp, settings-daemon,
# notifications, panel, bg, applets/files-applet, osd). The start-menu is a panel applet
# (loaded by the panel, not spawned here); orca is optional a11y.
# avahi: mDNS/DNS-SD daemon. wmde-files' network:/// device discovery needs a running
# avahi-daemon; the install hook below enables it (a desktop-level policy for WMDE).
# wmde-icons-base, not wmde-icons: it owns the WMDE/WMDE-Dark themes and pulls wmde-icons
# (WMDE-Extra) in as its own dependency.
# wmde-greeter is here for the SCREEN LOCKER - the session spawns it and `loginctl
# lock-session` is dead without it. That package is only the locker; the display manager
# is wmde-greeter-dm, which nothing depends on, so a machine logging in through GDM or a
# TTY never gets a second display manager forced on it.
# wmde-screenshot is here for the same reason as wmde-greeter: the compositor binds Print
# to it and wmde-portal forwards every screenshot request from other applications to it,
# so both are dead without the package installed.
# wmde-viewer for the third time over: this package is the one that ships
# wmde-mimeapps.list, so it is this package that names fun.wmde.Viewer.desktop as the
# handler for pictures. An association pointing at a desktop entry no installed package
# provides is dead - a double click on a photograph falls through to whatever else is
# around, or to nothing at all. The viewer holds every type it declares, camera RAW and
# compressed SVG included. wmde-photos, the former picture viewer, is retired: the viewer
# replaces it.
depends=('bash' 'wmde-comp' 'wmde-settings-daemon' 'wmde-notifications' 'wmde-panel'
         'wmde-bg' 'wmde-applets' 'wmde-files' 'wmde-osd' 'wmde-start-menu' 'wmde-icons-base'
         'wmde-portal' 'wmde-screenshot' 'wmde-viewer' 'wmde-greeter' 'libgcc'
         'glibc' 'xorg-xwayland' 'xdg-user-dirs' 'avahi')
# start-wmde exports QT_QPA_PLATFORMTHEME=qt5ct, a plugin key served by qt5ct (Qt5) and by
# qt6ct (Qt6). wmde-settings-daemon writes the WMDE palette into ~/.config/qt{5,6}ct; without
# one of these plugins installed nothing reads it. qt6ct is a hard dep of the wmde-desktop
# metapackage; Qt5 is legacy, so qt5ct stays optional here.
optdepends=('qt6ct: WMDE palette in Qt6 and KDE applications'
            'qt5ct: WMDE palette in Qt5 applications')
makedepends=('rust' 'cargo' 'just' 'git' 'clang' 'lld')
install="$pkgname.install"
source=("$pkgname::git+https://github.com/Lin-WMDE/wmde-session.git#branch=wmde")
sha256sums=('SKIP')

pkgver() {
  cd "$srcdir/$pkgname"
  # WMDE version: <COSMIC major.minor>.<WMDE release>.<commits since the nearest tag>.g<short>.
  local desc
  desc=$(git describe --long --tags --abbrev=7 2>/dev/null || true)
  if [ -n "$desc" ]; then
    printf '1.10.1.%s.g%s' "$(printf '%s' "$desc" | sed -E 's/.*-([0-9]+)-g[0-9a-f]+$/\1/')" "$(git rev-parse --short=7 HEAD)"
  else
    printf '1.10.1.%s.g%s' "$(git rev-list --count HEAD)" "$(git rev-parse --short=7 HEAD)"
  fi
}

build() {
  cd "$srcdir/$pkgname"
  # x86-64-v3 baseline for the WMDE repo (Haswell+; matches the VM).
  export RUSTFLAGS="${RUSTFLAGS:+$RUSTFLAGS }-C target-cpu=x86-64-v3"
  cargo build --release
}

package() {
  cd "$srcdir/$pkgname"
  # installs the wmde-session binary, start-wmde, the wmde-session systemd target, the
  # wayland session .desktop (wmde.desktop), wmde-mimeapps.list and the dconf wmde profile.
  just rootdir="$pkgdir" prefix=/usr install
  install -Dm644 LICENSE.md "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
}
