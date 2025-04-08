[[_TOC_]]

# Trunk-Based Development Overview

One way to improve the **Lead Time for Changes** metric is to migrate from ***Gitflow***, which is currently used by the client, to ***Trunk-based Development***.  

**Gitflow** is a popular branching model that provides a structured approach to software development, with separate branches for `features`, `releases`, and `hotfixes`. While Gitflow has its benefits, it can also lead to longer lead times for changes, especially when it comes to feature releases.

**Trunk-based Development**, on the other hand, is a development methodology that emphasizes continuous integration and delivery. In Trunk-based Development, there is only one `main` branch, called the trunk or the main branch, where all changes are integrated and tested. This approach encourages collaboration, reduces silos, and improves the speed of code integration and deployment.

Here are some of the <u>benefits of migrating from Gitflow to Trunk-based Development<u>:

1. **Reduce lead time for changes**: By integrating changes into a single trunk branch, Trunk-based Development reduces the time it takes for code to reach production. This is because there are fewer branches to manage, and code integration is simpler and faster.  
2. **Improve collaboration**: Trunk-based Development encourages collaboration between developers and reduces silos. Since there is only one branch, developers are forced to work together and resolve conflicts quickly. This approach leads to better code quality and faster software delivery.  
3. **Easier code integration**: With Trunk-based Development, there is no need to merge code from different branches, which can be time-consuming and error-prone. Instead, all changes are integrated into the trunk branch, which makes code integration simpler and more straightforward.  
4. **Faster feedback**: Since changes are integrated into the trunk branch quickly, developers can receive feedback on their code faster. This allows them to make improvements and iterate more quickly, which leads to faster software delivery and a more efficient DevOps team.  
5. **Simplified release process**: With Trunk-based Development, releases are simpler and more frequent. Since there is only one main branch, there is no need to create separate release branches or hotfix branches. Instead, releases can be made directly from the trunk branch, which simplifies the release process and reduces lead times.  

Of course, migrating from Gitflow to Trunk-based Development requires planning, communication, and training. The DevOps team must be comfortable with the new approach and understand its benefits. However, by taking the time to plan and implement the migration, the team can improve its Lead Time for Changes metric and become more efficient in delivering software.

# Target Software Delivery Model Overview

The target software delivery model for TrackX application is based on Scaled Trunk Based Development, where developers create short-lived feature branches that are reviewed and tested through Continuous Integration pipelines before being merged back into the `main` code trunk. This approach enables faster and more frequent delivery of software updates while maintaining a high level of quality, stability, and reliability.

We will use a "classic" three-tier environment DEV (Development environment), QA (Quality Assurance environment), and PROD (Production environment). In case using Kubernetes cluster as a resource that holds out the application, each software development environment exists as a Kubernetes namespace.  

The diagram below shows the CI/CD based on Scaled Trunk Based Development:

![development-worflows-diagrams-Trunk-Based-Development.png](/.attachments/development-worflows-diagrams-Trunk-Based-Development.png)  
[development-workflows-diagrams.drawio.xml](/.attachments/development-worflows-diagrams.drawio.xml)

## Development Stage

The `main` branch is basic for application development. Merging changes to the `main` branch triggers the pipeline that runs unit tests and image build verification, then publishes artifacts. Approval is required for deploying the artifacts to DEV and QA environments for running the following tests:

* **[DEV and QA]** Deployment verification tests
* **[DEV]** Integration tests
* **[QA]** Feature and high-priority risk-based tests
* **[QA]** Exploratory testing

![Tests-envs-DEV-trunk.png](/.attachments/Tests-envs-DEV-trunk.png)

[Tests-envs-DEV-trunk.xml](/.attachments/Tests-envs-DEV-trunk.xml)

### Feature flow

The `feature` and `bugfix` development starts with creating a branch from the `main` branch. After completing tests, image build verification, and pull request conditions you can merge the changes. 

## Release Stage

Cutting-off a `release/` branch from the `main` branch triggers a build and executes tests in the QA environment. After getting approval changes can be deployed to the PROD environment.  

The following tests will be run on the release flow:

* **[QA and PROD]** Deployment verification tests
* **[QA**] Low-priority risk-based tests
* **[QA]** Non-functional testing

![Tests-envs-release-trunk.png](/.attachments/Tests-envs-release-trunk.png)

[Tests-envs-release-trunk.xml](/.attachments/Tests-envs-release-trunk.xml)

### Bugfix flow

If any bug was found during Release stage on Production, `hotfix` is required, thus appropriate changes can be merged to the latest `release` branch to deploy fixed version on production. If the latest `release` branch does not exist anymore, `bugfix` flow will be processed and cutting of new release branch is require.

# High-Level Migration plan

1. **Assess the current Gitflow process:** Before making any changes, it's important to understand the current process and identify areas for improvement. Analyze the Lead Time for Changes metric and gather feedback from the DevOps team and stakeholders to gain a comprehensive understanding of the current situation.  
2. **Introduce Trunk-based Development:** Explain the concept of Trunk-based Development and its benefits, such as reduced lead time, increased collaboration, and easier code integration. Show how this approach differs from Gitflow and how it can address the issues identified in step 1.  
3. **Plan the migration:** Create a plan for the migration, including timelines, resources required, and communication strategies. Ensure that all stakeholders are aware of the changes and how they will be impacted.  
4. **Implement Trunk-based Development:** Follow the migration plan and implement Trunk-based Development. Provide training and support for the DevOps team to ensure a smooth transition. Monitor the Lead Time for Changes metric and gather feedback from the team to identify any areas for improvement.  
5. **Continuous improvement:** Regularly review the Lead Time for Changes metric and make adjustments to the Trunk-based Development process as needed. Encourage collaboration and continuous improvement to ensure that the DevOps team is working as efficiently as possible.  

# Implementation details

Review requirements, high-level migration plan, current repository and pipelines configuration. Plan further migration activities considering following:

* fundamental difference between Gitflow and Trunk-Based development workflows.
* required repository changes, like branches/policies.
* required pipelines modification.  
* pipeline triggers implementation.  
* Approval flow against Pipeline stages.

Apply required **repositories changes:**

* Changes default branch.
* Review and configure new default branch policies:
  * Setup minimum number of reviewers.
  * Configure verification of linked work items and comment resolution.
* Setup Build Validation pipeline for the new default branch.

Apply required **pipeline modification:**

* Setup CI trigger for `main` and `release` branches.
* Configure Approvals for QA and PROD stages (if necessary):
  * Do not allow approvers to approve their own runs.
  * Set 1-day approval timeout.
* Verify the changes according to <u>Target TrackX Application Software Delivery Model</u> flows (feature, release, hotfix, bugfix, etc.)

# Useful links

* [Trunk Based Development: Introduction](https://trunkbaseddevelopment.com/)  
* [Trunk-Based Development economics, Paul Hammant](https://youtu.be/meB_SWzZm8M)  
* [Git patterns and anti-patterns for successful developers, Edward Thomson](https://youtu.be/ykZbBD-CmP8)  
* [Introducing Branch By Abstraction, Paul Hammant](https://paulhammant.com/blog/branch_by_abstraction.html)  
* [BranchByAbstraction, Martin Fowler](https://martinfowler.com/bliki/BranchByAbstraction.html)  
* [Progressive experimentation with feature flags, Microsoft Docs ](https://learn.microsoft.com/en-us/devops/operate/progressive-experimentation-feature-flags)  
* [Continuous Code Review](https://trunkbaseddevelopment.com/continuous-review/)  
* [Continuous Review, Paul Hammant's blog](https://paulhammant.com/2013/12/05/continuous-review/)  