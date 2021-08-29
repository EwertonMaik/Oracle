-- Funções de Grupo
--OBS - Funções de Grupo ignoram valore nulos
--AVG -- Media do Grupo
--COUNT -- Conta número de linhas do Grupo
--MAX   -- Valor maximo do Grupo
--MIM   -- Valor minimo do Grupo
--SUM   -- Soma do valor do Grupo
--STDDEV -- Desvio Padrão do Grupo - como uma função agregada ou como uma função analítica
--VARIANCE -- Variação do Grupo

-- Utilizando as Funções AVG e SUM
SELECT
		AVG(salary), -- Retorna a média do Salário
		SUM(salary)  -- Retorna a soma de todos os Salários
FROM   employees;

-- Utilizando as Funções MIN e MAX
SELECT
		MIN(hire_date), -- Retorna o valor minimo de uma data, numero ou string
		MAX(hire_date)  -- Retorna o valor maximo de uma data, numero ou string 
FROM   employees;

SELECT
		MIN(salary), -- Retorna o valor minimo do salário
		MAX(salary)  -- Retorna o valor maximo do salario
FROM   employees;

-- Utilizando a Função COUNT
SELECT
		COUNT(*) -- Conta todos os registros da tabela employees
FROM   employees;

SELECT
		COUNT(commission_pct) -- Conta todos os registros da tabela employees da coluna commission_pct e ignora os NULLS
FROM   employees;

SELECT
		COUNT(commission_pct), -- Conta todos os registros da tabela employees da coluna commission_pct e ignora os NULLS
		COUNT(*) -- Conta todos os registros da tabela employees
FROM employees;

SELECT
		-- Conta todos os registros da tabela employees da coluna commission_pct e não ignora o NULL porque usa a função
		-- NVL para retorna 0 quando encontra um valor NULL
		COUNT(NVL(commission_pct,0))
FROM employees;

-- Utilizando a Função COUNT com DISTINCT
SELECT
		-- Conta todos os registros da tabela employees/ coluna department_id, porém ignoras os valores repetidos
		-- Pois utiliza a função DISTINCT
		COUNT(DISTINCT department_id)
FROM   employees;

SELECT
		COUNT(department_id) -- Conta todos os registros da tabela employees incluindo os registros repetidos
FROM   employees;

-- Funções de Grupo e valores NULOS
SELECT
		AVG(commission_pct), -- Retorna a média de commission_pct e ignora os nulls
		AVG(NVL(commission_pct, 0)) -- Retorna a média de commission_pct e não ignora os nulls, pois utiliza NVL para retornar zero
FROM   employees;

select
		STDDEV(bonus) -- Retorna o desvio padrão
from employees;

select
		employee_name, bonus,
		STDDEV(bonus) OVER (ORDER BY salary)
from employees
where department = 'Marketing';