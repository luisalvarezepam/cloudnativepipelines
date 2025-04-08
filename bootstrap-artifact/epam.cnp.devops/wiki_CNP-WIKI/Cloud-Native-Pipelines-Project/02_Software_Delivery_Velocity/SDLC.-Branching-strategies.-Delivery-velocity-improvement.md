[[_TOC_]]
# Software Development Lifecycle

   The software development lifecycle (SDLC) is the cost-effective and time-efficient process that development teams use to design and build high-quality software. 

The goal of SDLC is to minimize project risks through forward planning so that software meets customer expectations during production and beyond. This methodology outlines series of steps that divide the software development process into tasks you can assign, complete, and measure.
## SDLC phases
![image.png](/.attachments/image-f1705916-0c53-47fd-9d6b-5d9e6e57f459.png)

- Plan and Requirement Analysis:

Requirement analysis is the most important and fundamental stage in SDLC. It is performed by the senior members of the team with inputs from the customer, the sales department, market surveys and domain experts in the industry. This information is then used to plan the basic project approach and to conduct product feasibility study in the economical, operational and technical areas.

Planning for the quality assurance requirements and identification of the risks associated with the project is also done in the planning stage. The outcome of the technical feasibility study is to define the various technical approaches that can be followed to implement the project successfully with minimum risks.
- Design:

Based on the requirements, usually more than one design approach for the product architecture is proposed and documented in a DDS - Design Document Specification.

This DDS is reviewed by all the important stakeholders and based on various parameters as risk assessment, product robustness, design modularity, budget and time constraints, the best design approach is selected for the product.

A design approach clearly defines all the architectural modules of the product along with its communication and data flow representation with the external and third party modules (if any). The internal design of all the modules of the proposed architecture should be clearly defined with the minutest of the details in DDS.

- Implement

In this stage of SDLC the actual development starts and the product is built. The programming code is generated as per DDS during this stage. If the design is performed in a detailed and organized manner, code generation can be accomplished without much hassle.

Developers must follow the coding guidelines defined by their organization and programming tools like compilers, interpreters, debuggers, etc. are used to generate the code. Different high level programming languages such as C, C++, Pascal, Java, PHP and etc. are used for coding. The programming language is chosen with respect to the type of software being developed.
- Test

This stage is usually a subset of all the stages as in the modern SDLC models, the testing activities are mostly involved in all the stages of SDLC. However, this stage refers to the testing only stage of the product where product defects are reported, tracked, fixed and retested, until the product reaches the quality standards.
- Deploy

Once the product is tested and ready to be deployed it is released formally in the appropriate market. Sometimes product deployment happens in stages as per the business strategy of that organization. The product may first be released in a limited segment and tested in the real business environment (UAT- User acceptance testing).
- Maintain

The SDLC doesn’t end when software reaches the market. Developers must now move into a maintenance mode and begin practicing any activities required to handle issues reported by end-users.

## Why SDLC is important?
Here are some benefits of SDLC:
- Increased visibility of the development process for all stakeholders involved
- Efficient estimation, planning, and scheduling
- Improved risk management and cost estimation
- Systematic software delivery and better customer satisfaction

## SDLC Models
| Model | Description |
| --- | ---|
| Waterfall | Waterfall is the oldest and most straightforward of the structured SDLC methodologies — finish one phase, then move on to the next. No going back.
|V-Shaped Model| Also known as the Verification and Validation model, the V-shaped model grew out of Waterfall and is characterised by a corresponding testing phase for each development stage.|
| Iterative| The Iterative model is repetition incarnate. Instead of starting with fully known requirements, you implement a set of software requirements, then test, evaluate and pinpoint further requirements. A new version of the software is produced with each phase, or iteration. Rinse and repeat until the complete system is ready.|
| Spiral| One of the most flexible SDLC methodologies, the Spiral model takes a cue from the Iterative model and its repetition; the project passes through four phases over and over in a “spiral” until completed, allowing for multiple rounds of refinement.This model allows for the building of a highly customised product, and user feedback can be incorporated from early on in the project |
| Big Bang Model| A bit of an anomaly among SDLC methodologies, the Big Bang model follows no specific process, and very little time is spent on planning.|
|Agile|By breaking the product into cycles, the Agile model quickly delivers a working product and is considered a very realistic development approach. The model produces ongoing releases, each with small, incremental changes from the previous release. At each iteration, the product is tested.|

# Branching strategies

A branching strategy, therefore, is the strategy that software development teams adopt when writing, merging and deploying code when using a version control system.
It is essentially a set of rules that developers can follow to stipulate how they interact with a shared codebase.

A good branching strategy should have the following characteristics:
Provides a clear path for the development process from initial changes to production:
- Allows users to create workflows that lead to structured releases
- Enables parallel development
- Optimizes developer workflow without adding any overhead.
- Enables faster release cycles
- Efficiently integrates with all DevOps practices and tools such as different version control systems
- Offers the ability to enable GitOps (if you require it)

## Why do you need a branching strategy in DevOps?

A properly implemented branching strategy will be the key to creating an efficient DevOps process. DevOps is focused on creating a fast, streamlined, and efficient workflow without compromising the quality of the end product.

A branching strategy helps define how the delivery team functions and how each feature, improvement, or bug fix is handled.


It also reduces the complexity of the delivery pipeline by allowing developers to focus on developments and deployments only on the relevant branches—without affecting the entire product.


## Branching Strategies
| Branching Strategy | Description |
| --- | ---|
|GitFlow|Considered to be a bit complicated and advanced for many of today’s projects, GitFlow enables parallel development where developers can work separately from the master branch on features where a feature branch is created from the master branch.Afterwards, when changes are complete, the developer merges these changes back to the master branch for release. Branches: Master, Develop, feature, release, hotfix.|
|GitHub Flow|GitHub Flow is a simpler alternative to GitFlow ideal for smaller teams as they don’t need to manage multiple versions. Unlike GitFlow, this model doesn’t have release branches. You start off with the main branch then developers create branches, feature branches that stem directly from the master, to isolate their work which are then merged back into main. The feature branch is then deleted. The main idea behind this model is keeping the master code in a constant deployable state and hence can support continuous integration and continuous delivery processes. Branches: Main, feature |
|GitLab Flow|GitLab Flow is a simpler alternative to GitFlow that combines feature-driven development and feature branching with issue tracking. With GitFlow, developers create a develop branch and make that the default while GitLab Flow works with the main branch right away. GitLab Flow is great when you want to maintain multiple environments and when you prefer to have a staging environment separate from the production environment. Then, whenever the main branch is ready to be deployed, you can merge back into the production branch and release it. Branches: Master, Pre-production, production|
|Trunk-based development|Trunk-based development is a branching strategy that in fact requires no branches but instead, developers integrate their changes into a shared trunk at least once a day. This shared trunk should be ready for release anytime. The main idea behind this strategy is that developers make smaller changes more frequently and thus the goal is to limit long-lasting branches and avoid merge conflicts as all developers work on the same branch. In other words, developers commit directly into the trunk without the use of branches. Branches: Master, Features|

# Project metrics. Change delivery velocity improvement
## DORA metrics
In 2018, a research program called the DevOps Research and Assessment (DORA) team was acquired by Google. The principal goal of the team is to understand what enables teams to realize high performances in software delivery. The DORA team has established a set of metrics that can accurately evaluate a team’s performance. These DORA metrics include: 

- Deployment frequency

The deployment frequency (DF) indicates the frequency that a company deploys code for a given application, meaning how often there are successful software releases to production.

- Lead time for changes

The lead time for changes (LT) metric refers to the time between a code change and the amount of time required to get it to its deployable state.

- Change failure rate

The change failure rate (CFR) measures the number of changes that were made to a code which then resulted in any kinds of incidents or production failures.

- Mean time to restore service

Mean time to restore service (MTTR) refers to the time that is required for a service to come back from some kind of failure.

## What is development velocity and how it could be measured?
Velocity is an indicator or an estimate of how much work a development team can complete, based on previous time frames of similar work. This number is relative, and it’s important to rely on the trend rather than on the raw number, regardless of how you measure it. Each team will have different velocities, and this is entirely normal. Nothing beneficial will come from comparing different teams’ velocities.

Units of work can be measured in the following ways:

-  engineer hours
-  user stories,
-  story points

Time frame is measured in the following ways:

-  iterations
-  sprints
-  weeks.

# Useful material

- https://aws.amazon.com/what-is/sdlc/
- https://stackify.com/what-is-sdlc/
- https://www.tutorialspoint.com/sdlc/sdlc_overview.htm
- https://www.atlassian.com/agile/software-development/branching
- https://www.linkedin.com/pulse/what-devops-branching-strategies-wael-al-wirr/
- https://www.bmc.com/blogs/devops-branching-strategies/
- https://fellow.app/blog/engineering/dora-metrics-measuring-software-delivery-performance/?utm_source=google&utm_medium=cpc&utm_campaign=Dynamic_Intl&utm_term=-&utm_content=434058953407&adgroupid=101732089660&placement=&gclid=EAIaIQobChMI1dqdjYDI_QIVRsjVCh27AAfYEAAYASAAEgLOBfD_BwE
- https://www.bunnyshell.com/blog/what-development-velocity/
- https://www.7pace.com/blog/developer-velocity
