[[_TOC_]]

# CLIENT's COMPANY OVERVIEW

You work as a DevOps engineer for a company «Wey» that delivers cargo into space. The company has already taken the first steps in Public Cloud adoption as a part of IT-Landscape modernization. According to Cloud adoption program Azure Landing Zones approach has been defined and already implemented for enterprise scale workloads governance. In addition, one of the business-critical software products, the TrackX application, has been migrated straight away to Azure, applying lift-and-shift approach.  

TrackX application is used by «Wey» company to calculate the optimal trajectory to the station and tracks the cargo during the delivery. The company won a new critical contract for delivery. The contract aims to deliver cargo to the «Prometheus» station. The station is engaged in deep space exploration and in preparation for a new mission to explore the LV-223 object. Due to the orbital position of the station, the cargo must be delivered within N weeks to the station. The new contract requires more compute and storage capacity for the TrackX application, than exists within the Private Cloud. It was necessary to migrate the application as soon as possible to support the upcoming increase in workload before the existing on-premise data center reaches its limits.  

After the migration of TrackX Application to Azure, it works as expected and able to support required business load.

However, the product team faces other difficulties. Besides of the fact, that TrackX application requires frequent configuration updates during cargo formation within each new cargo delivery, and the load has been increased significantly. And also «Wey»'s company management wants to bring new functionality to the application to be able to support other space station types, and not only «Prometheus» station. Obviously this will require frequent application updates and upgrades in nearest future, but current software delivery model is unoptimized, complex, and requires business interruption during upgrades.

Product team decided eliminate current problems, optimize the software delivery process and ensure the software quality. As a part of these activates, the product team has already established and implemented the replatforming of TrackX application workload by designing microservices architecture and hosting it on K8s platform in Azure.

You need to help the product team make it happen.

# Current Issues / Challenges Highlights

The company has the following issues or challenges that need to be solved:

- Software delivery model is unoptimized and does not support frequent production updates;
- TrackX application upgrades require business interruption;
- Application failures or abnormal behavior are noticed primarily by the service consumers, which damages the reputation and SLA penalties for the "Wey" company;
- Required software quality of the application can be achieved with a significant amount of effort, which company cannot afford from time to time because of tight deadlines.

# EXPECTED OUTCOMES

Client expects following deliverables:  

1. Deployed a new infrastructure for the TrackX application, applying Azure Cloud native solutions, like AKS.
2. Defined and implemented software delivery model which supports frequent production updates.
3. Software delivery model ensures that only tested software in a desired quality will be delivered to production.
4. Production upgrade of the TrackX application will not interrupt business processes.

# PROJECT TIMELINES

The deployment of the new application instance and handover it to the operation must be done as per the agreed project timeline. Any deviation from the plan will cause reputation and financial damage:

![CSS_CNP_ProjectPlan.png](/.attachments/CSS_CNP_ProjectPlan.png)

# PROJECT ACTIVITIES

In the section below, you can find all the requirements and necessary implementation details for all components, in order to deliver expected by client outcomes.

:heavy_exclamation_mark: <u>Please follow the document structure below to procced with project deliverables.</u>  

> Note: Current page can be used as **home page** for reference.

## CURRENT IMPLEMENTATION OVERVIEW

The TrackX software is an essential tool used by the "Wey" company to optimize the delivery process and track cargo in real-time. While the application replatforming is not part of the current project scope, the client has requested a well-defined and executed software delivery model that ensures optimal software quality and supports frequent and non-disruptive software upgrades. To achieve this, it is imperative to conduct a thorough analysis of the existing setup before starting the agreed-upon project delivery.

:heavy_exclamation_mark: Following documentation describes current implementation of the TrackX infrastructure and and it's software delivery model: [00_TrackX_Application_Overview](/Cloud-Native-Pipelines-Project/00_TrackX_Application_Overview.md)

## PROJECT DELIVERY REPORTING

To ensure effective communication between the client and the delivery team and maintain transparency regarding the progress of the project delivery, it has been decided to implement a project management process before commencing the actual project delivery. This process will provide clarity on the entire delivery process and enable visibility into the project lifecycle.

:heavy_exclamation_mark: Following documentation describes Project Management setup requirements: [01_Project Management](/Cloud-Native-Pipelines-Project/01_Project-Management.md)

## IMPROVE SOFTWARE DELIVERY VELOCITY

"Wey" company desires to enhance the software delivery velocity of TrackX software product to achieve faster and more efficient delivery. This involves reducing the time it takes to develop and deliver the software, minimizing delays, and increasing the frequency of software releases while ensuring stability and reliability. The primary objective is to improve the overall quality of TrackX software product while delivering them to customers in a timely and efficient manner.

:heavy_exclamation_mark: Following documentation describes software delivery velocity requirements: [02_Software_Delivery_Velocity.md](/Cloud-Native-Pipelines-Project/02_Software_Delivery_Velocity.md)

## IMPROVE SOFTWARE DELIVERY QUALITY

"Wey" company wants to ensure the timely delivery of TrackX software product that meet or exceed customer's expectations. To achieve this, product team considers to adopt a shift-left testing approach, which involves introducing testing earlier in the development process to catch defects and issues before they become more costly to fix. The aim is to provide a software delivery process that consistently delivers high-quality software products, while reducing costs, minimizing defects and rework, and improving customer satisfaction.

:heavy_exclamation_mark: Following documentation describes software delivery quality requirements: [03_Software_Quality_And_Stability.md](/Cloud-Native-Pipelines-Project/03_Software_Quality_And_Stability.md)

## ZERO DOWNTIME APPLICATION UPGRADE

To minimize the impact of TrackX software upgrades on their business operations and reduce the risk of revenue loss and reputational damage, "Wey" company expects a software delivery process that ensures uninterrupted availability of TrackX software products and minimizes downtime. This can be achieved through the implementation of a zero-downtime deployment approach, which allows for the seamless transition between software versions without any interruption in service. By adopting this approach, "Wey" company can expect to maintain continuous availability of their software products, reduce the risk of service disruptions, and improve customer satisfaction.

:heavy_exclamation_mark: Following documentation describes software upgrade requirements: [04_Zero_Downtime.md](/Cloud-Native-Pipelines-Project/04_Zero_Downtime.md)