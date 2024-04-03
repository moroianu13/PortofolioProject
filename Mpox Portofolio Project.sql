SELECT*
FROM mpox2023
Order by  2, 4 DESC

--SELECT*
--FROM mpox2024
--ORDER BY 2DESC , 3 DESC


SELECT DateRep , CountryExp ,ConfCases
FROM mpox2023
ORDER BY 2 , 3 DESC

             --Looking at infections/date


SELECT DateRep , MAX(ConfCases) as TOTAL 
FROM mpox2023
GROUP BY DateRep
Order by DateRep;


                  --Looking at date/country peack infection

WITH CountryPeaks AS (
    SELECT
        CountryExp,
        DateRep,
        ConfCases,
        ROW_NUMBER() OVER (PARTITION BY CountryExp ORDER BY ConfCases DESC) AS PeakRank
    FROM
        mpox2023
)

SELECT
    CountryExp,
    DateRep AS PeakDate,
    ConfCases AS PeakInfections
FROM
    CountryPeaks
WHERE
    PeakRank = 1
ORDER BY
    PeakInfections DESC;


                 --Looking at % per Country

SELECT CountryExp  ,SUM(ConfCases) as TOTAL , (SUM(ConfCases) / (SELECT SUM(ConfCases) FROM mpox2023)) * 100 AS Percentage
FROM mpox2023
GROUP BY CountryExp 
ORDER BY Percentage DESC 


-----Creating View to store data for later visualization 

CREATE VIEW DailyTotalCases2023 AS
SELECT DateRep , MAX(ConfCases) as TOTAL 
FROM mpox2023
GROUP BY DateRep
--ORDER BY DateRep



CREATE VIEW CountryPeakInfections AS
WITH CountryPeaks AS (
    SELECT
        CountryExp,
        DateRep,
        ConfCases,
        ROW_NUMBER() OVER (PARTITION BY CountryExp ORDER BY ConfCases DESC) AS PeakRank
    FROM
        mpox2023
)
SELECT
    CountryExp,
    DateRep AS PeakDate,
    ConfCases AS PeakInfections
FROM
    CountryPeaks
WHERE
    PeakRank = 1
--ORDER BY PeakInfections DESC;


CREATE VIEW CountryCasePercentages AS
SELECT 
    CountryExp, 
    SUM(ConfCases) AS TotalCases, 
    (SUM(ConfCases) / (SELECT SUM(ConfCases) FROM mpox2023)) * 100 AS Percentage
FROM 
    mpox2023
GROUP BY 
    CountryExp 
--ORDER BY Percentage DESC;
