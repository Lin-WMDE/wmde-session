# Maintainer: WMDE <https://wmde.fun>
# Contributor: System76 <info@system76.com> (original cosmic-session)
# Builds our fork Lin-WMDE/wmde-session (branch wmde; master mirrors pop-os upstream).
# Only change vs upstream 1.2: cosmic-session spawns `wmde-files-applet` (our renamed
# desktop-icon applet) instead of `cosmic-files-applet`. Binary name, D-Bus name and
# the other component spawns stay stock for IPC compatibility with the COSMIC 1.2 stack.
pkgname=wmde-session
pkgver=1.2.0
pkgrel=1
pkgdesc="WMDE session (fork of cosmic-session) - launches the WMDE/COSMIC desktop"
arch=('x86_64')
url="https://wmde.fun"
license=('GPL-3.0-only')
# Same runtime components cosmic-session spawns; cosmic-files is satisfied by our
# wmde-files (provides=cosmic-files), which ships the wmde-files-applet desktop layer.
depends=('bash' 'cosmic-applets' 'cosmic-app-library' 'cosmic-bg' 'cosmic-comp'
         'cosmic-files' 'cosmic-greeter' 'cosmic-icon-theme' 'cosmic-idle'
         'cosmic-launcher' 'cosmic-notifications' 'cosmic-osd' 'cosmic-panel'
         'cosmic-randr' 'cosmic-screenshot' 'cosmic-settings-daemon' 'cosmic-settings'
         'cosmic-workspaces' 'libgcc' 'glibc' 'switcheroo-control'
         'xdg-desktop-portal-cosmic' 'xorg-xwayland')
makedepends=('rust' 'cargo' 'just' 'git' 'clang' 'lld')
provides=('cosmic-session')
conflicts=('cosmic-session')
replaces=('cosmic-session')
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
  # installs the cosmic-session binary, start-cosmic, systemd target, the
  # wayland session .desktop, mimeapps and the dconf profile.
  just rootdir="$pkgdir" prefix=/usr install
  install -Dm644 LICENSE.md "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
}
