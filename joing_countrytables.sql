---joining table to get country descriptions
select count(*) from datascore;
select * from last_10_countryindicator;

--creating an average of countries of last 10 years on country indicators
CREATE VIEW COUNTRY_AVG_BF_COVD AS
SELECT COUNTRY,
       ROUND(AVG(LIFE_EXPECTANCY_WORLD_BANK), 2) AS life_expectancy,
       ROUND(AVG(PREVALENCE_OF_UNDERNOURISHMENT), 2) AS prevalence_of_undernourishment,
       ROUND(AVG(CO2), 2) AS co2,
       ROUND(AVG(HEALTH_EXPENDITURE_PERCENTAGE), 2) AS health_expenditure_percentage,
       ROUND(AVG(EDUCATION_EXPENDITURE_PERCENTAGE), 2) AS education_expenditure_percentage,
       ROUND(AVG(UNEMPLOYMENT), 2) AS unemployment,
       ROUND(AVG(CORRUPTION), 2) AS corruption,
       ROUND(AVG(SANITATION), 2) AS sanitation,
       ROUND(AVG(INJURIES), 2) AS injuries,
       ROUND(AVG(COMMUNICABLE), 2) AScommunicable,
       ROUND(AVG(NONCOMMUNICABLE), 2) AS noncommunicable
FROM last_10_countryindicator
GROUP BY COUNTRY
ORDER BY COUNTRY;
