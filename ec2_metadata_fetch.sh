#!/bin/bash

# Check if the correct number of arguments is passed
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <profile_name> <region_name>"
    exit 1
fi

PROFILE=$1
REGION=$2


instance_ids=$(aws ec2 describe-instances --profile "$PROFILE" --region "$REGION" --query 'Reservations[*].Instances[*].InstanceId' --output text)

for instance_id in $instance_ids; do
    echo "Instance ID: $instance_id"

    aws ec2 describe-instance-attribute \
                --profile "$PROFILE" --region "$REGION" \
                --instance-id "$instance_id" \
                --attribute userData \
                --query 'UserData.Value' \
                --output text | base64 --decode 2>/dev/null > $instance_id

    a=$(file ${instance_id} | grep gzip)

    if [ $a'test' != 'test' ];
    then
        zcat ${instance_id} > ${instance_id}_zcat
        rm ${instance_id}
        cat ${instance_id}_zcat
    else
        cat ${instance_id}
    fi

    echo "--------------------------"
done