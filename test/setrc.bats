#!/usr/bin/env bats
TAB=$(printf "\t")
CONTENT="
root
    /user/cox
ignore
# comment
 n
    node_modules
${TAB}log

    .*
"

@test "should exit with 1 if doesn't specify a key" {
    run eval 'echo "$CONTENT" | scripts/setrc'
    [ "$status" -eq 1 ]
}

@test "should exit with 1 if specifying unknown options" {
    run eval 'echo "$CONTENT" | scripts/setrc -x ignore'
    [ "$status" -eq 1 ]
}

@test "should exit with 1 if passing too many arguments while adding data" {
    run eval 'echo "$CONTENT" | scripts/setrc a b c'
    [ "$status" -eq 1 ]
}

@test "should exit with 1 if didn't pass enough arguments for removing data" {
    run eval 'echo "$CONTENT" | scripts/setrc -r'
    [ "$status" -eq 1 ]
}

@test "should add new key while the key not exists" {
    set -f
    run eval 'echo "$CONTENT" | scripts/setrc nkey'
    [ "$status" -eq 0 ]
    [ "${#lines[@]}" -eq 9 ] 
    [ "${lines[0]}" = "root" ]
    [ "${lines[1]}" = "    /user/cox" ]
    [ "${lines[2]}" = "ignore" ]
    [ "${lines[3]}" = "# comment" ]
    [ "${lines[4]}" = "    n" ]
    [ "${lines[5]}" = "    node_modules" ]
    [ "${lines[6]}" = "    log" ]
    [ "${lines[7]}" = "    .*" ]
    [ "${lines[8]}" = "nkey" ]
}

@test "should do nothing while adding a new key and if the key exists" {
    set -f
    run eval 'echo "$CONTENT" | scripts/setrc ignore'
    [ "$status" -eq 0 ]
    [ "${#lines[@]}" -eq 8 ] 
    [ "${lines[0]}" = "root" ]
    [ "${lines[1]}" = "    /user/cox" ]
    [ "${lines[2]}" = "ignore" ]
    [ "${lines[3]}" = "# comment" ]
    [ "${lines[4]}" = "    n" ]
    [ "${lines[5]}" = "    node_modules" ]
    [ "${lines[6]}" = "    log" ]
    [ "${lines[7]}" = "    .*" ]
}

@test "should do nothing while removing a key and if the key not exists" {
    set -f
    run eval 'echo "$CONTENT" | scripts/setrc -r nkey'
    [ "$status" -eq 0 ]
    [ "${#lines[@]}" -eq 8 ] 
    [ "${lines[0]}" = "root" ]
    [ "${lines[1]}" = "    /user/cox" ]
    [ "${lines[2]}" = "ignore" ]
    [ "${lines[3]}" = "# comment" ]
    [ "${lines[4]}" = "    n" ]
    [ "${lines[5]}" = "    node_modules" ]
    [ "${lines[6]}" = "    log" ]
    [ "${lines[7]}" = "    .*" ]
}

@test "should set new value for the new added key" {
    set -f
    run eval 'echo "$CONTENT" | scripts/setrc nkey value'
    [ "$status" -eq 0 ]
    [ "${#lines[@]}" -eq 10 ] 
    [ "${lines[0]}" = "root" ]
    [ "${lines[1]}" = "    /user/cox" ]
    [ "${lines[2]}" = "ignore" ]
    [ "${lines[3]}" = "# comment" ]
    [ "${lines[4]}" = "    n" ]
    [ "${lines[5]}" = "    node_modules" ]
    [ "${lines[6]}" = "    log" ]
    [ "${lines[7]}" = "    .*" ]
    [ "${lines[8]}" = "nkey" ]
    [ "${lines[9]}" = "    value" ]
}

@test "should do nothing while setting new value to a non-existence key" {
    set -f
    run eval 'echo "$CONTENT" | scripts/setrc -r nkey'
    [ "$status" -eq 0 ]
    [ "${#lines[@]}" -eq 8 ] 
    [ "${lines[0]}" = "root" ]
    [ "${lines[1]}" = "    /user/cox" ]
    [ "${lines[2]}" = "ignore" ]
    [ "${lines[3]}" = "# comment" ]
    [ "${lines[4]}" = "    n" ]
    [ "${lines[5]}" = "    node_modules" ]
    [ "${lines[6]}" = "    log" ]
    [ "${lines[7]}" = "    .*" ]
}

@test "should remove all values of the specified key" {
    set -f
    run eval 'echo "$CONTENT" | scripts/setrc -r root'
    [ "$status" -eq 0 ]
    [ "${#lines[@]}" -eq 6 ] 
    [ "${lines[0]}" = "ignore" ]
    [ "${lines[1]}" = "# comment" ]
    [ "${lines[2]}" = "    n" ]
    [ "${lines[3]}" = "    node_modules" ]
    [ "${lines[4]}" = "    log" ]
    [ "${lines[5]}" = "    .*" ]
}

@test "should remove the specified value for a key" {
    set -f
    run eval 'echo "$CONTENT" | scripts/setrc -r ignore n'
    [ "$status" -eq 0 ]
    [ "${#lines[@]}" -eq 7 ] 
    [ "${lines[0]}" = "root" ]
    [ "${lines[1]}" = "    /user/cox" ]
    [ "${lines[2]}" = "ignore" ]
    [ "${lines[3]}" = "# comment" ]
    [ "${lines[4]}" = "    node_modules" ]
    [ "${lines[5]}" = "    log" ]
    [ "${lines[6]}" = "    .*" ]
}

@test "should set to the new value" {
    set -f
    run eval 'echo "$CONTENT" | scripts/setrc -s ignore n xxx'
    [ "$status" -eq 0 ]
    [ "${#lines[@]}" -eq 8 ] 
    [ "${lines[0]}" = "root" ]
    [ "${lines[1]}" = "    /user/cox" ]
    [ "${lines[2]}" = "ignore" ]
    [ "${lines[3]}" = "# comment" ]
    [ "${lines[4]}" = "    xxx" ]
    [ "${lines[5]}" = "    node_modules" ]
    [ "${lines[6]}" = "    log" ]
    [ "${lines[7]}" = "    .*" ]
}

@test "should only change the name of key while setting KEY" {
    set -f
    run eval 'echo "$CONTENT" | scripts/setrc -s ignore exclude'
    [ "$status" -eq 0 ]
    [ "${#lines[@]}" -eq 8 ] 
    [ "${lines[0]}" = "root" ]
    [ "${lines[1]}" = "    /user/cox" ]
    [ "${lines[2]}" = "exclude" ]
    [ "${lines[3]}" = "# comment" ]
    [ "${lines[4]}" = "    n" ]
    [ "${lines[5]}" = "    node_modules" ]
    [ "${lines[6]}" = "    log" ]
    [ "${lines[7]}" = "    .*" ]
}

@test "should add the value to end of the value list of the key" {
    set -f
    run eval 'echo "$CONTENT" | scripts/setrc root /cox'
    [ "$status" -eq 0 ]
    [ "${#lines[@]}" -eq 9 ] 
    [ "${lines[0]}" = "root" ]
    [ "${lines[1]}" = "    /user/cox" ]
    [ "${lines[2]}" = "    /cox" ]
    [ "${lines[3]}" = "ignore" ]
    [ "${lines[4]}" = "# comment" ]
    [ "${lines[5]}" = "    n" ]
    [ "${lines[6]}" = "    node_modules" ]
    [ "${lines[7]}" = "    log" ]
    [ "${lines[8]}" = "    .*" ]
}

@test "should add the value to the end of the file if the key is the last key of the file" {
    set -f
    run eval 'echo "$CONTENT" | scripts/setrc ignore ignorance'
    [ "$status" -eq 0 ]
    [ "${#lines[@]}" -eq 9 ] 
    [ "${lines[0]}" = "root" ]
    [ "${lines[1]}" = "    /user/cox" ]
    [ "${lines[2]}" = "ignore" ]
    [ "${lines[3]}" = "# comment" ]
    [ "${lines[4]}" = "    n" ]
    [ "${lines[5]}" = "    node_modules" ]
    [ "${lines[6]}" = "    log" ]
    [ "${lines[7]}" = "    .*" ]
    [ "${lines[8]}" = "    ignorance" ]
}
