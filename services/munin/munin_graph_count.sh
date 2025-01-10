#!/usr/bin/env bash

case $1 in
  config)
    echo 'graph_args -l 0'
    echo 'graph_title Number of graphs'
    echo 'graph_scale no'
    echo 'graph_vlabel graphs'
    echo 'munin_graph_count.label graphs'
    echo 'graph_category why'
    echo 'graph_info The number of graphs on the dashboard.'
    exit 0
    ;;
esac

#%PATH%#

echo -n 'munin_graph_count.value '
printf 'list\nquit\n' | nc localhost 4949 | grep -v '^#' | wc -w

