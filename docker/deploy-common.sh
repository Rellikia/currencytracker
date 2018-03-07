#!/bin/bash
stopTask=${1}
uploadImage=${2}
getLogin=${3}

###############################################################################
# COLORS
###############################################################################
colorRed='\e[0;31m'
colorGreen='\e[0;32m'
colorOrange='\e[1;33m'
colorYellow='\e[0;33m'
colorBlue='\e[0;34m'
colorPurple='\e[0;35m'
noColor='\033[0m'

###############################################################################
# LOGGING IN
###############################################################################
login()
{
    aws ecr get-login --no-include-email --region us-east-2 | bash -e

    deploy
}


###############################################################################
# DEPLOYING
###############################################################################
deploy()
{
    echo -e "$colorBlue Ready to deploy $colorYellow$project$noColor? (Y/n)"
    read shouldDeploy

    if [ "$shouldDeploy" = "Y" ]; then

        echo -e "Deploying $colorYellow$project\n $noColor"
        echo -e "\xF0\x9F\x90\xB3 Build docker image...\n"
        docker build -t $containerName:latest -f $dockerfilePath --build-arg RAILS_ENV=$envApplication ../ &&


        if [ "$uploadImage" = "--upload-image" ]; then
            echo -e "\n\xF0\x9F\x9A\x80 Upload docker image...\n"
            docker tag $containerName:latest $containerRepository/$containerName:latest &&
            docker push $containerRepository/$containerName:latest
        else
            echo -e "\nSkipped docker image upload\n"
        fi
    fi

    if [ "$stopTask" = "--stop-tasks" ]; then
        stopTasks
    else
        echo -e "Skipped stop tasks\n"
    fi
}


###############################################################################
# STOPPING CURRENT TASKS
###############################################################################
stopTasks()
{
    echo -e "$colorBlue Stop the current tasks? (Y/n) $noColor"
    read shouldDeploy

    if [ "$shouldDeploy" = "Y" ];then
        aws ecs list-tasks --cluster $clusterName | \
        sed '/\([{}].*\|.*taskArns.*\| *]\)/d' | sed 's/ *"\([^"]*\).*/\1/' | \
        while read -r task; do aws ecs stop-task --cluster $clusterName --task $task; done
    fi

    echo -e "$colorGreen \xE2\x9C\x85 Done $noColor"
}


###############################################################################
# STARTING POINT
###############################################################################
# clear

if [ "${getLogin}" = "--login" ]; then
    echo -e "$colorBlue Are you sure you want to deploy on AWS? This cannot be undone. (Y/n) $noColor"
    read shouldDeploy

    if [ "$shouldDeploy" = "Y" ];then
        login
    else
        echo -e "$colorRed \xE2\x9D\x8E Not deployed"
    fi
else
    deploy
fi
