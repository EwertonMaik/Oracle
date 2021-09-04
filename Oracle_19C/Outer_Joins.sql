-- LEFT OUTER JOIN -- Traz todos os registros da tabela da esquerda
-- e o que houver de relacionamento com a tabela da direita
SELECT
		e.first_name,
		e.last_name,
		d.department_id,
		d.department_name
FROM employees e
LEFT OUTER JOIN departments d ON (e.department_id = d.department_id) 
ORDER BY d.department_id;

-- RIGHT OUTER JOIN -- traz todos os registros da tabela da direita
-- e o que houver de relacionamento com a tabela da esquerda
SELECT
		d.department_id,
		d.department_name,
		e.first_name,
		e.last_name
FROM employees e
RIGHT OUTER JOIN departments d ON (e.department_id = d.department_id) 
ORDER BY d.department_id;

-- FULL OUTER JOIN -- Traz todos os registros relacionados entre a tabela da esquerda e direita
-- e traz tudo o que tiver relação entre as duas tabelas também
SELECT
		d.department_id,
		d.department_name,
		e.first_name,
		e.last_name
FROM   employees e
FULL OUTER JOIN departments d ON (e.department_id = d.department_id) 
ORDER BY d.department_id;