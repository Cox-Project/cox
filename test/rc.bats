#!/usr/bin/env bats

source "scripts/variables"

homerc="$_COX_HOME/$_COX_RC_FILE"
tmprc="test/.coxrc.tmp"

setup() {
    if [ -f "$homerc" ]; then
        mv "$homerc" "$tmprc"
    fi
}

@test "" {
    run scripts/rc 
}

teardown() {

    if [ -f "$tmp" ]; then
        mv "$tmprc" "$homerc" && rm -rf "$tmprc"
    else
        rm -rf "$homerc"
    fi
}
