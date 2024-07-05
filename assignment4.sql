select * from salary_pred limit 10;

-- Average salary of analysts byb department

with salary_grouped as (
select unit, avg(salary), designation from salary_pred
where designation= 'Analyst'
group by unit, designation)
select * from salary_grouped;


-- Employees with more than 10 leaves

with leave_limiter as (
select first_name, last_name, leaves_used from salary_pred
where leaves_used >= 10
)
select * from leave_limiter;

--  Creating a view to show all senior analysts

create view senior_analysts as
select * from salary_pred where designation= 'Senior Analyst';

select * from senior_analysts;


-- Create a materialized view to store the count of employees by department

create materialized view employee_per_department as
select unit as department, count(first_name) as number_of_employee from salary_pred
group by unit;


select * from employee_per_department;


-- Create a procedure to update an employee's salary by their first name and last name.

create or replace procedure salaryUpdater(
salaryIncrease int,
p_first_name varchar,
p_last_name varchar
)
language plpgsql
as $$
begin

update salary_pred set salary = salary + salaryIncrease
where first_name = p_first_name and last_name = p_last_name;

commit;
end;$$;

call salaryUpdater(10000,'TOMASA','ARMEN');

select * from salary_pred where first_name = 'TOMASA' and last_name='ARMEN';


-- Create a procedure to calculate the total number of leaves used across all departments

create or replace procedure leave_across_departments(
out total_leaves int
)
language plpgsql
as $$
begin

select sum(leaves_used) into total_leaves
from salary_pred;

end;$$;


DO $$
DECLARE
    total_leave int;
BEGIN
    CALL leave_across_departments(total_leave::int);
    RAISE NOTICE 'Total leave across departments: %', total_leave;
END $$;















