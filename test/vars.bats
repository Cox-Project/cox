#!/usr/bin/env bats

source "scripts/vars"

@test "should have defined _COX_VERSION" {
    [ -n "$_COX_VERSION" ]
}

@test "should have defined _COX_HOME" {
    [ -n "$_COX_HOME" ]
}

@test "should have defined _COX_RC_FILE" {
    [ -n "$_COX_RC_FILE" ]
}

@test "should have defined _COX_DIR" {
    [ -n "$_COX_DIR" ]
}
