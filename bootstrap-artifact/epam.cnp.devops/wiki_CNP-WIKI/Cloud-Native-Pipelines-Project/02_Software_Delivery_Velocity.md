[[_TOC_]]

# Problem Statement

The TrackX application now requires frequent configuration updates during cargo formation for each new cargo delivery, as the workload has significantly increased. Additionally, the management of Wey's company wishes to incorporate new functionality into the application, enabling support for other space station types besides the Prometheus station. As a result, frequent updates and upgrades to the application will be necessary in the near future. 

As a result, the management of Wey's company predicts some challenges, which may occur within TrackX updates delivery, such as slow release cycles, code integration issues, and difficulty in maintaining multiple long-lived branches. Therefore, the client considers to migrate from GitFlow to a Trunk-Based Development (TBD) workflow, which most likely will improve TrackX development process, increase the speed of delivery, and ensure better code integration.

One of the DORA metrics, which helps to measure software delivery performance is Lead Time for Changes. Lead Time for Changes is a key metric for any DevOps team that wants to measure its software delivery efficiency. This metric measures the time it takes for committed code to reach production. A low lead time for changes indicates an efficient DevOps team that can deploy code quickly, while a high lead time indicates bottlenecks and inefficiencies in the software delivery process.

To improve the Lead Time for Changes metric, it is suggested that the client consider migrating from Gitflow, their current branching model, to Trunk-based Development. 

# Requirements

* Gain clear understanding of the differences between Gitflow and Trunk-based Development workflows, including the benefits and drawbacks of each approach.
* Ensure a smooth transition from Gitflow to Trunk-based Development, minimizing any potential downtime or disruptions to the development process.
* Identify the necessary tools and infrastructure changes needed to support Trunk-based Development, including any upgrades or modifications to existing systems and delivery pipelines.
* Create a migration plan for how to migrate to the new workflow, including regular reviews and updates to ensure that it remains effective and efficient.
* Establish clear metrics and performance indicators to measure the success and ensure that the new workflow is delivering the desired benefits.

# Considering appropriate DORA metrics

As you plan to migrate from Gitflow to Trunk-based Development to improve the **Lead Time for Changes** metric, it's important to consider other relevant DORA (DevOps Research and Assessment) metrics that can help you measure the success of your migration and ensure that your DevOps team is working as efficiently as possible.

Here are some DORA metrics that you may want to consider in addition to **Lead Time for Changes**:

1. **Deployment Frequency:** This metric measures how frequently code changes are deployed to production. A high deployment frequency indicates that the DevOps team is able to release code quickly and efficiently.  
2. **Change Failure Rate:** This metric measures the percentage of changes that result in a failure or require remediation. A low change failure rate indicates that the DevOps team is able to deliver high-quality changes and respond quickly to issues.  
3. **Mean Time to Recover (MTTR):** This metric measures the time it takes to recover from a failure or incident. A low MTTR indicates that the DevOps team is able to resolve issues quickly and efficiently.  
4. **Lead Time for Changes (LTC):** As previously mentioned, this metric measures the time it takes for committed code to reach production. By migrating to Trunk-based Development, you should see a decrease in the Lead Time for Changes metric, indicating that your DevOps team is working more efficiently.  
5. **Cycle Time:** This metric measures the time it takes to complete a work item, from creation to delivery. A low cycle time indicates that the DevOps team is able to complete work items quickly and efficiently.  

When considering which DORA metrics to track, it's important to choose metrics that align with your business goals and the specific challenges your DevOps team is facing. By tracking multiple metrics, you can get a more comprehensive understanding of your DevOps team's performance and identify areas for improvement.