#!/bin/bash
echo $?;

if [ $? = 1 ] 
then 
  echo "Build is not started because errors on previouse steps"; 
  exit 1;
else
  echo Start release build
fi

echo Install npm modules...
npm i