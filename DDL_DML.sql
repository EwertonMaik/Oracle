--Scripts

-- Criado tabela de Tipo de Produto
-- Com ID_TP_PROD sendo number e sempre identity, não aceita null, e é criado automaticamente uma sequence que controla o autoincremento.
-- A tabela possui um Index também IX_TIPO_PRODUTO para o campo ID_TP_PROD que é Primary Key
--Todos Obejtos criados no esquema do usuário SYSTEM e tablespace SYSTEM;
CREATE TABLE "SYSTEM"."TIPO_PRODUTO" (
    "ID_TP_PROD" NUMBER GENERATED ALWAYS AS IDENTITY NOT NULL ENABLE,
    "NM_TIPO" VARCHAR2(50) NOT NULL,
    "DT_CAD" TIMESTAMP DEFAULT SYSDATE NOT NULL ENABLE,
    CONSTRAINT "IX_TIPO_PRODUTO" PRIMARY KEY ("ID_TP_PROD")
) TABLESPACE "SYSTEM";

-- Script gerado e criado objeto sequence pelo Banco Oracle
CREATE SEQUENCE ISEQ$$_73568 INCREMENT BY 1 MAXVALUE 9999999999999999999999999999 MINVALUE 1 CACHE 20

-- script INDEX da tabela Produto 
CREATE UNIQUE INDEX "SYSTEM"."PRODUTO_ID_PROD_PK" ON "SYSTEM"."PRODUTO" ("ID_PROD") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;

-- inderindo Dados na tabela, não sendo necessário passar valor para ID_TP_PROD, que é gerado automaticamente
insert into TIPO_PRODUTO (nm_tipo) values ('ALIMENTICIO');
insert into TIPO_PRODUTO (nm_tipo) values ('LIMPEZA');
insert into TIPO_PRODUTO (nm_tipo) values ('UTENCILIOS DE COZINHA');
select * from TIPO_PRODUTO;

-- Criado tabela PRODUTO, com ID_PROD sendo sempre Identity, Not NUll e Index por esse campo.
-- DT_CAD_PROD com DEFAULT SYSDATE
CREATE TABLE "SYSTEM"."PRODUTO" (
    "ID_PROD" NUMBER GENERATED ALWAYS AS IDENTITY NOT NULL ENABLE, 
	"NM_PROD" VARCHAR2(100 BYTE), 
	"TP_PROD" NUMBER(*,0) NOT NULL ENABLE, 
	"DT_CAD_PROD" TIMESTAMP (6) DEFAULT SYSDATE NOT NULL ENABLE, 
	 CONSTRAINT "PRODUTO_ID_PROD_PK" PRIMARY KEY ("ID_PROD")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM"  ENABLE
   ) PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
  
  -- Sequence criada pelo ORACLE ao criar e referenciar o campo ID_PROD como IDENTITY
  CREATE SEQUENCE ISEQ$$_73561 INCREMENT BY 1 MAXVALUE 9999999999999999999999999999 MINVALUE 1 CACHE 20
  
  -- Index Criado para a tabela PRODUTO campo ID_PROD
  CREATE UNIQUE INDEX "SYSTEM"."IX_TIPO_PRODUTO" ON "SYSTEM"."TIPO_PRODUTO" ("ID_TP_PROD") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
  
  --Criado um Inndex UNIQUE também para o campo NM_PROD, impedindo o cadastro de produtos iguais
  --Se tirado o parametro UNIQUE, ele se torna não-exclusivo, podendo receber o cadastros iguais
  CREATE UNIQUE INDEX IX_PRODUTO_NM_PROD ON PRODUTO (NM_PROD ASC);

--Alterando o campo NM_PROD da tabela PRODUTO para não aceitar valores null
ALTER TABLE PRODUTO MODIFY (NM_PROD NOT NULL);

-- Adicionando um FK na tabela PRODUTO referenciando ao campo ID_TP_PROD da tabela TIPO_PRODUTO
ALTER TABLE PRODUTO ADD CONSTRAINT FK_PRODUTO_TP_PROD FOREIGN KEY (TP_PROD)
REFERENCES TIPO_PRODUTO (ID_TP_PROD) ENABLE;

-- Posso criar uma tabela com GENERATED BY DEFAULT AS IDENTITY
-- É gerada e controlado automaticamente via a sequence o id do campo
-- E por ser BY DEFAULT, a tabela aceita inserir manualmente um valor para a chave também
-- Não aceita NULL para o campo
CREATE TABLE TABELA_EXEMPLO (
  id          NUMBER GENERATED BY DEFAULT AS IDENTITY,
  descricao   VARCHAR2(30)
);

--Exemplos de Insert
insert into TABELA_EXEMPLO (descricao) values ('Cadastro 01'); -- Registro inserido com ID 1
insert into TABELA_EXEMPLO (id, descricao) values (2, 'Cadastro 02'); -- Registro inserido  com ID 2 que foi passado manualmente

-- Posso criar uma tabela com NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY
-- É gerada e controlado automaticamente via a sequence o id do campo
-- Aceita inserir um registro e ser informado um vaor para a chave de itendificação
-- Aceita inserir um registro não passando a chave
CREATE TABLE TABELA_EXEMPLO2 (
  id          NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
  descricao   VARCHAR2(30)
);

--Exemplos de Insert
insert into TABELA_EXEMPLO2 (descricao) values ('Cadastro 01'); -- Registro inserido com ID 1
insert into TABELA_EXEMPLO2 (id, descricao) values (2, 'Cadastro 01'); -- Registro inserido com ID 2, que foi passado manualmente
insert into TABELA_EXEMPLO2 (id, descricao) values (NULL, 'Cadastro 03'); -- Registro inserido com ID 3, mesmo informaado null, foi gerado o ID da proxima sequencia.

--Criado uma Procedure todos parâmetros IN por default quando não é especificado
   CREATE OR REPLACE PROCEDURE proc_add_produto (p_nm_prod VARCHAR2, p_tp_prod NUMBER) AS
   BEGIN
        INSERT INTO PRODUTO (nm_prod, tp_prod) VALUES (p_nm_prod, p_tp_prod);
   END;
   
   --Executado procedure e consultado a tabela
   EXECUTE proc_add_produto('MILHO DE PIPOCA', 1);
   SELECT * FROM PRODUTO;
   
   -- Um segundo exemplo de procedure de cadastro de Produto, com um retorno do pakage dbms_output, listando no display o Resultado
   CREATE OR REPLACE PROCEDURE proc_add_produto_com_retorno (p_nm_prod VARCHAR2, p_tp_prod NUMBER) AS
   total_produtos NUMBER;
   BEGIN
        INSERT INTO PRODUTO (nm_prod, tp_prod) VALUES (p_nm_prod, p_tp_prod);
        total_produtos := func_get_total_produtos;
        dbms_output.put_line('Total de Produtos Cadastrados é : ' || total_produtos);
   END;
   
   EXECUTE proc_add_produto_com_retorno ('TRIGO', 1);
   SELECT * FROM PRODUTO;
   
   -- Procedure para Atualizar Descrição nome Produto
   CREATE OR REPLACE PROCEDURE proc_update_produto (p_id_prod NUMBER, p_nm_prod VARCHAR2) AS
   BEGIN
        UPDATE PRODUTO SET nm_prod = p_nm_prod
        WHERE
        id_prod = p_id_prod;
   END;
   
   -- Executando Procedure de Atualização
   EXECUTE proc_update_produto (25, 'MILHO PIPOCA');
   SELECT * FROM PRODUTO;
   
   -- Procedure para Excluir Cadastro de Produto
  CREATE OR REPLACE PROCEDURE proc_delete_produto (p_id_prod NUMBER) AS
   BEGIN
        DELETE FROM PRODUTO WHERE id_prod = p_id_prod;
   END;
   
   --Executando Procedure
   EXECUTE proc_delete_produto (25);
   SELECT * FROM PRODUTO; 

-- Criado uma procedure que retorno um parametro OUT
create or replace PROCEDURE proc_consulta_total_Produtos (p_out_tot_prod OUT NUMBER) AS
   BEGIN
        SELECT COUNT(ID_PROD) INTO p_out_tot_prod FROM PRODUTO;
        dbms_output.put_line('Total de Produtos Cadastrados é : ' || p_out_tot_prod);
   END;

--Executando Procedure dentro de um bloco para testar parâmetro OUT
-- É atribuido o valor 5 só para teste, porém é retornado o valor total de produtos executado pela proc_consulta_total_Produtos
DECLARE retorno NUMBER := 5;
   BEGIN
        proc_consulta_total_Produtos(retorno);
        dbms_output.put_line('Retorno é igual : ' || retorno);
   END;
   
   --Criado Função para Retornar o Total de Produtos
   create or replace FUNCTION func_get_total_produtos
   RETURN NUMBER 
   IS total_prod NUMBER;
   BEGIN 
      SELECT COUNT(ID_PROD) INTO total_prod 
      FROM PRODUTO;
      RETURN(total_prod); 
    END;
    
 -- Utilizando chamada da função via select
 select 'TOTAL PROD: ', func_get_total_produtos from DUAL;
 
 -- Função com 1 parametro de IN Entrada para poder buscar, contar e retornar a qts produtos existe para o código passado
 -- E 1 parâmetro OUT que vai receber o nome/descrição do tipo informado
 CREATE OR REPLACE FUNCTION func_get_total_prod_tipo (p_id_tp_prod IN NUMBER, p_nm_tipo OUT VARCHAR2)
RETURN NUMBER IS
    tot_prod_tip NUMBER;
BEGIN
    select count(id_prod) into tot_prod_tip from produto
    inner join tipo_produto on (tp_prod = id_tp_prod)
    where
    id_tp_prod = p_id_tp_prod;
    select nm_tipo into p_nm_tipo from tipo_produto where id_tp_prod = p_id_tp_prod;
    return tot_prod_tip;
END;

--Testando a Função
SET SERVEROUTPUT ON
DECLARE
    retorno_nome VARCHAR2(50);
   BEGIN
   DBMS_OUTPUT.PUT_LINE('Existe ' || func_get_total_prod_tipo(1, retorno_nome) || ' Produtos Cadastrados para o Tipo : ' || retorno_nome);
   END;

-- Criado Objeto VIEW
CREATE OR REPLACE VIEW view_produtos AS
select
a.id_prod, a.nm_prod, a.dt_cad_prod, b.id_tp_prod, b.nm_tipo
from produto a
inner join tipo_produto b ON (a.tp_prod = b.id_tp_prod);

-- Selecionando Visualização
select * from view_produtos;

-- Criado um VIEW MATERIALIZED com o parametro BUILD IMMEDIATE, Atualização Completa e conforme a tabela associada a visualização sofrer alteração e commit
-- Ela é atualizada automaticamente
CREATE MATERIALIZED VIEW view_produtos_IMMEDIATE
BUILD IMMEDIATE
REFRESH COMPLETE
ON COMMIT
AS
select
a.id_prod, a.nm_prod, a.dt_cad_prod, b.id_tp_prod, b.nm_tipo
from produto a
inner join tipo_produto b ON (a.tp_prod = b.id_tp_prod);

--Adicionado um registro e aplicado commit e consultando a view materialized
EXECUTE proc_add_produto('AÇUCAR', 1);
COMMIT;
select * from view_produtos_IMMEDIATE;

--Criado view MATERIALIZED com parametro BUILD DEFERRED - atualizada manualmente na primeira requisição solicitada, REFRESH FORCE - uma atualização
-- Rápida é executado, caso não uma completa é aplicada. DEMAND é iniciada manualmente ou por agendamento!
CREATE MATERIALIZED VIEW view_produtos_DEFERRED
BUILD DEFERRED
REFRESH FORCE
ON DEMAND
AS
select
a.id_prod, a.nm_prod, a.dt_cad_prod, b.id_tp_prod, b.nm_tipo
from produto a
inner join tipo_produto b ON (a.tp_prod = b.id_tp_prod);

-- Os dados irão aparecer na VIEW MATERIALIZED só após executar o REFRESH
EXECUTE DBMS_MVIEW.REFRESH('view_produtos_DEFERRED');

--Criado uma tabela AUDITORIA_PRODUTO COM BASE NA TABELA PRODUTO
CREATE TABLE AUDITORIA_PRODUTO AS (SELECT * FROM PRODUTO);

-- ADICIONANDO UM ID_AUDIT COM IDENTITY PARA A TABELA AUDITORIA_PRODUTO
ALTER TABLE AUDITORIA_PRODUTO 
ADD (ID_AUDIT NUMBER GENERATED ALWAYS AS IDENTITY NOT NULL);

-- ADICIONADO UM CAMPOO TIMESTAMP E COM DEFAULT PARA SER INSERIDO AUTOMATICAMENTE DATA E HORA ATUAL
ALTER TABLE AUDITORIA_PRODUTO 
ADD (DT_AUDIT_LOG TIMESTAMP WITH LOCAL TIME ZONE DEFAULT SYSDATE NOT NULL);

-- ADICIONADO UM CAMPO PARA SALVAR O USUÁRIO DA OPERAÇÃO
ALTER TABLE AUDITORIA_PRODUTO 
ADD (USER_OP VARCHAR2(20) NOT NULL);

--ADICIONADO UM CAMPO PARA SALVAR QUAL A OPERAÇÃO
ALTER TABLE AUDITORIA_PRODUTO 
ADD (OPERACAO VARCHAR2(20) NOT NULL);

--ADICIONANDO A CONSTRAINT PRIMARY KEY PARA ID_AUDIT
ALTER TABLE AUDITORIA_PRODUTO
ADD CONSTRAINT AUDITORIA_PRODUTO_PK PRIMARY KEY 
(
  ID_AUDIT 
)
ENABLE;

-- PARA A CONSTRAINT PRIMARY KEY CRIADA O ORACLE CRIA UM INDEX CLUSTER UNIQUE PARA ESSE CAMPO
CREATE UNIQUE INDEX "SYSTEM"."AUDITORIA_PRODUTO_PK" ON "SYSTEM"."AUDITORIA_PRODUTO" ("ID_AUDIT")
TABLESPACE "SYSTEM" ;

--RENOMEANDO O INDEX
ALTER INDEX AUDITORIA_PRODUTO_PK RENAME TO IX_AUDITORIA_PRODUTO_PK;

--ADICIONADO UM CONSTRAINT CHECK PARA O CAMPO OPERAÇÃO PERMITIR APENAS A CONDIÇÃO INFORMADA
ALTER TABLE AUDITORIA_PRODUTO
ADD CONSTRAINT AUDITORIA_PRODUTO_CHECK_OPERACAO CHECK 
(OPERACAO = 'INSERT' OR
OPERACAO = 'UPDATE' OR
OPERACAO = 'DELETE')
ENABLE;

-- CREATE TRIGGER PARA PEGAR TODAS AS OPERAÇÕES REALIZADAS NA TABELA PRODUTO E SALVAR EM AUDITORIA_PRODUTO
CREATE OR REPLACE TRIGGER TG_PRODUTO_AUDITORIA_PRODUTO
AFTER INSERT OR UPDATE OR DELETE ON PRODUTO
FOR EACH ROW
DECLARE
   v_username varchar2(10);
BEGIN
    SELECT user INTO v_username FROM dual;
    CASE
        WHEN INSERTING THEN
              DBMS_OUTPUT.PUT_LINE('Inserting');
              INSERT INTO auditoria_produto (ID_PROD, NM_PROD, TP_PROD, DT_CAD_PROD, USER_OP, OPERACAO)
              VALUES (:NEW.ID_PROD, :NEW.NM_PROD, :NEW.TP_PROD, :NEW.DT_CAD_PROD, v_username, 'INSERT');
        WHEN UPDATING THEN
              DBMS_OUTPUT.PUT_LINE('Updating');
              INSERT INTO auditoria_produto (ID_PROD, NM_PROD, TP_PROD, DT_CAD_PROD, USER_OP, OPERACAO)
              VALUES (:NEW.ID_PROD, :NEW.NM_PROD, :NEW.TP_PROD, :NEW.DT_CAD_PROD, v_username, 'UPDATE');
        WHEN DELETING THEN
              DBMS_OUTPUT.PUT_LINE('Deleting');
              INSERT INTO auditoria_produto (ID_PROD, NM_PROD, TP_PROD, DT_CAD_PROD, USER_OP, OPERACAO)
              VALUES (:OLD.ID_PROD, :OLD.NM_PROD, :OLD.TP_PROD, :OLD.DT_CAD_PROD, v_username, 'DELETE');
    END CASE;
END;

--ADICIONANDO, ATUALIZANDO E EXCLUINDO REGISTROS NA TABELA DE PRODUTOS E VALIDANDO NA TABELA DE AUDITORIA_PRODUTO
EXECUTE proc_add_produto('GARFO', 3);
EXECUTE proc_update_produto(62, 'GARFO COZINHA');
EXECUTE proc_delete_produto(62);
SELECT * FROM AUDITORIA_PRODUTO;
SELECT * FROM PRODUTO;

-- APLICANDO EXEMPLO DE CURSOR EXPLICÍTO, RETORNANDO TODOS OS DADOS DA TABELA PRODUTO
SET SERVEROUTPUT ON;
DECLARE
    V_ID_PROD PRODUTO.ID_PROD%TYPE;
    V_NM_PROD PRODUTO.NM_PROD%TYPE;
    V_TP_PROD PRODUTO.TP_PROD%TYPE;
    V_DT_CAD_PROD PRODUTO.DT_CAD_PROD%TYPE;
    CURSOR CURSOR_PRODUTO IS SELECT ID_PROD, NM_PROD, TP_PROD, DT_CAD_PROD FROM PRODUTO;
    
    BEGIN
        OPEN CURSOR_PRODUTO;
        LOOP
            FETCH CURSOR_PRODUTO INTO V_ID_PROD, V_NM_PROD, V_TP_PROD, V_DT_CAD_PROD;
            EXIT WHEN CURSOR_PRODUTO%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(V_ID_PROD || ' ' || V_NM_PROD || ' ' || V_TP_PROD || ' ' || V_DT_CAD_PROD);
        END LOOP;
        CLOSE CURSOR_PRODUTO;
    END;

--CRIANDO CURSOR COM PARAMETRO
--ESTE EXEMPLO DE CURSOR É REFERÊNTE AO ANTERIOR, PORÉM COM PASSAGEM DE PARÂMETRO PARA O CURSOR
-- NA SUA CRIAÇÃO É DEFINIDO O PARÂMETRO P_TP_PROD E AO ABRIR O CURSOR É INFORMADO O CÓDIGO DESEJADO
SET SERVEROUTPUT ON;
DECLARE
    V_ID_PROD PRODUTO.ID_PROD%TYPE;
    V_NM_PROD PRODUTO.NM_PROD%TYPE;
    V_TP_PROD PRODUTO.TP_PROD%TYPE;
    V_DT_CAD_PROD PRODUTO.DT_CAD_PROD%TYPE;
    CURSOR CURSOR_PRODUTO(P_TP_PROD PRODUTO.TP_PROD%TYPE) IS
           SELECT ID_PROD, NM_PROD, TP_PROD, DT_CAD_PROD FROM PRODUTO WHERE TP_PROD = P_TP_PROD;
    
    BEGIN
        OPEN CURSOR_PRODUTO(3);
        LOOP
            FETCH CURSOR_PRODUTO INTO V_ID_PROD, V_NM_PROD, V_TP_PROD, V_DT_CAD_PROD;
            EXIT WHEN CURSOR_PRODUTO%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(V_ID_PROD || ' ' || V_NM_PROD || ' ' || V_TP_PROD || ' ' || V_DT_CAD_PROD);
        END LOOP;
        CLOSE CURSOR_PRODUTO;
    END;
 
 --CÓDIGO EXEMPLO ANTERIOR DO CURSOR ADICIONADO DENTRO DE UMA PROCEDURE
 -- O PARÂMETRO DA PROCEDURE É PASSADO PARA O PARÂMETRO DO CURSOR
 CREATE OR REPLACE PROCEDURE PROC_CURSOR_EXPLICITO_COM_PARAMETRO(P PRODUTO.TP_PROD%TYPE)
AS
    V_ID_PROD PRODUTO.ID_PROD%TYPE;
    V_NM_PROD PRODUTO.NM_PROD%TYPE;
    V_TP_PROD PRODUTO.TP_PROD%TYPE;
    V_DT_CAD_PROD PRODUTO.DT_CAD_PROD%TYPE;
    CURSOR CURSOR_PRODUTO(P_TP_PROD PRODUTO.TP_PROD%TYPE) IS
           SELECT ID_PROD, NM_PROD, TP_PROD, DT_CAD_PROD FROM PRODUTO WHERE TP_PROD = P_TP_PROD;
    
    BEGIN
        OPEN CURSOR_PRODUTO(P);
        LOOP
            FETCH CURSOR_PRODUTO INTO V_ID_PROD, V_NM_PROD, V_TP_PROD, V_DT_CAD_PROD;
            EXIT WHEN CURSOR_PRODUTO%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(V_ID_PROD || ' ' || V_NM_PROD || ' ' || V_TP_PROD || ' ' || V_DT_CAD_PROD);
        END LOOP;
        CLOSE CURSOR_PRODUTO;
    END;
COMMIT;    
EXECUTE PROC_CURSOR_EXPLICITO_COM_PARAMETRO(3);

-- CRIADO A TABELA PRODUTO2 BASEADO NA TABELA PRODUTO, JUNTAMENTE COM TODOS SEUS REGISTROS
--ADICIONADO UM REGISTRO NESTA TABELA
CREATE TABLE PRODUTO2 AS (SELECT * FROM PRODUTO);
INSERT INTO PRODUTO2 (ID_PROD, NM_PROD, TP_PROD, DT_CAD_PROD) VALUES (64, 'MERGE 2', 1, SYSDATE);

-- APLICANDO UM MERGE NA TABELA PRODUTO, COM OS REGISTROS DA TABELA PRODUTO2
MERGE INTO PRODUTO A
    USING PRODUTO2 B
    ON (A.ID_PROD = B.ID_PROD)
  WHEN MATCHED THEN
    UPDATE SET A.NM_PROD = B.NM_PROD,
               A.TP_PROD = B.TP_PROD,
               A.DT_CAD_PROD = B.DT_CAD_PROD
  WHEN NOT MATCHED THEN
    INSERT (NM_PROD, TP_PROD, DT_CAD_PROD) VALUES (B.NM_PROD, B.TP_PROD, B.DT_CAD_PROD);
    
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

--SEGUE ALGUMAS APLICAÇÕES USANDO TRIGGERS E PROCEDURES
/* AS TRIGGERS DEVEM TER O TAMANHO MAXIMO DE 32K, NÃO EXECUTAM COMANDOS DE DTL - COMMIT, ROLLBACK E SAVEPOINTS */

-- CRIADO UMA TABELA PARA
CREATE TABLE ALUNO (
	IDALUNO INT PRIMARY KEY,
	NOME VARCHAR2(30),
	EMAIL VARCHAR2(30),
	SALARIO NUMBER(10,2)
);

--CRIADO UMA SEQUENCE
CREATE SEQUENCE SEQ_EXEMPLO;

--INSERINDO DADOS NA TABELA USUÁRIO
INSERT INTO ALUNO VALUES (SEQ_EXEMPLO.NEXTVAL, 'PEDRO', 'pedro@gmail.com', 1000);
INSERT INTO ALUNO VALUES (SEQ_EXEMPLO.NEXTVAL, 'ANA', 'ana@gmail.com', 2000);
INSERT INTO ALUNO VALUES (SEQ_EXEMPLO.NEXTVAL, 'MARTA', 'marta@gmail.com', 3000);

--CRIANDO UMA PROCEDURE QUE AUMENTA O SALÁRIO - RECEBE COMO PARÃMETRO O ID DO ALUNO E A PORCENTAGEM QUE SERÁ AUMENTADO
CREATE OR REPLACE PROCEDURE BONUS(P_IDALUNO ALUNO.IDALUNO%TYPE, P_PERCENT NUMBER)
AS
  BEGIN
	UPDATE ALUNO SET SALARIO = SALARIO + (SALARIO * (P_PERCENT / 100) )
	WHERE IDALUNO = P_IDALUNO;
  END;
  
  --CHAMANDO PROCEDURE E APLICANDO O AUMENTO DE 15% PARA O ID 2
CALL BONUS(2, 15);

--CRIADO UMA TRIGGER QUE É DISPARADA QUANDO O SALÁRIO É MENOR QUE 2.000
CREATE OR REPLACE TRIGGER CHECK_SALARIO
BEFORE INSERT OR UPDATE ON ALUNO
FOR EACH ROW
BEGIN
	IF :NEW.SALARIO < 2000 THEN
		RAISE_APPLICATION_ERROR(-20000, 'VALOR INCORRETO');
	END IF;
END;

--CRIANDO UMA TRIGGER DE EVENTOS - TRIGGER QUE CHAMA A PROCEDURE LOGPROC E REGISTRA NA TABELA AUDITORIA OS ACESSOS DE LOGIN

--TABELA CRIADA
CREATE TABLE AUDITORIA (
	DATA_LOGIN DATE,
	LOGIN VARCHAR2(30)
);

--CRIADO PROCEDURE QUE INSERE NA TABELA AUDITORIA O REGISTRO DE DATA E USUÁRIO
CREATE OR REPLACE PROCEDURE LOGPROC IS
BEGIN
	INSERT INTO AUDITORIA(DATA_LOGIN, LOGIN) VALUES (SYSDATE, USER);
END LOGPROC;

--TRIGGER É EXECUTADA DEPOIS DE QUALQUER LOGON NO BANCO DE DADOS, CHAMANDO A PROCEDURE LOGPROC
CREATE OR REPLACE TRIGGER LOGTRIGGER
AFTER LOGON ON DATABASE
CALL LOGPROC;

--TRIGGER DE EVENTO DE BANCO, REGISTRANDO FALHA DE LOGIN NO SERVIDOR E SALVANDO NA TABELA AUDITORIA
CREATE OR REPLACE TRIGGER FALHA_LOGON
AFTER SERVERERROR ON DATABASE
BEGIN
	IF( IS_SERVERERROR(1017) ) THEN
		INSER INTO AUDITORIA(DATA_LOGIN, LOGIN) VALUES (SYSDATE, 'ORA-1017');
	END IF;
END FALHA_LOGON;

--ALGUNS CÓDIGOS DE ERRO ORACLE
-- 1004 DEFAULT : USERNAME FEATURE NOT SUPPORTED
-- 1005 : PASSWORD NULO
-- 1045 : PRIVILEGIO INSUFICIENTE

--ESTA TRIGGER É CHAMADA ANTER DA OPERAÇÃO DELETE NA TABELA USUARIO, REGISTRANDO UM COPIA DO REGISTRO EXCLUIDO EM OUTRA TABELA

--TABELA CRIADA E ADICIONADO REGISTROS
CREATE TABLE USUARIO (
	ID INT,
	NOME VARCHAR2(30)
);
INSERT INTO USUARIO VALUES (1, 'MARIA');
INSERT INTO USUARIO VALUES (2, 'CLARA');

-- 2ª TABELA QUE RECERA A COPIA DO REGISTRO EXCLUÍDO NA TABELA USUÁRIO
CREATE TABLE BKP_USER(
	ID INT,
	NOME VARCHAR2(30)
);

--TRIGGER QUE PEGA O REGISTRO ANTES DE SER EXCLUÍDO E SALVA EM OUTRA TABELA
--USANDO AS VARIÁVEIS EM TEMPO DE EXECUÇÃO :OLD
CREATE OR REPLACE TRIGGER LOG_USUARIO
BEFORE DELETE ON USUARIO
FOR EACH ROW
BEGIN
	INSERT INTO BKP_USER VALUES (:OLD.ID, :OLD.NOME);
END;
/

--EXCLUINDO UM REGISTRO E CONSULTANDO NA TABELA BKP_USER
DELETE FROM USUARIO WHERE ID = 1;

SELECT * FROM BKP_USER;

--ALGUMAS OPERAÇÕES COM VIEW
--CRIADO UMA TABELA CLIENTE E INSERIDO UM REGISTRO
CREATE TABLE CLIENTE (
	IDCLIENTE INT PRIMARY KEY,
	NOME VARCHAR2(30),
	SEXO CHAR(1)
);
INSERT INTO CLIENTE VALUES (1007, 'PAULO', 'M');

--CRIADO UMA VIEW EM CIMA DA TABELA CLIENTE
CREATE OR REPLACE VIEW V_CLIENTE
AS
SELECT IDCLIENTE, NOME, SEXO FROM CLIENTE;

--INSERINDO DADOS PELA VIEW CRIADA
INSERT INTO V_CLIENTE VALUES (1008, 'JOSE', 'M');

--VIEW DE APENAS LEITURA, NÃO ACEITA INSERT DEVIDO TER CLAUSLA READ ONLY
CREATE OR REPLACE VIEW V_CLIENTE_RO
AS
SELECT IDCLIENTE, NOME, SEXO FROM CLIENTE
WITH READ ONLY;

--VIEW CRIADA UTILIZANDO O CLAUSULA FORCE. FORÇA A CRIAÇÃO DO OBJETO MESMO SE CAMPOS,
--TABELAS E RELACIONAMENTOS DA VIEW NÃO EXISTAM AINDA CRIADO
CREATE OR REPLACE FORCE VIEW RELATORIO
AS
SELECT NOME, SEXO, NUMERO FROM CLIENTE
INNER JOIN TELEFONE ON (IDCLIENTE = ID_CLIENTE);

SELECT * FROM RELATORIO; --OBTEM ERRO DEVIDO TABELA TELEFONE NÃO EXISTIR AINDA

--CRIANDO TABELA TELEFONE E FK DE RELACIONAMENTO COM TABELA CLIENTE
CREATE TABLE TELEFONE (
	IDTELEFONE INT PRIMARY KEY,
	NUMERO VARCHAR2(10),
	ID_CLIENTE INT
);

-- FOREIGN KEY
ALTER TABLE TELEFONE ADD CONSTRAINT FK_CLIENTE_TELEFONE FOREING KEY(ID_CLIENTE)
REFERENCES CLIENTE(IDCLIENTE);

-- APLICANDO EXEMPLO DE CONSTRAINTS DEFERRABLE
DROP TABLE FUNCIONARIO; -- EXCLUINDO TABLE E RECRIANDO

CREATE TABLE FUNCIONARIO (
	IDFUNCIONARIO INT CONSTRAINT PK_FUNCIONARIO PRIMARY KEY,
	NOME VARCHAR(100)
);

DROP TABLE TELEFONE; -- EXCLUINDO TABLE E RECRIANDO

CREATE TABLE TELEFONE (
	IDTELEFONE INT PRIMARY KEY,
	NUMERO VARCHAR2(10),
	ID_FUNCIONARIO INT
);

-- ADICIONANDO UM FK - FOREIGN KEY EM TELEFONE, QUE REFERENCIA A FUNCIONARIO
ALTER TABLE TELEFONE ADD CONSTRAINT FK_TELEFONE
FOREIGN KEY (ID_FUNCIONARIO) REFERENCES FUNCIONARIO;

-- ADICIONANDO UM REGISTRO EM FUNCIONARIO E TELEFONE
INSERT INTO FUNCIONARIO VALUES (1, 'CARLOS', 1);
INSERT INTO TELEFONE VALUES (10, '123456789', 1); -- ESSE REGISTRO É ADICIONADO POIS EXISTE NA TABELA FUNCIONARIO O IDFUNCIONARIO = 1

--VERIFICANDO O ESTADO DE UMA CONSTRAINT, SE ELA FAZ VERIFICAÇÃO DA INTEGRIDADE REFERENCIAL OU NÃO
SELECT CONSTRAINT_NAME, DEFERRABLE FROM USER_CONSTRAINT
WHERE TABLE_NAME IN ('FUNCIONARIO', 'TELEFONE');

--EXCLUINDO A FOREING KEY TA TABLEA TELEFONE QUE REFERENCIA A TABELA FUNCIONARIO
ALTER TABLE TELEFONE DROP CONSTRAINT FK_TELEFONE;

--RECRIANDO FK - FOREING KEY DA TABELA TELEFONE, PORÉM COM A CLAUSULA DEFERRABLE, QUE PERMITE ADICIONAR UM REGISTRO ID_FUNCIONARIO QUE NÃO EXISTA AINDA NA TABELA FUNCIONARIO
ALTER TABLE TELEFONE ADD CONSTRAINT FK_TELEFONE
FOREING KEY (ID_FUNCIONARIO) REFERENCES FUNCIONARIO
DEFERRABLE;

-- CONFIGURAÇÃO SET DE SESSÃO QUE DURA ATÉ A CONFIRMAÇÃO DO COMMIT, PERMITINDO QUE SEJA APLICADO, A INSTRUÇÃO, NESTE CASO O INSERT DO REGISTRO QUE TEM REFERENCIA AO
-- ID_FUNCIONARIO 10 QUE NÃO EXISTE AINDA NA TABELA FUNCIONARIO
SET CONSTRAINTS ALL DEFERRED;
INSERT INTO TELEFONE VALUES (4, '999999999', 10);
