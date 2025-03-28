---diabetes description
select diabetes_description,count(*)as ROW_COUNT from diabetes_transformed group by diabetes_description;

--Descriptives of diabetes based on other input factors
select round(avg(BMI),2) as average_bmi,sex_description,diabetes_description,count(*) from diabetes_transformed 
where diabetes_description <> 'No diabetes' AND BMI > (select avg(BMI)from diabetes_transformed) 
group by sex_description,diabetes_description having avg(bmi) > (select avg(bmi) from diabetes_transformed);

