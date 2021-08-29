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

-- Criando Grupos de de Dados utilizando GROUP BY
-- É possivel formar grupos por mais de uma coluna ou expressão
-- Sequência Lógica de Execeução
1 - WHERE, 2 - GROUP BY, 3 - HAVING, 4 - SELECT, ORDER BY

-- Criando um grupo de department_id onde é exibido a média de salario para cada department_id
SELECT
		department_id, -- Coluna que será agrupado os dados de média de salário
		AVG(salary) -- Função que retorna a média do salario
FROM   employees
GROUP BY department_id -- Definido o Grupo
ORDER BY department_id; -- Ordenado por

-- Utilizando a clásula Group by com mais de uma Coluna ou Expressão
SELECT
		department_id, job_id, -- As duas colunas fazem parte do Agrupamento dos Dados
		SUM(salary) -- Função que soma os salarios pelos Grupo (department_id, job_id)
FROM employees
GROUP BY department_id, job_id -- Grupo de Dados
ORDER BY department_id, job_id; -- Ordenado Dados

-- Consultas incorretas utilizando Funções de Grupo
SELECT
	department_id, -- Por conta da inclusão desta coluna, a query obtem erro
	AVG(salary)
FROM   employees; -- Deveria possui a cláusula GROUP BY para agrupar os dados por department_id

-- Corrigindo consultas incorretas utilizando Funções de Grupo
SELECT
		department_id, 
		AVG(salary)
FROM employees
GROUP BY department_id; -- Incluido a cláusula

-- Consultas incorretas utilizando Funções de Grupo
SELECT
		department_id,
		MAX(salary)
FROM   employees
WHERE  MAX(salary) > 10000 -- Obtem erro pois não é possivel utilizar uma função de agregação na clausula WHERE
GROUP BY department_id;

-- Corrigindo consultas incorretas utilizando Funções de Grupo
-- Restringindo Grupos utilizando a cláusula HAVING
SELECT
		job_id,
		SUM(salary) TOTAL
FROM   employees
WHERE  job_id <> 'SA_REP'
GROUP BY job_id
HAVING   SUM(salary) > 10000 -- Clausula HAVING, onde é possivel filtrar os dados usando funções de agregação
ORDER BY SUM(salary); -- Clausula ORDER BY também aceita ordernar utilizando função de agregação

-- Aninhando Funções de Grupo
SELECT
		-- Aninhado duas funções de Agregação - Primeiro calcula a média de todos salarios
		-- Segundo é pego a maior média com a função MAX
		MAX(AVG(salary))
FROM employees
GROUP BY department_id;
