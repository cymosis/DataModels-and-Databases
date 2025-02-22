--See schema name and tables
SELECT owner, table_name 
FROM all_tables;
--Count tables
SELECT count(table_name) as count_table from all_tables;
--myview
create table MYVIEW_DEPT as (select * from NIKOVITS.dept);
create table myview_emp as (select * from nikovits.emp);
--view columns
select * from myview_dept;
select * from myview_emp;
--map all data
create table emp_data as (select me.*,mt.dname,mt.loc from myview_emp me
join myview_dept mt on mt.deptno = me.deptno);
--select all columns from all_data
select * from emp_data;
--Question 1-Who has any commission? (NOT NULL)
select ename from emp_data where comm is not null;
--Question 2-Which employees work on a department not located at Boston or Chicago? (MINUS)
select * from emp_data where loc <>'BOSTON' AND loc <>'CHICAGO';
--Question 3-Who earns more than 3000 or works on dept. 30? (UNION)
select * from emp_data where sal > 3000 or deptno = 30;
--Question 4. Who was hired before 01-06-1981? (DATE TYPE, FUNCTIONS
select * from emp_data where hiredate > TO_DATE('01-JUN-1981', 'DD-MON-YYYY');
--Question 5. How much is the maximal salary of the employees?
select max(sal) as maximum_salary from emp_data;
--Question 6. How much is the sum of the salary of the employees?
select sum(sal) as sum_salary from emp_data;
--Question 7. How much is the average salary of the employees of department 20?
select avg(sal) as average_salary_dep20 from emp_data where deptno=20;
--Question 8. How many different jobs are there amongst the employees?
select DISTINCT(JOB) as different_jobs from emp_data;
--Question 9. How many employees has greater salary than 2000?
select count(*) as greater_salary_2000 from emp_data where sal > 2000;
--Question 10. List the average of the salary grouped by the departments!
select dname as department_name , ROUND(AVG(sal),2) as average_salary from emp_data group by dname;
--Question 11. List the number of workers for each departments!
select dname, LISTAGG(ename,',') within group(order by ename)as employees from emp_data group by dname;
--Question 12. List the average salary of those departments which has average salary greater than 2000!
select dname as department_name, round(avg(sal),2) as average_salary from emp_data having avg(sal) > 2000 group by dname;
--13. List the average salary of those departments which has more than 4 workers!
select dname as department_name, avg(sal) as average_salary from emp_data group by dname having count(ename)>5;
--Question 14. Who has the same salary and works on the same department than MARTIN (CROSS JOIN)
select * from myview_emp me cross join myview_dept mt where me.deptno in (select deptno from myview_emp where ename='MARTIN')
AND me.sal =(select sal from myview_emp where ename='MARTIN') AND me.ename <> 'MARTIN';
---Question 15 Which employees work on a department located at Boston or Chicago? (JOIN, NATURAL JOIN)
select * from emp_data where loc = 'BOSTON' OR loc = 'CHICAGO';
---Question 16 Who earns more than ALLEN?
select * from emp_data where sal > (select sal from emp_data where ename='ALLEN');
--Question 17 Select the employees with their job who have the lowest/highest salary!
select ename,job from emp_data where sal= (select min(sal)from emp_data) or sal=( select max(sal)from emp_data);
--Question 18 List the lowest salary for every department where the lowest salary is below the lowest salary of dept. 30

--Question 19 Who earns less than any/every CLERK?
select * from emp_data where sal <(select avg(sal) from emp_data where job='CLERK') and job='CLERK';
--Question 20. Which dept. has no employee? (OUTER JOIN or SUBQUERY with NOT EXIST )


--Question 21. Determine the number of employees for every deptartment! (0 where the dept has no employee) 

22. Delete the employees with NULL commission!
23. Delete the employees who hired before 1982!
24. Delete the employees who works in Dallas!
25. Delete the employees who has lower salary than tha average!
26. Delete the employee with the highest salary!
27. Delete the departments which have at least 2 employee in the second salary grade (SALGRADE table) 
28. Insert a new employee called ’Williams’ to the EMP table. Empno=1, ename=' Williams ', deptno=10,
 hire_date=today, sal=average salary of dept. 10. Rest of the attributes be NULL. 
 UPDATE:
--Question 29. Increase the salary of employees at dept. 20 by 20%.

30. Increase everyone’s commission with the highest commision. 