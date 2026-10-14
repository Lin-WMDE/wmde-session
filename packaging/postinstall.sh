#!/bin/sh
# Политика WMDE (см. wmde-session.install в Arch-пакете): для обнаружения
# сетевого окружения нужен запущенный avahi-daemon. В чруте systemd нет —
# ошибки глушим, транзакцию не роняем.
set -e
command -v systemctl >/dev/null 2>&1 && (systemctl enable --now avahi-daemon.service || systemctl enable avahi-daemon.service) || true
command -v systemctl >/dev/null 2>&1 && systemctl --user daemon-reload || true
command -v update-desktop-database >/dev/null 2>&1 && update-desktop-database /usr/share/applications || true
