#!/bin/bash
set -e

CLUSTER_NAME="my-eks-cluster"
REGION="us-east-1"
NAMESPACE="default"
INGRESS_NAME="shared-ingress"
MAX_RETRIES=10
SLEEP_SECONDS=30

#Update kubeconfig
aws eks --region $REGION update-kubeconfig --name $CLUSTER_NAME 

#Wait for the Load Balancer DNS name to be available
for i in $(seq 1 $MAX_RETRIES); do 
LB_DNS=$(kubectl get ingress -n $NAMESPACE $INGRESS_NAME -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
if [[ ! -z "$LB_DNS" ]]; then
echo "{\"lb_dns\": \"$LB_DNS\"}"
exit 0
else
echo "Load Balancer DNS not available yet. Retry $i/$MAX_RETRIES...">&2
sleep $SLEEP_SECONDS
fi
done

echo "Failed to retrieve Load Balancer DNS name after $MAX_RETRIES attempts." &>2
exit 1