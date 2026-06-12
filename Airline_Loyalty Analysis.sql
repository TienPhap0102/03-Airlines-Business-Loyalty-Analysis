SELECT TOP 1000*
FROM Calendar
;
SELECT TOP 1000*
FROM [Customer Flight Activity]
;
SELECT TOP 1000*
FROM [Customer Loyalty History]
;
--- COUNT NULL values
SELECT COUNT(*) AS total_rows
        , SUM(CASE WHEN Loyalty_Number IS NULL THEN 1 ELSE 0 END) AS NULL_loyalty_number
        , SUM(CASE WHEN [Year] IS NULL THEN 1 ELSE 0 END) AS NULL_year 
        , SUM(CASE WHEN [Month] IS NULL THEN 1 ELSE 0 END) AS NULL_month 
        , SUM(CASE WHEN Total_Flights IS NULL THEN 1 ELSE 0 END) AS NULL_total_flight
        , SUM(CASE WHEN Distance IS NULL THEN 1 ELSE 0 END) AS NULL_distance
        , SUM(CASE WHEN Points_Accumulated IS NULL THEN 1 ELSE 0 END) AS NULL_accumulated
        , SUM(CASE WHEN Points_Redeemed IS NULL THEN 1 ELSE 0 END) AS NULL_redeemed
        , SUM(CASE WHEN Dollar_Cost_Points_Redeemed IS NULL THEN 1 ELSE 0 END) AS NULL_cost
FROM [Customer Flight Activity]

;
---- COUNT NULL values
SELECT COUNT(*) AS total_rows ,
        SUM(CASE WHEN Loyalty_Number IS NULL THEN 1 ELSE 0 END) AS NULL_loyalty_number
        , SUM(CASE WHEN Country IS NULL THEN 1 ELSE 0 END) AS NULL_Country
        , SUM(CASE WHEN Province IS NULL THEN 1 ELSE 0 END) AS NULL_province
        , SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS NULL_city
        , SUM(CASE WHEN Postal_Code IS NULL THEN 1 ELSE 0 END) AS NULL_postal_code
        , SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS NULL_gender
        , SUM(CASE WHEN Education IS NULL THEN 1 ELSE 0 END) AS NULL_education
        , SUM(CASE WHEN Salary IS NULL THEN 1 ELSE 0 END) AS NULL_salary                       
        , SUM(CASE WHEN Marital_Status IS NULL THEN 1 ELSE 0 END) AS NULL_marital
        , SUM(CASE WHEN Loyalty_Card IS NULL THEN 1 ELSE 0 END) AS NULL_loyalty_card
        , SUM(CASE WHEN CLV IS NULL THEN 1 ELSE 0 END) AS NULL_CLV
        , SUM(CASE WHEN Enrollment_Type IS NULL THEN 1 ELSE 0 END) AS NULL_enrollment_type
        , SUM(CASE WHEN Enrollment_Month IS NULL THEN 1 ELSE 0 END) AS NULL_enrollment_month
        , SUM(CASE WHEN Cancellation_Year IS NULL THEN 1 ELSE 0 END) AS NULL_cancellation_year 
        , SUM(CASE WHEN Cancellation_Month IS NULL THEN 1 ELSE 0 END) AS NULL_cancellation_month 
FROM [Customer Loyalty History]
;

---- Kiểm tra giá trị bất trường trong dữ liệu 
SELECT *
FROM [Customer Loyalty History] 
WHERE Salary < 0 
        OR (Cancellation_Year IS NOT NULL AND Cancellation_Month IS NULL)
        OR (Cancellation_Year IS NULL AND Cancellation_Month IS NOT NULL)

--- Có 20 giá trị salary ÂM 
--- UPDATE lại 
UPDATE [Customer Loyalty History]
SET Salary = ABS(Salary)
WHERE Salary <0
;
---- Có 4238 giá trị NULL salary 
--- UPDATE lại 
UPDATE [Customer Loyalty History]
SET Salary = 0 
WHERE Salary IS NULL 
;

SELECT COUNT(DISTINCT Loyalty_Number) AS Total_customers 
        , SUM(Total_Flights) AS Total_flights
        , SUM(Total_Flights) * 1.00 / COUNT(DISTINCT Loyalty_Number) AS Avg_flight_per_customer
        , ROUND(AVG(Distance),2) AS AVG_Distance 
        , SUM(Points_Redeemed) * 1.00 / COUNT(DISTINCT Loyalty_Number) AS AVG_Redemption_rate_by_customers
        , SUM(Points_Redeemed) * 1.00 / SUM(Total_Flights) AS AVG_Redemption_rate_by_flights
        , SUM(Dollar_Cost_Points_Redeemed) AS Total_cost_redeemed 
        , SUM(Dollar_Cost_Points_Redeemed) * 1.00 / SUM(Total_Flights) AS Cost_redeemed_per_flights
        ,  SUM(Dollar_Cost_Points_Redeemed) * 1.00 / COUNT(DISTINCT Loyalty_Number) AS Cost_redeemed_per_customers
FROM [Customer Flight Activity]


;
WITH based AS (
SELECT DATEFROMPARTS([Year], [Month], 1) AS [Time] 
        , COUNT(DISTINCT Loyalty_Number) AS Total_customers 
        , SUM(Total_Flights) AS Total_flights 
        , 1.00 * SUM(Total_Flights) / COUNT(DISTINCT Loyalty_Number) AS Flight_per_customers 
        , AVG(Distance) AS Average_distance 
        , 1.00 * SUM(Points_Redeemed) / SUM(Total_Flights) AS Average_redeem 
        , SUM(Dollar_Cost_Points_Redeemed) AS Total_cost_Redeem 
        , 1.00 * SUM(Dollar_Cost_Points_Redeemed) / SUM(Total_Flights) AS Cost_per_flight
FROM [Customer Flight Activity]
GROUP BY DATEFROMPARTS([Year], [Month], 1) 
),
Previous AS (
        SELECT *,
                LAG(Total_flights) OVER(ORDER BY Time) AS Previous_month

        FROM based
)
SELECT *, 
        (Total_flights - Previous_month) * 1.00 / Previous_month AS MOM_growth 
FROM Previous

;

SELECT 
        SUM(Total_Flights) AS Total_flights
        , CASE 
                WHEN Distance <= 5000 THEN '1 - 5.000 Km'
                WHEN Distance <= 15000 THEN '5.001 - 15.00 Km'
                WHEN Distance <= 30000 THEN '15.001 - 30.000 Km'
                WHEN Distance <= 50000 THEN '30.001 - 50.000 Km' 
                WHEN Distance > 50000 THEN '50.000+ Km'    
        END AS Distance_range
FROM [Customer Flight Activity]
GROUP BY 
        CASE 
                WHEN Distance <= 5000 THEN '1 - 5.000 Km'
                WHEN Distance <= 15000 THEN '5.001 - 15.00 Km'
                WHEN Distance <= 30000 THEN '15.001 - 30.000 Km'
                WHEN Distance <= 50000 THEN '30.001 - 50.000 Km' 
                WHEN Distance > 50000 THEN '50.000+ Km'    
        END
; 

        SELECT t2.Loyalty_Card
                , AVG(Salary) AS AVG_salary
                , AVG(Points_Accumulated) AS Avg_pts_accumulated
                , AVG(CLV) AS AVG_CLV
        FROM [Customer Flight Activity] t1 
        LEFT JOIN [Customer Loyalty History] t2 ON t1.Loyalty_Number = t2.Loyalty_Number
        GROUP BY t2.Loyalty_Card
;
 WITH tiered AS (
        SELECT *,
                NTILE(3) OVER(ORDER BY CLV) AS CLV_ranking
        FROM [Customer Loyalty History]
 ),
tiers AS (
        SELECT 
                CASE 
                        WHEN CLV_ranking = 1 THEN 'Star'
                        WHEN CLV_ranking = 2 THEN 'Nova'
                        ELSE 'Aurora'
                END AS tier,
                Gender, Education, Marital_Status, Province, Salary, CLV
        FROM tiered
)
SELECT
        tier,
        COUNT(*) AS total_customers
        , AVG(Salary) AS AVG_salary 
        , AVG(CLV) AS AVG_CLV 
--- GENDER
        , 1.0 * SUM(CASE WHEN Gender = 'Male' THEN 1 ELSE 0 END) / COUNT(*) AS Pct_male 
        , 1.0 * SUM(CASE WHEN Gender = 'Female' THEN 1 ELSE 0 END) / COUNT(*) AS Pct_female 
--- married
        , 1.0 * SUM(CASE WHEN Marital_Status = 'Married' THEN 1 ELSE 0 END) / COUNT(*) AS Pct_married
        , 1.0 * SUM(CASE WHEN Marital_Status = 'Single' THEN 1 ELSE 0 END) / COUNT(*) AS Pct_single
        , 1.0 * SUM(CASE WHEN Marital_Status = 'Divorced' THEN 1 ELSE 0 END) / COUNT(*) AS Pct_divorced
--- Education
        , 1.0 * SUM(CASE WHEN Education = 'Bachelor' THEN 1 ELSE 0 END) / COUNT(*) AS Pct_Bachelor
        , 1.0 * SUM(CASE WHEN Education = 'College' THEN 1 ELSE 0 END) / COUNT(*) AS Pct_College
        , 1.0 * SUM(CASE WHEN Education = 'Doctor' THEN 1 ELSE 0 END) / COUNT(*) AS Pct_Doctor
        , 1.0 * SUM(CASE WHEN Education = 'High School or Below' THEN 1 ELSE 0 END) / COUNT(*) AS Pct_High_school
        , 1.0 * SUM(CASE WHEN Education = 'Master' THEN 1 ELSE 0 END) / COUNT(*) AS Pct_Master
FROM tiers
GROUP BY tier
;


WITH cust AS (
        SELECT Loyalty_Number
                , Enrollment_Type
                , CLV
                , Cancellation_Year
        FROM [Customer Loyalty History]
),
flights AS (
          SELECT
        Loyalty_Number,
        SUM(Total_Flights) AS total_flights
    FROM [Customer Flight Activity]
    GROUP BY Loyalty_Number
)
SELECT t1.enrollment_Type, 
        COUNT(DISTINCT t1.Loyalty_Number) AS Total_customers
        , SUM(total_flights) AS Total_flights
        , SUM(CASE WHEN Cancellation_Year IS NULL THEN 1 ELSE 0 END) AS active_customers 
        , 1.00*SUM(CASE WHEN Cancellation_Year IS NULL THEN 1 ELSE 0 END)/COUNT(DISTINCT t1.Loyalty_Number)
                AS Retention_rate
        , ROUND(AVG(CLV),2) AS Avg_CLV 
        , ROUND(SUM(total_flights)*1.00/COUNT(DISTINCT t1.Loyalty_Number),2) AS Avg_flight_per_customer
FROM cust t1 
LEFT JOIN flights t2 On t1.Loyalty_Number = t2.Loyalty_Number
GROUP BY Enrollment_Type
ORDER BY Retention_rate DESC

;

        SELECT DATEFROMPARTS([Year], [Month], 1) AS Time ,
                Loyalty_Card ,
                COUNT(DISTINCT t1.Loyalty_Number) AS Total_customers
                , SUM(Total_Flights) AS Total_flights 
                , SUM(Points_Accumulated) AS Total_point_acc
                , SUM(Points_Redeemed) AS Total_point_redeemed
                , SUM(Dollar_Cost_Points_Redeemed) AS Total_cost_redeemed
        FROM [Customer Loyalty History] t1 
        LEFT JOIN [Customer Flight Activity] t2 ON t1.Loyalty_Number = t2.Loyalty_Number
        GROUP BY Loyalty_Card, DATEFROMPARTS([Year], [Month], 1)
        ORDER BY Loyalty_Card
;

SELECT DATEFROMPARTS([Year], [Month], 1) AS Time 
        , Loyalty_Card
        , SUM(Total_Flights) AS Total_flights 
FROM [Customer Flight Activity] t1 
LEFT JOIN [Customer Loyalty History] t2 ON t1.Loyalty_Number = t2.Loyalty_Number
GROUP BY DATEFROMPARTS([Year], [Month], 1), Loyalty_Card
ORDER BY Loyalty_Card























