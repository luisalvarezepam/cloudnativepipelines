[[_TOC_]]

# Introduction

**Agile estimation** is the process for estimating the effort required to complete a prioritized task in the product backlog. This effort is usually measured with respect to the time it will take to complete that task, which, in turn, leads to accurate sprint planning. 

> :warning: No matter how accurately a business estimates the effort required to complete a user story in Agile, an estimate is still an estimate. Do not strive to achieve perfect accuracy because requirements can change at any time. There are also agile anti-patterns and other emerging realities that change the course of development.

Agile teams also make estimations with reference to story points. A **story point** is used in Agile Development projects <u>to estimate the difficulty of implementing a given user story</u>. This is measured in relative units assigned to different user stories that require estimation.

In a nutshell, a **story point** is a number that helps estimate the difficulty of building a user story successfully. This difficulty could be anything related to the complexities, risks, and efforts involved.

**Agile estimations** are essential for:

* Enabling better sprint management
* Predicting the approximate time it will take to finish a project
* Improving team productivity
* Making teams accountable for deliverables
* Inducing discipline across the Agile team

# Estimation Techniques

There is a diversity of estimation techniques in Agile world. Agile teams tend to take a one-dimensional approach when it comes to estimating work’s duration. Usually, it is selected what is most preferable for the team. For this particular project we would suggest to use Story Point Estimation approach.

## Story Point Estimation in Agile

**Story points** are a relative estimation model native to Agile and Scrum. They estimate the effort to build a product by addressing three aspects of development:

* the amount of work the product requires
* the complexity of the product’s features
* risks and uncertainties that might affect development

> :green_book: **Why Are Story Points Better Than Hours?**  
> Estimating the number of hours for a task has one big problem. Different engineers will take different amounts of time to complete the same task. This is an inescapable fact due to differences in their experience, knowledge, and skill.  
With Story points estimation technique it is easier to define unified individual capacity of each developer. In that case, it becomes easier to plan when you know that developer will be unavailable for an iteration.  
However, the story's complexity relative to other ones would stay the same, regardless of the difference in developer skill. The consensus is that story points can provide what hours can't.

Many agile teams use story points as the unit to score their tasks. The higher the number of points, the more effort the team believes the task will take.

**The Fibonacci sequence** is one popular scoring scale for estimating agile story points. In this sequence, each number is the sum of the previous two in the series. The Fibonacci sequence goes as follows: 0, 1, 2, 3, 5, 8, 13, 21… and so on. 

:exclamation:And we will use this technique to estimate stories for this particular project.

## Fibonacci sequence strategy explained

| **Points** | **Description** |**Can take into Sprint ?**|
|--|--|--|
| 1 | Very simple task, everything is clear, impossible to make errors | yes |
| 2 | More work that "1", everything is clear, low chances to make errors | yes |
| 3 | Need to spend some time coding, but it is manageable and still clear | yes |
| 5 | You know that you won't be able to do in 1 day, if unlucky may sit for couple of days | yes |
| 8 | "8" is a "5" where you do not know something. You need to investigate how to do this first | yes |
| 13 | A complex story, that will require significant implementation efforts. One might need a week to close it. Requires some research. Should be possible to close before code freeze. | yes |

## Estimate Stories

For this particular project as you will work individually, you will estimate stories based on your experience and scope undersntading. Most of the estimation techniques are applied when you work within the team. You can read about some options here: [Top 8 Agile Estimation Techniques](https://www.netsolutions.com/insights/how-to-estimate-projects-in-agile/)

For individual work most of techniques can't be applied, cause you estimate effort for yourself. We can suggest to look at **3-Points Estimating** technique, maybe it will help a bit.

# How to make estimation in Azure DevOps

![image.png](/.attachments/Project-plan.png)

# Reference Links

* [Agile Story Points vs Hours: How to Calculate for Software Development](https://themindstudios.com/blog/agile-story-points-vs-hours/)
* [Fibonacci Agile Estimation](https://www.productplan.com/glossary/fibonacci-agile-estimation/)
* [Top 8 Agile Estimation Techniques](https://www.netsolutions.com/insights/how-to-estimate-projects-in-agile/)
* [Planning poker](https://www.atlassian.com/blog/platform/a-brief-overview-of-planning-poker)
* [T-shirt sizing](https://www.easyagile.com/blog/agile-estimation-techniques/#tshirt-sizing-for-product-backlog-items).
* [Dot voting](https://www.nngroup.com/articles/dot-voting/)


