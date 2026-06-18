SELECT 
    isfraud,
    ROUND(AVG(transactionamt)::numeric, 2) AS avg_amount,
    ROUND(MIN(transactionamt)::numeric, 2) AS min_amount,
    ROUND(MAX(transactionamt)::numeric, 2) AS max_amount,
    COUNT(*) AS total
FROM fact_transactions
GROUP BY isfraud;

SELECT 
    i.devicetype,
    COUNT(*) AS total,
    SUM(t.isfraud) AS fraud_count,
    ROUND(SUM(t.isfraud) * 100.0 / COUNT(*), 2) AS fraud_rate_pct
FROM fact_transactions t
JOIN dim_identity i ON t.transactionid = i.transactionid
WHERE i.devicetype IS NOT NULL
GROUP BY i.devicetype
ORDER BY fraud_rate_pct DESC;

SELECT 
    card4,
    COUNT(*) AS total,
    SUM(isfraud) AS fraud_count,
    ROUND(SUM(isfraud) * 100.0 / COUNT(*), 2) AS fraud_rate_pct
FROM fact_transactions
WHERE card4 IS NOT NULL
GROUP BY card4
ORDER BY fraud_rate_pct DESC;

SELECT 
    transactionid,
    transactionamt,
    productcd,
    card4
FROM fact_transactions
WHERE isfraud = 1
ORDER BY transactionamt DESC
LIMIT 10;

SELECT 
    productcd,
    COUNT(*) AS total_transactions,
    SUM(isfraud) AS fraud_count,
    ROUND(SUM(isfraud) * 100.0 / COUNT(*), 2) AS fraud_rate_pct
FROM fact_transactions
GROUP BY productcd
ORDER BY fraud_rate_pct DESC;