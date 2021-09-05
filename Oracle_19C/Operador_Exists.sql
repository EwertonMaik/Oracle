-- Utilizando operador EXISTS
-- Muito parecido com o Operador IN

SELECT
		d.department_id,
		d.department_name
FROM   departments d
WHERE  EXISTS -- seleciona os registros de departments que exista dentro da Sub-Consulta logo abaixo
             (SELECT e.department_id FROM employees e
              WHERE d.department_id = e.department_id); -- E deve existir a relação de chave entre as duas tabelas


-- Utilizando operador NOT EXISTS
-- É utilizado o operador NOT para negar o eperador EXISTS
SELECT
		d.department_id,
		d.department_name
FROM   departments d
WHERE  NOT EXISTS -- Seleciona os registros de departments que não exista dentro da Sub-Consulta logo abaixo
				  (SELECT e.department_id FROM employees e
                   WHERE d.department_id = e.department_id);