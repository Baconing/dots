wsNext=$(( $( i3-msg -t get_workspaces | jq '.[] | select(.focused).num' ) + $2))
if [[ "$1" == "movefocus" ]] then
  i3-msg workspace number $wsNext
elif [[ "$1" == "movecontainer" ]] then
  i3-msg move container to workspace number $wsNext
else
  echo "do actual args pls"
fi
