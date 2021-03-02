#!/bin/bash
#
# Purpose: Starts scanning on specified freqency range with rtl_power.
#
# Inputs:
#    1. (Optional) GZip file to store CSV scan data (must have .csv.gz extension)
#
# Example:
#   ./start_scanning.sh my_scan.csv.gz
#   ...
#   ./stop_and_finalize_scanning.sh my_scan.csv.gz

# import common lib and settings
. "$HOME/.noaa-v2.conf"
. "$NOAA_HOME/scripts/common.sh"

[ $# -lt 1 ] && outfile=scan_$(date  +"%d.%m.%y-%H.%M").csv.gz || outfile=$1	#important: outfile needs to end with csv.gz

range="137M:138M:1k" #"130M:140M:5k"
scriptpath="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

echo "
$(tput setaf 2)
	Scanning in range $range, output file is $outfile.
$(tput setaf 1)
	Please note that this script will take precedence over all scheduled capture jobs!
$(tput setaf 3)
	To stop scanning, either type \`killall rtl_power\`
	or use the script \`$scriptpath/stop_and_finalize_scanning.sh $outfile\`.
	You can 'peek' while scanning with \`$scriptpath/generate_waterfall $outfile\`.
	(note that gzip output is buffered in chunks, so it won't be updated immediately)

$(tput sgr0)"

nohup rtl_power ${BIAS_TEE} -f $range -g $GAIN -c 25% -d 0 2> /dev/null | gzip > $outfile &
