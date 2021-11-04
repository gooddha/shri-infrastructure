#!/bin/bash
echo Start release publication

GITHUB_ACTION=$GITHUB_SERVER_URL/$GITHUB_REPOSITORY/actions/runs/$GITHUB_RUN_ID
echo GitHub is run action : $GITHUB_ACTION;

LAST_TAGS=$(git tag | tail -n 2);
PREV_TAG=$(echo $LAST_TAGS | awk '{ print $1 }');
LAST_TAG=$(echo $LAST_TAGS | awk '{ print $2 }');
LAST_TAG_DATE=$(git log $LAST_TAG -n 1 | grep Date:);

echo Prev tag version: $PREV_TAG;
echo Last tag version: $LAST_TAG;
echo Last tag date: $LAST_TAG_DATE;

CHANGELOG=$(git log --oneline --decorate $PREV_TAG..$LAST_TAG);
echo CHANGELOG:
echo $CHANGELOG

AUTHOR=$(git show $LAST_TAG | grep Author);
echo $AUTHOR

DESCRIPTION="\
Release version: $LAST_TAG\n$AUTHOR\n$LAST_TAG_DATE\nRun on: $GITHUB_ACTION\nChangelog:\n$CHANGELOG"
DESCRIPTION=$(echo "$DESCRIPTION" | sed -z 's/\n/\\n/g');

DATA="{\"summary\": \"Release: $LAST_TAG\", \"queue\": \"TMP\", \"description\": \"$DESCRIPTION\"}"
echo DATA: $DATA

OAUTH="Authorization: OAuth AQAAAAACmEmvAAd5AYEAYatyGkGwgxds0AOn_3M"
XORG="X-Org-Id: 6461097"
HOST='https://api.tracker.yandex.net'

API_RESPONSE1=$(curl -s -X 'POST' -H "$OAUTH" -H "$XORG" -H 'Content-Type: application/json' --data "${DATA}" $HOST/v2/issues/);

echo API RESPONSE1:
echo "$API_RESPONSE1"