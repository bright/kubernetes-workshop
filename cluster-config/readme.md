# Cluster

```shell
eksctl create cluster --name workshop-cluster --region eu-central-1 --node-volume-size 20 --max-pods-per-node 50 --node-type t4g.medium
```

# AWS Load Balancer

https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html

```shell
eksctl utils associate-iam-oidc-provider --region=eu-central-1 --cluster=workshop-cluster --approve
```

```shell
aws iam create-policy \                                                                                        
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam_policy.json
```

```shell
eksctl create iamserviceaccount --cluster=workshop-cluster \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --role-name AmazonEKSLoadBalancerControllerRole \
  --attach-policy-arn=arn:aws:iam::284345365060:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve
```

```shell
helm repo add eks https://aws.github.io/eks-charts
```

```shell
helm repo update
```

```shell
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=workshop-cluster \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller
```

# External DNS

https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/aws-load-balancer-controller.md

```shell
aws iam create-policy --policy-name "AllowExternalDNSUpdates" --policy-document file://external-dns-policy.json
```

```shell
eksctl create iamserviceaccount \
  --cluster workshop-cluster \
  --name "external-dns" \
  --override-existing-serviceaccounts --namespace "default" \
  --attach-policy-arn arn:aws:iam::284345365060:policy/AllowExternalDNSUpdates \
  --approve
```


```shell
kubectl apply -f external-dns.yaml
```
