#!/bin/sh
set -e
command -v systemctl >/dev/null 2>&1 && systemctl --user daemon-reload || true
command -v update-desktop-database >/dev/null 2>&1 && update-desktop-database /usr/share/applications || true
