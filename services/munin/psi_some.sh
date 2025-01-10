#!/usr/bin/env bash

case ${1:-} in
  config)
    echo 'graph_args -l 0'
    echo 'graph_scale no'
    echo 'graph_title Pressure Stall Information (some)'
    echo 'graph_vlabel % of last 5 min'
    echo 'psi_cpu.label cpu'
    echo 'psi_mem.label memory'
    echo 'psi_io.label i/o'
    echo 'graph_category system'
    echo 'graph_info The percentage of time at least one process was waiting on resources in the last 5 minutes.'
    exit 0
    ;;
esac

echo -n 'psi_cpu.value '
grep '^some' /proc/pressure/cpu | sed -E 's/^.*\savg300=(.*)\s.*$/\1/'
echo -n 'psi_mem.value '
grep '^some' /proc/pressure/memory | sed -E 's/^.*\savg300=(.*)\s.*$/\1/'
echo -n 'psi_io.value '
grep '^some' /proc/pressure/io | sed -E 's/^.*\savg300=(.*)\s.*$/\1/'

