#!/bin/bash
echo Start release publication

echo "GitHub is run action : $GITHUB_SERVER_URL/$GITHUB_REPOSITORY/actions/runs/$GITHUB_RUN_ID"

LAST_TAGS=$(git tag | tail -n 2);
LAST_TAGS2=$(echo $(git tag | tail -n 2));


echo "$LAST_TAGS"
echo "$LAST_TAGS2"
# echo $(git log v0.1..v0.2 --oneline)

# echo $(git tag | tail -n 2)


