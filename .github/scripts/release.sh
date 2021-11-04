#!/bin/bash
echo Start release publication

GITHUB_ACTION=$GITHUB_SERVER_URL/$GITHUB_REPOSITORY/actions/runs/$GITHUB_RUN_ID
echo GitHub is run action : $GITHUB_ACTION;

LAST_TAGS=$(git tag | tail -n 2);
LAST_TAG=$(echo $LAST_TAGS | awk '{ print $2 }');
PREV_TAG=$(echo $LAST_TAGS | awk '{ print $1 }');

echo Last tag version: $LAST_TAG;
echo Prev tag version: $PREV_TAG;

CHANGELOG=$(git log --oneline --decorate $PREV_TAG..$LAST_TAG);
echo CHANGELOG:
echo $CHANGELOG

AUTHOR=$(git show $LAST_TAG | grep Author);
echo $AUTHOR

CURL_DATA_CREATE_DESCRIPTION="\
Release version: $LAST_TAG\n\
$AUTHOR\n\
Builded on: $GITHUB_ACTIONS_URL\n\
Changelog:\n\
$CHANGELOG"


DATA='{"summary": "Release test", "queue": "TMP"}'
echo $DATA

OAUTH="Authorization: OAuth AQAAAAACmEmvAAd5AYEAYatyGkGwgxds0AOn_3M"
XORG="X-Org-Id: 6461097"
HOST='https://api.tracker.yandex.net'

API_RESPONSE1=$(curl -s -X 'POST' -H "$OAUTH" -H "$XORG" -H 'Content-Type: application/json' --data "${DATA}" $HOST/v2/issues/);
API_RESPONSE2=$(curl -s -X 'GET'  -H "$OAUTH" -H "$XORG" $HOST/v2/myself);

echo API RESPONSE1:
echo "$API_RESPONSE1"
echo API RESPONSE2:
echo "$API_RESPONSE2"
