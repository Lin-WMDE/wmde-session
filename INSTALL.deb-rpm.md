# Установка на deb/rpm-дистрибутивах без сборки из сырцов вручную

Шаблон: см. предыдущие компоненты. Автор собирает пакеты у себя локально, как сейчас `makepkg -si`.

Опорные платформы — Debian stable и Fedora: `.deb` собираем на Debian (встаёт и на Ubuntu/Mint),
`.rpm` — на Fedora (встаёт и на RHEL/openSUSE). Наоборот не гарантируется.

## Исходники рядом

Обычная сборка требует соседний чек-аут (path-зависимость Cargo):

```
work/
  wmde-session/                <- этот репозиторий (ветка wmde)
  wmde-dbus-settings-bindings/ <- git clone -b wmde https://github.com/Lin-WMDE/wmde-dbus-settings-bindings.git
```

## Собрать

```sh
# зависимости сборки: rustc>=1.93 cargo just clang lld + nfpm
cargo install --locked nfpm  # или бинарник с github.com/goreleaser/nfpm/releases

just deb   # -> target/wmde-session_*.deb
just rpm   # -> target/wmde-session-*.rpm
```

Версия — `1.10.0.<commits>.g<sha>`, как `pkgver()` в `PKGBUILD`.
По умолчанию сборка под чистый `x86-64`. Опционально под `x86-64-v3` (как в Arch-репозитории):

```sh
WMDE_CPU=x86-64-v3 just deb
```

## Офлайн-сборка (без сети к git-зависимостям)

`vendor.tar` в git не лежит (см. `.gitignore`), генерим на машине с сетью один раз
(соседний чек-аут для резолва нужен):

```sh
just vendor          # -> vendor.tar (реестр + git-крейты)
just deb-vendored    # сборка --frozen --offline -> target/*.deb
just rpm-vendored    # аналогично -> target/*.rpm
```

На машину без сети привозим `vendor.tar` файлом. Соседний чек-аут тоже нужен:
path-зависимость вендором не покрывается, Cargo читает её с диска.

## Поставить

```sh
# Debian/Ubuntu/Mint
sudo apt install ./target/wmde-session_*.deb

# Fedora/RHEL/openSUSE
sudo dnf install ./target/wmde-session-*.rpm
```

Пакеты WMDE идут в recommends (apt/dnf ставят их по умолчанию): пока их нет
в репозиториях дистрибутивов, depends сделал бы пакет неустанавливаемым.
Когда выйдет единый репозиторий WMDE — переключить в depends.
Хук `postinstall` включает `avahi-daemon` (политика WMDE, см. `wmde-session.install`),
в чруте без systemd молча пропускается.
