#!/bin/bash

export devhub="JavaDevHub"
export scratchOrg="WSteeleJava"
export DevHubURL="http://functionworkshopcom.my.salesforce.com"
export DevHubUsername="wsteele@salesforce.com.functionsworkshop3"
export scratchOrgUserName="test-qluy4umhvpb5@example.com"
export sandboxURL="http://functionworkshopcom--f3wsteele.my.salesforce.com"
export sandboxUsername="wsteele@salesforce.com.functionsworkshop3.F3wsteele"
export sandboxAlias="F3wsteele"
export sandboxCompute="F3wsteeleCompute"
export functionOne="f3wsteelefunction"
export gitRepo="git@github.com:SFDCSteele/NodeJSFunctions.git"
export gitBranch="JavaFunction"

dirs=( "activedirectory" "corefunctionality" "userprovisioning" )
clear
echo "==========================================================================="
echo "Performing work.....$1 - Scratch Org: $scratchOrg"
echo "==========================================================================="


sf env list
sfdx force:org:list

echo "1-Performing $1..."
if [ "$1" = "auth" ]
then
    echo "logging into devHub...$devhub with URL: $DevHubURL user $DevHubUsername"
    sf login -d -a $devhub
    echo "logging into functions...$devhub with URL: $DevHubURL user $DevHubUsername"
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
    #sfdx force:source:push -f -u $sandboxAlias
    sf deploy functions -o $sandboxAlias
elif [ "$1" = "runFunc1" ]
then
    echo "Attempting to Execute to $functionOne.."
    ls -al functions/$functionOne
    sf run function start
    sf run function -l http://localhost:8080 -p "@functions/$functionOne/payload.json"
elif [ "$1" = "gitininit" ]
then
    echo "Attempting to initialize git..$gitRepo"
    git add remote -v $gitRepo
    git fetch --all
    git checkout $gitBranch
    git status
elif [ "$1" = "gitin" ]
then
    echo "Attempting to push to git..$gitBranch"
    git status
    git add .
    git commit -m "$2"
    git push origin $gitBranch
elif [ "$1" = "DEMO" ]
then
    source ./scripts/deployMDAPI.sh $2
fi
