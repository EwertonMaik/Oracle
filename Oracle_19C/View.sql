-- Visões - VIEW
-- Representação Lógica de um SELECT sobre uma ou mais tabelas
-- A visão é armazenada do dicionário de dados

-- Criando uma Visão
CREATE OR REPLACE VIEW vemployeesdept60
AS
SELECT employee_id, first_name, last_name, department_id, salary, commission_pct
FROM employees
WHERE department_id = 60;

DESC vemployeesdept60

-- Recuperando dados utilizando uma Visão
SELECT * FROM   vemployeesdept60;

-- Criando uma Visão Complexa 
CREATE OR REPLACE VIEW vdepartments_total
(department_id, department_name, minsal, maxsal, avgsal)
AS
SELECT e.department_id, d.department_name, MIN(e.salary), MAX(e.salary),AVG(e.salary)
FROM employees e 
JOIN departments d ON (e.department_id = d.department_id)
GROUP BY e.department_id, department_name;

SELECT * FROM vdepartments_total;

-- Utilizando a Cláusula CHECK OPTION
CREATE OR REPLACE VIEW vemployeesdept100
AS
SELECT employee_id, first_name, last_name, department_id, salary
FROM employees
WHERE department_id = 100
WITH CHECK OPTION CONSTRAINT vemployeesdept100_ck; -- View poderá ser usada para validação em uma consulta

-- Utilizando a Cláusula READ ONLY
CREATE OR REPLACE VIEW vemployeesdept20
AS
SELECT employee_id, first_name, last_name, department_id, salary
FROM employees
WHERE department_id = 20
WITH READ ONLY; -- Permite que a view seja usada apanas para leitura / consulta, impedindo operações DML

-- Removendo uma Visão
DROP VIEW vemployeesdept20;
