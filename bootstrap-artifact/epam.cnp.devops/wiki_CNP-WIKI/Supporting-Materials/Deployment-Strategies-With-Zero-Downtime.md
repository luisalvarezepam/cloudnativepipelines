## Deployment Strategies With Zero Downtime
Equip your infrastructure for a Zero Downtime Deployment to ensure that your users aren't left hanging every time you need to upgrade. 

The term "zero down time deployment" refers to a deployment approach in which your website or application is never down or unusable during the deployment process. To do this, the web server waits until the full deployment procedure is completed before serving the updated code.
This article explains how to use deployment tactics to ensure that there is no downtime or service interruption.

###ROLLING DEPLOYMENT
In Rolling Deployment, each server is being taken offline, deployed to, and then brought back online again. "Taking a server offline" here refers to removing it from the load balancer's list of available servers. If you do this, the load balancer will stop sending traffic to that server for the duration of the upgrade.
The goal of a rolling deployment approach is to gradually replace existing instances of our application with newer ones. There are exactly N+1 instances running at any given time. As new ones arrive, the old ones are progressively removed.
 
####Pros & Cons of Rolling Deployment
1. There are fewer resources required. You may not even need any more servers to execute the deployment if the fleet of servers has enough redundancy to handle a few servers going down.
2. Because a pipeline of three versions can be prepared during peak deployment hours, more frequent deployments are achievable.
3. Deployments take a long time. Because you can't take down all of the servers at the same time, you'll have to deploy them one by one. This can be partially reduced by pulling a few servers offline and upgrading them all at once, but there is a trade-off between more capacity and deployment parallelism.
4. Rollbacks are really unpleasant. Rollbacks entail essentially re-deploying the earlier version one server at a time now that the old version is no longer running on extra servers.

###BLUE-GREEN DEPLOYMENT

The concept here is to have two identical environments with a load balancer in front of them. Traffic will be routed to the Blue environment, which is the current production code base. New changes are deployed to the Green environment for testing and verification, and once the testing results are satisfactory, the load balancer is pointed to the Green Environment to serve real traffic in production.
 
 
####Pros & Cons of Blue-Green Deployment
1. The deployment process is quick. Because the inactive fleet receives no traffic until the deployment is complete, servers can be deployed simultaneously.
2. Zero downtime is ideal since traffic will be routed to the new code base when the load balancer is swapped, and users will not notice any disruption.
3. Easily rolled back to the previous environment in case of issues.
4. You'll need two fully functional production environments, one of which must be identical to the other. After accounting for redundancy and extra capacity, this translates to twice the number of servers.
5. Extremely frequent deployments, where three versions of the application are running at the same time, are more expensive.

### CANARY DEPLOYMENT
Canary is all about releasing an app in modest, incremental steps to a small set of users. There are several options, ranging from the simplest of serving only a portion of the traffic to the new application into more complex solutions.
 
#### Pros & Cons of Canary Deployment
1. There will be no downtime.
2. Before introducing a new feature to the general public, users' feedback can be obtained.
3. canary suffers from the N-1 data compatibility, because at any point in time we are running more than one version of the application.
Conclusion

The most important thing is that developers and operations teams work closely together when picking the right approach for your application. There is no need for any application downtime with these deployment options. While new updates are being delivered in the production environment, the application can continue to run without interruption.
