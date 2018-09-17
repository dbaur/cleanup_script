#!/bin/bash

USER=john.doe@example.com
TENANT=admin
PASSWORD=admin
USER_ID=1

authenticate() {
  AUTH_URL="$1/api/login"
  TOKEN=$(curl -s -X POST ${AUTH_URL} -H "Accept: application/json" -H "Content-Type: application/json" --data '{"email":"john.doe@example.com","password":"admin","tenant":"admin"}' | jq -r '.token')
  echo ${TOKEN}
}

findInstanceUrl() {
  INSTANCE_URL="$1/api/instance"
  TOKEN=$(authenticate $1)
  INSTANCE=$(curl -s -X GET ${INSTANCE_URL} -H "Accept: application/json" -H "Content-Type: application/json" -H "X-Auth-Token: ${TOKEN}" -H "X-Auth-UserId: ${USER_ID}" -H "X-Tenant: ${TENANT}" | jq -r --arg UUID $2 '.[] | select(.remoteId==$UUID) | .link[] | select(.rel=="self") | .href')
  echo ${INSTANCE}
}

findVirtualMachineUrl() {
  INSTANCE_URL="$1/api/instance"
  TOKEN=$(authenticate $1)
  VM_ID=$(curl -s -X GET ${INSTANCE_URL} -H "Accept: application/json" -H "Content-Type: application/json" -H "X-Auth-Token: ${TOKEN}" -H "X-Auth-UserId: ${USER_ID}" -H "X-Tenant: ${TENANT}" | jq -r --arg UUID $2 '.[] | select(.remoteId==$UUID) | .virtualMachine')
  echo "${1}/api/virtualMachine/${VM_ID}"
}

deleteVM() {
  echo "Deleting VM $2"
  TOKEN=$(authenticate $1)
  curl -v -X DELETE ${2} -H "Accept: application/json" -H "Content-Type: application/json" -H "X-Auth-Token: ${TOKEN}" -H "X-Auth-UserId: ${USER_ID}" -H "X-Tenant: ${TENANT}"
}

deleteInstance() {
  echo "Deleting instance $2"
  TOKEN=$(authenticate $1)
  curl -v -X DELETE ${2} -H "Accept: application/json" -H "Content-Type: application/json" -H "X-Auth-Token: ${TOKEN}" -H "X-Auth-UserId: ${USER_ID}" -H "X-Tenant: ${TENANT}"
}

# Read environment variables to get instance and vm id
# visitor.visit("VM_ID", hostContext.getVMIdentifier());
# visitor.visit("INSTANCE_ID", myId.toString());

if [[ -z "$1" ]]; then
  echo "Expected colosseum url as parameter."
  exit 1
fi

if [[ -z "${INSTANCE_ID}" ]]; then
  echo "Could not read instance id from environment"
  exit 1
else
  INSTANCE="${INSTANCE_ID}"
fi

URL_OF_INSTANCE=$(findInstanceUrl $1 ${INSTANCE_ID})
URL_OF_VM=$(findVirtualMachineUrl $1 ${INSTANCE_ID})

deleteInstance $1 ${URL_OF_INSTANCE}
deleteVM $1 ${URL_OF_VM}



