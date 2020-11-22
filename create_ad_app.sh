#!/bin/bash

set -e

if ! command -v jq &> /dev/null
then
    echo "jq could not be found. Please install it: https://stedolan.github.io/jq/download/"
    exit
fi

if ! command -v az &> /dev/null
then
    echo "Azure CLI could not be found. Please install it: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
    exit
fi


# neurocode.io
az account set -s e9a0397c-9b68-49ea-ae88-dcbd2f08e73e

az ad app create \
  --display-name jupyter-notebook-ad-login \
  --native-app \
  --required-resource-accesses @manifest.json \
  --reply-urls http://localhost:8080

# Azure AD is eventual consitent ;)
sleep 5


appId=$(az ad app list --filter "displayname eq 'jupyter-notebook-ad-login'" | jq -r '.[0].appId')

az ad app credential reset --id $appId -p $azureAdAppPassword --years 1