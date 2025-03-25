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
when ad.cholcheck =1 then 'Yes in last 5 years' else 'No in last 5 years'
end as cholcheck_description,
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








