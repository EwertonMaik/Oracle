-- Funções de Conversão
-- Conversão Explicita de Tipo de Dados

to_char -- De número ou data para caractere
to_number -- De caractere para número
to_date -- De caractere para date

-- Elementos de Modelo de Formatação de DATA
-- YYYY ou RRRR - Ano com quatro digitos
-- MM - Mês com dois digitos
-- DD - Dia do mês com dois digitos
-- MONTH - Nome do mês com 9 caracteres
-- MON - Nome do mês abreviado com 3 caracteres
-- DAY - Dia da semana com 9 caracteres
-- DY - Dia da semana abreviado com 3 caracteres
-- D - Dia da semana de 1 a 7
-- YEAR - Ano soletrado (Em Inglês)
-- CC - Século
-- AC ou DC - Exibe se a data é antes de Cristo ou Depois de Cristo
-- HH ou HH12 - Hora de 1 a 12
-- MI - Minuto
-- SS - Segundo
-- Espaço, Virgula ou Ponto - espaços, Virgula ou Ponto são inseridos no Formato
-- "Texto" - Insere o texto entre aspas duplas no formato
-- SP - Números soletrados (Inglês)
-- TH - Números em ordinal (Inglês)


-- Elementos de Modelo de Formatação de Números
9 -- Numero com supressão de zeros a esquerda
0 -- Número incluindo zeros a partir a esquerda da posoição onde foi colocado o elemento de formato(0)
$ -- Símbolo de moeda ($) dollar
L -- Símbolo de moeda definido pelo parâmetro NLS_CURRENCY
. -- Decimal(.)
, -- Milhar (,)
D -- Símbolo de decimal definido de acordo com o parâmetro do banco de dados
G -- Símbolo de milhar definido de acordo com o parâmetro do banco de dados

-- Utilizando a Função TO_CHAR com Datas
SELECT
		last_name,
		TO_CHAR(hire_date, 'DD/MM/YYYY  HH24:MI:SS') DT_ADMISSAO -- Convertendo uma data para string
FROM employees;

SELECT
		sysdate,
		TO_CHAR(sysdate, 'DD/MM/YYYY  HH24:MI:SS') DATA -- Convertendo uma data para string
FROM   dual;

SELECT
		last_name,
		TO_CHAR(hire_date, 'DD, "de" Month "de" YYYY') DT_ADMISSÂO -- Convertendo uma data para string
FROM employees;

SELECT
		last_name,
		TO_CHAR(hire_date, 'FMDD, "de" Month "de" YYYY') DT_ADMISSÂO -- Convertendo uma data para string
FROM employees;

-- Utilizando a Função TO_CHAR com Números
SELECT
		first_name,
		last_name,
		TO_CHAR(salary, 'L99G999G999D99') SALARIO -- Formatando um número
FROM employees;

-- Utilizando a Função TO_NUMBER
SELECT TO_NUMBER('12000,50') FROM  dual;

-- Utilizando a Função TO_DATE
SELECT TO_DATE('06/02/2020','DD/MM/YYYY') DATA FROM  dual;

SELECT
		first_name, last_name, hire_date
FROM   employees
WHERE  hire_date = TO_DATE('17/06/2003','DD/MM/YYYY');

-- Utilizando Funções Aninhadas
SELECT
		first_name,
		last_name,
		ROUND( MONTHS_BETWEEN(SYSDATE, hire_date), 0) NUMERO_MESES -- Quantidade de meses entre duas datas e aredondado para 0 casas decimais
FROM   employees
WHERE  hire_date = TO_DATE('17/06/2003','DD/MM/YYYY');

-- Utilizando a Função NVL
SELECT
		last_name,
		salary,
		NVL(commission_pct, 0), -- Caso commission_pct seja NULL, é retornado ZERO
		salary * 12 SALARIO_ANUAL, 
       (salary * 12) + (salary * 12 * NVL(commission_pct, 0)) REMUNERACAO_ANUAL
FROM employees;

-- Utilizando a Função NVL2
SELECT
		last_name, salary, commission_pct, 
		NVL2(commission_pct, 10, 0) PERCENTUAL_ATERADO -- Se não for NULL retorna o valor passado 10, Se for NULL retorna o valor passado 0
FROM employees;

-- Utilizando a Função COALESCE
SELECT
		COALESCE(NULL, NULL, 'Expresssão 3'), -- Retorna o primeiro valor onde não é null
		COALESCE(NULL, 'Expressão 2', 'Expresssão 3'),
		COALESCE('Expressão 1', 'Expressão 2', 'Expresssão 3')
FROM dual;

SELECT
		last_name, employee_id, commission_pct, manager_id, 
		COALESCE(TO_CHAR(commission_pct), TO_CHAR(manager_id), 'Sem percentual de comissão e sem gerente') -- Retorna o primeiro valor onde não é null
FROM employees;

-- Utilizando a Função NULLIF
SELECT
		NULLIF(1000,1000), -- Se as expressões ou valores são iguais é retornado NULL
		NULLIF(1000,2000)  -- Se for diferente é retornado o primeiro valor 1000
FROM dual;

SELECT
		first_name, last_name,
		LENGTH(first_name) "Expressão 1",
		LENGTH(last_name)  "Expressão 2",
		NULLIF(LENGTH(first_name), LENGTH(last_name)) RESULTADO
FROM employees;

-- Expressão CASE
SELECT last_name, job_id, salary,
                          CASE job_id
                             WHEN 'IT_PROG'   
                               THEN 1.10*salary
                             WHEN 'ST_CLERK' 
                               THEN 1.15*salary
                             WHEN 'SA_REP' 
                               THEN 1.20*salary
                             ELSE salary 
                           END "NOVO SALARIO"
FROM employees;

-- Utilizando a Função DECODE
SELECT  last_name, job_id, salary,
		DECODE(job_id, 'IT_PROG' , 1.10*salary,
					   'ST_CLERK', 1.15*salary,
					   'SA_REP'  , 1.20*salary
								 , salary) "NOVO SALARIO"
FROM employees;