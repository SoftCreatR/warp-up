#!/usr/bin/env bash

##############################################################
# Title          : Warp-Up                                   #
# Description    : Automatically generated referrer bonuses  #
#                  for Cloudflare WARP.                      #
#                                                            #
# Author         : Sascha Greuel <hello@1-2.dev>             #
# Date           : 2020-09-18 19:47                          #
# License        : MIT                                       #
# Version        : 2.0.0                                     #
#                                                            #
# Usage          : bash warp-up.sh                           #
##############################################################

######################
# Check requirements #
######################

command_exists() {
  command -v "$@" >/dev/null 2>&1
}

required_packages="curl"

for package in $required_packages; do
  if ! command_exists "$package"; then
    echo "The package $package is missing. Please install it, before continuing."
    exit 1
  fi
done

####################
# Script arguments #
####################

if [ -f ./warp-up.conf ]; then
  . ./warp-up.conf
fi

while [ "$#" -gt 0 ]; do
  case "$1" in
  --id)
    REFERRER=$2
    ;;
  --iterations)
    ITERATIONS=$2
    ;;
  --interval)
    INTERVAL=$2
    ;;
  --log-file)
    LOG_FILE=$2
    ;;
  --disclaimer)
    DISCLAIMER_AGREE="yes"
    ;;
  --travis)
    TRAVIS_BUILD="yes"
    ;;
  *) ;;
  esac
  shift
done

#############
# Variables #
#############

SUCCESS=0
FAILURE=0

# Colors
CSI='\033['
CRED="${CSI}1;31m"
CGREEN="${CSI}1;32m"
CYELLOW="${CSI}1;33m"
CBLUE="${CSI}1;36m"
CEND="${CSI}0m"

if [ -z "$INTERVAL" ]; then
  INTERVAL=20
fi

if [ -z "$LOG_FILE" ]; then
  LOG_FILE=warp-up.log
fi

if [ ! -w "$LOG_FILE" ] && [ ! -w "$(dirname "${LOG_FILE}")" ]; then
  echo -e "${CRED}Could not write log file $LOG_FILE. Make sure, that you have the required permissions or restart Warp-Up with sudo.${CEND}"

  exit 1
fi

####################
# Helper functions #
####################

str_repeat() {
  printf -v v "%-*s" "$1" ""
  echo "${v// /$2}"
}

version() {
  echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'
}

rnd() {
  tr </dev/urandom -dc 'a-zA-Z0-9' | fold -w "$1" | head -n 1
}

function json_val() {
  temp=$(echo "$1" | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w "$2")
  echo "${temp##*|}"
}

json_encode() {
  local arr=("$@")
  local len=${#arr[@]}

  if [[ ${len} -eq 0 ]]; then
    echo >&2 "Error: Length of input array needs to be at least 2."
    return 1
  fi

  if [[ $((len % 2)) -eq 1 ]]; then
    echo >&2 "Error: Length of input array needs to be even (key/value pairs)."
    return 1
  fi

  local data=""
  local foo=0

  for i in "${arr[@]}"; do
    local char=","

    if [ $((++foo % 2)) -eq 0 ]; then
      char=":"
    fi

    local first="${i:0:1}"
    local app="\"$i\""

    if [[ "$first" == "^" ]]; then
      app="${i:1}"
    fi

    data="$data$char$app"
  done

  data="${data:1}"
  echo "{$data}"
}

##################
# Version checks #
##################

if [ -f "$0" ]; then
  WARP_UP_VER=$(grep -oP 'Version\s+:\s+\K([\d\.]+)' "$0")
  WARP_UP_LATEST_VER=$(wget -qO- "https://1-2.dev/warp-up?uc" | grep -oP 'Version\s+:\s+\K([\d\.]+)')
fi

##################
# Base functions #
##################

warpUp() {
  sleep $INTERVAL

  # Travis should never make API calls
  if [ -n "$TRAVIS_BUILD" ]; then
    if [ "$((1 + RANDOM % (1 + 10 - 1)))" -lt 5 ]; then
      SUCCESS=$((SUCCESS + 1))
    else
      FAILURE=$((FAILURE + 1))
    fi

    return
  fi

  API_URL="https://api.cloudflareclient.com/v0a$((100 + RANDOM % (1 + 999 - 100)))/reg"
  INSTALL_ID=$(rnd 22)
  BODY="$(
    json_encode \
      key "$(rnd 43)=" \
      install_id "$INSTALL_ID" \
      fcm_token "$INSTALL_ID":APA91b"$(rnd 134)" \
      referrer "$REFERRER" \
      warp_enabled ^false \
      tos "$(date '+%Y-%m-%dT%T.000%:z')" \
      type Android \
      locale "$(locale | grep LANG= | cut -d= -f2 | cut -d. -f1)"
  )"

  {
    API_RESPONSE=$(
      curl \
        --compressed \
        --cookie "/tmp/cfwarp.txt" \
        --cookie-jar "/tmp/cfwarp.txt" \
        --header "Content-Type: application/json" \
        --header "Host: api.cloudflareclient.com" \
        --header "Connection: Keep-Alive" \
        --header "Accept-Encoding: gzip" \
        --header "User-Agent: okhttp/3.12.1" \
        --request POST \
        --data "$BODY" \
        --silent \
        "$API_URL"
    )

    if [ "$(json_val "$API_RESPONSE" referrer)" = "$REFERRER" ]; then
      SUCCESS=$((SUCCESS + 1))

      echo "$(date): Success"
    else
      FAILURE=$((FAILURE + 1))

      echo "$(date): $API_RESPONSE"
    fi
  } >>"$LOG_FILE" 2>&1
}

#######
# Run #
#######

if [ -z "$TRAVIS_BUILD" ] && [ -z "$DISCLAIMER_AGREE" ]; then
  clear

  echo " DISCLAIMER"
  echo ""
  echo " This software and information is designed for educational purposes only."
  echo ""
  echo " This information is provided 'as is' and in no event shall the"
  echo " provider or 1-2.dev be liable for any damages, including, without"
  echo " limitation, damages resulting from lost data or lost profits or"
  echo " revenue, the costs of recovering such data, the costs of substitute"
  echo " data, claims by third parties or for other similar costs, or any"
  echo " special, incidental, or consequential damages arising out of use or"
  echo " misuse of this data. The accuracy or reliability of the data is not"
  echo " guaranteed or warranted in any way and the provider disclaim"
  echo " liability of any kind whatsoever, including, without limitation,"
  echo " liability for quality, performance, merchantability and fitness"
  echo " for a particular purpose arising out of the use, or inability"
  echo " to use the data. Information obtained via this software MUST"
  echo " NEVER BE USED to take medical decisions."
  echo ""
  echo " All respective trademarks belong to Cloudflare, Inc."
  echo " 1-2.dev is not affiliated with or endorsed by Cloudflare."
  echo ""

  while true; do
    read -rp " Do you agree? (y/n): " yn </dev/tty

    case $yn in
    [Yy]*)
      break
      ;;
    [Nn]*)
      echo ""
      echo " You did not agree to the disclaimer, therefore you are not allowed to use this software."
      echo ""
      exit
      ;;
    *)
      echo -e " ${CYELLOW}Please answer yes or no.${CEND}"
      echo ""
      ;;
    esac
  done
fi

clear

WELCOME_TXT="Welcome to Warp Up - $WARP_UP_VER"
WELCOME_LEN=${#WELCOME_TXT}

echo " $(str_repeat "$WELCOME_LEN" "#")"
echo " $WELCOME_TXT"
echo " $(str_repeat "$WELCOME_LEN" "#")"
echo ""

if [ -z "$TRAVIS_BUILD" ] && [ -n "$WARP_UP_VER" ] && [ "$(version "$WARP_UP_VER")" -lt "$(version "$WARP_UP_LATEST_VER")" ]; then
  echo -e " ${CYELLOW}A newer Warp Up version ($WARP_UP_LATEST_VER) is available!${CEND}"
  echo ""
fi

if [ -z "$REFERRER" ] || [[ ! "$REFERRER" =~ ^\{?[A-F0-9a-f]{8}-[A-F0-9a-f]{4}-[A-F0-9a-f]{4}-[A-F0-9a-f]{4}-[A-F0-9a-f]{12}\}?$ ]]; then
  while true; do
    read -n 36 -rp " Warp ID    : " REFERRER </dev/tty

    if [[ $REFERRER =~ ^\{?[A-F0-9a-f]{8}-[A-F0-9a-f]{4}-[A-F0-9a-f]{4}-[A-F0-9a-f]{4}-[A-F0-9a-f]{12}\}?$ ]]; then
      if [[ -x "$0" ]]; then
        exec bash "$0" --id "$REFERRER" --iterations "$ITERATIONS" --interval "$INTERVAL" --disclaimer "$DISCLAIMER_AGREE" && exit
      else
        break
      fi

    else
      echo -ne " ${CYELLOW}Invalid Warp ID provided. Please try again.${CEND}"
      echo ""
      echo ""
    fi
  done
else
  echo " Warp ID    : $REFERRER"
fi

if [ -z "$ITERATIONS" ] || [[ ! "$ITERATIONS" =~ ^[0-9]+$ ]]; then
  while true; do
    read -rp " Iterations : " ITERATIONS </dev/tty

    if [[ "$ITERATIONS" =~ ^[0-9]+$ ]]; then
      if [[ -x "$0" ]]; then
        exec bash "$0" --id "$REFERRER" --iterations "$ITERATIONS" --interval "$INTERVAL" --disclaimer "$DISCLAIMER_AGREE" && exit
      else
        break
      fi

    else
      echo -ne " ${CYELLOW}Please input numbers only.${CEND}"
      echo ""
      echo ""
    fi
  done
else
  echo " Iterations : $ITERATIONS"
fi

echo " Interval   : $INTERVAL"

echo ""
echo " Log File : $LOG_FILE"
echo " Travis   : ${TRAVIS_BUILD:-"no"}"
echo ""

echo " ##################"
echo " Generation Process"
echo " ##################"
echo ""

# Begin new log entry
HASH=$(date '+%N' | sha1sum | head -c 40)
START=$(date)
END=$(date --date="+$((ITERATIONS * INTERVAL)) seconds")

cat <<FOE >>$LOG_FILE
<<<<<<<<${HASH}<<<<
Warp-Up Version   : ${WARP_UP_VER}
Warp ID           : ${REFERRER}
Iterations        : ${ITERATIONS}
Interval          : ${INTERVAL}

Process Start     : ${START}
Process End (est) : ${END}

======

FOE

echo -ne ' Generating extra traffic        [..]\r'

if [ "$ITERATIONS" -lt 1 ]; then
  while true; do
    warpUp

    echo -ne " Generating extra traffic        [${CGREEN}Successful: $SUCCESS${CEND} - ${CRED}Failures: $FAILURE${CEND}]\r"
  done
else
  for ((i = 1; i <= ITERATIONS; i++)); do
    warpUp

    echo -ne " Generating extra traffic        [${CGREEN}Successful: $SUCCESS${CEND} - ${CRED}Failures: $FAILURE${CEND}]\r"
  done
fi

cat <<FOE >>$LOG_FILE
<<<<

FOE

echo ""
echo ""
echo -e "${CGREEN} Done! ${CEND}${CBLUE}$SUCCESS GB${CEND}${CGREEN} extra traffic have been added to your WARP account.${CEND}"
echo ""
echo ""
