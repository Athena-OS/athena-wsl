#!/usr/bin/env bash

if [[ "$(systemctl is-active user@1000)" != "active" ]]; then
    systemctl restart user@1000
fi
