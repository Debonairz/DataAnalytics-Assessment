# Data Analyst SQL Assessment

## Project: DataAnalytics-Assessment

This repository contains my solutions to a SQL-based data analytics assessment aimed at testing critical skills in querying relational data, analyzing customer behavior, and drawing meaningful insights from transaction records. The tasks presented a mix of real-world business questions requiring both technical knowledge and strategic thinking.

---

## Question 1: High-Value Customers with Multiple Products

**Objective:**  
To identify customers who have both a funded savings account and an active investment plan, in order to support cross-selling initiatives.

**My Approach:**  
I started by joining the `users_customuser`, `savings_savingsaccount`, and `plans_plan` tables using `owner_id` as the linking key. I filtered the savings data to include only transactions with a `confirmed_amount > 0`, ensuring that only actual funded accounts were considered. Similarly, I filtered investment plans using `is_a_fund = 1`. I grouped the data by customer and counted the number of funded savings and investment plans per user. I then summed the confirmed deposit amounts and converted them from kobo to naira. Finally, I filtered the grouped results to include only those customers who had at least one of each product type and sorted them by total deposits.

**Challenges Faced:**  
One key challenge was avoiding double-counting due to joins. To address this, I used `COUNT(DISTINCT ...)` for savings and investment counts. Ensuring accurate monetary conversion from kobo to naira also required attention to detail.

---

## Question 2: Transaction Frequency Analysis

**Objective:**  
To categorize customers based on how frequently they engage in savings transactions on a monthly basis.

**My Approach:**  
I began by calculating the total number of transactions per customer from the `savings_savingsaccount` table. To estimate monthly frequency, I computed the time span between each customer’s earliest and latest transaction, converted it into months, and used that to determine the average transactions per month. I then used a `CASE` expression to classify customers as "High", "Medium", or "Low Frequency" based on the defined thresholds. Lastly, I aggregated the counts for each frequency category and calculated their average monthly transaction rate.

**Challenges Faced:**  
A major consideration was handling cases where users had transactions within a single month or very short timeframes, which could skew averages or lead to divide-by-zero errors. To prevent this, I applied `NULLIF` within the division and made sure to include a minimum threshold of 1 month in the active period calculations.

---

## Question 3: Account Inactivity Alert

**Objective:**  
To flag active savings and investment accounts with no inflow activity for over a year (365 days).

**My Approach:**  
I worked with both `savings_savingsaccount` and `plans_plan` tables. For savings, I retrieved the most recent transaction date per account. For investment accounts, I limited the selection to rows where `is_a_fund = 1`. I used `DATEDIFF` against `CURRENT_DATE` to determine inactivity duration. Both result sets were combined using `UNION ALL`, and accounts with `inactivity_days > 365` were flagged.

**Challenges Faced:**  
Since savings and investments are stored in separate tables with different behaviors, I had to normalize the outputs and ensure a consistent structure before merging. Managing date comparisons and ensuring timezone-consistent values was another area I paid attention to during implementation.

---

## Question 4: Customer Lifetime Value (CLV) Estimation

**Objective:**  
To estimate customer lifetime value using a simplified model based on tenure and transaction volume.

**My Approach:**  
I used the `users_customuser` and `savings_savingsaccount` tables. I calculated each customer's tenure in months from their `date_joined` to the current date. I summed up the confirmed transaction amounts and counted total transactions. Using the assumption that profit per transaction is 0.1% of its value, I calculated the average profit and plugged it into a simplified CLV formula:  
\[
CLV = \left( \frac{\text{Total Transactions}}{\text{Tenure}} \right) \times 12 \times \text{Average Profit per Transaction}
\]  
Finally, I ordered the customers by their estimated CLV in descending order to highlight the most valuable users.

**Challenges Faced:**  
Ensuring data quality for tenure calculations was key—some users had minimal transaction activity or very recent signup dates. I also had to make sure that division operations didn’t fail by guarding with `NULLIF` to prevent divide-by-zero errors.

---

## Tools Used

- MySQL 8.0.42
- MySQL Workbench

---

## Assumptions & Limitations

- All amounts are stored in kobo and were converted to naira for reporting purposes.
- Only confirmed savings transactions were considered to reflect actual customer funding behavior.
- Customer tenure is calculated from the sign-up date to the current date.
- The CLV model is simplified and does not include factors like churn probability or customer acquisition cost.
