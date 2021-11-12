#!/usr/bin/env bash

steam -silent &
discord &
nitrogen --restore &

picom &
copyq &

qtile cmd-obj -o screen 1 -f toggle_group -a a &
qtile cmd-obj -o screen 0 -f toggle_group -a 1 &