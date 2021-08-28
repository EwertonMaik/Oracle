-- Comando para desbloquear, bloquear e alterar a senha de usuario hr
alter user hr account unlock;
alter user hr account lock;
alter user hr identified by senha123;

-- Comando do banco Oracle para ver descricao de uma Tabela
DESCRIBE employees
DESC     employees

-- Estrutura comando SELECT padrao, seleciona todas as colunas
select * from departments;

-- Selecionando apenas algumas colunas da tabela
SELECT department_id, department_name, manager_id FROM   departments;

-- Selecionando algumas colunas e realizando operações aritméticas
SELECT  first_name, last_name, salary, (salary * 1.15) as aumento_salario  FROM employees;

-- Conforme regra de precedencia, sera multiplicado primeiro e depois realizado a soma
SELECT  first_name, last_name, salary, salary + 100 * 1.15 FROM employees;

-- Com utilizacao de parenteses e possivel alterar a regra de precedencia, sera realizado a soma e apos a multiplicacao
SELECT  first_name, last_name, salary, ((salary + 100) * 1.15) as aumento_salario FROM employees;

-- Toda operacao aritmetica realizada com um coluna que contenha um valor NULL retornara NULL
SELECT  first_name, last_name, job_id, commission_pct, (200000 * commission_pct) valor_numerico_x_campo_null
FROM    employees WHERE   commission_pct IS NULL;

-- Formar de apelidar com alias uma coluna usando AS ou Aspas Dupla - ""
SELECT first_name AS nome,
	   last_name AS sobrenome,
	   salary AS salário
FROM employees;

SELECT first_name "Nome",
	   last_name  "Sobrenome",
	   salary     "Salário ($)",
	   commission_pct "Percentual de comissão"
FROM   employees;

-- Utilizando Operador alternativo para utilizar um apelido que conten aspas simples internamente
SELECT department_name || q'[ Department's Manager Id: ]' || manager_id "Departamento e Gerente"
FROM departments;

-- Utilizando DISTINCT para eliminar linhas duplicadas
SELECT DISTINCT department_id FROM employees;

-- Utilizando a clausula WHERE para restringir e filtrar linhas
SELECT employee_id, last_name, job_id, department_id
FROM employees
WHERE department_id = 60;

SELECT employee_id, last_name, job_id, department_id
FROM   employees
WHERE  job_id = 'IT_PROG';

SELECT first_name, last_name, job_id, department_id, hire_date
FROM employees
WHERE hire_date = '30/01/04';

SELECT last_name, salary
FROM employees
WHERE salary >= 10000;

-- Utilizando operador BETWEEN para filtrar periodos, faixas, intervalos
SELECT last_name, salary
FROM employees
WHERE salary BETWEEN 10000 AND 15000;

-- Utilizando operador IN para filtrar usando uma lista
SELECT employee_id, last_name, salary, manager_id, job_id
FROM employees
WHERE job_id IN ('IT_PROG', 'FI_ACCOUNT', 'SA_REP') ;

-- Utilizando operador LIKE para filtrar dados
SELECT first_name, last_name, job_id
FROM employees
WHERE first_name LIKE 'Sa%'; -- Pesquisa todos os registros da coluna first_name que iniciam com os caracteres (Sa)
-- LIKE '%Sa'  - Pesquisa os registros onde o valor termina com (Sa)
-- LIKE '%Sa%' - Pesquisa os registros onde contem o valor (Sa) em qualquer posicao do registro
-- LIKE '_Sa%' - Pesquisa os registros onde contem o valor (Sa) na segunda posicao do registro.

-- Comparações com valor NULL
SELECT last_name, manager_id
FROM employees
WHERE manager_id = NULL ;

-- Utilizando a expressão de comparação IS NULL
SELECT last_name, manager_id
FROM employees
WHERE manager_id IS NULL;

-- Utilizando o operador AND
SELECT employee_id, last_name, job_id, salary
FROM    employees
WHERE salary >= 5000
AND   job_id =  'IT_PROG' ;

-- Utilizando o operador OR
SELECT employee_id, last_name, job_id, salary
FROM    employees
WHERE salary >= 5000
OR   job_id =  'IT_PROG';

-- Utilizando o operador NOT
SELECT employee_id, last_name, salary, manager_id, job_id
FROM employees
WHERE job_id NOT IN ('IT_PROG', 'FI_ACCOUNT', 'SA_REP');

-- Regras de Precedência
SELECT last_name, job_id, salary
FROM employees
WHERE job_id = 'SA_REP'  OR job_id = 'IT_PROG' AND salary > 10000;

-- Utilizando parênteses para sobrepor as regras de precedência
SELECT last_name, job_id, salary
FROM employees
WHERE (job_id = 'SA_REP' OR job_id = 'IT_PROG') AND salary > 10000;

-- Utilizando a cláusula ORDER BY - Ordem Ascendente
SELECT last_name, job_id, department_id, hire_date
FROM employees
ORDER BY hire_date ASC;

-- Utilizando a cláusula ORDER BY – Ordem Descendente
SELECT last_name, job_id, department_id, hire_date
FROM employees
ORDER BY hire_date DESC;

-- Utilizando a cláusula ORDER BY – Referenciando ALIAS
SELECT employee_id, last_name, (salary * 12) as salario_anual
FROM employees
ORDER BY salario_anual;

-- Utilizando a cláusula ORDER BY – Referenciando a Posição
SELECT last_name, job_id, department_id, hire_date
FROM employees
ORDER BY 4;

-- Utilizando a cláusula ORDER BY – Múltiplas colunas ou expressões
SELECT last_name, department_id, salary
FROM employees
ORDER BY department_id, salary DESC;

-- Utilizando Variáveis de Substituição - & - Quando executado a query, será aberto prompot para passar o parametro
-- A cada execução é solicitado para digitar o valor
SELECT employee_id, last_name, salary, department_id
FROM employees
WHERE employee_id = &employee_id;

-- Utilizando Variáveis de Substituição - && - Ao usar 2 &&, é solicitado uma única vez
SELECT employee_id, last_name, salary, department_id
FROM employees
WHERE employee_id = &&employee_id;

-- Variáveis de substituição com valores tipo Character e Date
SELECT last_name, department_id, job_id, (salary * 12) as salario_anual
FROM employees
WHERE job_id = '&job_id' ;

-- Utilizando o comando DEFINE para criar uma variavel
DEFINE employee_id = 101

SELECT employee_id, last_name, salary, department_id
FROM employees
WHERE employee_id = &employee_id ;

DEFINE employee_id
UNDEFINE employee_id