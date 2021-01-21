#!/bin/bash
set -xe

if [ -z "$TF_VAR_environment" ] ;
then
    echo "environmentname is unset" ;
    exit 1;
fi

if [[ $TF_ACTION != "plan" ]];then
  TF_OPTIONS="--auto-approve"
fi

TERRAFORMVERSION=0.13.5

docker run \
    -v "$(pwd)"/:/workspace \
    -w /workspace \
    hashicorp/terraform:$TERRAFORMVERSION \
        init \
            -backend-config="key=${TF_VAR_environment}-platform.tfstate" \
            -backend-config="access_key=${STATE_BLOBACCESSKEY}" \
            -backend-config=storage_account_name="${TF_VAR_storage_account_name}"

docker run \
    -e ARM_SUBSCRIPTION_ID=$ARM_SUBSCRIPTION_ID \
    -e ARM_CLIENT_ID=$ARM_CLIENT_ID \
    -e ARM_CLIENT_SECRET=$ARM_CLIENT_SECRET \
    -e ARM_TENANT_ID=$ARM_TENANT_ID \
    -e STATE_BLOBACCESSKEY=$STATE_BLOBACCESSKEY \
    -e TF_VAR_environment=$TF_VAR_environment\
    -e TF_VAR_developergroup=$TF_VAR_developergroup\
    -e TF_VAR_spigroup=$TF_VAR_spigroup\
    -v "$(pwd)"/:/workspace \
    -w /workspace \
    hashicorp/terraform:$TERRAFORMVERSION \
        $TF_ACTION \
        $TF_OPTIONS