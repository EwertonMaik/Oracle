-- Criando uma tabela para armazenar os registros logs de uma JOB
CREATE TABLE activity_logs (
	log_id number,
	creation_date date );

-- Criando um JOB que é executada frequentemente em segundos, a cada 30 segundos
-- Esta ativa, e não tem data de encerramento
-- Sua ação é um script que declara uma variável count, para contar oos ID da tabela e sempre 
-- Inserir o proximo registro com ID (count + 1)	
BEGIN
DBMS_SCHEDULER.CREATE_JOB (
JOB_NAME => 'FIRST_JOB',
JOB_TYPE => 'PLSQL_BLOCK',
JOB_ACTION => '
		DECLARE
		V_COUNT NUMBER := 0;
		BEGIN
		SELECT COUNT(*) INTO V_COUNT FROM ACTIVITY_LOGS;
		INSERT INTO ACTIVITY_LOGS VALUES (V_COUNT + 1, SYSDATE);
		COMMIT;
		END;
	      ',
START_DATE => SYSTIMESTAMP,
REPEAT_INTERVAL => 'FREQ=SECONDLY; INTERVAL=30',
END_DATE => NULL,
ENABLED => TRUE,
COMMENTS => 'MY FIRST TEST JOB' );
END;


BEGIN
 DBMS_SCHEDULER.ENABLE('FIRST_JOB'); -- Ativo JOB
END;
BEGIN
  DBMS_SCHEDULER.DISABLE('FIRST_JOB'); -- Desativa JOB
END;
BEGIN
  DBMS_SCHEDULER.RUN_JOB('FIRST_JOB'); -- Executa manualmente a JOB
END;
BEGIN
  DBMS_SCHEDULER.STOP_JOB('FIRST_JOB'); -- PAra manualmente a JOB
END;
BEGIN
  DBMS_SCHEDULER.DROP_JOB ('FIRST_JOB'); -- Exclui a JOB
END;

-- Consulto as JOBS
SELECT * FROM DBA_SCHEDULER_JOBS WHERE JOB_NAME = 'FIRST_JOB';

-- Consulto se a JOB esta em execução no momento
SELECT * FROM ALL_SCHEDULER_RUNNING_JOBS WHERE JOB_NAME = 'FIRST_JOB';

-- Consulto os registro de log de cada execução da JOB
SELECT LOG_ID, TO_CHAR(LOG_DATE, 'DD/MM/YYYY HH24:MI:SS') LOG_DATE,
       SUBSTR(JOB_NAME, 1, 20) JOB_NAME, SUBSTR(STATUS, 1, 10) STATUS,
       ADDITIONAL_INFO OPERATION
FROM DBA_SCHEDULER_JOB_LOG WHERE JOB_NAME LIKE '%FIRST%';


-- ## Formatando a exibição dos Dados com SQL Developer
set sqlformat json; -- Exibi os dados da tabela em formato JSON
select * from activity_logs;

set sqlformat loader; -- Exibi os dados da tabela em formato PIPE
select * from activity_logs;

select /*pipe*/ * from activity_logs; -- Exibe os dados ta tabela em PIPE
select /*csv*/ * from activity_logs; -- Exibe os dados ta tabela em CSV
select /*insert*/ * from activity_logs; -- Exibe os dados ta tabela em INSERT

spool c:\data.csv;

--###########################################################################################
-- Criando uma simples tabela
CREATE TABLE T_TESTE_SCHEDULER (
	CARACTERE VARCHAR2(200)
	);

-- Criado uma procedure que insere um registro na tabela T_TESTE_SCHEDULER
CREATE OR REPLACE PROCEDURE PRC_INSERE_TABELA IS
BEGIN
	INSERT INTO T_TESTE_SCHEDULER VALUES ('A');
	COMMIT;
END;

-- Criado uma procedure que limpa os registros da Tabela
CREATE OR REPLACE PROCEDURE PRC_LIMPA_TABELA IS
BEGIN
	DELETE FROM T_TESTE_SCHEDULER;
END;

-- Criado uma JOB que é executado frequentemente por hora, a cada 1 hora e chama o procedimento armazenado PRC_INSERE_TABELA
BEGIN
DBMS_SCHEDULER.CREATE_JOB
(
	JOB_NAME => 'NOME_JOB',
	JOB_TYPE => 'STORED_PROCEDURE',
	JOB_ACTION => 'PRC_INSERE_TABELA',
	START_DATE => SYSDATE,
	REPEAT_INTERVAL => 'FREQ=HOURLY;INTERVAL=1',
	ENABLED => TRUE,
	COMMENTS => 'INSERE A LETRA A DE HORA EM HORA NA TABELA T_TESTE_SCHEDULER.'
);
END;

-- Aqui é um exemplo criado um agendador manualmente, que pode ser utilizado ao criar uma job, para ser executado comforme seu agendamento
BEGIN
    DBMS_SCHEDULER.CREATE_SCHEDULE (

        repeat_interval  => 'FREQ=DAILY;BYDAY=MON,TUE,WED,THU,FRI,SAT;BYHOUR=18;BYMINUTE=30;BYSECOND=0',
     
        start_date => TO_TIMESTAMP_TZ('2021-03-20 18:09:57.000000000 AMERICA/SAO_PAULO','YYYY-MM-DD HH24:MI:SS.FF TZR'),
        comments => 'AGENDADOR',
        schedule_name  => '"AGENDADOR"');

END;

EXEC PRC_INSERE_TABELA;
EXEC PRC_LIMPA_TABELA;
TRUNCATE TABLE T_TESTE_SCHEDULER;
DROP PROCEDURE PRC_TRUNCATE_TABELA;
