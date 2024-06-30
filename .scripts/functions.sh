#! /bin/zsh

log::error() {
    echo "\033[0;31m$@\033[0m" 1>&2
}

log::success() {
    echo "\033[0;32m$@\033[0m"
}

log::message() {
    echo "\033[0;36m▸ $@\033[0m"
}

log::info() {
    echo "\033[1;37m$@\033[0m"
}

