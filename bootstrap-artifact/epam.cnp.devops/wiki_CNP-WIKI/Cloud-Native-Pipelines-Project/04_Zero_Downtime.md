[[_TOC_]]

# Problem overview

Despite optimizations made to work processes, the development team's productivity exceeds the ability to implement changes in the working environment. Upon analysis, several factors contribute to the delay in delivering changes, including following:

* The current delivery process involves lengthy planning to update the working environment with all customers, resulting in an extended approval period that poses a challenge to product delivery.
* Special attention is required to the functionality, which was added during updates, as it sometimes might require rework or rollback to previous versions, which in its order, negatively impacts the company's credibility and customer loyalty, as it affects all customers and leads to additional downtime.
* All customers experience downtime during software upgrades simultaneously, leading to dissatisfaction with the process.

TrackX product team trying to optimize the software delivery process, with the aim of improving the following DORA metrics:

* Deployment Frequency: This metric measures the number of successful software releases to production within a given period.
* Lead Time for Changes: This metric refers to the time taken from committing the code to deploying it into production.
* Change Failure Rate: This metric assesses the frequency of failures after deploying the code or hotfixes.

The product team came up with the idea to improve the delivery process to be performed without interrupting the work of the users, the program must be updated only on part of the clients and only after checking whether it works on a part of the clients, perform it on all of the remaining clients or rollback the changes.

<span>&#9888;</span> Keep in mind, that the term "Zero Downtime deployment" usually refer to service availability during planned update, but it doesn't take into consideration the availability of all application transactions. That is mean, that during planned update service always ready to receive new connections, but interruptions with the old ones could happen.

# Consideration Points

* The infrastructure is built on the Azure Kubernetes Cluster.
* Containers handle critical transaction data.

# Requirements

* Ensure the protection of customers' data during and after the deployment of a new application version to production.
* Users should be able to use the service seamlessly before, during, and after the rollout of a new version of the application to production.
* The software delivery process should support multiple releases per day.
* The deployment strategy should incorporate the use of Canary releases to minimize the impact of changes on the production environment.

![canary_deployment.PNG](/.attachments/canary_deployment-66a6722d-5b1e-4cb3-afe8-8e0eed717567.PNG)

# Implementation Details

Information about implementation of Canary release you can find in this article: [Canary_implementation_approach](/Cloud-Native-Pipelines-Project/04_Zero_Downtime/Canary_implementation_approach).

# Useful Materials

- Deployment strategies to achieve - [zero downtime](/Supporting-Materials/Deployment-Strategies-With-Zero-Downtime).