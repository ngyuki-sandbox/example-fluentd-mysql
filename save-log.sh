#!/bin/bash

set -eu

printf 'time:%s\tlog_time:%s\tprocess_id:%s\tipaddr:%s\tpriority:%s\tmessage:%s\n' \
  "$(date +%Y%m%dT%H%M%S)" "$(date +%s)" "$$" "$(hostname -i)" "$1" "$2" \
    >> /var/log/app.log
