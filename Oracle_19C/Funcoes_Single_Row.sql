-- Funções de conversao Maiusculo & Minusculo
SELECT employee_id, LOWER(last_name), department_id
FROM employees
WHERE LOWER(last_name) = 'king'; -- Minusculo

SELECT employee_id, UPPER(last_name), department_id
FROM employees
WHERE UPPER(last_name) = 'KING'; -- Maiusculo

-- Funções de Manipulação de Caracteres
SELECT
		CONCAT(' Curso: ','Introdução ORACLE 19c'), -- Concatena uma String com Outra
		SUBSTR('Introdução ORACLE 19c', 1, 11), -- Corta um pedaço de uma String de um posição até outra
		LENGTH('Introdução ORACLE 19c'), -- Obtem um número do tamanho da String
		INSTR('Introdução ORACLE 19c','ORACLE') -- Pesquisa um determinado conjunto de caractere e retorna a posição
FROM dual;

SELECT
		first_name "Nome",
		LPAD(first_name, 20, ' ') "Nome alinhado a direita", -- Alinha a Direta preenchendo com espacos a esquerda
		RPAD(first_name, 20, ' ') "Nome alinhado a esquerda" -- Alinha a Esquerda preenchendo com espacos a direita
FROM   employees;

SELECT
		job_title,
		REPLACE(job_title, 'President', 'Presidente') CARGO -- Substitui um conjunto de caractere por outro
FROM jobs
WHERE  job_title = 'President';

-- Funções tipo NUMBER
SELECT
		ROUND(45.923, 2), -- Arredonda o numero para 2 casas decimais
		ROUND(45.923, 0)  -- Arredonda o numero para 0 casas decimais
FROM dual;

SELECT
		TRUNC(45.923, 2), -- Trunca o numero para 2 casas decimais
		TRUNC(45.923, 0)  -- Trunca o numero para 2 casas decimais
FROM dual;

SELECT
		MOD(1300, 600) RESTO -- Retorna o resto da divisao entre 1300 / 600
FROM dual;

SELECT
		ABS(-9), -- Retorna o valor absoluto de um numero
		SQRT(9)  -- Retorna a raiz quadrada de um numero
FROM dual;

-- Funções com DATA
-- Tabela do Oracle que possue uma linha e uma coluna
-- E utilizada para retornar varias operacoes com calculos, funções e expressões
SELECT * FROM dual;

SELECT 30000 * 1.25 FROM dual; -- Realizando uma operacao de calculo

SELECT sysdate FROM dual; -- Função SYSDADE que retorna data atual em que o banco esta instalado

-- Cálculos com Datas
SELECT
		sysdate,      -- Retorna data atual
		sysdate + 30, -- Retorna data atual + 30 dias
		sysdate + 60, -- Retorna data atual + 60 dias
		sysdate - 30  -- Retorna data atual - 30 dias
FROM dual;

SELECT
		last_name,
		--Data atual - data de admissao func. = nº de dia trabalho / 7 e arredonda para 2 casas decimais
		ROUND(( SYSDATE - hire_date) / 7, 2) "SEMANAS DE TRABALHO'"
FROM employees;

SELECT
		first_name,
		last_name,
		-- MONTHS_BETWEEN - Quantidade de Meses entre duas datas e o nº é aredondado para 2 casas decimais
		ROUND( MONTHS_BETWEEN(sysdate, hire_date), 2) "MESES DE TRABALHO"
FROM employees;

SELECT
		SYSDATE, -- Função que retorna data atual
		ADD_MONTHS(SYSDATE, 3), -- Obtem a data atual com SYSDATE e ADD + 3 Meses
		NEXT_DAY(SYSDATE,'SEXTA FEIRA'), -- A partir da data atual obtida, retorna qual é a proxima SEXTA-FEIRA
		LAST_DAY(SYSDATE) -- Retorna o ultimo dia do mês referente a data obtida
FROM   dual;

SELECT
		sysdate, -- Função que retorna data atual
		ROUND(SYSDATE, 'MONTH'), -- Aredonda uma data com o critério MES
		ROUND(SYSDATE, 'YEAR'),  -- Aredonda uma data com o critério ANO
        TRUNC(SYSDATE, 'MONTH'), -- TRUNCA uma data com o critério MES
		TRUNC(SYSDATE, 'YEAR')   -- TRUNCA uma data com o critério ANO
FROM   dual;
       
SELECT
		SYSDATE,
		-- Usando TO_CHAR para converter da data hora para string
		-- e mostrar o valor de tempo zerado
		TO_CHAR(TRUNC(SYSDATE),'DD/MM/YYYY HH24:MI:SS')
FROM  dual;