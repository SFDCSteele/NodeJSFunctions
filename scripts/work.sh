#!/bin/bash

export devhub="NodeJSDevHub"
export scratchOrg="WSteeleNodeJS"
export DevHubUsername="wsteele@salesforce.com.functionsworkshop2"
export scratchOrgUserName="test-qluy4umhvpb5@example.com"
export sandboxURL="https://functionsworkshop2com--f3wsteele.my.salesforce.com"
export sandboxUsername="wsteele@salesforce.com.functionsworkshop2.F3wsteele"
export sandboxAlias="F3wsteele"
export sandboxCompute="F3wsteeleCompute"
export functionOne="f3wsteelefunction"

dirs=( "activedirectory" "corefunctionality" "userprovisioning" )
echo "==========================================================================="
echo "Performing work.....$1 - Scratch Org: $scratchOrg"
echo "==========================================================================="


sf env list
sfdx force:org:list

echo "1-Performing $1..."
if [ "$1" = "auth" ]
then
    echo "logging into devHub..."
    sf login -d -a $devhub
    echo "logging into functions..."
    sf login functions
    sfdx auth:web:login -d -a $devhub
    echo "Once DevHub is authorized, hit return to continue..."
    read inpt
    echo "Authorizing sandbox $sandboxURL with user $sandboxUsername..."
    sfdx auth:web:login -r $sandboxURL -a $sandboxAlias
    echo "Once Sandbox is authorized, hit return to continue..."
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
elif [ "$1" = "compute" ]
then
    sf env create compute -o $sandboxAlias -a $sandboxCompute
elif [ "$1" = "function" ]
then
    echo "Attempting to create $functionOne.."
    sf generate function -n "$functionOne" -l javascript
elif [ "$1" = "depFunc1" ]
then
    echo "Attempting to Deploy to $sandboxAlias.."
    sfdx force:source:push -f -u $sandboxAlias
elif [ "$1" = "runFunc1" ]
then
    echo "Attempting to Execute to $functionOne.."
    ls -al functions/$functionOne
    sf run function start
    sf run function -l http://localhost:8080 -p "@functions/$functionOne/payload.json"
elif [ "$1" = "gitin" ]
then
    echo "Attempting to push to git.."
    git status
    git add .
    git commit -m "$2"
    git push origin master
elif [ "$1" = "DEMO" ]
then
    source ./scripts/deployMDAPI.sh $2
fi
