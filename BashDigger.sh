#!/bin/bash



if [ -z "$1" ]; then

  echo "Usage: $0 <aws_profile> [region]"

  exit 1

fi



PROFILE=$1

REGION=$2  # Optional region argument



ALL_REGIONS=("us-east-1" "us-east-2" "us-west-1" "us-west-2" "af-south-1" "ap-east-1"

             "ap-south-1" "ap-northeast-1" "ap-northeast-2" "ap-northeast-3" "ap-southeast-1"

             "ap-southeast-2" "ca-central-1" "eu-central-1" "eu-west-1" "eu-west-2"

             "eu-west-3" "eu-north-1" "eu-south-1" "me-south-1" "sa-east-1")



if [ -n "$REGION" ]; then

  REGIONS=("$REGION")

else

  REGIONS=("${ALL_REGIONS[@]}")

fi



echo "Fetching environment variables for all Lambda functions in the specified region(s) for profile: $PROFILE"



for CURRENT_REGION in "${REGIONS[@]}"; do

  echo -e "\nRegion: $CURRENT_REGION"

  

  FUNCTION_NAMES=$(aws lambda list-functions --region "$CURRENT_REGION" --profile "$PROFILE" --query "Functions[].FunctionName" --output text 2>/dev/null)



  if [ -z "$FUNCTION_NAMES" ]; then

    echo "No Lambda functions found in region $CURRENT_REGION."

    continue

  fi



  for FUNCTION_NAME in $FUNCTION_NAMES; do

    echo -e "\nLambda Function: $FUNCTION_NAME"

    

    ENV_VARS=$(aws lambda get-function-configuration --function-name "$FUNCTION_NAME" --region "$CURRENT_REGION" --profile "$PROFILE" --query "Environment.Variables" --output json)



    if [ "$ENV_VARS" != "null" ]; then

      echo "Environment Variables:"

      echo "$ENV_VARS" | jq .

    else

      echo "No environment variables set for this Lambda function."

    fi

  done

done

