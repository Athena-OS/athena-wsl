#!/usr/bin/env bash

if [[ ! -e "$XDG_RUNTIME_DIR/bus" ]]; then
    systemctl stop user@1000
    systemctl start user@1000
fi
