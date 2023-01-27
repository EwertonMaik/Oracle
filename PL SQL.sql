-- Documentação Scripts - PL/SQL do Banco de Dados ORACLE
-- Script Estudados do Livro - PL/SQL - Domine a linguagem do banco de dados Oracle

-- Estrutura do Bloco Anônimo - Não Possui Cabeçalho
declare
begin
  begin
  end;
  exception
  when others then
end;


--## Exemplo 01
declare
  soma number;
begin
  soma := 45 + 55;
  dbms_output.put_line('Soma :' || soma);
exception
  when others then
  raise_application_error(-20001, 'Erro ao somar valores!');
end;
/ -- Barra irá permitir que o bloco seja executado

--## Exemplo 02
set serveroutput on -- Comando para permitir que o pacote dbms_output imprima em tela.
declare
cursosr c1(pdname varchar2, pmgr number) is
  select ename, job, dname from emp, dept
  where emp.deptno = dept.deptno
  and dept.loc = pdname
  and emp.mgr = pmgr;

r1 c1%rowtype;
begin
  open c1( pmgr => 7698, pdname => 'CHICAGO' );
  loop
    fetch c1 into r1;
    
    if c1%found then
      dbms_output.put_line('Nome: ' || r1.ename || 'Cargo: ' || r1.job);
    else
    exit;
    end if;
    end loop;
    
    close c1;
    exception when others then
      dbms_output.put_line('Erro: ' || sqlerrm );
    end;
    /

--## Exemplo 03
set serveroutput on -- Habilita geração e visualização de mensagens em tela / prompt
enable -- Habilita a chamada das demais rotinas do pacote
begin
  dbms_output.enable(2000);
  dbms_output.put_line('TESTE')
end;
/

disable -- desabilita a chamada das demais rotinas do pacote
begin
  dbms_output.disable;
  dbms_output.put_line('TESTE');
end;
/

put -- inclui uma informação na área de buffer
begin
  dbms_output.put('T'); -- Só adiciona a informação ao Buffer
  dbms_output.put('E');
  dbms_output.put('S');
  dbms_output.put('T');
  dbms_output.put('E');
  dbms_output.new_line; -- Realiza a impressão em tela da informação em uma LINHA
end;
/

put_line -- inclui uma informação na área de buffer e adiciona, simultaneamente, um caractere para quebra de linha
begin
  dbms_output.put_line('T');
  dbms_output.put_line('E');
  dbms_output.put_line('S');
  dbms_output.put_line('T');
  dbms_output.put_line('E');
end;
/

get_line -- recupera uma linha do buffer
set serveroutput off
begin
  dbms_output.enable(2000);
  dbms_output.put('Como');
  dbms_output.new_line;
  dbms_output.put('aprender');
  dbms_output.new_line;
  dbms_output.put('PLSQL');
  dbms_output.new_line;
end;
/

set serveroutput on
declare
  var1    varchar2(100) default null;
  var2    varchar2(100) default null;
  var3    varchar2(100) default null;
  status  number        default null;
begin
  dbms_output.get_line(var1, status);
  dbms_output.get_line(var2, status);
  dbms_output.get_line(var3, status);
  
  dbms_output.put_line('Pergunta: ' || var1 || ' ' || var2 || ' ' || var3);
end;
/

get_lines -- recupera várias linhas do buffer
set serveroutput off
begin
  dbms_output.enable(2000);
  
  dbms_output.put('Como');
  dbms_output.new_line;
  dbms_output.put('aprender');
  dbms_output.new_line;
  dbms_output.put('PLSQL');
  dbms_output.new_line;
end;
/

set serveroutput on
declare
  tab       dbms_output.chararr;
  qtlines   number            default 3;
  res       varchar2(100)     default null;
begin
  dbms_output.get_lines(tab, qtlines);
  dbms_output.put_line('Retornou: ' || qtlines || ' registros.');
  
  for i in 1..qtlines loop
    res := res || ' ' || tab(i);
  end loop;
  
  dbms_output.put_line('Pergunta: ' || res);
  
end;
/

--## Exemplo 04
--## Variáveis BIND
set autoprint on -- ## Comando para habilitar impressão de uma variável BIND
variable mensagem varchar2(200)
begin
  :mensagem := 'Curso PLSQL';
end;
/

--## Visualizando o valor da variável através de uma instrução SELECT
select :mensagem from dual;

--## Atribuindo um valor para uma variávle BIND
variable gdepno number
exec :gpedno := 10
select ename from emp where deptno = :gdepno;
print gdepno;

--## Comando para visualizar todas as variáveis BIND declaradas em uma sessão
var

--## Variáveis de Substituição - &
define wempno = 7369
--define wempno = 10
select ename from emp where empno = &wempno;

begin
  for i in (select ename from emp where empno = &wempno) loop
    dbms_output.put_line(i.ename);
  end loop;
end;
/

--## Consultando o nome de uma variável de subistituição
define wempno

define gfrom = 'from emp'
define gwhere = 'where empno = 7369'
define gorderby = 'order by 1'

select ename &gfrom &gwhere &gorderby;

--## Funciona dentro de um Bloco PL/SQL
begin
  for i in (select ename &gfrom &gwhere &gorderby) loop
  dbms_output.put_line(i.ename);
end;
/

--## Excluíndo definição de uma variável de Substituição
undefine gfrom

--## Usando uma variável substituição sem a necessidade de defini-la ou declara-la
select job from emp where empno = &codigo;

--## Usando a variável de substituição
declare
  wjob emp.job%type;
begin
  select job into wjob from emp where empno = &cod_emp;
  dbms_output.put_line(wjob);
end;
/

--## Variável BIND em Arquivo
1 - select ename, job from emp where deptno = :bdeptno
2 - save B_EMP.sql -- Criado arquivo B_EMP.sql
3 - get B_EMP.sql
4 - select ename, job from emp where deptno = :bdeptno
5 - var bdeptno number
6 - exec :bdeptno := 10
7 - print bdeptno
8 - @B_EMP.sql -- Executando o arquivo de script SQL com Variável BIND

--## Variável Substituição em Arquivo
1 - select ename from emp where deptno = &sdeptno
2 - save S_EMP.sql -- Criado arquivo S_EMP.sql
3 - @S_EMP.sql -- Executando o arquivo de script SQL com Variável Substituição
  - Será solicitado para informar o valor para sdeptno
4 - define sdeptno = 10 -- Caso declare a variável no inicio do programa, não será mais solicitado para preencher o valor da variável

-- ## Excluíndo a definição da variável e será solicitado novamente a inserção do valor novo da variável
undefine sdeptno
@S_EMP.sql

-- ## && Duplo - Faz com que o SQL crie a definição da variável.
1 - edit S_EMP.sql
2 - get S_EMP.sql - select ename from emp where deptno = &&sdeptno
3 - @S_EMP.sql

define -- Visualizando todas as variáveis da sessão.

-- ## Passagens de valores para as variáveis de substituição
1 - edit S_EMP.sql
2 - get S_EMP.sql - select ename from emp where deptno = &1
3 - @S_EMP.sql 10 -- Realizando a execução do Script e passando o valor 10 como parâmetro
4 - @S_EMP.sql -- Na proxima execução o parâmetro anterior ficara salvo na sessão
5 - @S_EMP.sql 20 -- Realizando a execução do Script e passando um novo parâmetro

-- ## Usando a variável de substituição com a ACCEPT
1 - edit S_EMP.sql
2 - get S_EMP.sql
3 - accept SDEPTNO number for 999 default 20 prompt "Informe o deptno: "
4 - select ename from emp where deptno = &SDEPTNO
5 - @S_EMP.sql

--## Escopo de Identificadores
create or replace procedure folha_pagamento(pqt_dias number) is
wqt_dias    number;
wvl_bruto   number;
wvl_ir      number;
wvl_liquido number;

begin
  wvl_bruto   := (pqt_dias * 25);
  declare
  wtx_ir   number;
  begin
    if wvl_bruto > 5400 then
      wtx_ir := 27;
      dbms_output.put_line('Taxa IR: ' || wtx_ir);
    else
      wtx_ir := 8;
      dbms_output.put_line('Taxa IR: ' || wtx_ir);
    end if;
    wvl_ir      := (wvl_bruto * wtx_ir) / 100;
    wvl_liquido := (wvl_bruto - wvl_ir)
  end;
  dbms_output.put_line('Valor do salario bruto: ' || wvl_bruto);
  dbms_output.put_line('Desconto do valor do IR: ' || wvl_ir);
  dbms_output.put_line('Valor do salario liquido: ' || wvl_liquido);
  exception
    when others then
      dbms_output.put_line('Erro ao calcular pagamento. Erro: ' || sqlerrm);
end folha_pagamento;
/

begin
  folha_pagamento(pqt_dias => 300);
end;
/
--## Transações e SAVEPOINT
begin
  insert into dept values (41, 'GENERAL LEDGER', '');
  savepoint ponto_um;
  
  insert into dept values (42, 'PURCHASING', '');
  savepoint ponto_dois;
  
  insert into dept values (43, 'RECEIVABLES', '');
  savepoint ponto_tres;
  
  insert into dept values (44, 'PAYABLES', '');
  rollback to savepoint ponto_dois;
  
  commit;
end;
/

-- ## Variáveis e Constantes
declare
  DT_ENTRADA    DATE    DEFAULT SYSDATE;
  DT_SAIDA      DATE;
  FORNECEDOR    TIPO_PESSOA;  -- Tipo de dado definido pelo desenvolvedor
  QT_MAX        NUMBER(5)   DEFAULT 1000;
  QT_MIM    CONSTANT    NUMBER(50)  DEFAULT 100;
  NM_PESSOA     CHAR(60);
  VL_SALARIO    NUMBER(11,2);
  CD_DEPTO      NUMBER(5);
  IN_NAO    CONSTANT    BOOLEAN   DEFAULT FALSE;
  QTD       NUMBER(10)    := 0;
  VL_PERC   CONSTANT    NUMBER(4,2) := 55.00;
  CD_CARGO  EMPLOYEE.JOB%TYPE;    -- VARIÁVEL RECEBE O TIPO DE DADOS DA TABELA.COLUNA
  REG_DEPT  DEPARTMENT%ROWTYPE;   -- VARIÁVEL RECEBE O TIPO DE DADOS DA ESTRUTURA DA TABELA
  
-- ## Exceçoes
-- Existe dois tipos de exceções dentro do Oracle :As predefinidas e as definidas pelo usuário.
declare
  wempno number;
begin
  select empno into wempno from emp where deptno = 9999;
  exception
  when no_data_found then
    dbms_output.put_line('Empregado não encontrado.');
  when others then
    dbms_output.put_line('Erro ao selecionar empregado.');
end;
/

declare
  wempno  number;
begin
  select empno into wempno from emp where deptno = 30;
exception
  when no_data_found then
    dbms_output.put_line('Empregado não encontrado.');
  when others then
    dbms_output.put_line('Erro ao selecionar empregado.');
end;
/

declare
  wempno  number;
begin
  select empno into wempno from emp where deptno = 30;
exception
  when no_data_found then
    dbms_output.put_line('Empregado não encontrado');
  when too_many_rows then
    dbms_output.put_line('Erro: O código de departamento informado' || 'retornou mais de um registro.');
  when others then
    dbms_output.put_line('Erro ao selecionar empregado.');
end;
/

--## Variáveis Internas do Banco Oracle, quando uma Exception Others é disparada
-- sqlcode - Recebe o valor do código do Erro
-- sqlerrm - Recebe o valor do código do Erro e a Descrição do Erro
declare
  wempno  number;
begin
  select empno into wempno from emp where deptno = 30;
exception
  when no_data_found then
    dbms_output.put_line('Empregado não encontrado.');
  when others then
    dbms_output.put_line('Erro ao selecionar empregado. Erro: ' || sqlerrm || ' - Código: (' || sqlcode || ').');
end;
/

declare
  wsal    number;
  wdeptno number;
begin
  begin
    select avg(sal), deptno into wsal, wdeptno from emp where deptno = 99 group by deptno;
    exception
      when no_data_found then
        dbms_output.put_line('Valores não encontrados para o departamento 99.');
      when others then
        dbms_output.put_line('Erro ao selecionar valores referentes ao depto. 99. ' || 'Erro: ' || sqlerrm || '.');
  end;
  begin
    insert into emp (empno, ename, job, mgr, hiredate, sal, comm, deptno) values (8002, 'ANGELINA', 'MANAGER', 7839, TO_DATE('20/10/2011','DD/MM/RRRR'), wsal, null, 20 );
    commit;
  eception
    when others then
      dbms_output.put_line('Erro ao inserir novo empregado. ' || 'Erro: ' || sqlerrm || '.');
  end;
  dbms_output.put_line('Empregado ANGELINA inserido com sucesso.');
  exception
    when no_data_found then
      dbms_output.put_line('Empregado não encontrado.');
    when too_many_rows then
      dbms_output.put_line('Erro: O código de departamento informado ' || 'retornou mais de um registro.');
    when others then
      dbms_output.put_line('Erro ao inserir empregado. Erro: ' || sqlerrm || ' - Código : (' || sqlcode || ').' );
  
end;
/

-- ## Personalizando códigos de ERRO - ORACLE
declare
  wsal    number;
  wdeptno number;
begin
  begin
    select avg(sal), deptno into wsal, wdeptno from emp where deptno = 99 group by deptno;
    
    exception
      when no_data_found then
        raise_application_error(-20000, 'Valores não encontrados para o departamento 99.');
      when others then
        dbms_output.put_line('Erro ao selecionar valores referentes ao deptno. 99.. ' || 'Erro: ', sqlerrm || '.');
  end;
  begin
    insert into emp (empno, ename, job, mgr, hiredate, sal, comm, deptno) values (8002, 'ANGELINA', 'MANAGER', 7839, TO_DATE('20/10/2011','DD/MM/RRRR'), wsal, null, 20 );
    commit;
    exception
      when others then
        raise_application_error(-20000, 'Erro ao inserir um novo empregado. ' || 'Erro: ' || sqlerrm || ',');
  end;
  
  dbms_output.put_line('Empregado ANGELINA inserido com sucesso.');
  
  exception
  when no_data_found then
    dbms_output.put_line('Empregado não encontrado.');
  when too_many_rows then
    dbms_output.put_line('Erro: O código de departamento informado' || 'retornou mais de um registro.');
  when others then
    dbms_output.put_line('Erro ao inserir empregado. Erro: ' || sqlerrm || ' - Código: (' || sqlcode || ').' );
end;
/

declare
  wsal    number;
  wdeptno number;
begin
  begin
    select avg(sal), deptno into wsal, wdeptno from emp where deptno = 10 group by deptno;
    exception
      when no_data_found then
        raise_application_error(-20000, 'Valores não encontrados para o departamento 99.');
      when others then
        dbms_output.put_line('Erro ao selecionar valores referentes ao depto. 10. ' || 'Erro: ' || sqlerrm || '.');
  end;
  
  begin
    insert into emp (empno, ename, job, mgr, hiredata, sal, comm, deptno) values (8002, 'ANGELINA', 'MANAGER', 7839, TO_DATE('20/10/2011', 'DD/MM/RRRR'), wsal, null, 20 );
    commit;
    exception
      when others then
        raise_application_error(-20000, 'Erro ao inserir um novo empregado. ' || 'Erro: ' || sqlerrm || '.');
  end;
  
  dbms_output.put_line('Empregado ANGELINA inserido com sucesso.');
  
  exception
    when no_data_found then
      dbms_output.put_line('Empregado não encontrado.');
    when too_many_rows then
      dbms_output.put_line('Erro: O código de departamento informado' || 'retornou mais de um registro.');
    when others then
      dbms_output.put_line('Erro ao inserir empregado. Erro: ' || sqlerrm || ' - Código: (' || sqlcode || ').');
end;
/

--## Exceções definidas pelo usuário
declare
  wsal            number;
  werro_salario   exception;
begin
  begin
    select nvl(avg(sal),0) into wsal from emp where deptno = 99;
    
    if wsal = 0 then
      raise werro_salario;
    end if;
    
    exception
      when werro_salario then
        raise werr_salario;
      when others then
        raise_application_error(-20000, 'Erro ao selecionar valores referentes ao deptno. 99.' || 'Erro: ' || sqlerrm || '.');
  end;
  begin
    insert into emp(empno, ename, job, mgr, hiredate, sal, comm, depto) values (8002, 'ANGELINA', 'MANAGER', 7839, TO_DATE('20/10/2011','DD/MM/RRRR'), wsal, null, 20 );
    commit;
    exception
      when others then
        raise_application_error(-20000, 'Erro ao inserir um novo empregado. ' || 'Erro: ' || sqlerrm || '.');
  end;
  
  dbms_output.put_line('Empregado ANGELINA inserido com sucesso.');
  
  exception
    when werro_salario then
      dbms_output.put_line('O salario necessita ser maior que zero.');
    when no_data_found then
      dbms_output.put_line('Empregado não encontrado.');
    when too_many_rows then
      dbms_output.put_line('Erro: O código de departamento informa' !! 'retornou mais de um registro.');
    when others then
      dbms_output.put_line('Erro ao inserir empregado. Erro: ' || sqlerrm || ' - Código: (' || sqlcode || ").");
end;
/

--### Estruturas do comando IF-END IF
begin
  if <condicao> then
    <instruções>
  end if;
end;
/

declare
  x   number := 10;
  res number;
begin
  res := mod(x,2);
  if res = 0 then
    dbms_output.put_line('O resto da divisão é zero!');
  end if;
  dbms_output.put_line('Resultado do Cálculo: ' || res);
end;
/

declare
  x   number := 7;
  res number;
begin
  res   :=  mod(x,2);
  if res = 0 then
    dbms_output.put_line('O resto da divisão é zero!');
  end if;
  dbms_output.put_line('Resultado do Cálculo: ' || res);
end;
/

--### Estruturas do comando IF-ELSE-END IF
begin
  if <condicao> then
    <instruções>
  else
    <instruções>
  end if;
end;
/


