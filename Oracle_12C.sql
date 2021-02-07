-- Oracle Container Database (CBD) - Oracle Pluggable Database (PDB)
-- privilégios localmente (CONTAINER=CURRENT)
-- privilégios comum (CONTAINER=ALL)
https://www.oracle.com/br/technical-resources/articles/idm/common-local-oracle-database-12c.html

-- Verificar usuários por CDB
select username, common, con_id from cdb_users;

-- Verificar roles
select role, common from dba_roles;

-- Alterar de conexão 
alter session set container=st_plug;

--Verificar os PDB's
select pdb_id, dbid, pdb_name, status from cdb_pdbs order by pdb_id;

-- Criando um Usuário COMUN - Oracle 12C
create user C##COMMONUSER identified by "commonuser" container=all;
CREATE USER C##DEIBY IDENTIFIED BY MANAGER1 CONTAINER=ALL DEFAULT TABLESPACE TBS2; -- Criando usuário e definindo tablespace default
grant connect to C##COMMONUSER container=all; -- Permissão para conectar em qualquer PDB
grant create table  to C##COMMONUSER container=current; -- Permissão para criar tabela apenas no container atual que se encontra
