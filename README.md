# SQL-Project-2-Data-Cleaning-and-Explooration-on-Global-Salary-of-Managers-2021

### Raw File 
--------------------------------------------------------------------------------------------------------------------------
The raw and messy dataset is originially sourced [here](https://docs.google.com/spreadsheets/d/1IPS5dBSGtwYVbjsfbaMCYIWnOuRmJcbequohNxCyGVw/edit?resourcekey#gid=1625408792).

Here's a preview of the raw dataset:


| Timestamp               	| How old are you? 	| What industry do you work in? 	| Job title                                	| If your job title needs additional context, please clarify here: 	| What is your annual salary? (You'll indicate the currency in a l 	| How much additional monetary compensation do you get, if any (fo 	| Please indicate the currency 	| If "Other," please indicate the currency here: 	| If your income needs additional context, please provide it here: 	| What is your highest level of education completed? 	| What is your gender? 	| What country do you work in? 	| If you're in the U#S#, what state do you work in? 	| What city do you work in? 	| How many years of professional work experience do you have overa 	| How many years of professional work experience do you have in yo 	| What is your race? (Choose all that apply#) 	| F19  	| F20  	| F21  	| F22  	| F23  	| F24  	|
|-------------------------	|------------------	|-------------------------------	|------------------------------------------	|------------------------------------------------------------------	|------------------------------------------------------------------	|------------------------------------------------------------------	|------------------------------	|------------------------------------------------	|------------------------------------------------------------------	|----------------------------------------------------	|----------------------	|------------------------------	|---------------------------------------------------	|---------------------------	|------------------------------------------------------------------	|------------------------------------------------------------------	|---------------------------------------------	|------	|------	|------	|------	|------	|------	|
| 2021-04-27 11:02:10.000 	| 25-34            	| Education (Higher Education)  	| Research and Instruction Librarian       	| NULL                                                             	| 55000                                                            	| 0                                                                	| USD                          	| NULL                                           	| NULL                                                             	| Master's degree                                    	| Woman                	| United States                	| Massachusetts                                     	| Boston                    	| 5-7 years                                                        	| 5-7 years                                                        	| White                                       	| NULL 	| NULL 	| NULL 	| NULL 	| NULL 	| NULL 	|
| 2021-04-27 11:02:22.000 	| 25-34            	| Computing or Tech             	| Change & Internal Communications Manager 	| NULL                                                             	| 54600                                                            	| 4000                                                             	| GBP                          	| NULL                                           	| NULL                                                             	| College degree                                     	| Non-binary           	| United Kingdom               	| NULL                                              	| Cambridge                 	| 8 - 10 years                                                     	| 5-7 years                                                        	| White                                       	| NULL 	| NULL 	| NULL 	| NULL 	| NULL 	| NULL 	|
| 2021-04-27 11:02:38.000 	| 25-34            	| Accounting, Banking & Finance 	| Marketing Specialist                     	| NULL                                                             	| 34000                                                            	| NULL                                                             	| USD                          	| NULL                                           	| NULL                                                             	| College degree                                     	| Woman                	| US                           	| Tennessee                                         	| Chattanooga               	| 2 - 4 years                                                      	| 2 - 4 years                                                      	| White                                       	| NULL 	| NULL 	| NULL 	| NULL 	| NULL 	| NULL 	|


### Data Cleaning
--------------------------------------------------------------------------------------------------------------------------
The following steps were performed to clean the data:



      1. Rename lengthy column names
      
      2. Drop unneccessary columns such as Timestamp and columns which contain nothing but NULL values
      
      3. Standardize currency codes such that they conform to ISO 4217
      
      4. Consolidate Currency and Currency_Other data together
      
      5. Remove rows where Industry, Job Title and Annual Salary Columns all contain NULL values
      
      6. Convert Annual Salaries to USD (so that we can fairly compare salary data later)
      
      7. Standardize data in Education column such that values are limited to 
            - High School
            - College degree
            - Master's degree
            - PhD
            - Professional degree

      8. Standardize data in Gender column such that values are limited to 
            - Man
            - Woman
            - Non-binary
            - Other/Prefer not to answer

      8. Standardize Country names such that typos and abbreviations are removed
      
      9. Standardize data in Industry column
      
      
Here's a snippet of the cleaned data:
      
| Age   	| Industry                      	| Job Title                                	| Job Specification 	| Annual Salary 	| Additional Compensation 	| Currency 	| CurrencyOther 	| Salary Specification 	| Country        	| State (USA)   	| City        	| Years of Experience 	| Industry Experience 	| Education       	| Gender     	| Race  	| Annual Salary (USD) 	| Conversion Factor 	|
|-------	|-------------------------------	|------------------------------------------	|-------------------	|---------------	|-------------------------	|----------	|---------------	|----------------------	|----------------	|---------------	|-------------	|---------------------	|---------------------	|-----------------	|------------	|-------	|---------------------	|-------------------	|
| 25-34 	| Education (Higher Education)  	| Research and Instruction Librarian       	| NULL              	| 55000         	| 0                       	| USD      	| NULL          	| NULL                 	| United States  	| Massachusetts 	| Boston      	| 5-7 years           	| 5-7 years           	| Master's degree 	| Woman      	| White 	| 55000               	| 1                 	|
| 25-34 	| Computing or Tech             	| Change & Internal Communications Manager 	| NULL              	| 54600         	| 4000                    	| GBP      	| NULL          	| NULL                 	| United Kingdom 	| NULL          	| Cambridge   	| 8 - 10 years        	| 5-7 years           	| College degree  	| Non-binary 	| White 	| 66372.033           	| 1.215605          	|
| 25-34 	| Accounting, Banking & Finance 	| Marketing Specialist                     	| NULL              	| 34000         	| NULL                    	| USD      	| NULL          	| NULL                 	| United States  	| Tennessee     	| Chattanooga 	| 2 - 4 years         	| 2 - 4 years         	| College degree  	| Woman      	| White 	| 34000               	| 1                 	|


