#!/usr/bin/env bash

case ${1:-} in
  config)
    echo 'graph_args -l 0'
    echo 'graph_title Ping round trip time (ms)'
    echo 'graph_scale no'
    echo 'graph_vlabel rtt'
    echo 'ping_rtt.label rtt'
    echo 'graph_category network'
    echo 'graph_info The round trip time of a ping to 8.8.8.8.'
    exit 0
    ;;
esac

echo -n 'ping_rtt.value '

# do an initial test for packet loss
if ! ping -c3 8.8.8.8 -W 5 >/dev/null 2>&1 ; then
	# emit 'nan' if we probably don't have connectivity
	echo 'nan'
else
	# now that we should have connectivity, get the average of 10 round trips
	ping -c10 8.8.8.8 | grep -F 'rtt min' | cut -d'=' -f2 | cut -d'/' -f2
fi
