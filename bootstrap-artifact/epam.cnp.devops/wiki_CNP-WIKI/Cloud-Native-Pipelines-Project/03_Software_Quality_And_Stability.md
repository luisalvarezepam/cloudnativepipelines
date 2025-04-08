[[_TOC_]]

# Problem Statement

The current software quality and stability of the TrackX product is a major concern as the value of the Change Failure Rate (CFR) metric is higher than expected. This has resulted in frequent issues after production deployments, causing inconvenience to the end-users and negatively impacting the «Wey» company reputation. «Wey» company is looking to improve the overall software quality of the TrackX product by implementing a shift-left testing approach that can help identify and address issues earlier in the development cycle. However, the lack of a structured testing process and limited automated testing tools have led to a high number of defects being identified during the production stage. As a result, the client is facing challenges in delivering a stable and reliable application product to consumers. Therefore, there is a pressing need to address these issues and implement an effective shift-left testing strategy to reduce the CFR metric value and improve the overall software quality and stability.

To address the problem mentioned above «Wey» company decided to establish **"Shift-left business-driven development"** approach, which is a software development approach that emphasizes early collaboration between business stakeholders, development teams, and quality assurance (QA) teams to identify and prioritize requirements and validate software functionality throughout the development process. The term "shift-left" refers to the practice of duplicating testing and validation activities earlier in the software development life cycle (SDLC), rather than relying on testing at the end of the development cycle.

**Shift-left testing** is a strategy to move tasks and tests to an earlier stage in the development process, so that potential problems can be identified and fixed earlier before they become bigger and more expensive.

The client is interested in adopting this strategy and wants to focus on careful planning and review processes to catch risks and problems early on. Automated testing will also be used throughout the development process to identify issues quickly and reduce the amount of manual testing required.

By using shift-left testing, the client can speed up the development process, reduce costs by detecting issues in earlier stages, and deliver a higher-quality product that meets customer needs.

# Requirements

* Implement a basic after-deployment tests in the pipeline that allow to detect if the web application is up and running after deployment is done.  
* Establish "Shift-left business-driven development" approach by introducing *shift-left testing* process.
* Implement a shift-left testing process by duplicating appropriate test jobs to the early stages of Continuous Integration (CI). This should also include automating test cases and integrating them into the CI pipeline to identify and address issues early in the development process.  
* Introduce the temporary, dynamically created *feature environment* for the new shift-left testing approach handling.  
* Establish a change approval process that includes review and approval procedures for changes. The process must ensure that potential risks and issues are effectively identified and mitigated at earlier stages.  
* Adjust Continuous integration and delivery (CI/CD) pipeline to correspond new testing strategy.  

# Implementation details

## Automated tests

To implement a basic after-deployment tests in the pipeline, which allow to detect if the web application is up and running after deployment is done:  

* Implement a basic after-deployment *"Deployment verification test"* job in the pipeline that allows to detect if the web application is correctly installed and correctly responds to the HTTP request with the code 200.
  * The "Deployment verification test" must check web service availability from the Azure DevOps agent (outside the AKS cluster).
  * Include the "Deployment verification test" to the main pipeline after the deployment job to ensure that the application is responding with the HTTP 200 code.
* Implement a helm test that should be done on the basics of Helm Charts possibilities. It allows us to implement various testing scenarios, including connectivity testing
  * A test in a helm chart lives under the templates/ directory and is a job definition that specifies a container with a given command to run. The container should exit successfully (exit 0) for a test to be considered a success. The job definition must contain the helm test hook annotation: `helm.sh/hook: test`. For more details see  https://helm.sh/docs/topics/chart_tests/

## Shift-Left Testing

To implement a shift-left testing process proceed with the following steps:

* Implement a Dynamic Feature Environment (DFE) that can be used for deploying code from `feature` branches and perform appropriate tests before changes will get to `main` branch.
* The DFE must be created after creating a new pull request or pushing new commits to the existing pull request's source branch.
* The DFE must be destroyed after merging or closing the pull request.
* Ensure that the DFE is isolated from other environments.
* Follow the environment naming convention while creating the DFE.
* Create a pipeline that builds application artifacts and deploys them to the DFE.
* Duplicate execution of the *Integration tests*, and *High priority risk-based tests* jobs on the Dynamic Feature Environment within the Pull Request flow.
* *Integration tests*, and *High priority risk-based tests* jobs must be executed after deploying the application to the DFE environment.

The diagram below shows the Dynamic Feature Environment in the context of the Scaled Trunk Based Development CI/CD diagram:
![development-worflows-diagrams-Trunk-Based-Development.png](/.attachments/development-worflows-diagrams-Trunk-Based-Development-with-Feature-env.png)  
[development-worflows-diagrams.drawio.xml](/.attachments/development-worflows-diagrams.drawio.xml)

* Create a new variable group for the DFE in the variables Library
* Use the following naming convention for the application ingress hostname:  
 `{SYS_PROJECT_CODE}-{ENV_INFRA_NAME_PREFIX}-{ENV_NAME}.{ENV_INFRA_LOCATION}.cloudapp.azure.com`. Keep in mind when using AutoSSL with Let's Encrypt the domain name limitation exist. This error occurs when attempting to request an SSL certificate from Let's Encrypt for a domain name longer than 64 characters. When this domain name is used as the Common Name (CN) for the SSL certificate, the request fails. Use a shorter domain name as possible.
  * `ENV_NAME` variable in the variables Library with the value `feat-$(Build.SourceBranchName)` for generating the ingress host name dynamically


  
## Change Approval Process

To establish new change approval process, follow next steps:

* Configure pre-deployment approval gates before deploying to the QA and PROD environments:
    * Do not allow approvers to approve their own runs.
    * Set 1-day approval timeout.
* All changes should be reviewed and approved by relevant stakeholders before being incorporated into the `main` (trunk) branch.
* Implement build validation policy within the CI pipeline triggers for a pull request flow.

After the deployment is approved, the engineer is responsible for monitoring the application performance and ensuring reports of any issues or bugs are addressed immediately.

# Useful materials

- [Dora Metrics and Shift-Left Testing Approach](/Supporting-Materials/What-is-DevOps/DORA-Metrics.md)