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


deleteVM() {
  VM_URL="$1/api/virtualMachine/$2"
  echo "Deleting VM with id $2"
  TOKEN=$(authenticate $1)
  curl -v -X DELETE ${VM_URL} -H "Accept: application/json" -H "Content-Type: application/json" -H "X-Auth-Token: ${TOKEN}" -H "X-Auth-UserId: ${USER_ID}" -H "X-Tenant: ${TENANT}"
}

deleteInstance() {
  INSTANCE_URL="$1/api/instance/$2"
  echo "Deleting instance with id $2"
  TOKEN=$(authenticate $1)
  curl -v -X DELETE ${INSTANCE_URL} -H "Accept: application/json" -H "Content-Type: application/json" -H "X-Auth-Token: ${TOKEN}" -H "X-Auth-UserId: ${USER_ID}" -H "X-Tenant: ${TENANT}"
}

# Read environment variables to get instance and vm id
# visitor.visit("VM_ID", hostContext.getVMIdentifier());
# visitor.visit("INSTANCE_ID", myId.toString());

if [[ -z "$1" ]]; then
  echo "Expected colosseum url as parameter."
  exit 1
fi

if [[ -z "${VM_ID}" ]]; then
  echo "Could not read virtual machine id from environment"
  exit 1
else
  VM="${VM_ID}"
fi

if [[ -z "${INSTANCE_ID}" ]]; then
  echo "Could not read instance id from environment"
  exit 1
else
  INSTANCE="${INSTANCE_ID}"
fi

deleteInstance $1 ${INSTANCE}
deleteVM $1 ${VM}



