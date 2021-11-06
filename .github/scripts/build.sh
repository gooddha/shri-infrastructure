#!/bin/bash

echo Creating build artifact

docker build -t relase:$LAST_TAG .
BUILD_STATUS=$?;

if [ $BUILD_STATUS = 0 ] 
then BUILD_TEXT="Docker image release:$LAST_TAG successfully created.\nResult available here: $GITHUB_ACTION";
else echo "Failed to create docker image"; exit 1
fi;

echo $BUILD_TEXT

SEARCH_PARAMS="{ \"filter\": {\"queue\": \"TMP\", \"unique\": \"adamovich-$LAST_TAG\"}}";
FIND_RESPONSE=$(curl -s -X 'POST' -H "$OAUTH" -H "$XORG" -H 'Content-Type: application/json' --data "$SEARCH_PARAMS" $HOST/v2/issues/_search);
TASK_ID=$(echo $FIND_RESPONSE | jq '.[].id' | sed 's/\"//g');

COMMENT_RESPONSE=$(curl -o /dev/null -w "%{http_code}" -s -X 'POST' -H "$OAUTH" -H "$XORG" -H 'Content-Type: application/json' --data "{ \"text\" : \"$BUILD_TEXT\" }" $HOST/v2/issues/$TASK_ID/comments);

if [ $COMMENT_RESPONSE = 201 ]
  then 
    echo "Build is done. Docker image created. Reported to task. Status: $COMMENT_RESPONSE";
  else 
    echo "Failed to add comment with build result. Status: $COMMENT_RESPONSE"; 
    exit 1; 
fi;