#!/bin/sh

active_window_class=$(xdotool getwindowfocus getwindowclassname)
active_window_name=$(xdotool getwindowfocus getwindowname)
final="$active_window_class | $active_window_name"
echo $final
