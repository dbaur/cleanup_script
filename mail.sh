#!/bin/bash

source secure.sh

if [[ -z "$1" ]]; then
  echo "Expected fileName as first parameter"
  exit 1
fi

if [[ -z "$2" ]]; then
  echo "Expected target address as first parameter"
  exit 1
fi

echo ${FROM}
echo ${MAILSERVER}
echo ${PASSWORD}

echo "Please find your file ${1} attached in this mail. Best Regards, Cloudiator" | mailx -v -a ${1} -r ${FROM} -S smtp=${MAILSERVER} -S smtp-auth=login -S smtp-use-starttls -S smtp-auth-user=${FROM} -S smtp-auth-password=${PASSWORD} -s "Cloudiator is sending you your file ${1}." -t ${2}
