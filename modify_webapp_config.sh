#!/bin/bash
set -euo pipefail

if [ "$#" -ne 2 ]; then
  echo "usage: modify_webapp_config.sh lat lon"
  exit 2
fi

readonly lat="${1}"
readonly lon="${2}"

readonly config_file="/src/readsb-protobuf-db/webapp/src/script/readsb/defaults.json"

readonly zoom_level=9

jq '.SiteLat=($lat|tonumber) | .SiteLon=($lon|tonumber) | .CenterLat=($lat|tonumber) | .CenterLon=($lon|tonumber) | .ZoomLevel=($zoom|tonumber) | .DimMap=true' \
  --arg lat "${lat}" \
  --arg lon "${lon}" \
  --arg zoom "${zoom_level}" \
  "${config_file}" \
  > "${config_file}.new"

echo "============== WEBAPP CONIG FILE DIFF =============="
diff "${config_file}" "${config_file}.new" || :
echo "============== END WEBAPP CONIG FILE DIFF =============="
mv "${config_file}.new" "${config_file}"
