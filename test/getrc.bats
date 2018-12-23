#!/usr/bin/env bats

TAB=$(printf "\t")
CONTENT="
# comment
root
    /user/cox
ignore
# comment
 n
    node_modules
${TAB}log

    .*
ext
    .sh
    .js
"

@test "should exit with 1 if the specified key not exists" {
    run eval 'echo "$CONTENT" | scripts/getrc non-exitence'
    [ "$status" -eq 1 ]
}

@test "should exit with 1 if no argument specified" {
    run scripts/getrc 
    [ "$status" -eq 1 ]
}

@test "should get all items of the specified key" {
    set -f
    run eval 'echo "$CONTENT" | scripts/getrc ignore'
    [ "$status" -eq 0 ]
    [ "${#lines[@]}" -eq 4 ]
    [ "${lines[0]}" = "n" ]
    [ "${lines[1]}" = "node_modules" ]
    [ "${lines[2]}" = "log" ]
    [ "${lines[3]}" = ".*" ]
}
