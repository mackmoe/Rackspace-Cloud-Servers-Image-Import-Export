#!/bin/bash
echo "Please bear in mind that the containers for import/export must already exist in the source and destination regions in order for this script to run successfully"
echo ""
sleep 5
###### This section asks for the $vars
echo "Enter your mycloud username:";read USERNAME;
echo "Enter mycloud account number:";read CUSTOMERID;
echo "Enter your mycloud user APIKey:";read APIKEY;
echo "Enter the image UUID that you want to export:";read IMAGEID;
echo "Enter the region where the image resides:[dfw,ord,iad,lon,syd,hkg]";read EXP_DC;
echo "Enter the name of the exsisting container you're exporting to:";read EXP_CONTAINER;
echo "Enter the name of the exsisting container you're importing to:";read IMP_CONTAINER;
echo "Enter the name of what you'd like to call the imported image:";read IMAGENAME;

####### Basic Authentication This section simply retrieves the TOKEN 
TOKEN=`curl -s https://identity.api.rackspacecloud.com/v2.0/tokens -X POST \
-d '{ "auth":{"RAX-KSKEY:apiKeyCredentials": { "username":"'$USERNAME'", "apiKey": "'$APIKEY'" }} }' \
-H "Content-type: application/json" |  python -mjson.tool | grep -A5 token | grep id | cut -d '"' -f4`
 
####### This section requests the Glance API to copy the cloud server image uuid to a cloud files container and stores the task id
EXP_TASKID=`curl -s "https://$EXP_DC.images.api.rackspacecloud.com/v2/$CUSTOMERID/tasks" -X POST \
-d '{"type": "export", "input": {"image_uuid": "'"$IMAGEID"'", "receiving_swift_container": "'$EXP_CONTAINER'"}}' \
-H "X-Auth-Token: $TOKEN" -H "Content-Type: application/json" | python -mjson.tool | grep [i]d | grep -v "$IMAGEID"  | cut -d '"' -f4`

####### This section is a function get's the export status
getEXPprogress() {
  EXP_POLL=$(curl -s https://$EXP_DC.images.api.rackspacecloud.com/v2/$CUSTOMERID/tasks/$EXP_TASKID -X GET -H "X-Auth-Token: $TOKEN" -H "Content-Type: application/json")
  EXP_STATUS=$(echo $EXP_POLL | python -m json.tool | grep '"status": ' | sed -e 's/ //g' -e 's/"//g' -e 's/,//g' | cut -d: -f2)
}
getEXPprogress
while [[ $EXP_STATUS != "success" ]]; do
  echo "Image export is: $EXP_STATUS"
  getEXPprogress
  sleep 60
done

####### This section calls the Cloud Files API, asks for the vhd file and places it into a variable
CF_EP=$(curl -s https://identity.api.rackspacecloud.com/v2.0/tokens -X POST -d '{ "auth":{"RAX-KSKEY:apiKeyCredentials": { "username":"'$USERNAME'", "apiKey": "'$APIKEY'" }} }' -H "Content-type: application/json" | python -mjson.tool | sed -n '/object-store:default/{n;p;}' | sed -e 's/^.*"id": "\(.*\)",/\1/' | cut -d '"' -f4)
IMG_VHD=$(curl -s https://storage101.$EXP_DC.clouddrive.com/v1/$CF_EP/$EXP_CONTAINER -H "X-Auth-Token: $TOKEN")

####### This section requests the Glance API to import the cloud server image to the specified container and stores the task id
IMP_TASKID=`curl -s "https://$EXP_DC.images.api.rackspacecloud.com/v2/$CUSTOMERID/tasks" -X POST \
-d '{"type": "import", "input": {"image_properties": "'"$IMAGENAME"'", "import_from": "'$IMG_VHD'"}}' \
-H "X-Auth-Token: $TOKEN" -H "Content-Type: application/json" | python -mjson.tool | grep [i]d | grep -v "$IMAGEID"  | cut -d '"' -f4`

####### This section is a function get's the import status - then  reports back once it's complete
getIMPprogress() {
  IMP_POLL=$(curl https://$EXP_DC.images.api.rackspacecloud.com/v2/$CUSTOMERID/tasks/$IMP_TASKID -X GET \
  -H "X-Auth-Token: $TOKEN" \
  -H "Content-Type: application/json")
  IMP_STATUS=$(echo $IMP_POLL | python -m json.tool | grep '"status": ' | sed -e 's/ //g' -e 's/"//g' -e 's/,//g' | cut -d: -f2)
}
getIMPprogress
while [[ $IMP_STATUS != "success" ]]; do
  echo "Image export is: $IMP_STATUS"
  getIMPprogress
  sleep 60
  echo "Image import complete! The image can now be used to build a server in the new region.";
done
