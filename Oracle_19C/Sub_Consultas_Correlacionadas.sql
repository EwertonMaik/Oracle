-- Utilizando Sub-Consultas Correlacionadas
SELECT
		e1.employee_id,
		e1.first_name,
		e1.last_name,
		e1.department_id,
		e1.salary
FROM   employees e1 -- Select trará todos os registros de employees, baseado em e1.salary >= a
WHERE  e1.salary >= ( -- média dos salarios, porém quando existir a relação de e1.department_id = e2.department_id
					 SELECT TRUNC(AVG(NVL(salary,0)),0) FROM employees e2
                     WHERE     e1.department_id = e2.department_id
					 );


-- Utilizando Sub-Consultas Multiple-Column (Que comparam mais de uma coluna)
SELECT
		e1.employee_id,
		e1.first_name,
		e1.job_id,
		e1.salary
FROM   employees e1 -- Seleciona todos os registros de employees
WHERE (e1.job_id, e1.salary) -- Quando as duas colunas informadas estão dentro da Sub-Consulta do IN
IN (SELECT e2.job_id, MAX(e2.salary) FROM employees e2 -- E nesta Sub-Consulta é retornado duas colunas também
    GROUP by e2.job_id
	);

-- Utilizando Sub-Consultas na Cláusula FROM
SELECT
		empregados.employee_id,
		empregados.first_name,
		empregados.last_name,
		empregados.job_id,
		empregados.salary,
		ROUND(max_salary_job.max_salary,2) MAX_SALARY,
		empregados.salary - ROUND(max_salary_job.max_salary,2) DIFERENCA
FROM   employees empregados -- Seleciona todos registros de employees baseado na relação LEFT JOIN abaixo
LEFT JOIN ( -- Sempre traz todos os registros da tabela há esquerda, mesmo que não tenha relacionamento com a tabela do Sub-SELECT
		   SELECT e2.job_id, MAX(e2.salary) max_salary FROM employees e2 GROUP by e2.job_id
		   ) max_salary_job ON empregados.job_id = max_salary_job.job_id; -- O nome do Sub-SELECT é max_salary_job e realizado a amarração entre os campos