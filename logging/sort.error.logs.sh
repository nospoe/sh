#!/bin/sh
# George Babanau
# Script searches through declared error logs and sorts errors based on occurence


usage()
{
cat << @@
List obsolete definition files

usage: $0 -l error.log error.log.2017-12-09.gz error.log.2017-12-08.gz

options:
        -h : Help
        -l : list the log file names that you wish to search through
        -d : debug
@@
}

# read options input
while getopts "h?:i:u:l:w:d" opt ; do
        case "$opt" in
        h | "?")
                usage
                exit 1
        		;;
        i)
                LOGS="$OPTARG"
                echo "Using input: $OPTARG"
                ;;
        d)
                DEBUG="1"
                ;;
        esac
done

cat /dev/null > allerrors
zgrep ERROR $LOGS | cut -d' ' -f7-99 > allerrors_tmp
sort -u allerrors_tmp > allerrors


cat /dev/null > allerrors_final
while IFS='' read -r line || [[ -n "$line" ]]; do
	echo "$(grep -c "$line" allerrors) $line" >> allerrors_tmp
done < allerrors

sort -k1,1nr -k2,2 allerrors_tmp >> allerrors_final
rm -f allerrors_tmp
rm -f allerrors