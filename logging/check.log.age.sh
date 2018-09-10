#!/bin/sh

# Variables
INSTANCE=`hostname -f`
LOG=/opt/day/cq-publish/crx-quickstart/logs/request.log
AGE=$(echo $(( `date +%s` - `stat -L --format %Y $LOG` )))
RECIPIENTS="george.babanau@netcentric.biz,george.stefanov@netcentric.biz,henkel-support-monitoring@netcentric.biz"
PIDFILE=/tmp/test.pid

# Check if script is already running
if [ -e "${PIDFILE}" ] && (ps -u $(whoami) -opid= |
                           grep -P "^\s*$(cat ${PIDFILE})$" &> /dev/null); then
        echo "Already running."
        exit 99
fi

echo $$ > "${PIDFILE}"

# Check request.log age
if [ "$AGE" -gt 60 ]
then
        echo -e "Subject:WARNING - request.log older than 1 minute on $INSTANCE" | /usr/sbin/sendmail -v "$RECIPIENTS"
        sleep 300
fi