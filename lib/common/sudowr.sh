#!/usr/bin/bash

if [ $(id -u) -eq 0 ]; then
  "$@"
else
  sudo "$@"
fi
