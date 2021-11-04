#!/bin/bash
echo Start release publication

GITHUB_ACTION_URL="$GITHUB_SERVER_URL/$GITHUB_REPOSITORY/actions/runs/$GITHUB_RUN_ID"
echo "GitHub is run action : $GITHUB_ACTIONS_URL"

TAG_VERSION=$(git tag | tail -n 1);

if [ $? = 0 ]
then echo $TAG_VERSION
fi


