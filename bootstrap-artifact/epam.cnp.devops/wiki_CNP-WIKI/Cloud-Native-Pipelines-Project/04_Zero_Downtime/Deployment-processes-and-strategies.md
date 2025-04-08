[[_TOC_]]

# Basic CD process

The CI/CD process is a key practice in DevOps, a software development methodology that emphasizes collaboration and communication between development and operations teams. In our session, we will focus on the CD part.

Deployment is a crucial step in the software development process because it involves the actual delivery of software changes to end-users or customers. Continuous deployment is a strategy or methodology for software releases where any new code update or change made through the rigorous automated test process is deployed directly into the live production environment, where it will be visible to customers.

The main goals of the continuous deployment process are:

- **Validation:** Deployment provides an opportunity to validate the changes made to the software;
- **Feedback:** Deployment provides valuable feedback from end-users or customers;
- **Faster Time-to-Market:** Deployment enables faster time-to-market;
- **Continual Improvement:** Deployment facilitates continual improvement by enabling developers to make changes and updates to the software;
- **Risk Mitigation:** Deployment helps to mitigate risks associated with software changes.

It is very important to highlight the difference between the processes of **Continuous deployment** and **Continuous delivery**:
 - **Continuous Delivery** ensures that the software is always ready for deployment, while **Continuous Deployment** automates the entire release process and deploys changes automatically without any human intervention.

![Continuous_Deploiment](/.attachments/Mentors_coaching_Stage_4_CD.png)

# Deployment strategies

Deployment is a critical part of the software development process, as it involves releasing a new or updated application into the production environment where it can be accessed by users. One way to ensure that deployment is a seamless part of the development process is to use CI/CD practices.  With CI/CD, developers commit code changes to a shared repository, where automated tests are run and the application is built and deployed automatically to a testing environment. If the tests pass, the application is then automatically deployed to the production environment.

**Deployment strategy** refers to the process of releasing software updates or new features to users in a controlled and systematic way. It involves a set of steps and procedures that ensure that the new version of the software is installed correctly and works as intended.

There are several deployment strategies such as:

  - **Recreate:** The recreate strategy is a dummy deployment which consists of shutting down version A then deploying version B after version A is turned off. This technique implies downtime of the service that depends on both shutdown and boot duration of the application.

  - **Rolling deployment:** This involves gradually releasing the new version to small subsets of users or servers, while continuously monitoring the system for any issues. If a problem is detected, the deployment can be paused, rolled back, or fixed before continuing with the deployment.

  - **Blue-green deployment:** This involves maintaining two identical environments, one being the current production environment and the other being the new environment. The new environment is tested thoroughly before switching the traffic to it, and the old environment is maintained as a backup.

  - **Canary deployment:** In this strategy, a small percentage of users are exposed to the new version while the rest are still using the old version. This approach helps to identify any issues early on and reduces the impact of a potential failure.

  - **A\B testing:** A/B testing deployments consists of routing a subset of users to a new functionality under specific conditions. It is usually a technique for making business decisions based on statistics, rather than a deployment strategy. However, it is related and can be implemented by adding extra functionality to a canary deployment so we will briefly discuss it here.

  - **Shadow:** A shadow deployment consists of releasing version B alongside version A, fork version A’s incoming requests and send them to version B as well without impacting production traffic. This is particularly useful to test production load on a new feature. A rollout of the application is triggered when stability and performance meet the requirements.
This technique is fairly complex to setup and needs special requirements, especially with egress traffic. For example, given a shopping cart platform, if you want to shadow test the payment service you can end-up having customers paying twice for their order. In this case, you can solve it by creating a mocking service that replicates the response from the provider.

# Zero Downtime

**Zero Downtime** is a set of mechanisms, tools, strategies and best practices used to protect end users from any outage, maintain capacity, reliability of applications and infrastructure when updates or migration are produced globally.

It is possible to pick out the following varieties of **Zero Downtime**:

- **Zero Downtime migration** refers to zero downtime for migrating from one ecosystem to another.
- **Zero Downtime deployment** refers primarily to zero downtime for new applications and/or services.

There are a lot of tools according to Cloud and common tools and mechanisms used to organize zero-downtime process. Which tool should be used depends on the list of requirements such as customer requirements, functionality, security, costs and etc. The following list contains a few examples, but is far from complete:
  - Azure cloud: Azure Traffic Manager, Azure Application Gateway, Azure App Service (deployment slots)
  - In common: High Availability Architecture, different kinds of load balancers, Nginx, Ingress controllers, etc.

 The following deployment strategies can provide a Zero downtime deployment: 

 - Rolling deployment
 - Blue-green deployment
 - Canary deployment
 - A/B testing
 - Shadow

Also it is important to keep in mind that is possible to talk about Near-Zero Downtime and True-Zero Downtime:
- **True zero-downtime** refers to a system where there is absolutely no interruption in service or availability during maintenance, upgrades, or failure recovery. This is achieved by having redundant systems or components in place that can take over immediately in case of any issues.

Strengths of **True zero-downtime**:

1. Continuous availability: Users experience no service interruption, ensuring seamless access to applications or services.
2. Enhanced customer experience: Consistent service availability promotes customer satisfaction and loyalty.
3. Better fault tolerance: Redundant systems or components can handle failures without affecting overall system performance.
4. Improved business continuity: Reduces the risk of lost revenue or damaged reputation due to downtime.

Weaknesses of **True zero-downtime**:

1. Higher costs: Implementing true zero-downtime solutions typically involves additional infrastructure, such as redundant servers or components, leading to increased costs.
2. Complexity: Building and maintaining a true zero-downtime system can be complex, requiring in-depth knowledge and expertise.
3. Potential resource underutilization: Redundant systems or components may not be used to their full capacity, leading to inefficient resource utilization.

- **Near zero-downtime** refers to a system where there is a minimal and often negligible interruption in service or availability during maintenance, upgrades, or failure recovery. This is achieved by having robust systems in place that can recover quickly from any issues and resume normal operations with minimal impact on the users.

Strengths of **Near zero-downtime**:

1. Reduced downtime: Near zero-downtime ensures minimal service interruption, which can be almost unnoticeable to users.
2. Cost-effective: This approach may require fewer resources and infrastructure compared to true zero-downtime, resulting in lower costs.
3. Easier implementation: Near zero-downtime solutions can be simpler to implement and maintain, requiring less specialized knowledge and expertise.
4. Better resource utilization: By minimizing redundancy, resources can be used more efficiently.

Weaknesses of **Near zero-downtime**:

1. Brief service interruptions: Users may experience short periods of service unavailability or degraded performance during maintenance or upgrades.
2. Slightly less fault tolerance: In case of a failure, there might be a brief interruption before the system recovers and resumes normal operations.
3. Potential impact on customer experience: Depending on the nature of the service, even brief downtime could negatively affect user experience or satisfaction.

In summary, choosing between **true zero-downtime** and **near zero-downtime** strategies depends on various requirements and factors. True zero-downtime is suitable for applications demanding continuous availability, enhanced customer experience, and improved business continuity, but comes with higher costs and complexity. Near zero-downtime offers a more cost-effective solution with easier implementation and better resource utilization, but may involve brief service interruptions and slightly less fault tolerance. Careful assessment of the specific needs, priorities, and resources of your application or service is essential to select the most appropriate strategy.



#Conclusion
The deployment is a very important part of application development process. There are a lot of varieties of deployment processes' organization. Before making a decision what kind of a process, deployment strategy or deployment approach to choose, DevOps engineer should focus on:
- Customer requirements
- Best practices 
- Need for a certain process or approach
- Balance between such entities as cost, redundancy, zero downtime, time of implementation, etc. according to conditions and requirements.


#Education material:
https://thenewstack.io/deployment-strategies/

https://www.harness.io/blog/continuous-delivery-vs-continuous-deployment

https://www.atlassian.com/continuous-delivery/principles/continuous-integration-vs-delivery-vs-deployment

https://docs.openshift.com/dedicated/3/dev_guide/deployments/deployment_strategies.html#:~:text=the%20Command%20Line-,What%20Are%20Deployment%20Strategies%3F,use%20a%20blue%2Dgreen%20deployment.

https://docs.mirantis.com/mke/3.6/ops/deploy-apps-k8s/nginx-ingress/configure-canary-deployment.html

https://www.flagship.io/canary-deployments/

https://www.pingidentity.com/en/resources/blog/post/what-is-zero-downtime-deployment.html

https://www.encora.com/insights/zero-downtime-deployment-techniques-blue-green-deployments

https://docs.gitlab.com/ee/update/zero_downtime.html

https://medium.com/@sagarkonde/deployment-strategies-to-achieve-zero-downtime-in-production-b3da23f8fbb

https://www.allwin.hu/post/how-to-do-a-zero-downtime-deployment-using-azure-kubernetes-service

http://www.diva-portal.org/smash/get/diva2:1213119/FULLTEXT01.pdf
