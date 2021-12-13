--Database : CO2 Emission (metric tons per capita), source of data : data.worldbank.org

SELECT * FROM Emission;

SELECT * FROM Countries;

-- Show emissions per year from country for the latest 3 years
SELECT [Country Name], [2016], [2017], [2018]
From Emission
Order by [Country Name];

-- Sorting countries from largest total emission in the latest 3 years
Select [country name], ([2016]+[2017]+[2018]) AS Total_Emission
FROM Emission
ORDER BY Total_Emission DESC;

--Select top 50 countries with largest emission in 2018
Select [COUNTRY NAME], [2018] 
FROM Emission
ORDER BY [2018] DESC;

SELECT TOP 50 Emission.[Country Name], Countries.IncomeGroup, Emission.[2018] FROM Emission JOIN Countries
ON Emission.[Country Name]=Countries.[Country Name]
ORDER BY Emission.[2018] DESC;


--Shows Total Emission by Countries in 2016-2018 grouped by Region
SELECT Countries.[Region], SUM(Emission.[2016]) AS [TOTAL EMISSION 2016], 
SUM(Emission.[2017]) [TOTAL EMISSION 2017], SUM(Emission.[2018]) [TOTAL EMISSION 2018]
FROM Emission JOIN Countries
ON Emission.[Country Name]=Countries.[Country Name] WHERE Countries.[Region] IS NOT NULL
GROUP BY Countries.[Region]
ORDER BY Countries.[Region];

--Sorting largest emission grouped by Income in 2018
SELECT Countries.IncomeGroup, SUM(Emission.[2018]) AS [2018Emission] FROM Countries
JOIN Emission ON Emission.[Country Name]=Countries.[Country Name]
WHERE IncomeGroup IS NOT NULL
GROUP BY Countries.IncomeGroup
ORDER BY SUM(Emission.[2018]) DESC;

--Sorting largest emission grouped by Region in 2018
SELECT Countries.Region, SUM(Emission.[2018]) AS [2018Emission] FROM Countries
JOIN Emission ON Emission.[Country Name]=Countries.[Country Name]
WHERE Region IS NOT NULL
GROUP BY Countries.Region
ORDER BY SUM(Emission.[2018]) DESC;

--Shows countries who have increased CO2 Emission from 2017-2018
Select [country name], [2017], [2018]
FROM Emission where [2018]>[2017]
ORDER BY 1;

--Sorting Countries from largest increase percentage 2017-2018
Select [country name], (([2018]-[2017])/[2017])*100 AS increasement
FROM Emission where [2018]>[2017]
ORDER BY increasement DESC;

--Shows countries who have decreased CO2 Emission from 2017-2018
Select [country name], [2017], [2018]
FROM Emission where [2018]<[2017]
ORDER BY 1;

Select [country name], (([2017]-[2018])/[2017])*100 AS decreasement
FROM Emission where [2018]<[2017]
ORDER BY decreasement DESC;

--Shows countries who have increased CO2 Emission for 3 consecutive years
SELECT [Country Name], [2016], [2017], [2018]
From Emission
WHERE [2018]>[2017] AND [2017]>[2016]
Order by [Country Name];

--Shows countries who have increased CO2 Emission for 3 consecutive years
SELECT [Country Name], [2016], [2017], [2018]
From Emission
WHERE [2018]<[2017] AND [2017]<[2016]
Order by [Country Name];
