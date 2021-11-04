#!/bin/bash
echo Start release publication

echo "GitHub is run action : $GITHUB_SERVER_URL/$GITHUB_REPOSITORY/actions/runs/$GITHUB_RUN_ID"

TAG_VERSION=$(git tag | tail -n 1);

if [ $? = 0 ]
then echo $TAG_VERSION
fi


