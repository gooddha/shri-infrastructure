#!/bin/bash
echo Start release build
echo Install npm modules...
npm install > "/dev/null" 

if [ $? = 0 ]
  then echo "Npm modules is successfully installed"; 
else 
  echo "Npm install is failed"; 
  exit 1; 
fi;

echo Creating build artifact
