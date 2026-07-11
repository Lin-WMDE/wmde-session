rootdir := ''
prefix := '/usr'
cargo-target-dir := env('CARGO_TARGET_DIR', 'target')
orca := '/usr/bin/orca'
wmde_dconf_profile := prefix + '/share/dconf/profile/wmde'
usrdir := absolute_path(clean(rootdir / prefix))
bindir := usrdir / 'bin'
systemddir := usrdir / 'lib' / 'systemd' / 'user'
sessiondir := usrdir / 'share' / 'wayland-sessions'
applicationdir := usrdir / 'share' / 'applications'

default: build-release

build-debug *args:
    ORCA={{ orca }} cargo build {{ args }}

# Compile with release profile
build-release *args: (build-debug '--release' args)

# Compile with a vendored tarball
build-vendored *args: vendor-extract (build-release '--frozen --offline' args)

# Remove Cargo build artifacts
clean:
    cargo clean

# Also remove .cargo and vendored dependencies
clean-dist: clean
    rm -rf .cargo vendor vendor.tar target

# Installs files into the system
install:
    echo {{ wmde_dconf_profile }}
    # main binary
    install -Dm0755 {{ cargo-target-dir }}/release/wmde-session {{ bindir }}/wmde-session

    # session start script
    install -Dm0755 data/start-wmde {{ bindir }}/start-wmde
    sed -i "s|DCONF_PROFILE=wmde|DCONF_PROFILE={{ wmde_dconf_profile }}|" {{ bindir }}/start-wmde

    # systemd target
    install -Dm0644 data/wmde-session.target {{ systemddir }}/wmde-session.target

    # session
    install -Dm0644 data/wmde.desktop {{ sessiondir }}/wmde.desktop

    # mimeapps
    install -Dm0644 data/wmde-mimeapps.list {{ applicationdir }}/wmde-mimeapps.list

    # dconf profile
    install -Dm644 data/dconf/profile/wmde {{ rootdir }}/{{ wmde_dconf_profile }}

# Vendor Cargo dependencies locally
vendor:
    mkdir -p .cargo
    cargo vendor | head -n -1 > .cargo/config.toml
    echo 'directory = "vendor"' >> .cargo/config.toml
    tar pcf vendor.tar vendor
    rm -rf vendor

# Extracts vendored dependencies
[private]
vendor-extract:
    rm -rf vendor
    tar pxf vendor.tar

# Bump cargo version, create git commit, and create tag
tag version:
    find -type f -name Cargo.toml -exec sed -i '0,/^version/s/^version.*/version = "{{ version }}"/' '{}' \; -exec git add '{}' \;
    cargo check
    cargo clean
    git add Cargo.lock
    git commit -m 'release: {{ version }}'
    git commit --amend
    git tag -a {{ version }} -m ''
