#!/usr/bin/env bats

ESC=$(printf '\033')

@test "should echo the original string" {
    run scripts/coecho abcdefg
    [ "$status" -eq 0 ]
    [ "$output" = "abcdefg" ]
}

@test "should display the original string if no foreground and background color specified" {
    run scripts/coecho -s abc abcdefg
    [ "$status" -eq 0 ]
    [ "$output" = "abcdefg" ]
}

@test "should use the -f argument for foreground color" {
    run scripts/coecho -f red -s abc abcdefg
    echo "$output"
    [ "$status" -eq 0 ]
    [ "$output" = "$ESC[31mabc$ESC[0mdefg" ]
}

@test "should use the -b argument for background color" {
    run scripts/coecho -b red -s abc abcdefg
    [ "$status" -eq 0 ]
    [ "$output" = "$ESC[41mabc$ESC[0mdefg" ]
}

@test "should support using -f and -b together" {
    run scripts/coecho -f red -b white -s abc abcdefg
    [ "$status" -eq 0 ]
    [ "$output" = "$ESC[47m$ESC[31mabc$ESC[0m$ESC[0mdefg" ]
}

@test "should accept the statndard input" {
    run eval 'echo "abcdefg" | scripts/coecho -f red -b white -s abc'
    [ "$status" -eq 0 ]
    [ "$output" = "$ESC[47m$ESC[31mabc$ESC[0m$ESC[0mdefg" ]
}

@test "should highlight mutlipart" {
    run eval 'scripts/coecho -f red -b white -s abc abcdefg | scripts/coecho -f white -b red -s fg'
    [ "$status" -eq 0 ]
    [ "$output" = "$ESC[47m$ESC[31mabc$ESC[0m$ESC[0mde$ESC[41m$ESC[37mfg$ESC[0m$ESC[0m" ]
}
