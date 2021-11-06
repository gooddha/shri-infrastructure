#!/bin/bash

echo Start testing

npm test -- --json --outputFile=output.json
TEST_STATUS=$?;
echo TEST_STATUS $TEST_STATUS;

if [ $TEST_STATUS = 0 ] 
then TEST_TEXT="All tests passed. Result available here: $GITHUB_ACTION";
else TEST_TEXT="Some tests failed. Result available here: $GITHUB_ACTION";
fi;

echo $TEST_TEXT

COMMENT_RESPONSE=$(curl -o /dev/null -w "%{http_code}" -s -X 'POST' -H "$OAUTH" -H "$XORG" -H 'Content-Type: application/json' --data "{ \"text\" : \"$TEST_TEXT\" }" $HOST/v2/issues/$TASK_ID/comments);

if [ $COMMENT_RESPONSE = 201 ]
  then 
    echo "Test results successfully reported to task. Status: $COMMENT_RESPONSE";
  else 
    echo "Failed to add comment with tests result. Status: $COMMENT_RESPONSE"; 
    exit 1; 
fi;