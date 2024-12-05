gh pr checks --fail-fast --watch && pushover.sh "`gh pr checks | awk -F '\t' '{print $2 ":  " $1}'`"
