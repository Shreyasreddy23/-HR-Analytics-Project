create database HR_Analytics ;
Use HR_Analytics;

CREATE TABLE hr1 (
    EmployeeNumber INT,
    Age INT,
    Attrition VARCHAR(3),
    BusinessTravel VARCHAR(20),
    DailyRate INT,
    Department VARCHAR(30),
    DistanceFromHome INT,
    Education INT,
    EducationField VARCHAR(50),
    EmployeeCount INT,
    EnvironmentSatisfaction INT,
    Gender VARCHAR(6),
    HourlyRate INT,
    JobInvolvement INT,
    JobLevel INT,
    JobRole VARCHAR(50),
    JobSatisfaction INT,
    MaritalStatus VARCHAR(10)
);

CREATE TABLE hr2 (
    EmployeeID INT,
    MonthlyIncome INT,
    MonthlyRate INT,
    NumCompaniesWorked INT,
    Over18 CHAR(1),
    OverTime VARCHAR(3),
    PercentSalaryHike INT,
    PerformanceRating INT,
    RelationshipSatisfaction INT,
    StandardHours INT,
    StockOptionLevel INT,
    TotalWorkingYears INT,
    TrainingTimesLastYear INT,
    WorkLifeBalance INT,
    YearsAtCompany INT,
    YearsInCurrentRole INT,
    YearsSinceLastPromotion INT,
    YearsWithCurrManager INT
);
 
 select * from hr1;
 select *
from hr2;

CREATE VIEW merged_hr AS
SELECT
    hr1.EmployeeNumber AS EmployeeID,
    hr1.Age,
    hr1.Attrition,
    hr1.BusinessTravel,
    hr1.DailyRate,
    hr1.Department,
    hr1.DistanceFromHome,
    hr1.Education,
    hr1.EducationField,
    hr1.EmployeeCount,
    hr1.EnvironmentSatisfaction,
    hr1.Gender,
    hr1.HourlyRate,
    hr1.JobInvolvement,
    hr1.JobLevel,
    hr1.JobRole,
    hr1.JobSatisfaction,
    hr1.MaritalStatus,
    hr2.MonthlyIncome,
    hr2.MonthlyRate,
    hr2.NumCompaniesWorked,
    hr2.Over18,
    hr2.OverTime,
    hr2.PercentSalaryHike,
    hr2.PerformanceRating,
    hr2.RelationshipSatisfaction,
    hr2.StandardHours,
    hr2.StockOptionLevel,
    hr2.TotalWorkingYears,
    hr2.TrainingTimesLastYear,
    hr2.WorkLifeBalance,
    hr2.YearsAtCompany,
    hr2.YearsInCurrentRole,
    hr2.YearsSinceLastPromotion,
    hr2.YearsWithCurrManager
FROM hr1
INNER JOIN hr2
    ON hr1.EmployeeNumber = hr2.EmployeeID;
    
    select * from merged_hr ;
    
 -- KPI 1: Average Attrition Rate for All Departments 
 SELECT
    Department,
    ROUND(AVG(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS Avg_Attrition_Rate_Percentage
FROM merged_hr
GROUP BY Department
ORDER BY Avg_Attrition_Rate_Percentage DESC;

-- KPI 2: Average Hourly Rate of Male Research Scientists
SELECT
    Gender,
    JobRole,
    ROUND(AVG(HourlyRate), 2) AS Avg_Hourly_Rate
FROM merged_hr
WHERE Gender = 'Male'
  AND JobRole = 'Research Scientist';

-- KPI 3: Attrition Rate vs Monthly Income
SELECT
    CASE
        WHEN MonthlyIncome < 3000 THEN 'Low Income (<3K)'
        WHEN MonthlyIncome BETWEEN 3000 AND 6000 THEN 'Mid Income (3K-6K)'
        WHEN MonthlyIncome BETWEEN 6001 AND 10000 THEN 'High Income (6K-10K)'
        ELSE 'Very High Income (>10K)'
    END AS Income_Band,
    ROUND(AVG(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS Attrition_Rate_Percentage,
    COUNT(*) AS Employee_Count
FROM merged_hr
GROUP BY Income_Band
ORDER BY Attrition_Rate_Percentage DESC;

-- KPI 4: Average Working Years for Each Department
SELECT
    Department,
    ROUND(AVG(TotalWorkingYears), 2) AS Avg_Working_Years
FROM merged_hr
GROUP BY Department
ORDER BY Avg_Working_Years DESC;

-- KPI 5: Job Role vs Work-Life Balance
SELECT
    JobRole,
    ROUND(AVG(WorkLifeBalance), 2) AS Avg_WorkLife_Balance,
    COUNT(*) AS Employee_Count
FROM merged_hr
GROUP BY JobRole
ORDER BY Avg_WorkLife_Balance DESC;

-- KPI 6: Attrition Rate vs Years Since Last Promotion
SELECT
    YearsSinceLastPromotion,
    ROUND(AVG(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS Attrition_Rate_Percentage,
    COUNT(*) AS Employee_Count
FROM merged_hr
GROUP BY YearsSinceLastPromotion
ORDER BY YearsSinceLastPromotion;

-- KPI 7 Attrition Rate by Job Role 
SELECT
    JobRole,
    ROUND(AVG(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS Attrition_Rate_Percentage,
    COUNT(*) AS Employee_Count
FROM merged_hr
GROUP BY JobRole
ORDER BY Attrition_Rate_Percentage DESC;

-- kpi 8  Average Age of Employees by Attrition Status
SELECT
    Attrition,
    ROUND(AVG(Age), 2) AS Avg_Age,
    COUNT(*) AS Employee_Count
FROM merged_hr
GROUP BY Attrition;

-- KPI 9: Average Percent Salary Hike by Department
SELECT
    Department,
    ROUND(AVG(PercentSalaryHike), 2) AS Avg_Percent_Salary_Hike
FROM merged_hr
GROUP BY Department
ORDER BY Avg_Percent_Salary_Hike DESC;

-- kpi 10 Attrition Rate by Performance Rating
SELECT
    PerformanceRating,
    ROUND(AVG(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS Attrition_Rate_Percentage,
    COUNT(*) AS Employee_Count
FROM merged_hr
GROUP BY PerformanceRating
ORDER BY PerformanceRating;

