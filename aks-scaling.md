
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


Using the following rule to define the scaling threshold ( set up HPA very easily ) : 

    kubectl autoscale deployment melon-sampleapp --cpu-percent=50 --min=3 --max=10

Or using yaml definition : 

```yaml
apiVersion: autoscaling/v1
kind: HorizontalPodAutoscaler
metadata:
  name: melon-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: melon-deploy
  minReplicas: 4
  maxReplicas: 10
  targetCPUUtilizationPercentage: 50

 ```
Then you can use the following command to deploy hpa to AKS : 

    kubectl apply -f captureorder-hpa.yaml

Ref : through HPA ( https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/#create-horizontal-pod-autoscaler )

https://docs.microsoft.com/en-gb/azure/aks/tutorial-kubernetes-scale#autoscale-pods

Using the following to check the hpa:

    kubectl get hpa


Just in case if a custom metrics needed : 

https://docs.bitnami.com/kubernetes/how-to/configure-autoscaling-custom-metrics/


Everything about scaling : 

https://docs.microsoft.com/en-gb/azure/aks/concepts-scale#burst-to-azure-container-instances