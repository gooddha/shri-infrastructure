#!/bin/bash
git tag

TAG_VERSION=$(git tag);

if [ $? = 0 ]
then echo $TAG_VERSION
fi