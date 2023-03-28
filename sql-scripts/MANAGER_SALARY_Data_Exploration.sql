-- PART 2: DATA EXPLORATION

-- GOAL 1: FIND THE AVERAGE ANNUAL SALARY OF MANAGERS PER INDUSTRY, RANKED BY THEIR SALARY IN DESCENDING ORDER
-- Goal 2: DETERMINE THE PERCENTAGE OF WOMEN IN THE INDUSTRY
-- Note: Results were filtered such that sample size > 30
--       When not filtered, results will include industries with small sample sizes
--       which may not be reliable data

SELECT *,
ROUND(CAST([Woman Count] AS float)/[Sample Size], 2) [Woman Share]
FROM (
	SELECT Industry, 
	ROUND(AVG([Annual Salary (USD)]),0) [Average Annual Salary (USD)],
	SUM(CASE WHEN Gender = 'Woman' THEN 1 ELSE 0 END) [Woman Count],
	COUNT(Industry) [Sample Size]
	FROM MANAGER_SALARY..salary
	WHERE Industry IS NOT NULL
	GROUP BY Industry
	HAVING COUNT(Industry) >30
) subquery
ORDER BY [Average Annual Salary (USD)] DESC

----------------------------------------------------

-- GOAL 1: DETERMINE THE AVERAGE ANNUAL SALARY PER AGE GROUP
-- GOAL 2: SHOW THE PERCENT SHARE OF EACH HIGHEST EDUCATIONAL ATTAINMENT CATEGORY PER AGE GROUP
UPDATE MANAGER_SALARY..Salary
SET Age = '0-18' WHERE Age = 'under 18'

SELECT Age, 
	   [Average Annual Salary (USD)],
       ROUND(CAST([High School] AS float)/[Sample Size]*100,2) [High School (%)],
	   ROUND(CAST([College Degree] AS float)/[Sample Size]*100,2) [College Degree (%)],
	   ROUND(CAST([Master's degree] AS float)/[Sample Size]*100,2) [Master's degree (%)],
	   ROUND(CAST([PhD] AS float)/[Sample Size]*100,2) [PhD (%)],
	   ROUND(CAST([Professional degree] AS float)/[Sample Size]*100,2) [Professional degree (%)]
FROM (
	SELECT Age, 
	ROUND(AVG([Annual Salary (USD)]),0) [Average Annual Salary (USD)],
	SUM(CASE WHEN Education = 'High School' THEN 1 ELSE 0 END) [High School],
	SUM(CASE WHEN Education = 'College degree' THEN 1 ELSE 0 END) [College degree],
	SUM(CASE WHEN Education = 'Master''s degree' THEN 1 ELSE 0 END) [Master's degree],
	SUM(CASE WHEN Education = 'PhD' THEN 1 ELSE 0 END) [PhD],
	SUM(CASE WHEN Education = 'Professional degree' THEN 1 ELSE 0 END) [Professional degree],
	COUNT(Education) [Sample Size]
	FROM MANAGER_SALARY..salary
	GROUP BY Age
) subquery
ORDER BY Age 
----------------------------------------------------

-- GOAL: DETERMINE THE AVERAGE ANNUAL SALARY FOR MEN AND WOMEN, SEPARATELY, IN EACH INDUSTRY

SElECT Industry, 
	   ROUND(AVG(CASE WHEN Gender = 'Woman' THEN [Annual Salary (USD)] ELSE NULL END),0) [Annual Salary (Women)],
	   ROUND(AVG(CASE WHEN Gender = 'Man' THEN [Annual Salary (USD)] ELSE NULL END),0) [Annual Salary (Men)]
FROM MANAGER_SALARY..salary
WHERE GENDER IS NOT NULL AND
	   Industry IS NOT NULL
GROUP BY Industry
HAVING COUNT(Industry) > 30


----------------------------------------------------

-- GOAL 1: FILTER THE INDUSTRIES WHERE WOMEN ARE PAID HIGHER THAN MEN
-- GOAL 2: SHOW HOW MUCH HIGHER THE PAY IS FOR WOMEN IN PERCENTAGE
SELECT Industry,
	   ROUND(([Annual Salary (Women)] - [Annual Salary (Men)])/[Annual Salary (Women)] * 100,2) [Percent Difference]
FROM (
	SElECT Industry, 
		   ROUND(AVG([Annual Salary (USD)]),0) [Average Annual Salary (USD)],
		   ROUND(AVG(CASE WHEN Gender = 'Woman' THEN [Annual Salary (USD)] ELSE NULL END),0) [Annual Salary (Women)],
		   ROUND(AVG(CASE WHEN Gender = 'Man' THEN [Annual Salary (USD)] ELSE NULL END),0) [Annual Salary (Men)]
	FROM MANAGER_SALARY..salary
	WHERE GENDER IS NOT NULL AND
		  Industry IS NOT NULL
	GROUP BY Industry
	HAVING COUNT(Industry) > 30
) subquery
WHERE [Annual Salary (Women)] > [Annual Salary (MEN)]
ORDER BY ([Annual Salary (Women)] - [Annual Salary (MEN)]) DESC 

