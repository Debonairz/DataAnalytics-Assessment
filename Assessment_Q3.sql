WITH last_savings_txn AS (
    SELECT 
        plan_id,
        owner_id,
        MAX(transaction_date) AS last_transaction_date,
        'Savings' AS type
    FROM savings_savingsaccount
    GROUP BY plan_id, owner_id
),

last_investment_txn AS (
    SELECT 
        id AS plan_id,
        owner_id,
        NULL AS last_transaction_date,
        'Investment' AS type
    FROM plans_plan
    WHERE is_a_fund = 1
), -- Last transaction date for investment plan

combined AS (
    SELECT 
        l.plan_id,
        l.owner_id,
        l.last_transaction_date,
        l.type
    FROM last_savings_txn l
    UNION ALL
    SELECT 
        p.id,
        p.owner_id,
        NULL,
        'Investment'
    FROM plans_plan p
    WHERE p.is_a_fund = 1
)

SELECT 
    c.plan_id,
    c.owner_id,
    c.type,
    COALESCE(c.last_transaction_date, '1900-01-01') AS last_transaction_date,

    -- Calculate inactivity days
    DATEDIFF(CURRENT_DATE, COALESCE(c.last_transaction_date, '1900-01-01')) AS inactivity_days

FROM combined c
JOIN plans_plan p ON c.plan_id = p.id
WHERE p.status_id = 1
    AND (c.last_transaction_date IS NULL OR
        c.last_transaction_date < DATE_SUB(CURRENT_DATE, INTERVAL 365 DAY)) -- inactive over 365 days and only active plans
ORDER BY inactivity_days DESC;
