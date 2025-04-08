[[_TOC_]]

# Why is Agile reporting important?
Agile reporting refers to the use of selected metrics and tools for analyzing and making informed decisions about the way work is managed. Reporting supports decision-making, helps to achieve outcomes that create customer value, and offers the ability to track progress in real-time. Here are the three critical aspects of Agile reports.

* Outcomes of an Agile project report can uncover process insights (bottlenecks, dependencies, and improvement opportunities) and team performance clues that support informed decision-making.
* Creating real customer value can be measured by analyzing how efficient your team is in resolving customers’ issues, or how value is delivered over time.
* Meeting customers’ expectations is a cornerstone of the Agile mindset. Understanding how fit-for-purpose your process is unlocks insights into optimizing your service delivery to increase customer satisfaction and into better future delivery predictions.

# How to use Azure DevOps tools to optimize your delivery?
Azure DevOps offers a generous choice of tools to help you get real-time reports and draw insights into your work process, team performance, or another indicator of success.

## Dashboards, charts, reports, and widgets
Gain visibility into your team's progress by adding one or more widgets or charts to your dashboard. Customizable, highly configurable dashboards provide you and your teams with the flexibility to share information, monitor progress and trends, and improve your workflow processes. Each team can tailor their dashboards to share information and monitor their progress. The following features provide support for viewing Azure DevOps data through the web portal:
* **Dashboards** are customizable interactive signboards that provide real-time information. Dashboards are associated with a team or a project and display configurable charts and widgets.
* **Charts** are query-based status or trend charts derived from a work item query or test results.
* **Widgets** display configurable information and charts on dashboards. The widget catalog provides brief descriptions of those widgets available to you.
* **In-context reports** are system-generated charts that support specific services. Examples are team velocity, sprint burndown, etc. These reports are displayed on the Analytics tab for a specific service and derive data from Analytics.

![dashboard-view-with-widgets.png](/.attachments/dashboard-view-with-widgets-27ee33fa-6e27-4b81-a9fb-9dc82fb34105.png)

## Sprint burndown chart
The chart is applied by Scrum teams and helps managers track how many user stories have been completed for a given iteration (sprint). The report allows them to predict how many sprints are needed to complete specific pieces of work, such as features, epics, or projects.

![sprint-burndown-widget.png](/.attachments/sprint-burndown-widget-929286b5-36a2-46a4-9871-6d0ef826bfac.png)

In Azure DevOps there are two sprint accessible burndown charts: the in-context Burndown Trend report viewable from a team sprint backlog and the Sprint Burndown widget you can add to a dashboard. Both the report and the widget derive data from [Analytics](https://learn.microsoft.com/en-us/azure/devops/report/powerbi/what-is-analytics?view=azure-devops). They support monitoring burndown based on a count of work items or a sum of Story Points/Size/Effort, Remaining Work, or other numeric field.

![open-analytics.png](/.attachments/open-analytics-c86f8293-753c-4f85-8dbf-d300c2ada1ba.png)

## Sprint velocity chart
Velocity is an important Agile metric used by Scrum development teams. It represents the average amount of work items that can be completed during a single iteration (sprint). Velocity provides an indication of how much work a team can complete during a sprint based on either:
* A count of work items completed.
* The sum of estimates made to:
  * Effort (product backlog items).
  * Story Points (user stories).
  * Size (requirements).

![team-velocity-six-iterations.png](/.attachments/team-velocity-six-iterations-48be7502-59f8-46d4-b9b4-8fe34347c9cd.png)

There are two velocity charts: the in-context report you can view from a team backlog or Kanban board and the Velocity widget you can add to a dashboard. Velocity reports are available for each backlog level, both product and portfolio backlogs. Each report provides interactive controls to provide each user the view of interest to them.

![analytics-summary-cfd-velocity.png](/.attachments/analytics-summary-cfd-velocity-84544a80-d243-448c-bdc2-eb777d2b8332.png)

## Work tracking charts
You can quickly view the status of work in progress by charting the results of a [flat-list query](https://learn.microsoft.com/en-us/azure/devops/boards/queries/using-queries?view=azure-devops). Charts support viewing a count of work items or a sum of values for select numeric fields, such as Story Points, Effort, or Remaining Work. Group work by State, Assigned To, or other system defined or custom field. For example, the following image illustrates two different charts created from the same flat-list query. You can find more details about charts [here](https://learn.microsoft.com/en-us/azure/devops/report/dashboards/charts?view=azure-devops).

![active-bug-charts-on-dashboards-2019.png](/.attachments/active-bug-charts-on-dashboards-2019-be914ca1-4151-41d2-8a91-d3cdeb6e7650.png)

# Reference links
* [Five agile metrics you won't hate](https://www.atlassian.com/agile/project-management/metrics)
* [What Is Reporting in Agile and How It Helps You To Optimize Your Delivery Process? ](https://kanbanize.com/agile/project-management/reporting)
* [About dashboards, charts, reports, & widgets](https://learn.microsoft.com/en-us/azure/devops/report/dashboards/overview?view=azure-devops)
* [Configure and monitor sprint burndown](https://learn.microsoft.com/en-us/azure/devops/report/dashboards/configure-sprint-burndown?view=azure-devops)
* [View or configure team velocity](https://learn.microsoft.com/en-us/azure/devops/report/dashboards/team-velocity?view=azure-devops)
* [Track progress with status and trend query-based charts](https://learn.microsoft.com/en-us/azure/devops/report/dashboards/charts?view=azure-devops)