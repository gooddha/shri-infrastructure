#!/bin/bash
git tag

GIT_VERSION=$(git --version)

if [ $? = 0 ]
then echo $GIT_VERSION
else 
    echo "Git не установлен"
    exit 1
fi