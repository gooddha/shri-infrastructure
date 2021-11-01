#!/bin/bash


TAG_VERSION=$(git tag | tail -n 1);

if [ $? = 0 ]
then echo $TAG_VERSION
fi


