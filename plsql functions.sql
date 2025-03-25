---PLsql functions

---function to calculate the death stastics in years
create or replace function yearly_cumulative_deaths(input_year in number)
 return number
is 
 cumulative_deaths_year number;
begin
  select sum(new_deaths)into cumulative_deaths_year from a1phra.global_covid_statistics where report_year=input_year; 
  return cumulative_deaths_year;
end yearly_cumulative_deaths;
/

SELECT '2023' as year,yearly_cumulative_deaths(2023) AS cumulative_deaths_for_2023
FROM dual
UNION ALL
SELECT '2022',yearly_cumulative_deaths(2022) AS cumulative_deaths_for_2023
FROM dual
UNION ALL
SELECT '2021',yearly_cumulative_deaths(2021) AS cumulative_deaths_for_2023
FROM dual
UNION ALL
SELECT '2020',yearly_cumulative_deaths(2020) AS cumulative_deaths_for_2023
FROM dual;
