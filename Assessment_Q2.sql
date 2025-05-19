WITH transactions_per_customer AS (
    SELECT
        owner_id,
        YEAR(transaction_date) AS year,
        MONTH(transaction_date) AS month,
        COUNT(*) AS transactions_in_month
    FROM savings_savingsaccount
    GROUP BY owner_id, year, month
),

avg_transactions AS (
    SELECT
        owner_id,
        AVG(transactions_in_month) AS avg_transactions_per_month
    FROM transactions_per_customer
    GROUP BY owner_id
)

SELECT
    CASE
	WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
	WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
	ELSE 'Low Frequency'
    END AS frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month
FROM avg_transactions
GROUP BY frequency_category
ORDER BY
    CASE frequency_category
	WHEN 'High Frequency' THEN 1
	WHEN 'Medium Frequency' THEN 2
	WHEN 'Low Frequency' THEN 3
END;
