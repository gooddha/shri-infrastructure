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
echo $CHANGELOG

AUTHOR=$(git show $LAST_TAG | grep Author)
echo $AUTHOR

CURL_DATA_CREATE_DESCRIPTION="\
Release version: $LAST_TAG\n\
$AUTHOR\n\
Builded on: $GITHUB_ACTIONS_URL\n\
Changelog:\n\
$CHANGELOG"



DATA_CREATE="{\
    \"summary\":\"Release $LATEST_TAG\", \
    \"queue\": \"TMP\", \
    \"unique\": \"adam-$LATEST_TAG\", \
    \"description\": \"$CURL_DATA_CREATE_DESCRIPTION\" \
}"

OAUTH="Authorization: OAuth ${YANDEX_TOKEN}"
XORG="X-Org-Id: ${YANDEX_XORG_ID}"
HOST='https://api.tracker.yandex.net'

API_RESPONSE=$(curl \
   -s -o /dev/null -w "%{http_code}" \
   -X 'POST' \
   -H "$OAUTH"  \
   -H "$ORG"  \
   -H 'Content-Type: application/json' \
   --data "${DATA_CREATE}" \
  "$HOST"/v2/issues/)

echo "$API_RESPONSE"