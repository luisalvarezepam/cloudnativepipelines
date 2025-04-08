[[_TOC_]]
# Code Quality

Code quality is a metric that can be used to classify code as good or bad. It can only be measured subjectively, and different industries, organisations and teams will have different definitions of quality code.

High-quality code often meets these common parameters:

- Functional
- Consistent
- Easy to understand
- Meets clients' needs
- Testable
- Reusable
- Free of bugs and errors
- Secure
- Well documented

## How can be code quality improved?

It can be done by adding quality gates, code review and monitoring and observability.

**Monitoring** is tooling or a technical solution that allows teams to watch and understand the state of their systems. Monitoring is based on gathering predefined sets of metrics or logs.

**Observability** is tooling or a technical solution that allows teams to actively debug their system. Observability is based on exploring properties and patterns not defined in advance.

![image.png](/.attachments/image-23f5a11e-921a-426b-af37-968e3d4851f6.png)

## Quality gates

Quality Gates are an essential part of modern application development practices. It is used as a checklist or gate at every stage of an SDLC. With Quality Gates practices, each artifact is reviewed and measured against certain requirements essential for the artifact to be pushed to the next phase. If an artifact doesn’t meet the checklist, it is sent back to its respective team to get it done to meet the required standards.

## Why it is better to include quality gates into CI/CD pipeline?

- A quality gate’s implementation aids in identifying sections of the code that require restructuring or simplicity.
- Early in the development cycle, a bug that eliminates the technical debt businesses build up over time can be found. It lowers the expense of future maintenance.
- It enables developers to build application code that compiles or runs without error and warns them if any problems arise, helping them avoid using poor coding standards. It aids in the overall enhancement of the code’s quality.
- It helps define project-specific rules that will afterward be automatically implemented.

##  Code review

Code reviews are methodical assessments of code designed to identify bugs, increase code quality, and help developers learn the source code. Developing a strong code review process sets a foundation for continuous improvement and prevents unstable code from shipping to customers. Code reviews should become part of a software development team’s workflow to improve code quality and ensure that every piece of code has been looked at by another team member.

##  Code review benefits

- Share knowledge
- Discover bugs earlier
- Maintain compliance
- Enhance security
- Increase collaboration
- Improve code quality

# Automated tests

## Test automation

   Test automation is the practice of automatically reviewing and validating a software product to make sure it meets predefined quality standards for code style, functionality (business logic), and user experience.

Testing practices typically involve the following stages:
- Unit testing: validates individual units of code, such as a function, so it works as expected
- Integration testing: ensures several pieces of code can work together without unintended consequences
- End-to-end testing: validates that the application meets the user’s expectations
- Exploratory testing: takes an unstructured approach to reviewing numerous areas of an application from the user perspective, to uncover functional or visual issues The different types of testing are often visualized as a pyramid. As you climb up the pyramid, the number of tests in each type decreases, and the cost of creating and running tests increases.
![image.png](/.attachments/image-1267afbd-e323-47d1-bd4c-8f8796a924a2.png)

## The DevOps benefits of automated testing

- Speed without sacrificing quality: gain high product velocity that makes developers happy and enables them to deliver more value to users, faster Improved team collaboration: shared responsibility for quality empowers better collaboration among team members
- Reliability: improve the reliability of releases by increasing coverage with test automation. Issues in production should be a rare occurrence rather than the norm
- Scale: produce consistent quality outcomes with reduced risk by distributing development across multiple small teams that operate in a self-sufficient manner
- Security: move quickly without compromising security and compliance by leveraging automated compliance policies, fine-grained controls, and configuration management techniques
- Increased customer happiness: improved reliability and fast responses to user feedback increases user satisfaction and leads to more product referrals

# Shift-left testing

Shift Left is a practice intended to find and prevent defects early in the software delivery process. The idea is to improve quality by moving tasks to the left as early in the lifecycle as possible. Shift Left testing means testing earlier in the software development process.
![image.png](/.attachments/image-8f1076ef-e7f4-41fc-a928-3ff00cb21b8a.png)

## Benefits of the shift left testing

- Early detection of issues for quicker identification and remediation reduces the likelihood of problems being discovered in production.
- Close collaboration between developers, testers, and other stakeholders is a key aspect of the shift-left approach. This fosters better communication and alignment on project goals and requirements.
- Higher quality software by integrating quality control activities throughout the development cycle, the overall quality of the software is improved. This can help reduce the CFR by ensuring that software delivered to production is thoroughly tested and meets the desired quality standards.
- Increasing efficiency through automated testing and continuous integration can help reduce the time and effort required for manual testing and deployment. This can help to speed up the development cycle and reduce the time to market for new features and updates.
- Better user experience by focusing on the business drivers and user requirements from the beginning of the development cycle, the resulting software is more likely to meet the needs and expectations of end-users. This can lead to higher user satisfaction and better business outcomes.

# Useful material

-  https://about.gitlab.com/topics/version-control/what-is-code-review/#:~:text=Code reviews%2C also known as,developers learn the source code
-  https://successive.cloud/why-does-your-ci-cd-pipeline-need-devops-quality-gates/ 
-  https://www.atlassian.com/devops/devops-tools/test-automation#:~:text=Automated testing in DevOps&text=In practice%2C this means that,-to-end user experience .
-  https://dev.azure.com/#{org_name}#/Cloud Senior School/_wiki/wikis/CSS-WIKI/2590/DORA-Metrics
-  https://docs.aws.amazon.com/whitepapers/latest/practicing-continuous-integration-continuous-delivery/testing-stages-in-continuous-integration-and-continuous-delivery.html
