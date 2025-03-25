---doctor_patient(this represents the no of beds in 2020)
select * from a1phra.doctor_patient;
ALTER TABLE a1phra.doctor_patient
ADD report_month NUMBER;

---update month
UPDATE a1phra.doctor_patient
SET DATES = TO_DATE(DATES, 'YYYY-MM-DD');

UPDATE a1phra.doctor_patient
SET report_month = EXTRACT(MONTH FROM TO_DATE(DATES, 'YYYY-MM-DD'));

---update year
ALTER TABLE a1phra.doctor_patient
ADD report_year NUMBER;

UPDATE a1phra.doctor_patient
SET report_year = EXTRACT(YEAR FROM TO_DATE(DATES, 'DD-MM-YY'));  





--function to replace null values in daily tests
create or replace procedure daily_tests(replacor in number)IS
BEGIN
    update a1phra.doctor_patient
    set dailytests=replacor 
    where dailytests is null;
    commit;
end;
/
exec daily_tests(0);

--function to update null values in deaths
create or replace procedure death_replace(replacor in number) IS
BEGIN
    update a1phra.doctor_patient
    set deaths=replacor 
    where deaths is null;
    commit;
end;
/
exec death_replace(0);

--create a view of average doctor_patients
--drop view average_doctor_patients;
CREATE VIEW average_doctor_patients AS
SELECT 
    report_year,
    COUNTRY,
    ROUND(AVG(AVERAGETEMPERATURE)) AS avg_temperature,
    ROUND(AVG(BEDSPER1000)) AS avg_beds_per_1000,
    ROUND(AVG(DOCTORSPER1000)) AS avg_doctors_per_1000,
    ROUND(AVG(GDP)) AS avg_gdp,
    ROUND(AVG(POPULATION)) AS avg_population,
    ROUND(AVG(MEDIANAGE)) AS avg_median_age,
    ROUND(AVG(POPULATIONABOVE65)) AS avg_population_above_65,
    ROUND(AVG(DAILYTESTS)) AS avg_daily_tests,
    ROUND(AVG(CASES)) AS avg_cases,
    ROUND(AVG(DEATHS)) AS avg_deaths
FROM a1phra.doctor_patient
GROUP BY report_year, COUNTRY;


---joining tables datascores, with with country to get country id
create view all_doctor_patients as select cs.id_row as country_id,ds.* from a1phra.countries cs join average_doctor_patients ds on
UTL_MATCH.EDIT_DISTANCE_SIMILARITY(trim(ds.country), trim(cs.name)) > 70;

---joining tables datascores, with with country to get country id
create view all_covid_statistics as select cs.id_row as country_id,ds.* from a1phra.countries cs join average_covid_statistics ds on
UTL_MATCH.EDIT_DISTANCE_SIMILARITY(trim(ds.country), trim(cs.name)) > 70;

select * from all_covid_statistics where report_year='2020';

select * from all_doctor_patients where report_year='2020';









