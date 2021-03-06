#!/bin/bash

## import common lib
. "$HOME/.noaa-v2.conf"
. "$NOAA_HOME/scripts/common.sh"

for img_path in $(sqlite3 ${DB_FILE} "select file_path from decoded_passes limit 10;"); do
    find "${IMAGE_OUTPUT}/" -type f -name "${IMG_NAME}*.jpg" -exec rm -f {} \;
    find "${IMAGE_OUTPUT}/thumb/" -type f -name "${IMG_NAME}*.jpg" -exec rm -f {} \;
    log "${img_path} file pruned" "INFO"
    sqlite3 "${DB_FILE}" "delete from decoded_passes where file_path = \"$img_path\";"
    log "Database entry pruned" "INFO"
done
