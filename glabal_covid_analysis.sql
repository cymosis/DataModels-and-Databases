---creating a new column year and month

ALTER TABLE a1phra.global_covid_statistics
ADD report_month NUMBER;
UPDATE a1phra.global_covid_statistics
SET report_month = EXTRACT(MONTH FROM date_reported);

ALTER TABLE a1phra.global_covid_statistics
ADD report_year NUMBER;
UPDATE a1phra.global_covid_statistics
SET report_year= EXTRACT(YEAR FROM date_reported);

---function to calculate the statistics in years
create or replace function yearly_cumulative_deaths(input_year in number)
 return number
is 
 cumulative_deaths_year number;
begin
  select sum(cumulative_deaths)into cumulative_deaths_year from a1phra.global_covid_statistics where report_year=input_year; 
  return cumulative_deaths_year;
end yearly_cumulative_deaths;
/
SELECT yearly_cumulative_deaths(2023) AS cumulative_deaths_for_2023
FROM dual;
SELECT yearly_cumulative_deaths(2022) AS cumulative_deaths_for_2023
FROM dual;

---function (stored procedure)
ALTER TABLE a1phra.global_covid_statistics 
ADD cases_before NUMBER;

CREATE OR REPLACE PROCEDURE cases_before_today IS
    CURSOR covid_cursor IS
        SELECT cumulative_cases, new_cases, rowid AS row_id
        FROM a1phra.global_covid_statistics;
    -- Declare variables to hold fetched column values
    v_cumulative_cases NUMBER;
    v_new_cases NUMBER;
    v_row_id ROWID;
BEGIN
    -- Open the cursor and loop through each row
    FOR rec IN covid_cursor LOOP
        -- Update each row individually
        UPDATE a1phra.global_covid_statistics
        SET cases_before = rec.cumulative_cases - rec.new_cases
        WHERE rowid = rec.row_id;
    END LOOP;
    COMMIT; -- Save all changes at the end
END;
/
EXEC cases_before_today;

---replacing null values in new_deaths with 0
CREATE OR REPLACE PROCEDURE replace_missing_values(
    replacer IN NUMBER 
) IS
BEGIN
    UPDATE a1phra.global_covid_statistics
    SET new_deaths = replacer
    WHERE new_deaths IS NULL; 
    COMMIT; 

END;
/

EXECUTE replace_missing_values(0);


---replace new cases with 0
create or replace procedure missing_values_case(replacer in float
) IS
    cursor all_new_cases is
        select rowid from a1phra.global_covid_statistics where new_cases is null;
BEGIN
    FOR roc in all_new_cases loop
        update a1phra.global_covid_statistics
        set new_cases=replacer
        where new_cases is null;
    end loop;
    commit;
end;
/
EXECUTE missing_values_case(0);

---count the regions

SET SERVEROUTPUT ON;

DECLARE
    Euro_count NUMBER;
BEGIN
    -- Count the NULL values in the 'new_cases' column
    SELECT COUNT(*)
    INTO Euro_count
    FROM a1phra.global_covid_statistics
    WHERE who_region = 'EURO';

    -- Output the result using DBMS_OUTPUT
    DBMS_OUTPUT.PUT_LINE('Number of Euro values in new_cases: ' || Euro_count);
END;
/

---cases by moth
set serveroutput on;

create or replace procedure cases_by_month IS

BEGIN

 for rec in(select report_month,sum(new_cases)as month_cases from a1phra.global_covid_statistics group by report_month) loop
    dbms_output.put_line('Month '||rec.report_month||' Sum of Cases '||rec.month_cases);
 end loop;
end;
/
exec cases_by_month;

--cases by year
set serveroutput on;
create or replace procedure cases_by_year IS
BEGIN 
 for rec in (select report_year,sum(new_cases) as yearly_cases from a1phra.global_covid_statistics group by report_year)loop
    dbms_output.put_line(rec.report_year ||' Year  '||rec.yearly_cases);
 end loop;
end;
/
exec cases_by_year;
---Count Countries zero cases of covid 2024
create or replace procedure zero_cases_2024(year in number) IS
    zero_count NUMBER;
BEGIN
    SELECT COUNT(distinct country) 
    INTO zero_count
    FROM all_covid_statistics
    WHERE report_year = year AND total_new_cases= 0;
    IF zero_count > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Number of countries with zero cases 2024: ' || zero_count);
    ELSE
        DBMS_OUTPUT.PUT_LINE('No countries with zero count.');
    END IF;
END;
/
execute zero_cases_2024(2024)





--create a view
--drop view average_covid_statistics;
CREATE VIEW average_covid_statistics AS
SELECT 
    report_year,
    country_code,
    COUNTRY,
    ROUND(SUM(NEW_CASES)) AS total_new_cases,
    ROUND(SUM(NEW_DEATHS)) AS total_new_deaths
FROM a1phra.global_covid_statistics
GROUP BY report_year, COUNTRY,country_code;

select * from average_covid_statistics where report_year='2020';










