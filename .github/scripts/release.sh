#!/bin/bash
echo Start release publication...

export GITHUB_ACTION=$GITHUB_SERVER_URL/$GITHUB_REPOSITORY/actions/runs/$GITHUB_RUN_ID
echo GitHub is run action : $GITHUB_ACTION;

LAST_TAGS=$(git tag | tail -n 2);
PREV_TAG=$(echo $LAST_TAGS | awk '{ print $1 }');
export LAST_TAG=$(echo $LAST_TAGS | awk '{ print $2 }');
LAST_TAG_DATE=$(git log $LAST_TAG -n 1 | grep Date:);

echo Release version: $LAST_TAG;
echo Release date: $LAST_TAG_DATE;
AUTHOR=$(git show $LAST_TAG | grep Author);
echo $AUTHOR

CHANGELOG=$(git log --oneline --decorate $PREV_TAG..$LAST_TAG);
echo CHANGELOG: $CHANGELOG
echo 

echo "Sending request to tracker API for create new task..."
DESCRIPTION="Release version: $LAST_TAG\n$AUTHOR\n$LAST_TAG_DATE\nChangelog:\n$CHANGELOG"
DESCRIPTION=$(echo "$DESCRIPTION" | sed -z 's/\n/\\n/g');
DATA="{\"summary\": \"Release: $LAST_TAG\", \"queue\": \"TMP\", \"unique\": \"adamovich-$LAST_TAG\", \"description\": \"$DESCRIPTION\"}";

echo $YANDEX_TOKEN #="AQAAAAACmEmvAAd5AYEAYatyGkGwgxds0AOn_3M";
echo $YANDEX_XORG_ID #="6461097";

export OAUTH="Authorization: OAuth $YANDEX_TOKEN";
export XORG="X-Org-Id: $YANDEX_XORG_ID";
export HOST='https://api.tracker.yandex.net';

API_RESPONSE=$(curl -o /dev/null -w "%{http_code}" -s -X 'POST' -H "$OAUTH" -H "$XORG" -H 'Content-Type: application/json' --data "$DATA" $HOST/v2/issues/);

if [ $API_RESPONSE = 201 ] 
then echo "Task successfully created";
elif [ $API_RESPONSE = 409 ]
then 
  echo "Task for realese $LAST_TAG already exist."

  SEARCH_PARAMS="{ \"filter\": {\"queue\": \"TMP\", \"unique\": \"adamovich-$LAST_TAG\"}}";
  FIND_RESPONSE=$(curl -s -X 'POST' -H "$OAUTH" -H "$XORG" -H 'Content-Type: application/json' --data "$SEARCH_PARAMS" $HOST/v2/issues/_search);
  TASK_ID=$(echo $FIND_RESPONSE | jq '.[].id' | sed 's/\"//g');
  TASK_QUEUE_KEY=$(echo $FIND_RESPONSE | jq '.[].key' | sed 's/\"//g');

  if [ -z $TASK_ID ]; then echo "Error, cant get existing task ID"; exit 1; fi
  if [ -z $TASK_QUEUE_KEY ]; then echo "Error, cant get existing task queue key"; exit 1; fi

  echo "Existing task URL: https://tracker.yandex.ru/$TASK_QUEUE_KEY"  
  echo "Trying to update existing task..."

  UPDATE_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X 'PATCH' -H "$OAUTH" -H "$XORG" -H 'Content-Type: application/json' --data "$DATA" $HOST/v2/issues/$TASK_ID);
  if [ $UPDATE_RESPONSE = 200 ]; 
    then echo "Task is successfully updated!"; 
    else echo "Task updating is fail with error: $UPDATE_RESPONSE"; 
    exit 1; 
  fi;

else 
  echo "Task creating is fail with error: $API_RESPONSE";
  exit 1;
fi

./.github/scripts/test.sh
./.github/scripts/build.sh