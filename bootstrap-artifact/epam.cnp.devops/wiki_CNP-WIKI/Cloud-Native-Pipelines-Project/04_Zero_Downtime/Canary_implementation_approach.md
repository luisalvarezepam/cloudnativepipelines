[[_TOC_]]
# Overview

There are a lot of methods how to implement canary deployment strategy in the specific environment, especially if we are speaking about Kubernetes. The wide variety of tools and technologies that are used in the containerized environment allow us to realize any deployment strategy in a flexible manner. 
By default, Kubernetes uses rolling update deployment strategy during POD update, and it is used for all Kubernetes environment deployments in current project. But canary deployment is not available out of the box. Therefore, we have to use additional instruments, such as Helm and Ingress NGINX Controller for Kubernetes. At the same time, Helm already used in deployment flow, while Ingress NGINX Controller implemented in current infrastructure.

# Canary deployment flow

Canary deployment should be done on the basis of Ingress NGINX Controller possibilities and `nginx.ingress.kubernetes.io/canary*` annotations specifically. It allows us to redirect requests to appropriate ingress resource. That is mean that we have to use at least two different ingress resource with equal path and, optionally, additional dedicated ingress object (direct) with different path that routes traffic right to the news version of application.

Using two or three ingress resource force us to use the same number of Kubernetes service resources, that will be route traffic to the both application versions (current and new).

Finally, we must have two different application versions. The diagram below shows the traffic flow to the current PODs and to the new PODs:

![AKS_CosmosDB_traffic_flow.png](/.attachments/AKS_CosmosDB_traffic_flow-72b58ad7-b687-471f-bc78-729727ebd446.png)

[Diagrams.net XML source code for AKS Canary deployment requests flow](/.attachments/AKS_CosmosDB_traffic_flow.xml)

# Canary deployment configuration

## NGINX Controller configuration

Ingress NGINX Controller uses the following annotations to enable canary deployments:
```
nginx.ingress.kubernetes.io/canary
nginx.ingress.kubernetes.io/canary-weight
nginx.ingress.kubernetes.io/canary-by-header
nginx.ingress.kubernetes.io/canary-by-header-value
nginx.ingress.kubernetes.io/canary-by-header-pattern
nginx.ingress.kubernetes.io/canary-by-cookie
```
For the purpose of balancing traffic on the basis of percentage, using `nginx.ingress.kubernetes.io/canary, nginx.ingress.kubernetes.io/canary-weight` more than enough. Ingress NGINX annotations must be configured right in application Helm chart, because ingress Kubernetes resource already managed by application Helm chart.

## Application configuration

Application deployment flow is fully managed by Helm and its' Helm chart. So, the configuration of additional Kubernetes service resources and PODs must be done through application Helm chart. If you are deploying PODs as PODs Kubernetes manifest - you must have two different PODs manifest as an output of Helm chart. If application POD managed by Kubernetes Deployment - you must have two Kubernetes Deployment manifest as an output of Helm chart and etc.. This could be done by changing the source application Helm chart, while adding new manifests and conditions, or by separate application Helm chart which support canary deployment flow. Helm chart components example:
```
apiVersion: apps/v1 
kind: Deployment 
metadata: 
  name: app-v1 
spec: 
  replicas: 1 
  selector: 
    matchLabels: 
      app: app 
      version: "1" 
  template: 
    metadata: 
      labels: 
        app: app 
        version: "1"
    spec: 
      containers: 
        - name: app-v1
          image: "nginx:1" 
          ports: 
            - containerPort: 80 
          volumeMounts: 
            - mountPath: /etc/nginx 
              name: nginx-config 
      volumes: 
        - name: nginx-config 
          configMap: 
            name: app-v1
--- 
apiVersion: v1 
kind: Service 
metadata: 
  name: app-svc 
  labels: 
    app: app 
spec: 
  ports: 
    - port: 80 
      targetPort: 80 
  selector: 
    app: app
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    ingress.kubernetes.io/rewrite-target: /
  name: app-current
spec:
  ingressClassName: nginx-default
  rules:
    - host: example.com
      http:
        paths:
          - path: /echo
            pathType: Prefix
            backend:
              service:
                name: app-svc
                port:
                  number: 80
---
apiVersion: apps/v1 
kind: Deployment 
metadata: 
  name: app-v2 
spec: 
  replicas: 1 
  selector: 
    matchLabels: 
      app: app-canary 
      version: "2" 
  template: 
    metadata: 
      labels: 
        app: app-canary
        version: "2"
    spec: 
      containers: 
        - name: app-v2 
          image: "nginx:2" 
          ports: 
            - containerPort: 80 
          volumeMounts: 
            - mountPath: /etc/nginx 
              name: nginx-config 
      volumes: 
        - name: nginx-config 
          configMap: 
            name: app-v2
--- 
apiVersion: v1 
kind: Service 
metadata: 
  name: app-svc-canary
  labels: 
    app: app-canary
spec: 
  ports: 
    - port: 80 
      targetPort: 80 
  selector: 
    app: app-canary
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/canary: "true"
    nginx.ingress.kubernetes.io/canary-weight: "20"
  name: app-canary
spec:
  ingressClassName: nginx-default
  rules:
    - host: example.com
      http:
        paths:
          - path: /echo
            pathType: Prefix
            backend:
              service:
                name: app-svc-canary
                port:
                  number: 80
```

## Pipeline configuration

Canary deployment flow is not a one time update action as it could be done for Blue/Green deployment flow. Canary deployment approach could be implemented at least with next active phases:
- deploy new application version and redirect part of users to the new application version;
- swap 100% traffic to the new application version;
- mark new application version as current, changing the code for the current version and removing additional replicas for the new application version.

Considering that - Azure DevOps CD pipeline also must support canary deployment flow, at least 3 stages with approval procedure insight based on Azure DevOps environments and just only for production deployment.

The diagram below shows the flow for canary deployment into the PROD environment:

![AKS_CosmosDB_Canary_deployment.png](/.attachments/AKS_CosmosDB_Canary_deployment.png)

[Diagrams.net XML source code for  AKS CosmosDB Canary deployment](/.attachments/AKS_CosmosDB_Canary_deployment.xml)


# Zero downtime concerns

Zero downtime deployment is a great way how to deploy application without service interruptions. It allows us to update the application without any service downtime that would otherwise impact your users’ experience and thus your revenue. And if we dive deep into the problem it means that in every moment during planned update your service is ready to process users’ request, but doesn't guarantee that users’ session will not be interrupted while old application replica will be terminated and swapped right to the new one. Honestly speaking, Kubernetes default deployment strategy rolling update also support such process out of the box.

To avoid users’ session termination before all transactions will be resolved, we may look into the problem from POD lifecycle perspective. There are few container states exist, and one of them is `Terminated` state. This is the last state before POD deletion. So we can use `preStop` hook, that runs before the container enters the Terminated state. It must contain some executable script that simply check what we want and exit with code 0 when it needs for us. This approach enable us to allow Kubernetes service to delete completely the POD only when we need it. For example, we can create the script that simply check the number of active HTTP session right inside the POD and do not exit while the count is not equal to zero. Kubernetes manifests example:
```
## Kubernetes Deployment manifest example:

apiVersion: apps/v1
kind: Deployment
....
          lifecycle:
            preStop:
              exec:
                command: ["/script.sh"]
...
## lifecycle script script.sh example:

#!/bin/bash
get_connections() {
    wget $WGET_OPTS -qO- http://localhost:123
}
con_number=$(get_connections)
until [[ $con_number -eq 1 ]]; do
    sleep 1m
    echo "$HOSTNAME still handles $(( con_number - 1 )) connection(s)..." >>$OUTPUT
    con_number=$(get_connections)
done
echo "All active connections were closed. Exiting $HOSTNAME" >>$OUTPUT
```
Considering this - configuring additional application status check will be very useful, and in some cases, necessary to use. So, it is optional to add additional `preStop` script before an application POD deletion.