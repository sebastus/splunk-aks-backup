#! /bin/bash

if [ -n "$AKS_RG" ] && [ -n "$AKS_NAME" ]; then 
    echo "AKS locators are set"
else 
    echo "AKS locators are unset"
    exit 1
fi

if [ -n "$AZURE_TENANT_ID" ] && [ -n "$AZURE_APP_ID" ] && [ -n "$AZURE_APP_KEY" ]; then 
    echo "AAD creds are set"
else 
    echo "AAD creds are unset"
    exit 1
fi

azlogin --service-principal --tenant $AZURE_TENANT_ID -u $AZURE_APP_ID -p $AZURE_APP_KEY
az aks get-credentials -g $AKS_RG -n $AKS_NAME
