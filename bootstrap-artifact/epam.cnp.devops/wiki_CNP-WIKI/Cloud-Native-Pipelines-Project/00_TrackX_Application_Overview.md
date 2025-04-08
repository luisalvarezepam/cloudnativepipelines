[[_TOC_]]

# Application Overview

Current setup of the TrackX Application solution represents a basic reference model for infrastructure management and application CI/CD processes in case of using Azure Kubernetes Services (AKS) in combination with Azure Cosmos DB.

It relies on Azure DevOps services as an orchestrator for CI/CD and infrastructure deployment and configuration. Terraform used as IaC tool. Application and infrastructure components inside AKS cluster are managed by Helm. It allows us to control full application and infrastructure life cycle starting from creation phase, its' update and deletion phases.

Initially, the  TrackX Application solution based on the [Cloud Native Pipelines](/EPAM-Cloud-Native-Pipelines-Accelerator) (CNP) accelerator and .Net application CI/CD [demonstration concept](/EPAM-Cloud-Native-Pipelines-Accelerator/Demonstration-concepts/#{project_name}#.app.v1) specifically that enable us to speed up delivery process establishment from a DevOps perspective.

The key features such as pipelines design, dynamic components' configuration, its' naming conventions, policies, IaC development approach are actively used in current implementation.

# Architecture

Initial architecture based on [Microservices architecture on Azure Kubernetes Service](https://learn.microsoft.com/en-us/azure/architecture/reference-architectures/containers/aks-microservices/aks-microservices) but the key difference is - how we use IaC approach. Azure Cloud infrastructure components managed by Terraform and uses Azure Landing Zone concepts.

Here is a diagram that shows the solution architecture:

![CNP_AKS.jpg](/.attachments/CNP_AKS-ddd78aae-8a6f-4927-bd0b-bfbc5b370bd1.jpg)

## Infrastructure components

The whole solution is divided into two independent parts - development and production environments. Each environment consist of next Azure Cloud components:

- Azure Kubernetes Service (AKS) - AKS is an Azure service that deploys a managed Kubernetes cluster. AKS is responsible for deploying the Kubernetes cluster and managing the Kubernetes API server. You only manage the agent nodes.

- Azure virtual network - By default, AKS creates a virtual network to deploy the agent nodes. For more advanced scenarios, you can create the virtual network first, which lets you control how the subnets are configured, on-premises connectivity, and IP addressing.

- Ingress - Ingress exposes HTTP and HTTPS routes from outside the cluster to services within the cluster. Traffic routing is controlled by rules defined on the Ingress resource. "Ingress NGINX Controller" used in current implementation, but it could be [any](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/).

- Azure Load Balancer - An Azure Load Balancer is created when the "Ingress NGINX Controller" is deployed. The load balancer routes internet traffic to the ingress.

- External data stores - Microservices are typically stateless and write state to external data stores, such as Azure SQL Database or Cosmos DB. In current case Azure Cosmos DB stores application data.

- Private endpoint - provide a privately accessible IP address for the specific resource (Azure Cosmos DB).

- Azure Container Registry - Azure Container Registry (ACR) used to store Docker images and make it possible to deploy them to the kubernetes cluster. AKS can authenticate with ACR using its Azure AD identity. Note that AKS does not require ACR. You can use other container registries, such as Docker Hub.

- Azure Monitor - Azure Monitor collects and stores metrics and logs, including platform metrics for the Azure services in the solution and application telemetry. Use this data to monitor the application, set up alerts and dashboards, and perform root cause analysis of failures. Moreover, Azure Monitor integrates with AKS to collect metrics from controllers, nodes, and containers, as well as container and node logs.

- Azure Log Analytics - used for analyze and alerts in case of infrastructure and application disasters. Also used by container insights to monitor the performance of Kubernetes instances. 

- Application Insights - uses for application performance monitoring and availability test specifically.

- Resource groups - uses to logically split Azure Cloud resources for an Azure solution.

# Infrastructure Delivery Model

Azure Cloud infrastructure components are deployed using Terraform IaC tool, on the basis of Azure Landing Zone IaC governance procedures. IaC templates organized in modular manner and could be easily modified and reused, even using different Terraform configuration files. Helm helps us to manage infrastructure components (such as nginx ingress controller or cert-manager) right inside Kubernetes cluster.

While Terraform and Helm are used to define the infrastructure IaC templates, Azure Pipelines service automates deployment, decommission and infrastructure updates.

## Terraform modules

Terraform module structure represented below:

**main.tf** - file contains Terraform code which call other Terraform modules.<br>
**variables.tf** - file contains declarations of input variables.<br>
**variables.tfvars** - file contains Terraform code variables configuration with its' own values.<br>
**output.tf** - file contains declarations of outputs.

There are the following Terraform modules are used to deploy all infrastructure components:  

- Base infrastructure [module: cnp_app_v1](https://dev.azure.com/#{org_name}#/#{project_name}#/_git/#{project_name}#?path=/iac/terraform/epam.alz.terraform/_solutions/cnp_app_v1);
- Application monitoring [module: 070_appmonitoring](https://dev.azure.com/#{org_name}#/_git/#{project_name}#?path=/iac/terraform/epam.alz.terraform/_modules/070_appmonitoring).

Even so, each Terraform module uses a number of different Terraform 'child' modules and additional functions.

## Helm charts

The following [Helm charts](https://dev.azure.com/#{org_name}#/_git/#{project_name}#?path=/containers/infrastructure/helm-charts/ingress-nginx) are used to deploy infrastructure components:  

- [Cert-manager](https://cert-manager.io/) - cloud native certificate management solution allows us to generate HTTPS TLS certificates.
- [Ingress NGINX Controller](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/) - ingress-nginx is an Ingress controller for Kubernetes using NGINX as a reverse proxy and load balancer.
- [cert-manager-config](https://dev.azure.com/#{org_name}#/_git/#{project_name}#?path=/containers/infrastructure/helm-charts/cert-manager-config) - used to properly configure Cert-manager solution.

## Infrastructure CI/CD Pipelines

- To make possible to store Terraform tfstate file in dedicated shared storage, we are using Azure storage account. It deploys as an initial deployment step with help of ARM templates. Resources could be created and deleted with help of dedicated pipeline.
- To deploy Azure Cloud resources with help of Terraform utility, a separate YAML template file exists. Pipeline supports the full resources' life cycle.
- To deploy infrastructure Kubernetes resources, the separate YAML template file also exists. It supports shared and environment specific resources' creation options.

| Pipeline | Class |  Triggers | Description |
|--|--|--|--|
| 00-infra-prerequisites-cd | Infrastructure | none | Initial pipeline used to deploy resource group and Azure storage account to store Terraform tfstate files. [ARM templates](https://dev.azure.com/#{org_name}#/#{project_name}#.app.v1/_git/epam.cnp.todoapp?path=/pipelines/_configuration/_prerequsites) and environment variable groups used to configure initial components. |
| 01-infra-cd | Infrastructure | none | The pipeline used to deploy Azure Cloud infrastructure components. Terraform .tfvars configuration [files](https://dev.azure.com/#{org_name}#/#{project_name}#.app.v1/_git/epam.cnp.todoapp?path=/pipelines/_configuration) and environment variable groups used to configure infrastructure components. |
| 02-infra-k8s-environment-cd | Infrastructure | none | The pipeline used to deploy Kubernetes environment components (like ingress controllers and cert-manager). Configuration is done mainly through Helm chart value files configuration (in the core DevOps project) and variables in variable groups.|
| 04-infra-appmonitoring-cd | Infrastructure | none | The pipeline used to deploy application monitoring components. Terraform .tfvars configuration [files](https://dev.azure.com/#{org_name}#/#{project_name}#.app.v1/_git/epam.cnp.todoapp?path=/pipelines/_configuration) and environment variable groups used to configure infrastructure components. |

The diagram below shows the pipelines and their stages with main infrastructure deployment tools:

![CNP_AKS.jpg](/.attachments/CICD_Infrastructure.png)

[CICD_Infrastructure.xml](/.attachments/CICD_Infrastructure.xml)

# Application Delivery Model

Application Software Delivery Model is based on Gitflow model, which uses "classic" three tier environment DEV (Development environment); QA (Quality Assurance environment); PROD (Production environment). In case using Kubernetes cluster as a resource that holds out application, each software development environment exists as a Kubernetes namespace. In high-level:

- At the CI stage an application is building, after that docker image is prepared to deploy an app into DEV and QA environments one by one. 
- It is possible to deploy an application to DEV environment only from _develop_ git branch.
- PROD deployment is possible only by cutting off _develop_ branch on _release/_ Git branch.

The diagram below shows the CI/CD based on Git flow Development:

![development-worflows-diagrams-GitFlow.png](/.attachments/development-worflows-diagrams-GitFlow.png)  

[development-worflows-diagrams.drawio.xml](/.attachments/development-worflows-diagrams.drawio.xml)

## Development Stage

The `develop` branch is basic for application development. The `develop` branch  is maintained throughout the development process, and contains pre-production code with newly developed features that are in the process of being tested. Newly-created features should be based off the develop branch, and then merged back in when ready for testing.

The following tests are executed during the <u>development stage</u>:

* **[DEV and QA]:** Deployment verification tests
* **[DEV]:** Integration tests
* **[QA]:** Low-priority risk-based tests
* **[QA]:** Exploratory testing
* **[QA]:** High-priority risk-based tests

![Tests-envs-DEV.png](/.attachments/Tests-envs-DEV.png)

[Tests-envs-DEV.xml](/.attachments/Tests-envs-DEV.xml)

Branch policy for `develop`:  

* Pull Request flow is mandatory
* minimum 1 reviewer
* linked appropriate work item is required
* comment resolution check is mandatory
* build validation is mandatory

### Feature Flow

The feature development starts with cutting off a `feature/*` branch from the `develop` branch. When feature development is done and recent code is pushed to `feature/*` branch, automatic build is triggered to complete unit tests execution, image build verification. Pull request conditions are met and changes can be merged to the `develop` branch. 

## Release Stage

Cutting off a `release` branch from the `develop` branch triggers a build and running tests in the QA environment. After getting positive Release-verification it can be deployed to the PROD environment.  

The following tests are executed during the <u>release stage<u>:

* **[QA and PROD]:** Deployment verification tests
* **[QA]:** Low-priority risk-based tests
* **[QA]:** Exploratory testing
* **[QA]:** Non-functional testing

![Tests-envs-release.png](/.attachments/Tests-envs-release.png)

[Tests-envs-release.xml](/.attachments/Tests-envs-release.xml)
Branch policy for `release/`
 branches:

* Pull Request flow is mandatory
* minimum 1 reviewer
* linked appropriate work item is required
* comment resolution check is mandatory
* build validation is mandatory

### Bugfix flow

If some bugs were found during *Release confirmation*, the work starts over from `develop` branch again to fix the bug.

## Main Branch

`Main` branch contains stable code of recently released application. After sucessfull deployment on PROD environment, `release/` branch must be merged to `main`. 

### Hotfix flow

In Gitflow, the `hotfix` branch is used to quickly address necessary changes in the `Main` branch.

The base of the hotfix branch should be `main` branch and should be merged back into both the `release` and `develop` branches. Merging the changes from your `hotfix` branch back into the `develop` branch is critical to ensure the fix persists the next time the `main` branch is released.

# Current application deployment approach

Application deployment is done by Helm, because it is easier to manage the instance that consist of multiple Kubernetes manifests. Also, Helm allow us to use additional tool logic, to make application package that is called Helm chart to be flexible and well reusable. A Kubernetes deployment enables us to use different deployment strategies. And the default Kubernetes deployment strategy is - [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy). This strategy is used by the current application update flow on the level of Kubernetes **Deployments**. The diagram below shows the deployment flow for the current implementation through the all AKS environments without taking into consideration release management flow:

![AKS_CosmosDB_APP_deployment_flow.png](/.attachments/AKS_CosmosDB_APP_deployment_flow.png)

[Diagrams.net XML source code for  AKS CosmosDB application deployment flow](/.attachments/AKS_CosmosDB_APP_deployment_flow.drawio.xml)

## Application CI/CD Pipelines

CI/CD YAML templates files could be found [here](https://dev.azure.com/#{org_name}#/#{project_name}#/_git/#{project_name}#?path=/pipelines/application). There are few "root" pipelines that allow us to manage the whole application CI/CD process, but the main application CI/CD pipeline called **app-v1-cicd**. Application variable groups used to configure application and environment components. **app-v1-cicd** pipeline supports rolling update deployment strategy for all Kubernetes environment deployments.