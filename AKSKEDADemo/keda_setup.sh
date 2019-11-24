#!/bin/bash

# init your functions using the following choose the language of your choice
func init . --docker

# using  Azure Queue Storage Trigger
func new


az group create -l westeurope -n aks-keda

az storage account create --sku Standard_LRS --location westeurope -g aks-keda -n kedasa

CONNECTION_STRING=$(az storage account show-connection-string --name kedasa --query connectionString)

az storage queue create -n keda-queue --connection-string $CONNECTION_STRING


# Then using the following to get current security context :
az aks get-credentials --resource-group melonvk-rg --name vkaks

# By default, Core Tools installs both KEDA and Osiris components, which support event-driven and HTTP scaling, respectively. The installation uses kubectl running in the current context. 
# Install KEDA in your cluster by running the following install command:
func kubernetes install --namespace keda


# You can use the following command to test results ( test CRD  : https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/): 

kubectl get customresourcedefinition

# or the following command :
kubectl get crd


# deploy your functions to ACR 
az acr create --resource-group aks-keda --name melonkedaacr --sku Standard

az acr login --name melonkedaacr

az aks update -g melonvk-rg -n vkaks --attach-acr melonkedaacr

# Let us do a dry run 
func kubernetes deploy --name melonkedaaf --registry melonkedaacr --javascript --dry-run > deploy.yaml

func kubernetes deploy --name melonkedaaf --registry melonkedaacr.azurecr.io --pull-secret regcred

# Ref to : https://docs.microsoft.com/en-us/azure/azure-functions/functions-kubernetes-keda
# https://github.com/kedacore/sample-hello-world-azure-functions