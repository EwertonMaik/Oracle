-- Operadores SET combinam multiplas consultas em uma única consulta
-- Pode controlar a ordem que as linhas são retornadas
-- Operadores SET trabalham com conjuntos
-- O número de colunas ou expressões da lista de colunas ou expressões em cada SELECT devem ser iguais
-- O tipo de dado de cada coluna ou expressão na lista de colunas ou expressão em cada SELECT respectivamente devem combinar
-- Parênteses podem ser utilizados para alterar a sequ~encia de execução
-- A cláusula ORDER BY deve ser informada somente para o resultado final
-- Linhas duplicadas são automaticamente eliminadas, exceto pelo operador UNION ALL
-- São os nomes de colunas da primeira consulta que aparecem no cabeçalho do resultado

1 - UNION / UNION ALL -- SOMA TUDO
2 - INTERSECT -- TRAZ A INTERSEÇÂO ENTRE AS TABELAS INFORMADAS
3 - MINUS -- SUBTRAI


-- Utilizando o operador UNION - Uni as duas consultas e exibe apenas 1 registro caso tenha linha duplicada
SELECT
		employee_id,
		job_id,
		hire_date,
		salary
FROM    employees
WHERE   department_id IN (60, 90, 100)
UNION
SELECT
		employee_id,
		job_id,
		hire_date,
		salary
FROM    employees
WHERE   job_id = 'IT_PROG'
ORDER BY employee_id;

-- Utilizando o operador UNION ALL -- Soma tudo e exibe as linhas duplicadas
SELECT
		employee_id,
		job_id,
		hire_date,
		salary
FROM   	employees
WHERE  job_id = 'IT_PROG'
UNION ALL
SELECT
		employee_id,
		job_id,
		hire_date,
		salary
FROM   	employees
WHERE  department_id = 60
ORDER BY employee_id;

-- Utilizando operador INTERSECT -- Retorna apenas os registrom em comum entre as duas consultas
SELECT
		employee_id,
		job_id
FROM   	employees
WHERE   job_id = 'IT_PROG'
INTERSECT
SELECT
		employee_id,
		job_id
FROM    employees
WHERE   department_id IN (60, 90, 100)
ORDER BY employee_id;

-- Utilizando operador MINUS -- Retorna a primeira consulta - a segunda consulta
SELECT
		employee_id,
		job_id
FROM    employees
WHERE   department_id IN (60, 90, 100)
MINUS
SELECT
		employee_id,
		job_id
FROM    employees
WHERE   job_id = 'IT_PROG'
ORDER BY employee_id;

-- Cuidados com os tipos de dados na lista de colunas ou expressões do SELECT
-- Query obtem erro devido na 1º consulta a coluna hire_date é de um tipo e na 2º consulta salary ser outro tipo
SELECT
		employee_id,
		job_id,
		hire_date
FROM   	employees
WHERE   department_id IN (60, 90, 100)
UNION
SELECT
		employee_id,
		job_id,
		salary
FROM    employees
WHERE   job_id = 'IT_PROG'
ORDER BY employee_id;

-- Corrigindo o erro
SELECT
		employee_id,
		job_id,
		hire_date,
		salary
FROM    employees
WHERE   department_id IN (60, 90, 100)
UNION
SELECT
		employee_id,
		job_id,
		hire_date,
		salary
FROM    employees
WHERE   job_id = 'IT_PROG'
ORDER BY employee_id;

-- Utilizando mais de um operador SET
-- Toda consulta tem 2 operadores, e é usado parenteses para alterar a ordem de precedencia 
SELECT
		employee_id,
		job_id,
		hire_date,
		salary
FROM    employees
WHERE   department_id IN (60, 90, 100)
UNION
(	SELECT
			employee_id,
			job_id,
			hire_date,
			salary
	FROM    employees
	WHERE   job_id = 'IT_PROG'
	INTERSECT
	SELECT
			employee_id,
			job_id,
			hire_date,
			salary
	FROM    employees
	WHERE   salary > 10000
)
ORDER BY employee_id;