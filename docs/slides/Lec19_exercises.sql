## Exercise 1

### 1. The total costs in payroll for this company

SELECT SUM(salary) FROM employees;

### 2. The average salary within each department

SELECT dept, AVG(salary) FROM employees GROUP BY dept;


## Exercise 2

SELECT *, round(salary-avg,2) AS diff 
FROM employees
NATURAL JOIN  (
  SELECT dept, round(avg(salary),2) AS avg FROM employees GROUP BY dept
) dept_avg
ORDER dept, diff;

## ┌─────────┬───────────────────┬─────────┬────────────┬──────────┬─────────┐
## │  name   │       email       │ salary  │    dept    │   avg    │  diff   │
## │ varchar │      varchar      │ double  │  varchar   │  double  │ double  │
## ├─────────┼───────────────────┼─────────┼────────────┼──────────┼─────────┤
## │ Alice   │ alice@company.com │ 52000.0 │ Accounting │ 41666.67 │ 10333.0 │
## │ Bob     │ bob@company.com   │ 40000.0 │ Accounting │ 41666.67 │ -1667.0 │
## │ Carol   │ carol@company.com │ 30000.0 │ Sales      │  37000.0 │ -7000.0 │
## │ Dave    │ dave@company.com  │ 33000.0 │ Accounting │ 41666.67 │ -8667.0 │
## │ Eve     │ eve@company.com   │ 44000.0 │ Sales      │  37000.0 │  7000.0 │
## │ Frank   │ frank@comany.com  │ 37000.0 │ Sales      │  37000.0 │     0.0 │
## └─────────┴───────────────────┴─────────┴────────────┴──────────┴─────────┘


## Exercise 3

SELECT sum(seats) FROM flights NATURAL LEFT JOIN planes; # Wrong

SELECT sum(seats) FROM flights LEFT JOIN planes USING (tailnum); # Correct
