# **Project #1 - Streaming Video Subscriptions Analysis**

### 📖 Table of Contents
- [About the Project](#-about-the-project)
- [Links to Project Files](#-links-to-project-files)
- [Tools and Techniques](#-tools-and-techniques)
- [About the Data](#-about-the-data)
- [Dataset limitations](#-dataset-limitations)
- [Summary](#-summary)
- [Recommendation](#-recommendation)

### 📄 **About the project:** 

Subscription records for MavenFlix, a fictitious video streaming platform. The goal was to uncover subscription trends, how long a customer uses the platform, and what are the best and worst months, using **MySQL** and **Tableau.** 


<ins>Key Requirements:</ins><br/>
• Display a summary of total number of new and churned users for each month<br/>
• Identify the months with the highest and lowest number of new/churned users<br/>
• Display the percentage of users that stays less than 5 months<br/>
• Present the duration of subsriptions<br/>

<ins>Sales Trends:</ins><br/>
• Show total profit per months<br/>
• Show changes in profit each months<br/>

### 🔗 **Links to Project Files:**

A **Tableau dashboard** can be found [here](https://public.tableau.com/app/profile/boglarka.toth3838/viz/mavenflix_modified/Analysis-Canceled?publish=yes)<br/>
**Data Cleaning with SQL** can be found [here](https://github.com/bogitoth5/PortfolioProjects/blob/main/MavenFlix_Analysis/mavenflix_data_cleaning_sql)<br/>
**EDA in SQL** can be found [here](https://github.com/bogitoth5/PortfolioProjects/blob/main/MavenFlix_Analysis/mavenflix_analysis_sql)

### 🔧 **Tools and Techniques:**

**MySQL:** Data cleaning, Common Table Expressions (CTEs), Window Functions(LAG), Date Functions, Conditional queries, handling NULL<br/>
**Tableau:** Interactive dashboard creation (user trends, profit information)

### 📋 **About the data:** 

Dataset includes information about ~2,800 subscribers from September 2022 through September 2023. Each record represents an individual customer's subscription, including the subscription cost, created/canceled date, interval, and payment status. New columns such as Subscription Lenght, Subscription Lenght(String) and Over 5 months were created to identify the lenght of the subsription. 

<p align="center">
  <img width="446" height="434" src="https://github.com/bogitoth5/PortfolioProjects/blob/main/MavenFlix_Analysis/images/tableau_data_mavenflix.PNG">
</p>

### ⚠️ Dataset limitations:

• The dataset spans from September 2022 to August 2023, limiting the ability to conduct a comprehensive seasonal analysis.

### 📊 **Summary**

<ins>Overview of Findings:</ins>

The data shows that MavenFlix had a higher-than-average number of new users during only a few months: **early 2023 and summer 2023**. In most months, the number of new subscribers stayed close to the average. However, there isn’t enough data to confirm if the increases in new users during those periods are due to seasonal trends.

On the other hand, cancellations have been steadily rising since September 2022. Starting in February 2023, cancellations have consistently been above the average, with the highest number occurring in June 2023. This sharp increase might be due to competition, such as another service offering better features or pricing. Conducting a user survey could help identify the reasons behind this trend.

Retention is also a concern, as a very high number of the users cancel their subscription before reaching five months. **Only 21% of users** have stayed with MavenFlix for more than five months, including currently active and already canceled users. The highest number of cancellations happens **after just one or two months**. This is another area that could benefit from further investigation, potentially through a user feedback survey.

<p align="center">
  <img width="1031" height="544" src="https://github.com/bogitoth5/PortfolioProjects/blob/main/MavenFlix_Analysis/images/mavenflix_dashboard_canceled1.PNG">
</p>
<p align="center">
Overall analysis, with focus on the subscription duration of canceled users
</p>

<ins>Analysis of Active users:</ins>

MavenFlix has a low retention rate among active users, with few remaining subscribed for more than five months. The majority of active users joined within the last one or two months, and based on cancellation trends, they are likely to cancel after two months. To improve long-term retention, it is recommended to explore strategies for keeping users engaged, such as introducing rewards for continued subscription.<br/>
The visualization below indicates that the majority of currently active users have been subscribed for **1 to 3 months**, highlighting a high proportion of new users. In contrast, the platform has a **very small number** of users who have remained subscribed for 9 months or longer.

<p align="center">
  <img width="954" height="454" src="https://github.com/bogitoth5/PortfolioProjects/blob/main/MavenFlix_Analysis/images/mavenflix_dashboard_active.PNG">
</p>
<p align="center">
Analysis of the subscription duration of active users
</p>

### 📢 **Recommendation**

Based on the uncovered insights, the following recommendations have been provided:

• **Conducting a user survey** would help identify the reason behind the high cancellation rate.<br/>
• **Analyze competitors** to see where MavenFlix can improve its service and offer more value to its users.<br/>
• **Consider introducing different subscription plans** for new users. Right now, there is only one option, and having more variety could help attract and retain users by giving them more choices.<br/>
