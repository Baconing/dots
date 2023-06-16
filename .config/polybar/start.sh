#!/bin/bash

killall polybar


if type "xrandr"; then
	  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
      if [[ $m = $MAINMON ]]; then
            MONITOR=$m TRAY=center polybar main &
      else
            MONITOR=$m TRAY=none polybar main &
      fi
		        done
		else
        echo "install xrandr pls"
			  polybar main &
fi
