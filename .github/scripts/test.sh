#!/bin/bash
echo Install npm modules...
npm install;

if [ $? = 0 ]
  then echo "Npm modules is successfully installed"; 
else 
  echo "Npm install is failed"; 
  exit 1; 
fi;

echo Start testing

npm test -- --json --outputFile=output.json
TEST_STATUS=$?;

if [ $TEST_STATUS = 0 ] 
then TEST_TEXT="All tests passed.\nResult available here: $GITHUB_ACTION";
else TEST_TEXT="Some tests failed.\nResult available here: $GITHUB_ACTION";
fi;

echo $TEST_TEXT

SEARCH_PARAMS="{ \"filter\": {\"queue\": \"TMP\", \"unique\": \"adamovich-$LAST_TAG\"}}";
FIND_RESPONSE=$(curl -s -X 'POST' -H "$OAUTH" -H "$XORG" -H 'Content-Type: application/json' --data "$SEARCH_PARAMS" $HOST/v2/issues/_search);
TASK_ID=$(echo $FIND_RESPONSE | jq '.[].id' | sed 's/\"//g');

COMMENT_RESPONSE=$(curl -o /dev/null -w "%{http_code}" -s -X 'POST' -H "$OAUTH" -H "$XORG" -H 'Content-Type: application/json' --data "{ \"text\" : \"$TEST_TEXT\" }" $HOST/v2/issues/$TASK_ID/comments);

if [ $COMMENT_RESPONSE = 201 ]
  then 
    echo "Test results successfully reported to task. Status: $COMMENT_RESPONSE";
  else 
    echo "Failed to add comment with tests result. Status: $COMMENT_RESPONSE"; 
    exit 1; 
fi;

if [ $TEST_STATUS = 0 ] 
then ./.github/scripts/build.sh
else exit 1;
fi;