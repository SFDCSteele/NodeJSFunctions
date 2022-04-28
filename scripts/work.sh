#!/bin/bash

export devhub="NodeJSDevHub"
export scratchOrg="WSteeleNodeJS"
export DevHubUsername="wsteele@salesforce.com.functionsworkshop2"
export scratchOrgUserName="test-qluy4umhvpb5@example.com"
dirs=( "activedirectory" "corefunctionality" "userprovisioning" )
echo "==========================================================================="
echo "Performing work.....$1 - Scratch Org: $scratchOrg"
echo "==========================================================================="


sf env list

echo "1-Performing $1..."
if [ "$1" = "auth" ]
then
    sf login -d -a $devhub
    sf login functions
    sfdx auth:web:login -d -a $devhub
    echo "Once DevHub is authorized, hit return to continue..."
    read inpt
elif [ "$1" = "scratch" ]
then
    sfdx force:org:create -s -f config/project-scratch-def.json -a $scratchOrg
    # username=$username
    sfdx force:org:list
    #sfdx force:org:create -s -f config/project-scratch-def.json -a $dxOrg --durationdays 30
    sfdx force:user:password:generate
    echo "Enter new username: "
    read dxUser
elif [ "$1" = "DEMO" ]
then
    source ./scripts/deployMDAPI.sh $2
fi
