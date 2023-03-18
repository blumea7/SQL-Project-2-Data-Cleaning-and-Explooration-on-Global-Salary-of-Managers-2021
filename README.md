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



### Data Exploration
--------------------------------------------------------------------------------------------------------------------------
#### 1. Find the average annual salary of managers in each industry. Order the result by their salary in descending order. Also, compute the ratio of women in each industry.



| Industry                             | Average Annual Salary (USD) | Woman Count | Sample Size | Woman Share |
|--------------------------------------|-----------------------------|-------------|-------------|-------------|
| Utilities & Telecommunications       | 367015                      | 248         | 360         | 0.69        |
| Pharmaceutical                       | 125670                      | 102         | 122         | 0.84        |
| Computing or Tech                    | 120105                      | 2465        | 4715        | 0.52        |
| Law                                  | 115652                      | 946         | 1097        | 0.86        |
| Oil and Gas                          | 111216                      | 32          | 43          | 0.74        |
| Biotechnology                        | 106011                      | 70          | 85          | 0.82        |
| Business or Consulting               | 99747                       | 693         | 891         | 0.78        |
| Sales                                | 96806                       | 207         | 291         | 0.71        |
| Entertainment                        | 95471                       | 178         | 259         | 0.69        |
| Engineering or Manufacturing         | 91553                       | 1231        | 1778        | 0.69        |
| Health care                          | 88271                       | 1657        | 1930        | 0.86        |
| Accounting, Banking & Finance        | 87465                       | 1418        | 1803        | 0.79        |
| Marketing, Advertising & PR          | 83832                       | 955         | 1132        | 0.84        |
| Insurance                            | 82871                       | 422         | 530         | 0.8         |
| Media & Digital                      | 80183                       | 585         | 774         | 0.76        |
| Art & Design                         | 78943                       | 285         | 368         | 0.77        |
| Agriculture or Forestry              | 78361                       | 107         | 139         | 0.77        |
| Government and Public Administration | 78259                       | 1568        | 1882        | 0.83        |
| Recruitment or HR                    | 77007                       | 413         | 458         | 0.9         |
| Transport or Logistics               | 73599                       | 216         | 306         | 0.71        |
| Research                             | 73509                       | 182         | 213         | 0.85        |
| Nonprofits                           | 70599                       | 2096        | 2426        | 0.86        |
| Real Estate                          | 69542                       | 45          | 53          | 0.85        |
| Property or Construction             | 69468                       | 319         | 404         | 0.79        |
| Education (Higher Education)         | 66612                       | 2044        | 2458        | 0.83        |
| Leisure, Sport & Tourism             | 66213                       | 86          | 101         | 0.85        |
| Education (Primary/Secondary)        | 63496                       | 733         | 832         | 0.88        |
| Hospitality & Events                 | 62696                       | 204         | 261         | 0.78        |
| Law Enforcement & Security           | 60374                       | 31          | 43          | 0.72        |
| Retail                               | 59354                       | 377         | 508         | 0.74        |
| Publishing                           | 58759                       | 85          | 96          | 0.89        |
| Social Work                          | 55311                       | 252         | 273         | 0.92        |
| Library                              | 55073                       | 212         | 246         | 0.86        |




#### 2. Determine the average annual salary per age group. Show the percent share of each educational background per age group. 



| Age        | Average Annual Salary (USD) | High School (%) | College Degree (%) | Master's degree (%) | PhD (%) | Professional degree (%) |
|------------|-----------------------------|-----------------|--------------------|---------------------|---------|-------------------------|
| 0-18       | 72455                       | 40              | 20                 | 30                  | 10      | 0                       |
| 18-24      | 56568                       | 4.87            | 85.23              | 9.56                | 0.09    | 0.26                    |
| 25-34      | 87328                       | 1.44            | 59.33              | 30.97               | 3.96    | 4.31                    |
| 35-44      | 95445                       | 2.72            | 48.69              | 35.93               | 6.6     | 6.06                    |
| 45-54      | 98932                       | 2.88            | 53.88              | 31.85               | 6.84    | 4.56                    |
| 55-64      | 101924                      | 3.35            | 57.87              | 28.83               | 5.79    | 4.16                    |
| 65 or over | 94636                       | 3.26            | 51.09              | 36.96               | 7.61    | 1.09                    |


#### 3. Determine the average annual salary of men and women, separately, for each industry.



| Industry                             | Annual Salary (Women) | Annual Salary (Men) |
|--------------------------------------|-----------------------|---------------------|
| Marketing, Advertising & PR          | 83544                 | 88333               |
| Government and Public Administration | 77835                 | 85641               |
| Entertainment                        | 94930                 | 100275              |
| Media & Digital                      | 77657                 | 92943               |
| Oil and Gas                          | 97495                 | 151132              |
| Research                             | 73752                 | 76364               |
| Agriculture or Forestry              | 68070                 | 75145               |
| Recruitment or HR                    | 77060                 | 80329               |
| Sales                                | 98202                 | 99927               |
| Insurance                            | 79475                 | 98952               |
| Library                              | 56221                 | 53700               |
| Engineering or Manufacturing         | 89199                 | 98659               |
| Transport or Logistics               | 71167                 | 82500               |
| Social Work                          | 55051                 | 59831               |
| Law                                  | 111991                | 156398              |
| Art & Design                         | 81037                 | 75345               |
| Leisure, Sport & Tourism             | 64201                 | 83288               |
| Pharmaceutical                       | 125209                | 136368              |
| Accounting, Banking & Finance        | 83820                 | 104322              |
| Property or Construction             | 67651                 | 76590               |
| Publishing                           | 57301                 | 80754               |
| Utilities & Telecommunications       | 80831                 | 1082928             |
| Real Estate                          | 69245                 | 87489               |
| Hospitality & Events                 | 64630                 | 62337               |
| Business or Consulting               | 95903                 | 113592              |
| Nonprofits                           | 70386                 | 79435               |
| Computing or Tech                    | 110869                | 131486              |
| Biotechnology                        | 105293                | 112382              |
| Health care                          | 87117                 | 98282               |
| Law Enforcement & Security           | 63543                 | 56192               |
| Retail                               | 58361                 | 71856               |
| Education (Primary/Secondary)        | 62832                 | 71789               |
| Education (Higher Education)         | 65869                 | 74936               |




#### 4. Filter industries where women earn higher than men. Also, show the pay difference in percentage.



| Industry                   | Percent Difference |
|----------------------------|--------------------|
| Law Enforcement & Security | 11.57              |
| Art & Design               | 7.02               |
| Library                    | 4.48               |
| Hospitality & Events       | 3.55               |


### Data Analysis and Visualization
--------------------------------------------------------------------------------------------------------------------------
#### Notes: 
1. Data Visualizations are done in Power BI. 
2. Data visualizations are just derived from the queried tables in Data Exploration Section and not from the whole dataset. 

#### Average Annual Salary of Managers per Age Group


Findings:
      
1. Generally, older managers earn higher. This is opposite from what we've seen in our [FIFA 2021 Analysis](https://github.com/blumea7/SQL-Project-1-Data-Cleaning-and-Exploration-on-2021-FIFA-Dataset), where players' wage peak at 25-35 years old.
2. Most managers' highest educational attainment is a college degree, followed by master's degree.
       
![Average Annual Salary of Managers per Age Group](https://github.com/blumea7/SQL-Project-2-Data-Cleaning-and-Explooration-on-Global-Salary-of-Managers-2021/blob/main/assets/1.%20Average%20Annual%20Salary%20per%20Age%20Group.JPG)

#### Average Annual Salary of Managers Against Ratio of Women (per Industry)

Findings:

1. Generally, women dominate all industries in terms of quantity (as seen in the graph, ratio of women are always greater than 0.5)
      - However, as the ratio of women in an industry increases, the average annual salary usually decreases.

![verage Annual Salary of Managers Against Ratio of Women](https://github.com/blumea7/SQL-Project-2-Data-Cleaning-and-Explooration-on-Global-Salary-of-Managers-2021/blob/main/assets/2.%20Average%20Annual%20Salary%20against%20Women%20Share.JPG)

#### Average Annual Salary of Managers per Gender and Industry

Findings

1. In most industries, men are paid higher. 
2. The only 4 industries that pay women higher are 
      - Law enforcement & security 
      - Art & Design
      - Library
      - Hospitality & Events

![Average Annual Salary of Managers per Gender and Industry](https://github.com/blumea7/SQL-Project-2-Data-Cleaning-and-Explooration-on-Global-Salary-of-Managers-2021/blob/main/assets/3.%20Average%20Annual%20Salary%20by%20Gender%20and%20Industry.JPG)
