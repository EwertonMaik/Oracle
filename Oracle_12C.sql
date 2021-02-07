-- Verificar usuários por CDB
select username, common, con_id from cdb_users;

-- Verificar roles
select role, common from dba_roles;

-- Alterar de conexão 
alter session set container=st_plug;

--Verificar os PDB's
select pdb_id, dbid, pdb_name, status from cdb_pdbs order by pdb_id;
