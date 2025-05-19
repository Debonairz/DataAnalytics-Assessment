SELECT 
    u.id AS Owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS Name,
    COUNT(DISTINCT s.id) AS Savings_count,
    COUNT(DISTINCT p.id) AS Investment_count,
    SUM(s.confirmed_amount) / 100.0 AS Total_deposits
FROM users_customuser u
JOIN savings_savingsaccount s ON u.id = s.owner_id
JOIN plans_plan p ON u.id = p.owner_id
WHERE s.confirmed_amount > 0
  AND p.is_a_fund = 1
GROUP BY u.id, u.first_name, u.last_name
HAVING savings_count >= 1 AND investment_count >= 1
ORDER BY total_deposits DESC;