#!/bin/bash
echo Start release publication

echo GitHub is run action : $GITHUB_SERVER_URL/$GITHUB_REPOSITORY/actions/runs/$GITHUB_RUN_ID;

LAST_TAGS=$(git tag | tail -n 2);
LAST_TAG=$(echo $LAST_TAGS | awk '{ print $2 }');
PREV_TAG=$(echo $LAST_TAGS | awk '{ print $1 }');

echo Last tag version: $LAST_TAG;
echo Prev tag version: $PREV_TAG;

CHANGELOG=$(git log --pretty=format:"%s" $PREV_TAG..$LAST_TAG);
echo $CHANGELOG

AUTHOR=$(git show $LAST_TAG | grep Author)
echo $AUTHOR

