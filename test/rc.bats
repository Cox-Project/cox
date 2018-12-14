#!/usr/bin/env bats

source "scripts/vars"

homerc="$_COX_HOME/$_COX_RC_FILE"
thomerc=".homerc"

currc="$PWD/$_COX_RC_FILE"
tcurrc=".currc"

parentrc="$(dirname $PWD)/$_COX_RC_FILE"
tparentrc=".parentrc"

tmp="$PWD/.tmp"

generate_homerc() {
    echo 'root
    /home/cox
ignore
    node_modules
    .*' > $homerc
}

generate_currc() {
    echo 'ignore
    node_modules
    .*' > $currc
}

generate_parentrc() {
    echo 'ignore
    node_modules
    .*' > $parentrc
}

# to backup the rc file in $HOME, $PWD and some other directories
backup() {
    mkdir -p "$tmp"
    if [ -f "$homerc" ]; then
        mv "$homerc" "$tmp/$thomerc"
    fi

    if [ -f "$currc" ]; then
        mv "$currc" "$tmp/$tcurrc"
    fi

    if [ -f "$parentrc" ]; then
        mv "$parentrc" "$tmp/$tparentrc"
    fi
}

restore() {

    if [ -f "$tmp/$thomerc" ]; then
        mv "$tmp/$thomerc" "$homerc"
    else
        rm -rf "$homerc"
    fi

    if [ -f "$tmp/$tcurrc" ]; then
        mv "$tmp/$tcurrc" "$currc"
    else
        rm -rf "$currc"
    fi

    if [ -f "$tmp/$tparentrc" ]; then
        mv "$tmp/$tparentrc" "$parentrc"
    else
        rm -rf "$parentrc"
    fi

    rm -rf "$tmp"
}

@test "should exit with 1 if the start path is empty" {
    run scripts/rc 
    [ "$status" -eq 1 ]
}

@test "should exit with 1 if cannot find rc file while -f exists" {
    run scripts/rc -f "/a/non/existence/dir"
    [ "$status" -eq 1 ]
}

@test "should exit with 1 if cannot find rc file even in HOME dir" {
    backup
    run scripts/rc -f "/a/non/existane/dir"
    [ "$status" -eq 1 ]
    restore
}

@test "should get the rc file in current directory" {
    backup && generate_currc
    run scripts/rc "$PWD"
    [ "$status" -eq 0 ]
    [ "$output" = "$PWD/$_COX_RC_FILE" ]
    restore
}

@test "should search rc file in parent directories" {
    backup && generate_parentrc
    run scripts/rc "$PWD"
    [ "$status" -eq 0 ]
    [ "$output" = "$(dirname $PWD)/$_COX_RC_FILE" ]
    restore
}

@test "should search rc file in $HOME directory" {
    backup && generate_homerc
    run scripts/rc "/a/non/existence/dir"
    [ "$status" -eq 0 ]
    [ "$output" = "$_COX_HOME/$_COX_RC_FILE" ]
    restore
}
