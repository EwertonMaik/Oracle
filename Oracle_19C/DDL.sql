-- DDL - Data Defination Language

Tabelas -- Tables - Unidade Basica de armazenamento composta por linhas
Visão -- Views - Representação lógica de um sub-conjunto de dados de uma ou mais tabelas
Sequencia -- Sequence - Objeto utilizado para gerar números sequenciais
Indice -- Index - Objeto que pode otimizar performance de consultas
Sinonimo -- SYNONYM - Nome alternativo para um objeto

-- Consultando os objetos do schema do usuario HR
SELECT * FROM   user_objects ORDER BY Object_type;

-- Criando Tabelas
DROP TABLE projects;

CREATE TABLE projects
(project_id    NUMBER(6)     NOT NULL,
 project_code  VARCHAR2(10)  NOT NULL,
 project_name  VARCHAR2(100) NOT NULL,
 CREATION_DATE DATE DEFAULT  sysdate NOT NULL,
 START_DATE    DATE,
 END_DATE      DATE,
 STATUS        VARCHAR2(20)  NOT NULL,
 PRIORITY      VARCHAR2(10)  NOT NULL,
 BUDGET        NUMBER(11,2)  NOT NULL,
 DESCRIPTION   VARCHAR2(400) NOT NULL);
 
DESC projects
 
SELECT * FROM projects;
 
DROP TABLE TEAMS;

CREATE TABLE TEAMS
(project_id    NUMBER(6)  NOT NULL,
 employee_id   NUMBER(6)  NOT NULL);

-- Consultando a Estrutura da Tabela
DESC projects
DESC teams;

-- Tipo ROWID - Retorna o endereço de uma linha
DESC employees

SELECT employee_id, first_name, rowid, LENGTH(rowid)
from   employees
WHERE rowid = 'AAAR6YAAEAAALBbAAE'; -- Tal endereço pode ser consultado na claúsula WHERE

-- Consultando as Tabelas existentes pelo Dicionário de Dados
DESC user_tables

SELECT table_name
FROM   user_tables;

-- Consultando os Objetos do tipo TABLE do usuário

DESC user_objects

SELECT object_name, object_type FROM user_objects
WHERE  object_type = 'TABLE';

-- Criando uma Tabela utilizando uma Sub-consulta
DROP TABLE employees_department60;

CREATE TABLE employees_department60 -- Cria uma tabela e inserer regitros nela atraves de uma SELECT
AS
SELECT employee_id, last_name, salary * 12 ANNSAL, hire_date
FROM employees
WHERE department_id = 60;

DESC employees_department60

SELECT * FROM employees_department60;

-- TRUNCATE TABLE
TRUNCATE TABLE employees_department60;

SELECT * FROM employees_department60;

-- DROP TABLE
DROP TABLE employees_department60;

SELECT * FROM employees_department60;

-- Consultando a Lixeira
SELECT * FROM user_recyclebin;

ALTER TABLE PROJECTS ADD (DEPARTMENT_ID NUMBER(3) );
ALTER TABLE PROJECTS DROP COLUMN DEPARTMENT_ID;
ALTER TABLE PROJECTS ADD (DEPARTMENT_ID NUMBER(3) NOT NULL);
ALTER TABLE PROJECTS MODIFY (PROJECT_CODE VARCHAR2(6) );
ALTER TABLE PROJECTS RENAME COLUMN PROJECT_NAME TO NAME;
ALTER TABLE EMPLOYEES READ ONLY; -- A TABELA SÓ PODE RECEBER LEITURA
ALTER TABLE EMPLOYEES READ WRITE; -- A TABELA PODE RECEBER ESCRITA E LEITURA