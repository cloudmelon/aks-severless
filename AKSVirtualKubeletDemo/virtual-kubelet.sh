#!/bin/bash

# check Azure providers 

az provider list --query "[?contains(namespace,'Microsoft.ContainerInstance')]" -o table


# potential use the following command : 
az provider register --namespace Microsoft.ContainerInstance

# Support regiosn : https://docs.microsoft.com/en-gb/azure/aks/virtual-nodes-cli#regional-availability

# limitations : https://docs.microsoft.com/en-gb/azure/aks/virtual-nodes-cli#known-limitations

# create RG
az group create --name melonvk-rg --location westeurope

# create VNET

az network vnet create \
    --resource-group melonvk-rg \
    --name vknet \
    --address-prefixes 10.0.0.0/8 \
    --subnet-name k8ssubnet \
    --subnet-prefix 10.240.0.0/16

# dedicated subnet for all virtual nodes 
az network vnet subnet create \
    --resource-group melonvk-rg \
    --vnet-name vknet \
    --name vksubnet \
    --address-prefixes 10.241.0.0/16


# Create SP for AKS

az ad sp create-for-rbac --skip-assignment

# Assign permissions to the virtual network

az network vnet show --resource-group melonvk-rg --name vknet --query id -o tsv

# The output will be something like the following : /subscriptions/{subscription-id}/resourceGroups/melonvk-rg/providers/Microsoft.Network/virtualNetworks/vknet
# To grant the correct access for the AKS cluster to use the virtual network, create a role assignment using the az role assignment create command. 
az role assignment create --assignee <appId> --scope <vnetId> --role Contributor


#Deploy AKS to dedicated AKS Subnet
az network vnet subnet show --resource-group melonvk-rg --vnet-name vknet --name k8ssubnet --query id -o tsv

# Create AKS 

az aks create \
    --resource-group melonvk-rg \
    --name vkaks \
    --node-count 1 \
    --network-plugin azure \
    --service-cidr 10.0.0.0/16 \
    --dns-service-ip 10.0.0.10 \
    --docker-bridge-address 172.17.0.1/16 \
    --vnet-subnet-id /subscriptions/9b1b3746-eb27-417d-804c-a00646520a34/resourceGroups/melonvk-rg/providers/Microsoft.Network/virtualNetworks/vknet/subnets/k8ssubnet \
    --service-principal <appId> \
    --client-secret <password>


# After creating AKS you can enable the add-on

az aks enable-addons \
    --resource-group melonvk-rg \
    --name vkaks \
    --addons virtual-node \
    --subnet-name vksubnet


# Then connect to the cluster 

az aks get-credentials --resource-group melonvk-rg --name vkaks

# Then you can use the following command to check nodes 

kubectl get nodes

# deploy sample app

k apply -f sample-app.yaml

# check pods 
kubectl get pods -o wide

# Very interesting testing method : 
kubectl run --generator=run-pod/v1 -it --rm testvk --image=debian

apt-get update && apt-get install -y curl

curl -L < IP of ACI >

# Know more about Ingress go to : https://docs.microsoft.com/en-gb/azure/aks/ingress-basic



