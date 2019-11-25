
# Serverless AKS Scaling Guidance 

# Scaling 


Resources Management inside the cluster 

Example : 

```yaml
resources:
  requests:
     cpu: 250m
  limits:
     cpu: 500m

 ```


Using the following rule to define the scaling threshold  : 

    kubectl autoscale deployment melon-sampleapp --cpu-percent=50 --min=3 --max=10


Ref : through HPA 

https://docs.microsoft.com/en-gb/azure/aks/tutorial-kubernetes-scale#autoscale-pods

Using the following to check the hpa:

    kubectl get hpa


Just in case if a custom metrics needed : 

https://docs.bitnami.com/kubernetes/how-to/configure-autoscaling-custom-metrics/


Everything about scaling : 

https://docs.microsoft.com/en-gb/azure/aks/concepts-scale#burst-to-azure-container-instances