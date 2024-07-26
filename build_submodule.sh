#! /bin/zsh -e

source ".scripts/functions.sh"

log::message "Updating smoldot-swift submodule"
git submodule update --init --remote checkouts/smoldot-swift

cd checkouts/smoldot-swift
/bin/zsh "build_xcframework.sh" dev
