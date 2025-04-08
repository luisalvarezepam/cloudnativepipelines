# DORA Metrics Overview

DORA metrics, also known as the DevOps Research and Assessment (DORA) metrics, are designed to measure software quality, stability, and overall performance. These metrics include lead time, deployment frequency, change failure rate, mean time to restore, and time to total failure, among others. The goal of these metrics is to provide an objective way to measure and analyze different aspects of software and help ensure it is of high quality and stability

# Change Failure Rate (CFR)

Change Failure Rate (CFR) - This metric captures the percentage of changes that were made to a code that then resulted in incidents, rollbacks, or any production failure. The CFR is a true measure of quality and stability while the previous metrics, Deployment Frequency, and Lead Time for Changes don't indicate the quality of software but just the tempo of software delivery. According to the DORA report, high performers fall somewhere between 0-15%.

# Shift-Left Testing Approach

Organizations can use a shift-left approach to decrease the CFR, which involves moving testing and quality control activities earlier in the software delivery process.

![Agile/DevOps Shift Left](/.attachments/agile_devops_shiftleft.png)

Using shift-left for improving software quality can offer the following benefits:

1. Early detection of issues for quicker identification and remediation reduces the likelihood of problems being discovered in production.

2. Close collaboration between developers, testers, and other stakeholders is a key aspect of the shift-left approach. This fosters better communication and alignment on project goals and requirements.

3. Higher quality software by integrating quality control activities throughout the development cycle, the overall quality of the software is improved. This can help reduce the CFR by ensuring that software delivered to production is thoroughly tested and meets the desired quality standards.

4. Increasing efficiency through automated testing and continuous integration can help reduce the time and effort required for manual testing and deployment. This can help to speed up the development cycle and reduce the time to market for new features and updates.

5. Better user experience by focusing on the business drivers and user requirements from the beginning of the development cycle, the resulting software is more likely to meet the needs and expectations of end-users. This can lead to higher user satisfaction and better business outcomes.


# Useful materials

- Saif Gunja (October 27, 2022). [Shift left vs shift right: A DevOps mystery solved. Dynatrace blog](https://www.dynatrace.com/news/blog/what-is-shift-left-and-what-is-shift-right/)
- Microsoft (2012). ["Test Early and Often"](https://learn.microsoft.com/en-us/previous-versions/visualstudio/visual-studio-2012/ee330950(v=vs.110)?redirectedfrom=MSDN)
- Firesmith, D. (March 23, 2015). [Four Types of Shift Left Testing. Carnegie Mellon University, Software Engineering Institute's Insights (blog)](https://insights.sei.cmu.edu/blog/four-types-of-shift-left-testing/)
- Mallory Mooney (June 23, 2021). [Best practices for shift-left testing. Datadog blog ](https://www.datadoghq.com/blog/shift-left-testing-best-practices/)