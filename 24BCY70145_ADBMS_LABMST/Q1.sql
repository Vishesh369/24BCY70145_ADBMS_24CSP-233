CREATE TABLE department (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(30)
);

CREATE TABLE employee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    salary NUMERIC(10,2),
    dept_id INT REFERENCES department(dept_id)
);

INSERT INTO department VALUES
(1, 'IT'),
(2, 'Sales'),
(3, 'HR');

INSERT INTO employee VALUES
(101, 'Aman', 90000, 1),
(102, 'Neha', 70000, 1),
(103, 'Raj', 50000, 1),
(104, 'Priya', 80000, 2),
(105, 'Karan', 60000, 2),
(106, 'Riya', 40000, 2),
(107, 'Mohit', 75000, 3),
(108, 'Simran', 55000, 3);

SELECT 
    d.dept_name AS "Department", 
    e.emp_name AS "Employee", 
    e.salary AS "Salary"
FROM employee e
JOIN department d 
    ON e.dept_id = d.dept_id
JOIN (
    SELECT dept_id, AVG(salary) AS avg_salary
    FROM employee
    GROUP BY dept_id
    HAVING COUNT(emp_id) >= 3
) dept_stats 
    ON e.dept_id = dept_stats.dept_id
WHERE e.salary > dept_stats.avg_salary;