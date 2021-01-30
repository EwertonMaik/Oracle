--SINTAXE PARA CRIAÇÃO DE UMA TABLESPACE E ARQUIVOS DE DADOS
CREATE TABLESPACE recursos_humanos
DATAFILE 'C:/data/rh_01.dbf'
SIZE 100m AUTOEXTEND
ON NEXT 100m
MAXSIZE 4096m;

--ALTERANDO TABLESPACE E ADICIONANDO UM 2ª ARQUIVO DE DADOS
ALTER TABLESPACE recursos_humanos
ADD DATAFILE 'C:/data/rh_02.dbf'
SIZE 200M AUTOEXTEND
ON NEXT 200M
MAXSIZE 4096M;

--CRIADO O OBJETO SEQUENCE
CREATE SEQUENCE SEQ_GERAL
START WITH 100
INCREMENT BY 10;

--CRAIDO A TABELA FUNCIONARIOS NA TABLESPACE recursos_humanos
CREATE TABLE FUNCIONARIOS (
	ID INT PRIMARY KEY,
	NOME VARCHAR2(30)
) TABLESPACE recursos_humanos;

--REALIZADO INSERÇÃO NA TABELA, E O PREENCHIMENTO DO ID É FEITO PELA SEQUENCE
INSERT INTO FUNCIONARIOS VALUES(SEQ_GERAL.NEXTVAL, 'CARLA');
INSERT INTO FUNCIONARIOS VALUES(SEQ_GERAL.NEXTVAL, 'JOSE');
INSERT INTO FUNCIONARIOS VALUES(SEQ_GERAL.NEXTVAL, 'MARTA');

--COLOCANDO UMA TABLESPACE OFFINE PARA MANUTENÇÕES
ALTER TABLESPACE RECURSOS_HUMANOS OFFILINE;

--ALTERANDO O CAMINHO DOS ARQUIVOS DA TABLESPACE QUE FORAM MIGRADOS PARA OUTRO DISCO
ALTER TABLESPACE recursos_humanos
RENAME DATAFILE 'C:/data/rh_01.dbf' TO 'D:/prd/hr_01.dbf';

ALTER TABLESPACE recursos_humanos
RENAME DATAFILE 'C:/data/rh_02.dbf' TO 'D:/prd/hr_02.dbf';

--COLOCANDO UMA TABLESPACE ONLINE APÓS MANUTENÇÕES
ALTER TABLESPACE RECURSOS_HUMANOS ONLINE;

--#################################################3

-- Criando uma Tablespace
CREATE TABLESPACE TBS_PAULO_PRD
DATAFILE 'D:\app\Ewerton\oradata\orcl\prd\TBS_PAULO_PRD.dbf'
SIZE 100 M AUTOEXTEND ON NEXT 20 M
MAXSIZE UNLIMITED;

CREATE TABLESPACE TBS_PEDRO_HML
DATAFILE 'D:\app\Ewerton\oradata\orcl\prd\TBS_PEDRO_HML.dbf'
SIZE 100 M AUTOEXTEND ON NEXT 20 M
MAXSIZE UNLIMITED;

-- Visualizando as tablespaces criadas e seu caminho onde foi criada
select tablespace_name, file_name from DBA_DATA_FILES;

-- Criando um Usuário e Definindo a tablespace padrão TBS_PAULO_PRD
CREATE USER paulo IDENTIFIED BY 123456789
DEFAULT TABLESPACE TBS_PAULO_PRD
TEMPORARY TABLESPACE temp;

CREATE USER pedro IDENTIFIED BY 123456789
DEFAULT TABLESPACE TBS_PEDRO_HML
TEMPORARY TABLESPACE temp;

-- Verificando qual a Tablespace do usuário criado
SELECT username, default_tablespace, temporary_tablespace FROM dba_users WHERE username = 'PAULO';
SELECT username, default_tablespace, temporary_tablespace FROM dba_users WHERE username = 'PEDRO';

-- Alterando senha do Usuário
ALTER USER paulo identified by 0123456789;
ALTER USER pedro identified by 0123456789;

-- Comando para Bloquear e Desbloquear usuário
ALTER USER paulo account lock;
ALTER USER paulo identified by 123456789 account unlock;

-- Excluíndo Usuário
DROP USER paulo;

-- Privilégios de Sistemas
-- Liberando acesso para o usuário pode Logar e realizar operações de Criar Tabela, Views...
GRANT create session, create table, create view TO paulo;
GRANT create session, create table, create view TO pedro;

-- Quando utilizado o parâmetro WITH ADMIN OPTION, o usuário pode conceder este acesso para outros usuários.
GRANT create session,create table,create view TO paulo WITH ADMIN OPTION;

-- Privilégio de Objetos
-- Concedendo acesso ao usuário paulo para arealizar select, update e delete na tabela employees do usuário/esquema - HR
GRANT insert, select, update, delete ON HR.employees TO paulo;

-- Privilégio que permite ao usuário conceder a permissão para outros usuários
GRANT insert, select, update, delete ON HR.employees TO paulo WITH GRANT OPTION;

-- Removendo privilégios de SISTEMA
REVOKE create view FROM paulo;

-- Removendo privilégios de OBJETOS
REVOKE insert ON HR.employees FROM paulo;

