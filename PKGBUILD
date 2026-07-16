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
pkgrel=1
pkgdesc="WMDE session (fork of cosmic-session) - launches the WMDE desktop"
arch=('x86_64')
url="https://wmde.fun"
license=('GPL-3.0-only')
# Runtime components the session spawns (minimal WMDE edition: comp, settings-daemon,
# notifications, panel, bg, applets/files-applet, osd, launcher). orca is optional a11y.
depends=('bash' 'wmde-comp' 'wmde-settings-daemon' 'wmde-notifications' 'wmde-panel'
         'wmde-bg' 'wmde-applets' 'wmde-files' 'wmde-osd' 'wmde-launcher' 'wmde-icons'
         'wmde-portal' 'libgcc' 'glibc' 'xorg-xwayland')
makedepends=('rust' 'cargo' 'just' 'git' 'clang' 'lld')
source=("$pkgname::git+https://github.com/Lin-WMDE/wmde-session.git#branch=wmde")
sha256sums=('SKIP')

pkgver() {
  cd "$srcdir/$pkgname"
  git describe --long --tags --abbrev=7 2>/dev/null | sed 's/^epoch-//;s/^v//;s/\([^-]*-g\)/r\1/;s/-/./g' ||
    printf '1.2.0.r%s.g%s' "$(git rev-list --count HEAD)" "$(git rev-parse --short=7 HEAD)"
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
