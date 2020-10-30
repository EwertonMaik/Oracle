-- Comandos Utilizados

-- Conectar em uma instância
. oraenv
XE

--Verificar variável Oracle
echo $ORACLE_SID
echo $ORACLE_HOME
echo $ORACLE_BASE

SET ORACLE_BASE=d:\app\oracle
SET ORACLE_HOME=%ORACLE_BASE%\11.1.0\db_1
SET PATH=%ORACLE_HOME%\bin;%PATH%

--Conectar em um banco via terminal / SQL Plus
sqlplus /nolog -- Posso iniciar o SQL Plus sem conectar em Banco de Dados com Usuário e senha

sqlplus system/oracle -- Conectando com usuário system e senha oracle

sqlplus / as sysdba -- Conectando com sysdba

connect sys / sys as sysdba -- Conectando com sysdba

-- Consultar dados instnacia em V$instance
select status, instance_name, parallel from V$instance;

--Consultar Informações Bases de Dados
select protection_level, * from V$database;

--Consultar em qual mode de Log o Banco esta
select log_mode from v$database;

--Consultar o destido do arquivo de Log
archive log list;
select dest_name, status, destination from v$archive_dest;  

--Consultar informações de Streams
select * from dba_streams_administrador;

--Listar Serviços do Banco
select * from V$services;

-- Listar DataFiles do banco
select * from V$datafile

--Listar Informações dos usuários
select * from dba_users;
SELECT * FROM ALL_USERS;

--Mostrar conexão
SHOW CON_NAME;
SHOW CON_ID;
SELECT SYS_CONTEXT('USERENV', 'CON_NAME') FROM   dual;
SELECT SYS_CONTEXT('USERENV', 'CON_ID') FROM   dual;

--Trocando entre Conteiner de banco de Dados
ALTER SESSION SET CONTAINER=pdb1;
ALTER SESSION SET CONTAINER=cdb$root;

--Verificação Listener
lsnrctl help
services listener
lsnrctl status
lsnrctl start
lsnrctl stop

emctl status dbconsole
emctl start dbconsole

tnsping (name)

--Comandos START e STOP Banco
SHUTDOWN -- Normal
SHUTDOWN TRANSACTIONAL
SHUTDOWN IMMEDIATE
SHUTDOWN ABORT

STARTUP --(Inicia Instância, Lê e monta arquivos do Banco de Dados e Abre para aceitar Conexões)
STARTUP NOMOUNT --(Inicia Instaância sem montar o Banco de Dados)
STARTUP MOUNT   --(Inicia Instância, Lê e monta arquivos do Banco de Dados)

ALTER DATABASE MOUNT; -- Com a instancia já iniciada, Lê e monta arquivos do Banco de Dados.
ALTER DATABASE OPEN;  -- Com a instância já iniciada, e arquivos do Banco de Dados lidos e montados, é aberto para conexões 

--Alterar o modo de NOARCHIVELOG para ARCHIVELOG
shut immediate; --Necessário desligar o Banco
startup mount; -- E inicia-lo no modo monut
alter database archivelog; -- Altera o modo de LOG
alter database open; -- Abre o Banco de Dados para uso

