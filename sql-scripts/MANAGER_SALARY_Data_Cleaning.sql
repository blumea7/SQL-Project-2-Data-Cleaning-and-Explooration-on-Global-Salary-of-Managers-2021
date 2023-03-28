-- USEFUL QUERIES FOR FAMILIARIZING THE TABLE THAT I CAN REUSE FROM TIME TO TIME

SELECT * FROM MANAGER_SALARY..salary

-- Check Table Schema

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'salary'

---------------------------------------------------------------------------------------
-- PART 1: DATA CLEANING

-- GOAL: RENAME LENGTHY COLUMN NAMES

EXEC sp_rename 'dbo.salary.[How old are you?]', 'Age', 'COLUMN'
EXEC sp_rename 'dbo.salary.[What industry do you work in?]', 'Industry', 'COLUMN'
EXEC sp_rename 'dbo.salary.[Job title]', 'Job Title', 'COLUMN'
EXEC sp_rename 'dbo.salary.[If your job title needs additional context, please clarify here:]', 'Job Specification', 'COLUMN'
EXEC sp_rename 'dbo.salary.[What is your annual salary? (You''ll indicate the currency in a l]', 'Annual Salary', 'COLUMN'
EXEC sp_rename 'dbo.salary.[How much additional monetary compensation do you get, if any (fo]', 'Additional Compensation', 'COLUMN'
EXEC sp_rename 'dbo.salary.[Please indicate the currency]', 'Currency', 'COLUMN'
EXEC sp_rename 'dbo.salary.[If "Other," please indicate the currency here:]', 'CurrencyOther', 'COLUMN'
EXEC sp_rename 'dbo.salary.[If your income needs additional context, please provide it here:]', 'Salary Specification', 'COLUMN'
EXEC sp_rename 'dbo.salary.[What country do you work in?]', 'Country', 'COLUMN'
EXEC sp_rename 'dbo.salary.[If you''re in the U#S#, what state do you work in?]', 'State (USA)', 'COLUMN'
EXEC sp_rename 'dbo.salary.[What city do you work in?]', 'City', 'COLUMN'
EXEC sp_rename 'dbo.salary.[How many years of professional work experience do you have overa]', 'Years of Experience', 'COLUMN'
EXEC sp_rename 'dbo.salary.[How many years of professional work experience do you have in yo]', 'Industry Experience', 'COLUMN'
EXEC sp_rename 'dbo.salary.[What is your highest level of education completed?]', 'Education', 'COLUMN'
EXEC sp_rename 'dbo.salary.[What is your gender?]', 'Gender', 'COLUMN'
EXEC sp_rename 'dbo.salary.[What is your race? (Choose all that apply#)]', 'Race', 'COLUMN'

---------------------------------------------------------------------------------------
-- GOAL: DROP UNNECESSARY COLUMNS

ALTER TABLE MANAGER_SALARY..salary
DROP COLUMN Timestamp,
	 COLUMN F19,
	 COLUMN F20,
	 COLUMN F21,
	 COLUMN F22,
	 COLUMN F23,
	 COLUMN F24

---------------------------------------------------------------------------------------

--GOAL: STANDARDIZE VALUES IN Currency_Other COLUMN INTO ISO 4217 CURRENCY CODES
--		e.g., Change Peso Argentino to ARS, Australian Dollars to AUD/NZD, and so on

SELECT [Annual Salary], Currency, CurrencyOther, Country
FROM MANAGER_SALARY..salary
WHERE Currency = 'Other' AND
	  LEN(CurrencyOther) != 3

SELECT [Annual Salary], Currency, CurrencyOther, Country
FROM MANAGER_SALARY..salary
WHERE Currency IS NULL 

UPDATE MANAGER_SALARY..salary
SET CurrencyOther = CASE WHEN CurrencyOther LIKE '%Argentin%' THEN 'ARS'
						 WHEN CurrencyOther LIKE '%Australian%' THEN 'AUD/NZD'
						 WHEN CurrencyOther LIKE '%Israel%' OR CurrencyOther LIKE '%NIS%' OR CurrencyOther LIKE '%shekel%'THEN 'ILS'
						 WHEN CurrencyOther LIKE '%Norwegian%' THEN 'NOK'
						 WHEN CurrencyOther LIKE '%Thai%' THEN 'THB'
						 WHEN CurrencyOther LIKE '%India%' OR Country = 'India' THEN 'INR'
						 WHEN CurrencyOther LIKE '%US%' OR  CurrencyOther LIKE '%America%' OR Country = 'United States'THEN 'USD'
						 WHEN CurrencyOther LIKE '%Korea%' THEN 'KRW'
						 WHEN CurrencyOther LIKE '%Croatia%' THEN 'HRK'
						 WHEN CurrencyOther LIKE 'PLN%' OR CurrencyOther LIKE '%Polish%' THEN 'PLN'
						 WHEN CurrencyOther LIKE '%BR%' THEN 'BRL'
						 WHEN CurrencyOther LIKE '%Mexican%' THEN 'MXN'
						 WHEN CurrencyOther LIKE '%RMB%' THEN 'CNY'
						 WHEN CurrencyOther LIKE '%Philippine%' THEN 'PHP'
						 WHEN CurrencyOther LIKE '%Singapore%' THEN 'SGD'
						 WHEN CurrencyOther LIKE '%Taiwan%' THEN 'TWD'
						 WHEN CurrencyOther LIKE '%Euro%' THEN 'EUR'
						 WHEN CurrencyOther LIKE '%Danish%' THEN 'DKK'
						 WHEN CurrencyOther LIKE '%czech%' THEN 'CZK'
						 WHEN CurrencyOther LIKE '%czech%' THEN 'CZK'
						 WHEN Country = 'Malaysia' THEN 'MYR'
						 ELSE CurrencyOther
						 END
						 WHERE Currency = 'Other'

----------------------------------------------------
--GOAL 1: TRANSFER DATA FROM COLUMN 'Currency_Other' TO 'Currency'
--		I.E., IF 'Currency' VALUE IS 'Other', REPLACE IT WITH THE VALUE IN 'Currency_Other' COLUMN

--GOAL 2: CORRECT TYPO ERRORS AND STANDARDIZE VALUES IN Currency COLUMN 

SELECT Currency, CurrencyOther
FROM MANAGER_SALARY..salary
WHERE Currency = 'Other'

UPDATE MANAGER_SALARY..salary
SET Currency = CASE WHEN Currency = 'Other' THEN CurrencyOther
				    WHEN Country = 'United States' AND Currency IS NULL THEN 'USD'
					WHEN Country = 'Taiwan' AND Currency = 'NTD' THEN 'TWD'
					WHEN Currency = 'NZD' THEN 'AUD/NZD'
					ELSE UPPER(Currency)
					END

----------------------------------------------------
-- GOAL: REMOVE ROWS WHERE Industry, Job Title, Annual Salary COLUMNS ALL CONTAIN NULL VALUES
--		 AS THESE WILL NOT BE BENEFICIAL IN OUR ANALYSES
					
SELECT COUNT(*)              -- Findings: 93 rows have simultaneouslty empty Industry, Job TItle, and Annual Salary columns
FROM MANAGER_SALARY..salary
WHERE Industry IS NULL AND
	  [Job Title] IS NULL AND
	  [Annual Salary] IS NULL

DELETE FROM MANAGER_SALARY..SALARY
WHERE Industry IS NULL AND
	  [Job Title] IS NULL AND
	  [Annual Salary] IS NULL

----------------------------------------------------
-- GOAL : CONVERT ANNUAL SALARIES TO USD 
-- Limitation: Exchange rates used are based on Mar 14, 2023 04:10 UTC data

SELECT Currency, COUNT(*) count
FROM MANAGER_SALARY..salary
GROUP BY Currency
ORDER BY count DESC

ALTER TABLE MANAGER_SALARY..salary
ADD [Annual Salary (USD)] FLOAT, 
	[Conversion Factor] FLOAT

UPDATE MANAGER_SALARY..salary
SET [Conversion Factor] = CASE WHEN Currency = 'USD' THEN 1.000000
							   WHEN Currency = 'CAD' THEN 0.728354	
							   WHEN Currency = 'GBP' THEN 1.215605
							   WHEN Currency = 'EUR' THEN 1.070543		
							   WHEN Currency = 'AUD/NZD' THEN 0.664371485
							   WHEN Currency = 'SEK' THEN 0.0941
							   WHEN Currency = 'CHF' THEN 1.094371
							   WHEN Currency = 'JPY' THEN 0.007475551
							   WHEN Currency = 'ZAR' THEN 0.054863369
							   WHEN Currency = 'INR' THEN 0.012141822
							   WHEN Currency = 'SGD' THEN 0.741951496
							   WHEN Currency = 'MYR' THEN 0.223211296
							   WHEN Currency = 'DKK' THEN 0.143786745
							   WHEN Currency = 'NOK' THEN 0.094455
							   WHEN Currency = 'PLN' THEN 0.228579
							   WHEN Currency = 'ILS' THEN 0.275965147
							   WHEN Currency = 'BRL' THEN 0.190576
							   WHEN Currency = 'CZK' THEN 0.045058678
							   WHEN Currency = 'PHP' THEN 0.01817455
							   WHEN Currency = 'ARS' THEN 0.004983836
							   WHEN Currency = 'MXN' THEN 0.052838877
							   WHEN Currency = 'KRW' THEN 0.000766989
							   WHEN Currency = 'HKD' THEN 0.127479
							   WHEN Currency = 'THB' THEN 0.028953356
							   WHEN Currency = 'CNY' THEN 0.145556785
							   WHEN Currency = 'IDR' THEN 0.00006504172
							   WHEN Currency = 'TRY' THEN 0.0527
							   WHEN Currency = 'HRK' THEN 7.025481421
							   WHEN Currency = 'LKR' THEN 0.003050453
							   WHEN Currency = 'BDT' THEN 0.0095
							   WHEN Currency = 'TWD' THEN 0.032822
							   WHEN Currency = 'TTD' THEN 0.147781
							   WHEN Currency = 'NGN' THEN 0.0022 
							   WHEN Currency = 'COP' THEN 0.00021
							   WHEN Currency = 'SAR' THEN 0.266667
							   ELSE NULL
							   END

UPDATE MANAGER_SALARY..salary
SET [Annual Salary (USD)] = [Annual Salary] * [Conversion Factor]

----------------------------------------------------
-- GOAL : STANDARDIZE Education VALUES

SELECT Education, COUNT(Education) count
FROM MANAGER_SALARY..salary
GROUP BY Education
ORDER BY count DESC

UPDATE MANAGER_SALARY..salary
SET Education = 'College degree'
WHERE Education = 'Some college'

UPDATE MANAGER_SALARY..salary
SET Education = 'Professional degree'
WHERE Education = 'Professional degree (MD, JD, etc.)'


----------------------------------------------------
-- GOAL : STANDARDIZE Gender VALUES

SELECT Gender, COUNT(Gender) count
FROM MANAGER_SALARY..salary
GROUP BY Gender
ORDER BY count DESC

UPDATE MANAGER_SALARY..salary
SET Gender = 'Other/Prefer not to answer'
WHERE Gender NOT IN ('Woman', 'Man', 'Non-binary')


----------------------------------------------------
-- GOAL : STANDARDIZE Country VALUES

SELECT Country, COUNT(*) count
FROM MANAGER_SALARY..salary
GROUP BY Country
ORDER BY count DESC

SELECT Country, Currency		-- Findings: All instances with Currency = USD have JobCountry Values which 
FROM MANAGER_SALARY..salary		--  are variations of 'United States'
WHERE Currency = 'USD' AND 
	  Country <> 'United States' 

UPDATE MANAGER_SALARY..salary	
SET Country = 'United States' 
				WHERE Currency = 'USD' AND 
				Country <> 'United States' 



SELECT Country, Currency		-- Findings: All instances with Currency = GBP have JobCountry Values which 
FROM MANAGER_SALARY..salary     -- are part of United Kingdom i.e. ('England', 'Scotland', 'Wales', 'Northern Ireland')
WHERE Currency = 'GBP' AND 
	  Country <> 'United Kingdom' 

UPDATE MANAGER_SALARY..salary
SET Country = 'United Kingdom'
				 WHERE Currency = 'GBP' AND
					   Country <> 'United Kingdom' 


SELECT Country, Currency		
FROM MANAGER_SALARY..salary     
WHERE Currency = 'EUR' AND (
	  Country <> 'The Netherlands' OR
	  Country LIKE '%lands%' )

UPDATE MANAGER_SALARY..salary	-- Update variations of Netherlands to 'The Netherlands'
SET Country = 'The Netherlands'
			  WHERE Currency = 'EUR'AND 
			  (Country <> 'The Netherlands' OR
			  Country LIKE '%lands%')


Select Country, Currency 
FROM MANAGER_SALARY..salary
WHERE Country = 'NZ'

UPDATE MANAGER_SALARY..salary   -- Update variations of New Zealand to 'The Netherlands'
SET Country = 'New Zealand'
			  WHERE Country = 'NZ' OR
					Country LIKE '%New Zeland%'

UPDATE MANAGER_SALARY..salary	-- Update variations of US to 'United States'
SET Country = 'United States'
			   WHERE Country = 'USA' OR
					 Country = 'US'


SELECT Country, Currency, City  -- Findings: Some people who earn CAD reside in the US 
FROM MANAGER_SALARY..salary		-- Therefore, when updating variations of 'Canada', we should
WHERE Currency = 'CAD'          -- apply additional constraints (e.g. cities in Canada)            
AND Country <> 'Canada'

UPDATE MANAGER_SALARY..salary
SET Country = 'Canada'
WHERE Currency = 'CAD' AND (
	  Country LIKE '%CAN%' OR
	  City = 'Toronto' OR
	  City = 'Regina' OR
	  City = 'Canada' OR 
	  City = 'Ottawa')


SELECT Country, COUNT(Country) count --	Findings: All instances where currency = MXN, the manager is from Mexico
FROM MANAGER_SALARY..salary		
WHERE currency = 'MXN'
GROUP BY Country 

UPDATE MANAGER_SALARY..salary
SET Country = 'Mexico'
			   WHERE Currency = 'MXN'


SELECT Country, Currency			       
FROM MANAGER_SALARY..salary
WHERE Country LIKE '%Austra%'
GROUP BY Country, Currency

UPDATE MANAGER_SALARY..salary
SET Country = 'Australia'
			   WHERE Country LIKE '%Austral%' AND
					 Currency LIKE '%AUD%'


SELECT Country, Currency, COUNT(Country) count		-- Findings: All instances where currency = ARS, the manager is from Argentina
FROM MANAGER_SALARY..salary
WHERE Currency = 'ARS'
GROUP BY Country, Currency

UPDATE MANAGER_SALARY..salary
SET Country = 'Argentina'
			   WHERE Country LIKE '%Argentina%' AND
					 Currency = 'ARS'


SELECT Country, Currency,  COUNT(Country) count		-- Findings: All instances where currency = CNY, the manager is from China
FROM MANAGER_SALARY..salary
WHERE Currency = 'CNY'
GROUP BY Country, Currency

UPDATE MANAGER_SALARY..salary
SET Country = 'China'
			  WHERE Country <> 'China' AND
					Currency = 'CNY'

SELECT Country, Currency,  COUNT(Country) count		-- Findings: All instances where currency = THB, the manager works in Thailand
FROM MANAGER_SALARY..salary
WHERE Currency = 'THB'
GROUP BY Country, Currency

UPDATE MANAGER_SALARY..salary
SET Country = 'Thailand'
			   WHERE Country <> 'Thailand' AND
					 Currency = 'THB'
					

----------------------------------------------------
-- GOAL : STANDARDIZE Industry VALUES

SELECT Industry, COUNT(Industry) count
FROM MANAGER_SALARY..salary
GROUP BY Industry
ORDER BY count DESC


SELECT Industry, COUNT(Industry) count	
FROM MANAGER_SALARY..salary
WHERE (Industry LIKE '%Engineer%' OR 
	  Industry LIKE '%Manufacturing%')
GROUP BY Industry
ORDER BY count DESC

UPDATE MANAGER_SALARY..salary	-- Standardize engineering industry
SET Industry = 'Engineering or Manufacturing'
				WHERE (Industry LIKE '%Engineer%' OR 
					  Industry LIKE '%Manufacturing%') AND
					  Industry <> 'Engineering or Manufacturing'


SELECT Industry, COUNT(Industry) count		
FROM MANAGER_SALARY..salary
WHERE Industry LIKE '%Computing%' OR 
      Industry LIKE 'Tech%' OR 
	  Industry LIKE '%Fintech%' OR 
	  Industry LIKE 'IT%' OR 
	  Industry LIKE '%Software%'
GROUP BY Industry
ORDER BY count DESC

UPDATE MANAGER_SALARY..salary	-- Standardize Computing or Tech industry
SET Industry = 'Computing or Tech'
				WHERE (Industry LIKE '%Computing%' OR
					  Industry LIKE 'Tech%' OR 
					  Industry LIKE '%Fintech%' OR
					  Industry LIKE 'IT%' OR 
					  Industry LIKE '%Software%') AND
					  Industry <> 'Computing or Tech'


SELECT Industry, COUNT(Industry) count
FROM MANAGER_SALARY..salary
WHERE Industry LIKE '%Non-profit%' OR
	  Industry LIKE '%Non profit%'
GROUP BY Industry
ORDER BY count DESC

UPDATE MANAGER_SALARY..salary	-- Standardize Non profit industry
SET Industry = 'Nonprofits'
				WHERE (Industry LIKE '%Non-profit%' OR
					   Industry LIKE '%Non profit%') AND
					   Industry <> 'Nonprofits'


SELECT Industry, COUNT(Industry) count
FROM MANAGER_SALARY..salary
WHERE Industry LIKE '%Finance%' OR
	  Industry LIKE '%Accounting%' OR 
	  Industry LIKE '%Bank%'
GROUP BY Industry
ORDER BY count DESC

UPDATE MANAGER_SALARY..salary	-- Standardize Accounting, Banking & Finance Industry
SET Industry = 'Accounting, Banking & Finance'
				WHERE (Industry LIKE '%Finance%' OR
				       Industry LIKE '%Accounting%' OR 
				       Industry LIKE '%Bank%') AND
				       Industry <> 'Accounting, Banking & Finance'


SELECT Industry, COUNT(Industry) count
FROM MANAGER_SALARY..salary
WHERE Industry LIKE '%health%' 
GROUP BY Industry
ORDER BY count DESC

UPDATE MANAGER_SALARY..salary	-- Standardize  Health care Industry
SET Industry = 'Health care'
				WHERE Industry LIKE '%health%' AND
				      Industry <> 'Health care'



SELECT Industry, COUNT(Industry) count
FROM MANAGER_SALARY..salary
WHERE Industry LIKE '%Marketing%' OR
	  Industry LIKE '%Advertising%' OR
	  Industry = 'PR' OR
	  Industry LIKE '%Public relation%'
GROUP BY Industry
ORDER BY count DESC

UPDATE MANAGER_SALARY..salary	-- Standardize 'Marketing, Advertising & PR' Industry
SET Industry = 'Marketing, Advertising & PR'
				WHERE (Industry LIKE '%Marketing%' OR
					   Industry LIKE '%Advertising%' OR
				       Industry = 'PR' OR
					   Industry LIKE '%Public relation%') AND
					   Industry <> 'Marketing, Advertising & PR'


SELECT Industry, COUNT(Industry) count
FROM MANAGER_SALARY..salary
WHERE Industry LIKE '%Business%' OR
	  Industry LIKE '%Consulting%'
GROUP BY Industry
ORDER BY count DESC

UPDATE MANAGER_SALARY..salary	-- Standardize 'Business or Consulting' Industry
SET Industry = 'Business or Consulting'
				WHERE (Industry LIKE '%Business%' OR
					   Industry LIKE '%Consulting%') AND
					   Industry <> 'Business or Consulting' AND
					   Industry NOT LIKE '%not quite consulting%'


SELECT Industry, COUNT(Industry) count
FROM MANAGER_SALARY..salary
WHERE Industry LIKE 'Media%' OR
	  Industry LIKE '%Digital%'
GROUP BY Industry
ORDER BY count DESC


UPDATE MANAGER_SALARY..salary	-- Standardize Media & Digital Industry
SET Industry = 'Media & Digital'
				WHERE (Industry LIKE 'Media%' OR
					   Industry LIKE 'Digital%') AND
					   Industry <> 'Media & Digital' 


SELECT Industry, COUNT(Industry) count
FROM MANAGER_SALARY..salary
WHERE Industry LIKE '%Retail%'
GROUP BY Industry
ORDER BY count DESC

UPDATE MANAGER_SALARY..salary	-- Standardize Retaill Industry
SET Industry = 'Retail'
				WHERE Industry LIKE '%Retail%' AND
				   	  Industry <> 'Retail'


SELECT Industry, COUNT(Industry) count 
FROM MANAGER_SALARY..salary
WHERE Industry LIKE '%Construction%' OR
	  Industry LIKE '%Property%'
GROUP BY Industry
ORDER BY count DESC

UPDATE MANAGER_SALARY..salary	-- Standardize Construction Industry
SET Industry = 'Property or Construction'
				WHERE (Industry LIKE '%Construction%' OR
					   Industry LIKE '%Property%') AND
					   Industry <> 'Property or Construction'


SELECT Industry, COUNT(Industry) count 
FROM MANAGER_SALARY..salary
WHERE Industry LIKE '%Telecommunications%'
GROUP BY Industry
ORDER BY count DESC

UPDATE MANAGER_SALARY..salary	-- Standardize Construction Industry
SET Industry = 'Utilities & Telecommunications'
				WHERE Industry LIKE '%Telecommunications%' AND
					  Industry <> 'Utilities & Telecommunications'


SELECT Industry, COUNT(Industry) count 
FROM MANAGER_SALARY..salary
WHERE Industry LIKE 'Art%' OR 
Industry LIKE '%Design%'
GROUP BY Industry
ORDER BY count DESC

UPDATE MANAGER_SALARY..salary	--Standardize Art & Design Industry
SET Industry = 'Art & Design'
				WHERE (Industry LIKE 'Art%' OR 
					  Industry LIKE '%Design%') AND
				      Industry <> 'Art & Design'


SELECT Industry, COUNT(Industry) count 
FROM MANAGER_SALARY..salary
WHERE Industry LIKE '%Transport%' OR 
Industry LIKE '%Logistics%'
GROUP BY Industry
ORDER BY count DESC

UPDATE MANAGER_SALARY..salary	-- Standardize Transport or Logistics Industry
SET Industry = 'Transport or Logistics'
				WHERE (Industry LIKE '%Transport%' OR 
				      Industry LIKE '%Logistics%') AND
				      Industry <> 'Transport or Logistics'


SELECT Industry, COUNT(Industry) count 
FROM MANAGER_SALARY..salary
WHERE Industry LIKE '%Sales%'
GROUP BY Industry
ORDER BY count DESC

UPDATE MANAGER_SALARY..salary	-- Standardize Sales Industry
SET Industry = 'Sales'
				WHERE Industry LIKE '%Sales%' AND
				      Industry <> 'Sales'


SELECT Industry, COUNT(Industry) count 
FROM MANAGER_SALARY..salary
WHERE Industry LIKE '%Hospitality%' OR
	  Industry LIKE '%Event%'
GROUP BY Industry
ORDER BY count DESC

UPDATE MANAGER_SALARY..salary	-- Standardize Hospitality & Events Industry
SET Industry = 'Hospitality & Events'
				WHERE (Industry LIKE '%Hospitality%' OR
					   Industry LIKE '%Event%') AND
				      Industry <> 'Hospitality & Events'


SELECT Industry, COUNT(Industry) count 
FROM MANAGER_SALARY..salary
WHERE Industry LIKE '%Entertainment%' OR 
	  Industry LIKE '%Music%' OR 
	  Industry LIKE '%Film%'
GROUP BY Industry
ORDER BY count DESC

UPDATE MANAGER_SALARY..salary	-- Standardize Entertainment Industry
SET Industry = 'Entertainment'
				WHERE (Industry LIKE '%Entertainment%' OR 
				       Industry LIKE '%Music%' OR 
		               Industry LIKE '%Film%') AND
				       Industry <> 'Entertainment'


SELECT Industry, COUNT(Industry) count 
FROM MANAGER_SALARY..salary
WHERE Industry LIKE '%Agriculture%' OR 
	  Industry LIKE '%Forestry%'
GROUP BY Industry
ORDER BY count DESC

UPDATE MANAGER_SALARY..salary	-- Standardize Agriculture or Forestry Industry
SET Industry = 'Agriculture or Forestry'
				WHERE (Industry LIKE '%Agriculture%' OR 
					   Industry LIKE '%Forestry%') AND
				       Industry <> 'Agriculture or Forestry'


SELECT Industry, COUNT(Industry) count 
FROM MANAGER_SALARY..salary
WHERE Industry LIKE '%Leisure%' OR 
	  Industry LIKE '%Sports%' OR 
	  Industry LIKE '%Tourism%'
GROUP BY Industry
ORDER BY count DESC

UPDATE MANAGER_SALARY..salary	-- Standardize Leisure, Sport & Tourism Industry
SET Industry = 'Leisure, Sport & Tourism'
				WHERE (Industry LIKE '%Leisure%' OR 
					   Industry LIKE '%Sports%' OR 
				       Industry LIKE '%Tourism%') AND
				       Industry <> 'Leisure, Sport & Tourism'


SELECT Industry, COUNT(Industry) count 
FROM MANAGER_SALARY..salary
WHERE Industry LIKE '%Publishing%'
GROUP BY Industry
ORDER BY count DESC

UPDATE MANAGER_SALARY..salary	-- Standardize Publishing Industry
SET Industry = 'Publishing'
				WHERE Industry LIKE '%Publishing%' AND
				      Industry <> 'Publishing'


SELECT Industry, COUNT(Industry) count 
FROM MANAGER_SALARY..salary
WHERE Industry LIKE '%Library%' OR
	  Industry LIKE '%Libraries%' OR
	  Industry LIKE '%Librarian%'
GROUP BY Industry
ORDER BY count DESC

UPDATE MANAGER_SALARY..salary	-- Standardize Library Industry
SET Industry = 'Library'
				WHERE (Industry LIKE '%Library%' OR
			          Industry LIKE '%Libraries%' OR
					  Industry LIKE '%Librarian%') AND
				      Industry <> 'Library'


SELECT Industry, COUNT(Industry) count 
FROM MANAGER_SALARY..salary
WHERE Industry LIKE '%Research%' OR
	  Industry LIKE '%R&D%'
GROUP BY Industry
ORDER BY count DESC

UPDATE MANAGER_SALARY..salary	-- Standardize Research Industry
SET Industry = 'Research'
				WHERE (Industry LIKE '%Research%' OR
					   Industry LIKE '%R&D%') AND
				       Industry <> 'Research'


SELECT Industry, COUNT(Industry) count 
FROM MANAGER_SALARY..salary
WHERE Industry LIKE '%Pharma%'
GROUP BY Industry
ORDER BY count DESC

UPDATE MANAGER_SALARY..salary	-- Standardize Pharmaceutical  Industry
SET Industry = 'Pharmaceutical'
				WHERE Industry LIKE '%Pharma%' AND
				       Industry <> 'Pharmaceutical'


SELECT Industry, COUNT(Industry) count 
FROM MANAGER_SALARY..salary
WHERE Industry LIKE '%Biotech%'
GROUP BY Industry
ORDER BY count DESC

UPDATE MANAGER_SALARY..salary	-- Standardize Biotech  Industry
SET Industry = 'Biotechnology'
				WHERE Industry LIKE '%Biotech%' AND
				       Industry <> 'Biotechnology'


SELECT Industry, COUNT(Industry) count 
FROM MANAGER_SALARY..salary
WHERE Industry LIKE '%Real Estate%'
GROUP BY Industry
ORDER BY count DESC

UPDATE MANAGER_SALARY..salary	-- Standardize Real Estate Industry
SET Industry = 'Real Estate'
				WHERE Industry LIKE '%Real Estate%' AND
				      Industry <> 'Real Estate'


SELECT Industry, COUNT(Industry) count 
FROM MANAGER_SALARY..salary
WHERE Industry LIKE '%Oil%' OR
      Industry LIKE '%Gas%'
GROUP BY Industry
ORDER BY count DESC

UPDATE MANAGER_SALARY..salary	-- Standardize Oil and Gas Industry
SET Industry = 'Oil and Gas'
				WHERE (Industry LIKE '%Oil%' OR
					   Industry LIKE '%Gas%') AND
				       Industry <> 'Oil and Gas'


SELECT Industry, COUNT(Industry) count 
FROM MANAGER_SALARY..salary
WHERE Industry LIKE '%Museum%'
GROUP BY Industry
ORDER BY count DESC

UPDATE MANAGER_SALARY..salary	-- Standardize Museum Industry
SET Industry = 'Museum'
				WHERE Industry LIKE '%Museum%' AND
				       Industry <> 'Museum'
