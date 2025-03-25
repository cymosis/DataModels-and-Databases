---indexing on country_year_indicatiors_part
CREATE INDEX IDX_COUNTRY_YEAR_PART ON A1PHRA.COUNTRY_YEAR_INDICATORS_PART(COUNTRY);

---partitioning into each year 
--creating anew table with partioned data


CREATE TABLE A1PHRA.COUNTRY_YEAR_INDICATORS_PART (
    COUNTRY VARCHAR2(100) NOT NULL,
    COUNTRY_CODE VARCHAR2(10),
    REGION VARCHAR2(50),
    INCOMEGROUP VARCHAR2(50),
    YEAR NUMBER(38,0) ,
    LIFE_EXPECTANCY_WORLD_BANK FLOAT,
    PREVALENCE_OF_UNDERNOURISHMENT FLOAT,
    CO2 FLOAT,
    HEALTH_EXPENDITURE_PERCENTAGE FLOAT,
    EDUCATION_EXPENDITURE_PERCENTAGE FLOAT,
    UNEMPLOYMENT FLOAT,
    CORRUPTION FLOAT,
    SANITATION FLOAT,
    INJURIES FLOAT,
    COMMUNICABLE FLOAT,
    NONCOMMUNICABLE FLOAT,
    CONSTRAINT PK_COUNTRY_YEAR_PART PRIMARY KEY (COUNTRY,YEAR)
)
PARTITION BY RANGE (YEAR) ( 
    PARTITION p_before_2000 VALUES LESS THAN (2000),
    PARTITION p_2000_2009 VALUES LESS THAN (2010),
    PARTITION p_2010_2019 VALUES LESS THAN (2020),
    PARTITION p_2020_2029 VALUES LESS THAN (2030),
    PARTITION p_future VALUES LESS THAN (MAXVALUE)
);


---inserting data
INSERT INTO A1PHRA.COUNTRY_YEAR_INDICATORS_PART


SELECT * FROM A1PHRA.COUNTRY_YEAR_INDICATORS 

--cleaning the diabetes table and updating it with values instead of binary represenattion
-- Creating the table
CREATE TABLE a1phra.diabetes_1 (
    naming VARCHAR2(1000),
    diabetes_code NUMBER,  
    general_description VARCHAR2(255)
);
-- Inserting data into the table
INSERT INTO a1phra.diabetes_1 (naming, diabetes_code, general_description) 
VALUES ('No diabetes', 0, 'No diabetes');
INSERT INTO a1phra.diabetes_1 (naming, diabetes_code, general_description) 
VALUES ('Pre diabetes', 1, 'Pre diabetes');
INSERT INTO a1phra.diabetes_1 (naming, diabetes_code, general_description) 
VALUES ('Diabetes', 2, 'Diabetes')

---replacing codes with real dscriptions

create view diabetes_transformed as 
select d1.naming as diabetes_description,
case
when ad.highbp =1 then 'High' else 'Not High' end as highbp_description,
case
when ad.highchol =1 then 'High' else 'Not High' end as highcol_description,
case
when ad.cholcheck =1 then 'Yes in last 5 years' else 'No in last 5 years' end as cholcheck_description,
case
when ad.smoker =1 then 'Yes more than 100 cigarates' else 'No' end as smoker_description,
case
when ad.stroke =1 then 'Yes' else 'No' end as stroke_description,
case
when ad.heartdiseaseorattack =1 then 'Yes' else 'No' end as heartattack_description,
case
when ad.physactivity =1 then 'Yes inlast 30 days' else 'No' end as physactivity_description,
case
when ad.fruits =1 then 'Yes' else 'No' end as fruits_description,
case
when ad.veggies =1 then 'Yes' else 'No' end as veggies_description,
case
when ad.sex =1 then 'Male' else 'Female' end as sex_description,
case
when ad.anyhealthcare =1 then 'Insurance covered' else 'No Insurance' end as insurance_coverage,
case
when ad.HVYALCOHOLCONSUMP =1 then 'Yes' else 'No' end as heavyalcohol_intake,

ad.BMI,ad.age,ad.sex,ad.income,ad.education
from a1phra.diabetes ad
join diabetes_1 d1 on d1.diabetes_code=ad.diabetes;


---cleanng the doctor_patient

UPDATE a1phra.doctor_patient
SET DATES = TO_DATE(DATES, 'YYYY-MM-DD');

UPDATE a1phra.doctor_patient
SET YEAR_COL = TO_NUMBER(TO_CHAR(DATES, 'YYYY')),
    MONTH_COL = TO_NUMBER(TO_CHAR(DATES, 'MM'));








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

---joining tables datascores, with with country to get country id
select cs.id_row as country_id,ds.* from a1phra.countries cs join datascore ds on
UTL_MATCH.EDIT_DISTANCE_SIMILARITY(trim(ds.country), trim(cs.name)) > 70;

---joining tables last_10_countryindicator with country to get country id
select cs.id_row as country_id,ls.* from a1phra.countries cs join last_10_countryindicator ls on
UTL_MATCH.EDIT_DISTANCE_SIMILARITY(ls.country, cs.name) > 80;

--joining with avg_bf_covid
select cs.id_row as country_id,ls.* from a1phra.countries cs join country_avg_bf_covd ls on
UTL_MATCH.EDIT_DISTANCE_SIMILARITY(ls.country, cs.name) > 80;


--joining country description tables the updatec ones
CREATE TABLE a1phra.all_country_metrics AS
SELECT ds.country_id,ds.country,ds.governance,ds.marketaccessinfrastructure,ds.economicquality,ds.health,
ds.education,ls.life_expectancy,ls.prevalence_of_undernourishment,ls.health_expenditure_percentage,ls.education_expenditure_percentage,
ls.unemployment,ls.corruption,ds.socialcapital
FROM updated_datascore ds
JOIN updated_cpuntry_avg_bf_covd ls
  ON ls.country_id = ds.country_id;


---selecting only rows with no nulls in country and country_1
---Cleaning up country data ,triming data values
update a1phra.country_year_indicators set country = trim(country);
update a1phra.countryscores set country = trim(country);

--Creating a view of country_year_indicators for 
CREATE VIEW LAST_10_COUNTRYINDICATOR AS SELECT * FROM A1PHRA.COUNTRY_YEAR_INDICATORS_PART where YEAR > 2010 AND YEAR <=2020;

---creating datascore view
CREATE VIEW DATASCORE AS SELECT * FROM A1PHRA.countryscores;

--created view on diabetes on data cleaning

-- Create table countries
CREATE TABLE a1phra.countries (
    id_row NUMBER(6),
    name VARCHAR2(200),
    country_code VARCHAR2(200)
);


---create a view of updated datascore and update avg_bf_covd
drop view updated_datascore;
create view updated_datascore as select cs.id_row as country_id,ds.* from a1phra.countries cs join datascore ds on
UTL_MATCH.EDIT_DISTANCE_SIMILARITY(trim(ds.country), trim(cs.name)) > 70;

create view updated_last_10_country as select cs.id_row as country_id,ls.* from a1phra.countries cs join last_10_countryindicator ls on
UTL_MATCH.EDIT_DISTANCE_SIMILARITY(ls.country, cs.name) > 80;

create view updated_cpuntry_avg_bf_covd as select cs.id_row as country_id,ls.* from a1phra.countries cs join country_avg_bf_covd ls on
UTL_MATCH.EDIT_DISTANCE_SIMILARITY(ls.country, cs.name) > 80;

---all coutries metrics
create view all_countries_metrics as select * from a1phra.all_country_metrics;
--creating trigger to insert country_id each time a country is added
CREATE OR REPLACE TRIGGER a1phra.countries_seq
BEFORE INSERT ON a1phra.countries
FOR EACH ROW
BEGIN
    IF :NEW.id_row IS NULL THEN
        SELECT a1phra.countries_seq.NEXTVAL INTO :NEW.id_row FROM DUAL;
    END IF;
END;
/





