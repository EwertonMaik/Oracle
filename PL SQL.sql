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

declare
  x     number := 10;
  res   number;
begin
  res := mod(x, 2);
  if res = 0 then
    dbms_output.put_line('O resto da divisão é zero|');
  else
    dbms_output.put_line('O resto da divisão não é zero!');
  end if;
  dbms_output.put_line('Resultado do cálculo: ' || res);
end;
/

--## Estruturas do comando IF-ELSIF(-ELSE)-END IF
begin
  if <condicao> then
    <instruçõe>
  elsif <condicao> then
    <instruções>
  else
    <instruções>
  end if;
end;
/

declare
  x   number := 10;
  --x   number := 11;
  --x   number := -6;
  res number;
begin
  res := mod(x,5);
  if res = 0 then
    dbms_output.put_line('O resto da diivisão é zero!');
  elsif res > 0 then
    dbms_output.put_line('O resto da divisão não é zero!');
  else
    dbms_output.put_line('O resto da divisão é menor zero!');
  end if;
    dbms_output.put_line('Resultado do cálculo : ' || res);
end;
/

--### Declaração Aninhadas IF
begin
  if <condição> then
    if <condição> then
      <instruções>
    else
      <instruções>
      if <condição> then
        <instruções>
      else
        <instruções>
      end if;
    end if;
  end if;
end;


declare
  x1    number  := 10;
  x2    number  := 5;
  op    varchar2(1) := '+';
  res   number;
begin
  if (x1 + x2) = 0 then
    dbms_output.put_line('Resultado : 0');
  elsif op = '*' then
    res := x1 * x2;
  elsif op = '/' then
    if x2 = 0 then
      dbms_output.put_line('Erro de divisão por zero!');
    else
      res := x1 / x2;
    end if;
  elsif op = '-' then
    res := x1 - x2;
    if res = 0 then
      dbms_output.put_line('Resultado igual a zero!');
    elsif res < 0 then
      dbms_output.put_line('Resultado menor que zero!');
    elsif res > 0 then
      dbms_output.put_line('Resultado maior a zero!');
    end if;
   elsif op = '+' then
    res := x1 + x2;
   else
    dbms_output.put_line('Operador inválido!');
   end if;
   dbms_output.put_line('Resultado do cálculo : ' || res);
 end;
/
end;
/

-- ## Comandos de Repetição - LOOP, WHILE LOOP, FOR LOOP

-- FOR LOOP
begin
  for i in 1..10 loop
    dbms_output.put_line('5 X ' || i || ' = ' || (5 * i) );
  end loop;
end;
/

-- Utilizando REVERSE no LOOP FOR
begin
  for i in REVERSE 1..10 loop
    dbms_output.put_line('5 x ' || i || ' = ' || (5*1) );
  end for;
end;
/

-- LOOP FOR Aninhados
begin
  for x in 5..6 loop
    dbms_output.put_line('Tabuada de ' || x);
    dbms_output.put_line(' ');
    
    for y in 1..10 loop
      dbms_output.put_line(x || ' X ' || y || ' = ' || (x * y) );
    end loop;
    
    dbms_output.put_line(' ');
  end loop;
end;
/

begin
  for x in 1..15 loop
    if mod(x, 2) = 0 then
      dbms_output.put_line('Número divisível por 2: ' || x);
  end loop;
end;
/


declare
inter1    number default 1;
inter2    number default 15;

begin
  for x in inter1..inter2 loop
    if mod(x, 2) = 0 then
      dbms_output.put_line('Número divisível por 2: ' || x)
    end if;
  end loop;
end;
/

-- ## WHILE LOOP
declare
  x           number          default 0;
  label_vert  varchar2(240)   default '&label';
  tam_label   number          default 0;
begin
  tam_label := length(label_vert);
  while (x < tam_label) loop
    x := x + 1;
    dbms_output.put_line(substr(label_vert, x, 1) );
  end loop;
end;
/

declare
  x           number          default 0;
  label_vert  varchar2(240)   default '&label';
  tam_label   number          default 0;
begin
  tam_label := length(label_vert);
  loop
    x := x + 1;
    dbms_output.put_line(substr(label_vert, x, 1) );
    if x = tam_label then
      exit;
    end if;
  end loop;
end;
/

-- ### No Oracle não existe o comando - repeat until. E sim o comando loop e exit when
declare
  x           number        default 0;
  label_vert  varchar2(240) default '&label';
  tam_label   number        default 0;
begin
  tam_label := length(label_vert);
  loop
    x := x + 1;
    dbms_output.put_line(substr(label_vert, x, 1) );
    exit when x = tam_label;
  end loop;
end;
/

-- CURSORES
-- Existem dois tipos de cursosres no PL/SQL, os explícitos e os implícitos
-- O Oracle cria CURSOSRES implícitos quando utilizamos operações de UPDATE e DELETE dentro de uma aplicação.

--## Exemplo 01
cursor c1 is select ename, job from emp where deptno = 30;

-- Passando parâmetro para o Cursor
cursor c1(pdeptno number, pjob varchar2) is select empno, ename from emp where deptno = pdeptno and job > pjob;

--
declare
  cursor c1 is select ename, job from emp where deptno = 30; -- Lista todos os empregados do departamento 30.
  r1 c1%rowtype; -- Variável que recebe estrutura do cursor
  r1 emp%rowtype; -- Variável que recebe a estrutura da tabela EMP
begin
  open c1;
  loop
    fetch c1 into r1;
    exit when c1%notfound;
      dbms_output.put_line('Nome: ' || r1.ename || 'Cargo: ' || r1.job);
  end loop;
  close c1;
end;
/

--
declare
  cursor c1(pdname varchar2, pmgr number) is select ename, job, dname from emp, dept where emp.deptno = dept.deptno and dept.loc = pdname and emp.mgr = pmgr;
  r1 c1%rowtype;
begin
  open c1('CHICAGO', 7698);
  open c1( pmgr => 7698, pdname => 'CHICAGO') -- Segunda alternativa abrir o cursor usando passagem de parâmetro nomeada
  loop
    fetch c1 into r1;
    exit when c1%notfound;
    dbms_output.put_line('Nome: ' || r1.ename || 'Cargo: ' || r1.job);
  end loop;
  close c1;
end;
/

-- Usando cursor com FOR LOOP - Não precisa abrir e fechar cursor
declare
  cursor c1(pdname varchar2, pmgr number) is select ename, job, dname from emp, dept where emp.deptno = dept.deptno and dept.loc = pdname and emp.mgr = pmgr;
begin
  for r1 in c1(pmgr => 7698, pdname => 'CHICAGO') loop
    dbms_output.put_line('Nome : ' || r1.ename || 'Cargo : ' || r1.job);
    -- Duas formas de sair da estrutura do FOR LOOP antes de terminar sua execução
    /*
    * Primeira
    if r1.ename = 'MARTIN' then
      exit;
    end if;
    
    * Segunda
    exit when r1.ename = 'MARTIN';
    */
  end loop;
end;
/

-- Cursosres sem a clúsula de declaração
declare

begin
  for r1 in (select enpbo, ename from emp where job = 'MANAGER') loop
      dbms_output.put_line('Gerente : ' || r1.empno || ' - ' || r1.ename);
  
      for r2 in (select empno, ename, dname from emp, dept where emp.deptno = dept.deptno and mgr = r1.empno) loop
        dbms_output.put_line(' Subordinado: ' || r2.empno || ' - ' || r2.ename);
      end loop;
      dbms_output.put_line('');
  end loop;
end;
/

declare
  cursor c1(pdname varchar2, pmgr number) is select ename, job, dname from emp, dept where emp.deptno = deptno and dept.loc = pdname and emp.mgr = pmgr;
  r1 c1%rowtype;
begin
open c1(pmgr => 7689), ppdname -> 'CHICAHO');
  loop
  if c1%joun then
    dbms_output.put_line('Nome: || r1.ename ||', 'Cargo : ' r1.job)
  else
    exit
  emd if;
 end loop;
 close c1;
end;
/

-- Cursores Implicitos
-- %found
declare
  wename    emp.ename%type;
  wjob      emp.job%type;
  wdname    dept.dname%type;
begin
  select  ename, job, dname
  into    wename, wjob, wdname
  from    emp, dept
  where   emp.deptno  = dept.deptno
  and     dept.loc    = 'CHICAGO'
  and     emp.mgr     = 7698
  and     job         = 'CLERK'
  
  if SQL%found then
    dbms_output.put_line('O select retornou o seguinte registro: Nome: ' || wename || ' Cargo: ' || wjob);
  end if;
end;
/

-- %notfound
declare
  cursor c1(pdname varchar2, pmgr number) is select ename, job, dname from emp, dept
                                             where emp.deptno = dept.deptno and dept.loc = pdname and emp.mgr = pmgr;
  r1 c1%rowtype;
begin
  open c1(pmgr => 7698, pdname => 'CHICAGO');
  loop
    fetch c1 into r1;
      exit when c1%notfound;
      dbms_output.put_line('Nome: ' || r1.ename || 'Cargo: ' || r1.job);
  end loop;
  close c1;
end;
/


-- Cursores implícitos
declare
  wename    emp.ename%type;
  wjob      emp.job%type;
  wdname    dept.dname%type;
begin
  update    emp
  set       deptno  = 100 
  where     job     = 'ANALISTA_1';
  
  if SQL%notfound then
    dbms_output.put_line('Nenhum registro foi atualizado.')
  end if;
end;
/

-- %rowcount - Conta o Número de linhas lidas ou afetadas
declare
  cursor c1(pdname varchar2, pmgr number) is
  select ename, job, dname from emp, dept
  where emp.deptno = dept.deptno
  and dept.loc = pdname
  and emp.mgr = pmgr;
  
  r1 c1%rowtype;
  
begin
  open c1(pmgr => 7698, pdname => 'CHICAGO');
  loop
    fetch c1 into r1;
    exit when c1%notfound;
    dbms_output.put_line('Nome: ' || r1.ename || 'Cargo: ' || r1.job);
  end loop;
  
  dbms_output.put_line('');
  dbms_output.put_line('Registros recuperados: ' || c1%rowcount || '.');
  close c1;
end;
/


declare
  wename  emp.ename%type;
  wjob    emp.job%type;
  wdname  dept.dname%type;
begin
  delete  emp
  where   deptno = (select deptno from dept where dname = 'SALES');
  
  dbms_output.put_line(SQL%rowcount || 'registro(s) foram excluídos.');
  commit;
end;
/


-- %isopen - Verifica se o cursor esta aberto ou não
declare
  cursor c1(pdname varchar2, pmgr number) is select ename, job, dname from emp, dept
                                             where emp.deptno = dept.deptno
                                             and dept.loc = pdname
                                             and emp.mgr = pmgr;
   r1 c1%rowtype;
begin
  loop
    if c1%isopen then
      fetch c1 into r1;
        if c1%notfound then
          close c1;
          exit;
        else
          dbms_output.put_line('Nome: ' || r1.ename || 'Cargo: ' || r1.job);
        end if;
    else
      dbms_output.put_line('O cursor não foi aberto!');
      dbms_output.put_line('Abrindo cursor...');
      open c1(pmgr => 7698, pdname => 'CHICAGO')
    end if;
  end loop;
end;
/


-- CURSOSRES ENCADEADOS - Cursores sendo manipulados dentro de outros cursosres.
declare
  cursor c1 is select empno, ename from emp where job = 'MANAGER';
  cursor c2(pmgr number) is select empno, ename, dname from emp, dept where emp.deptno = dept.deptno and mgr = pmgr;
begin
  for r1 in c1 loop -- Primeiro Loop Cursor C1
    dbms_output.put_line('Gerente: ' || r1.empno -|| ' - ' || r1.ename);
      for r2 in c2(r1.empno) loop -- segundo Loop Cursor C2
        dbms_output.put_line('Subordinado: ' || r2.empno || ' - ' || r2.ename);
      end loop;
      dbms_output.put_line('');
  end loop;
end;
/

-- CURSOR COM FOR UPDATE - Torna a instrução com acesso exclusivo - LOCK
declare
  cursor c1(pdname varchar2) is select ename, job, dname
                                from emp, dept
                                where emp.deptno = dept.deptno
                                and dept.loc = pdname
                                for update; -- Aqui todas as colunas então em LOCK
                                --for update of ename, dname; -- Aqui apenas as colunas informadas entram em LOCK
                                --for update of ename; -- Apesar de estar selecionando 2 tabelas, pode-se locar apenas uma tabela informando apenas a coluna desejada
  r1 c1%rowtype;
begin
  open c1(pdname => 'DALLAS');
  loop
    if c1%isopen then
      fetch c1 into r1;
        if c1%notfound then
          close c1;
          exit;
        else
          dbms_output.put_line('Nome: ' || r1.ename || 'Cargo: ' || r1.job);
        end if;
    else
      dbms_output.put_line('O Cursor não foi aberto!');
      exit;
    end if;
  end loop;
end;
/

-- Utilizando FOR UPDATE com NOWAIT
declare
  cursor c1(pdname varchar2) is select ename, job, dname from emp, dept
                                where emp.deptno = dept.deptno
                                and delt.loc = pdname
                                for update of ename nowait; # Se estiver algum LOCK, a instrução nem espera, aguarda, e levante uma exception
r1 c1%rowtype;

begin
  open c1(pdname => 'DALLAS');
  loop
    if c1%isopen then
      fetch c1 into r1;
        if c1%notfound then
          close c1;
          exit;
        else
          dbms_output.put_line('Nome: ' || r1.ename || 'Cargo: ' || r1.job);
        end if;
    else
      dbms_output.put_line('O cursor não foi aberto!');
      exit;
    end if;
  end loop;
end;
/

-- Utilizando FOR UPDATE com CURRENT OF.
declare
  cursor c1(pdeptno number) is select * from emp where deptno = pdeptno for update of sal nowait;
  r1 c1%rowtype;
  wreg_excluidos number default 0;
begin
  open c1(pdepto => 10);
  loop
    fetch c1 into r1;
    exit when c1%notfound;
    
    update emp set sal = sal + 100.00
    where current of c1;
    
    wreg_excluidos := wreg_excluidos + sql%rowcount;
    
  end loop;
  
  dnms_output.put_line(wreg_excluidos || 'registros excluídos!')
;end;
/


declare
  cursor c1(pdloc varchar2) is select ename, dname from emp, dept
                               where emp.deptno = dept.deptno
                               and dept.loc = pdloc
                               for update of emp.ename, dept.loc;
r1 c1%rowtype;
wreg_atua_dep number default 0;
wreg_excl_emp number default 0;

begin
  open c1(pdloc => 'NEW YORK');
  loop
    fetch c1 into r1;
    exit when c1%notfound;
    
    update dept set loc = 'FLORIDA' where current of c1;
    wreg_atua_dep := wreg_atua_dep + sql%rowcount;
    
    delete emp where current of c1;
    wreg_excl_emp := wreg_excl_emp + sql%rowcount;
    
  end loop;
  
  dbms_output.put_line(wreg_atua_dep || 'registros de departamentos atualizados!');
  dbms_output.put_line(wreg_excl_emp || 'registros de empregados excluídos!')
  
end;
/


declare
  cursor c1(pdloc varchar2) is select ename, dname from emp, deptt
                               where emp.deptno = dept.deptno
                               and dept.loc = pdloc
                               for update of emp.ename, dept.loc;
  r1 c1%rowtype;
  wreg_atua_dep number default 0;
  wreg_excl_emp number default 0;

begin
  open c1(pdloc => 'NEW YORK');
  loop
    fetch c1 into r1;
    exit when c1%notfound;
    
    delete emp when current of c1;
    wreg_excl_emp := wreg_excl_emp + sql%rowcount;
    
  end loop;
  dbms_output.put_line(wreg_excl_emp || 'registros de empregados excluídos!');
  
end;
/


declare
  cursor c1(pdloc varchar2) is select ename, dname from emp, dept
                               where emp.deptno = dept.deptno
                               and dept.loc = pdloc
                               for update of emp.ename;
   r1 c1%rowtype;
   
   wreg_atual_dep number default 0;
   wreg_excl_emp number default 0;
begin
  open c1(pdloc => 'NEW YORK');
  loop
    fetch c1 into r1;
    exit when c1%notfound;
    
    delete emp where current of c1;
    
    wreg_excl_emp := wreg_excl_emp + sql%rowcount;
  end loop;
  
  dbms_output.put_line(wreg_excl_emp || 'registros de empregados excluídos!');
  
end;
/


-- Exemplo - Aplicando o FOR UPDATE em uma tabela e o DELETE em outra - Resultado é igual a ERRO
declare
  cursor c1(pdloc varchar2) is select ename, dname from emp, dept
                               where emp.deptno = dept.deptno
                               and dept.loc = pdloc
                               for update of dept.loc;
  r1 c1%rowtype;
  
  wreg_atua_dep number default 0;
  wreg_excl_emp number default 0;
  
begin
  open c1(pdloc => 'NEW YORK');
  loop
    fetch c1 into r1;
    exit when c1%notfound;
    
    delete emp where current of c1;
    
    wreg_excl_emp := wreg_excl_emp + sql%rowcount;
    
  end loop;
  
  dbms_output.put_line(wreg_excl_emp || 'registros de empregados excluídos!')
  
end;
/


declare
  cursor c1(pdloc varchar2) is select dname from dept where dept.loc = pdloc for update;
  r1 c1%rowtype;
  wreg_atua_dep number default 0;
begin
  open c1(pdloc => 'NEW YORK');
  loop
    fetch c1 into r1;
    exit when c1%notfound;
    
    update dept set loc = 'FLORIDA' where current of c1;
    
    wreg_atua_dep := wreg_atua_dep + sql%rowcount;
    
  end loop;
  dbms_output.put_line(wreg_atua_dep || 'registros de departamentos atualizados!');
end;
/


-- ## Funções de Caracteres e Operadores Aritméticos
INITCAP - Retorna o primeiro caractere de cada palavra em maiúscula
LOWER - Força caracteres maiúsculos aparecerem em minúsculo
UPPER - Força caracteres minúsculos aparecerem em mai´sculos
SUBSTR - Extrai um trecho de uma string, posição inicial e quantidade
TO_CHAR - Converte um valor númerico para uma string
INSTR - Retorna a posição do primeiro caractere encontrado passado como parâmetro
LENGTH - Traz o tamanho dos caracteres em bytes
RPAD - Faz alinhamento à esquerda e preenche com caracteres à direita
LPAD - Faz alinhamento à direita e preenche com caracteres à esquerda.

# Exemplos:
declare
  wnome1 varchar2(100) default 'analista de sistemas';
  wnome2 varchar2(100) default 'PEDREIRO';
  wnome3 varchar2(100) default 'padeiro';
begin
  wnome1 := initcap(wnome1);
  wnome2 := lower(wnome2);
  wnome3 := upper(wnome3);
  
  dbms_output.put_line(wnome1);
  dbms_output.put_line(wnome2);
  dbms_output.put_line(wnome3);
end;
/


select * from regions;
REGION_ID REGION_NAME
--------- -------------------------
1 Europe
2 Americas
3 Asia
4 Middle East and Africa

declare
  wregion_name_short varchar2(500);
begin
  for r1 in (select region_name from regions) loop
    wregionns_name_short := upper(SUBSTR(t1.regions_name, 1, 2) );
    dbms_output.put_line(wregion_name_ahort);
  end loop
end;
/


declare
  wsalario varchar2(200);
begin
  for r1 in (select ename, sal from emp where comm is null) loop
    wsalario := 'R$ ' || to_char(r1,sal, 'fm999G990D00');
    dbms_output.put_line('Nome: ' || r1.ename || 'Salário : ' || wsalario);
  end loop
end;
/

declare
  valor number;
begin
  valor := instr(37462.12,'62');
  dbms_output.put_line('Posição: ' || valor);
end;
/


begin
  for r1 in (select first_name from employees where length(fisrt_name) > 10 ) loop
    dbms_output,print_line('Nome: ' || r1.fisrt_name);
  end loop
end;
/

declare
  wlast_name  varchar2(200);
  wsalary     varchar2(50);
begin
  for r1 in (select last_name, salary from employees where department_id = 30) loop
    wlast_name := rpad(r1.last_name, 12, '++++');
    wsalary    := lpad(r1.salary, 7, '0');
    
    dbms_output.put_line('Último Nome: ' || wlast_name || 'Salário: ' || wsalary);
  end loop
end;
/

# FUNÇÔES DE CÁLCULOS
ROUND - Arredonda valores com casas decimais.
TRUNC - Trunca valores com casas decimais.
MOD - Mostra o resto da divisão de dois valores.
SQRT - Retorna a raiz quadrada de um valor.
POWER - Retorna um valor elevado a outro valor.
ABS - Retorna o valor absoluto.
CEIL - Retorna o menor inteiro, maior ou igual a valor.
FLOOR - Retorna o maior inteiro, menor ou igual a valor.
SIGN - Se valor maior que o retornar +1. Se valor menor que o retornar -1. Se valor igual a o retornar o.

# ROUND
declare
  wsal_calc number;
  wcomm number;
begin
  for r1 in (select sal, ename from emp where deptno = 20) loop
    wsal_calc := (r1.sal / 2.7);
    dbms_output.put_line('Nome: ' || r1.ename || 'Salário: ' || wsal_calc);
  end loop;
  
  dbms_output.put_line('-');
  
  for r1 in (select comm, ename from emp where comm is not null) loop
    wcomm := round( (r1.comm / 2.7) );
    dbms_output.put_line('Nome: ' || r1.ename || 'Comissão: ' || wcomm);
  end loop;
  
  dbms_output.put_line('-');
  
  for r1 in (select sal, ename from emp where empno between 7500 and 7700) loop
    wsal_calc := round( (r1.sal / 2.7), 2 );
    dbms_output.put_line('Nome: ' || r1.ename || 'Salário: ' || r1.sal || 'Salário Calc: ' || wsal_calc);
  end loop;
  
end;
/

# TRUNC
declare
  wsal_calc number;
begin
  for r1 in (select first_name, salary, job_id from employees where job_id = 'MK_MAN') loop
    wsal_calc := (r1.salary / 2.7);
    dbms_output.put_line('Nome: ' || r1.first_name || 'Salário Calc.: ' || wsal_calc || ' Salário: ' || r1.salary || ' Job: ' || r1.job_id);
  end loop;
  
  dbms_output.put_line('-');
  
  for r1 in (select last_name, salary, email from employees where email = 'NSARCHAN') loop
    wsal_calc := trunc( (r1.salary / 2.7) );
    dbms_output.put_line('Nome: ' || r1.last_name || 'Sal. Calc: ' || wsal_calc || ' Sal. : ' || r1.salary || ' Email. : ' || r1.email);
  end loop;
  
  dbms_output.put_line('-');
  
  for r1 in (select last_name, salary from employees where employee_id between 100 and 105 ) loop
    wsal_calc := trunc( (r1.salary / 2.7), 2 );
    dbms_output.put_line('Nome: ' || r1.last_name || ' Sal. Calc: ' || wsal_calc || ' Sal. : ' || r1.salary);
  end loop;
  
end;
/


# MOD / SQRT / POWER
declare
  wres number;
begin
  wres := mod(10, 2);
  dbms_output.put_line('Resultado: ' || wres);
  
  wres := sqrt(64);
  dbms_output.put_line('Resultado : ' || wres);
  
  wres := power(8, 2);
  dbms_output.put_line('Resultado: ' || wres);
end;
/


# ABS / CEIL / FLOOR
declare
  wres number;
begin
  wres := abs(-20);
  dbms_output.put_line('Resultado: ' || wres);
  
  wres := ceil(10.2);
  dbms_output.put_line('Resultado: ' || wres);
  
  wres := floor(10.2);
  dbms_output.put_line('Resultado: ' || wres);
  
end;
/

# SIGN
declare
  wres number;
begin
  sign(-2000);
  dbms_output.put_line('Resultado: ' || wres);
  
  wres := sign(2000);
  dbms_output.put_line('Resultado: ' || wres);
  
  wres := sign(0);
  dbms_output.put_line('Resultado: ' || wres);
end;
/

# Operadores Aritméticos
* Multiplicação
/ Divisão
+ Adição
- Subtração

declare
  wsal_calc number;
begin
  for r1 in (select sal from emp where comm is not null) loop
    wsal_calc := (r1.sal * 2/3);
    dbms_output.put_line('Salário Calc.: ' || wsal_calc || 'Salário: ' || r1.sal);
  end loop;
end;
/


declare
  wsal_calc number;
begin
  for r1 in (select ename, sal from emp where deptno = 30) loop
    wsal_calc := round( (r1.sal * 2) / 3 + 100.00 , 2 );
    dbms_output.put_line('Nome: ' || r1.ename || 'Salário Calc.: ' || wsal_calc || ' Salário: ' r1.sal);
  end loop;
end;
/


declare
  wdt_emissao number;
  wpremiacao number;
  
  cursor c1 is select ename, dname, hiredate, sal from emp e, dept d
               where e.deptno = d.deptno
               and trunc( (sysdate - hiredate) / 365 ) = 30;


## Uso de Funções Aritméticas de Multiplicação / Divisão e Subtração
begin
  for r1 in c1 loop
    wdt_emissao := trunc( (sysdate - r1.hiredate) / 365);
    wpremiacao := (r1.sal / 10 * trunc((sysdate - r1.hiredate) / 365) );
    
    dbms_output.put_line('Nome: ' || r1.ename || 'Dt. Emissão: ' || wdt_emissao || 'Premiação: ' || wpremiacao);
  end loop;
end;
/

## FUNÇÕES DE AGREGAÇÃO

select ename, dname, sal from emp e, dept d where e.deptno = d.deptno order by ename;

# Gera erro
declare
  cursor c1 is select ename, dname, SUM(sal) soma_sal from emp e, dept d
               where e.deptno = d.deptno
               order by ename;
begin
  for r1 in c1 loop
    dbms_output.put_line('Nome: ' || r1.ename || 'Departamento: ' || r1.dname || 'Soma Sal.: ' || r1.soma_sal);
  end loop;
end;
/


# Erro Corrigido - Porém não agrupado da forma correta ainda.
declare
  cursor c1 is select ename, dname, SUM(sal) soma_sal from emp e, dept d
               where e.deptno = d.deptno
               group by ename, dname
               order by ename;
begin
  for r1 in c1 loop
    dbms_output.put_line('Nome: ' || r1.ename || 'Departamento: ' || r1.dname || 'Soma Sal.: ' || r1.soma_sal);
  end loop;
end;
/


# Agrupamanto realizado, porém errado ainda, pois a coluna ename continuou no group by
declare
  cursor c1 is select dname, SUM(sal) soma_sal from emp e, dept d
               where e.deptno = d.deptno
               group by ename, dname
               order by ename;
begin
  for r1 in c1 loop
    dbms_output.put_line('Departamento: ' || r1.dname || 'Soma Sal.: ' || r1.soma_sal);
  end loop;
end;
/


# Agrupamento realizado com sucesso
declare
  cursor c1 is select dname, SUM(sal) soma_sal from emp e, dept d
               where e.deptno = d.deptno
               group by dname;
begin
  for r1 in c1 loop
    dbms_output.put_line('Departamento: ' || r1.dname || 'Soma Sal.: ' || r1.soma_sal);
  end loop;
end;
/

COUNT - Retorna a quantidade de incidências de registros.
SUM - Exibe a soma dos valores dos registros.
AVG - Exibe a média dos valores de uma determinada coluna.
MIN - Exibe o menor valor de uma coluna.
MAX - Retorna o maior valor de uma coluna


declare
  cursor c1 is
    select COUNT(employee_id) cont_emp, country_name
    from employees e, departments d, locations l, countries c
    where e.department_id = d.department_id
    and d.location_id = l.location_id
    group by country_name
    order by country_name;
begin
  for r1 in c1 loop
    dbms_output.put_line('Qtde. Empregados: ' || r1.count_emp || ' Cidade: ' || r1.country_name);
  end loop;
end;
/


declare
  cursor c1 is
    select count(*) cont_emp, country_name
    from employees e, departments d, locations l, countries c
    where e.department_id = d.department_id
    and d.location_id = l.location_id
    and l.country_id = c.country_id
    group by country_name;
begin
  for r1 in c1 loop
    dbms_output.put_line('Qtde. Empregados: ' || r1.cont_emp || ' Cidade: ' || r1.country_name);
  end loop;
end;
/


declare
  cursor c1 is
    select dname, MAX(hiredate) dt_adamissão
    from emp e, dept d
    where e.deptno = d.deptno
    group by dname
    order by 2 desc;
begin
  for r1 in c1 loop
    dbms_output.put_line('Departamento: ' || r1.dname || 'Dt. Admissão: ' || r1.dt_admissao);
  end loop;
end;
/


declare
  wres date;
begin
  select MIN(hire_date) hire_date_min into wres from employees;
  dbms_output.put_line('Menor Dt. Emissão: ' || wres);
end;
/


declare
  cursor c1 is
    select count(employee_id) cont_emp, SUM(salary) soma_salario, department_name
    from employees e, departments d
    where e.department_id = d.department_id
    having count(employee_id) > 5
    group by department_name
    order by department_name;
begin
  for r1 in c1 loop
    dbms_output.put_line('Qtde. Empregado: ' || r1.cont_emp || ' Soma Sal.: ' || r1.soma_salario || ' Depto.: ' || r1.department_name);
  end loop;
end;
/


declare
  cursor c1 is
    select department_name, SUM(salary) soma_sal, coutry_name
    from emploess e, departments d, locations l, countries c
    where e.department_id = d.department_id
    and d.location_id = l.location_id
    and l.country_id = c.country_id
    having sum(salary) > (select avg(em.slary) from employees em, departments dm, locations lm, countries cm
                          where em.department_id = dm.departmemt_id
                          and dm.location_id = lm.location_id
                          and lm.country_id = cm.country_id
                          and cm.country_id = c.country__id
     group by c.country_id, department_name, country_name
     order by country_name, department_name;
begin
  for r1 in c1 loop
    dbms_output.put_line('Departamento: ' || r1.departament_name || 'Soma Sal.: ' || r1.soma_sal || ' Cidade: ' || r1.country_name);
  end loop;
end;
/

# Funções de Data
add_months - adiciona meses em uma determinada data.
months_between - Retorna a quantidade de meses entre duas datas.
next_day - Procura o proximo dia após uma data informada.
last_day - Retorna o último dia do mês com base em uma data informada.
trunc - trunca uma data passada por parâmetro. O trunc pode ser feito por dia e mês, utilizando o parâmetro FMT (formato).
sysdate - Retorna a data corrente com base no servidor do banco de dados.
sessiontimezone
current_date


declare
  wdt_admissao date;
  wsexta date;

  cursor c1 is select first_name, hire_date from employees where to_char(hire_date, 'mm') = to_char(sysdate, 'mm') order by 2;
begin
  for r1 in c1 loop
    wdt_admissao := to_date( to_char(r1.hire_date, 'dd/mm') || '/' || to_char(sysdate, 'rrrr'), 'dd/mm/rrrr' );
    wsexta := next_day( to_date(to_char(r1.hire_date, 'dd/mm') || '/' || to_char(sysdate, 'rrrr'), 'dd/mm/rrrr'), 'FRIDAY');
    dbms_output.put_line('Nome: ' || r1.first_name || 'Dt. Admissão: ' || wdt_admissao || ' Sexta de Folga: ' || wsexta);
  end loop;
end;
/

declare
  wdt_termino_exp date;
  wdt_meses_trabalho number;

  cursor c1 is select ename, dname, hiredate from emp e, dept d where e.deptno = d.petno and add_months(hiredate, 350) >= sysdate;
begin
  for r1 in c1 loop
    wdt_termino_exp := add_months(r1.hiredate, 3);
    wqt_meses_trabalho := to_char(months_between(sysdate, r1.hiredate), '990D00' );
    dbms_output.put_line('Nome: ' || r1.ename || ' ' || 'Depto: ' || r1.dname || ' ' || 'Dt. Admissão: ' || r1.hiredate || ' ' || 'Término Exp.: ' || wdt_termino_exp || ' ' || 'Qtde. Meses Trab.: ' || wqt_meses_trabalho);
  end loop;
end;
/


declare
  wsessiomtimezone varchar(10);
  wcurrrent_date date;
  wsysdate date;
begin
  wsessiontimezone := sessiontimezone;
  wcurrent_date := current_date;
  wsysdate := sysdate;
  dbms_output.put_line('Fuso Horário: ' || wsessiontimezone || ' ' || 'Data Corrente: ' || wcurrent_date || ' ' || 'Data Atual: ' || wsysdate);
end;
/

declare
  wlast date;
  wround date;
  wtrunc date;
  
  cursor c1 is select ename, hiredate from emp where deptno = 20;
begin
  for r1 in c1 loop
    wlast := last_day(r1.hiredate);
    wround := round(r1.hiredate, 'YEAR');
    wtrunc := trunc(r1.hiredate, 'YEAR');

    dbms_output.put_line(
      'Nome: ' || r1.ename || ' ' ||
      'Dt. Admissão: ' r1.hiredate || ' ' ||
      'Último dia Mês Admissão: ' || wlast || ' ' ||
      'Arredonda Ano Admissão.: ' || wround || ' ' ||
      'Trunc Ano Admissão: ' || wtrunc
    );
  end loop;
end;
/


# Funções de Conversão
to_date - Converte uma String (char ou varchar2) de caractere para uma data;
to_number - Converte uma String (char ou varchar2) de caractere para um número;
to_char - Converte um número ou uma data para uma string de caractere

-- Exemplo que Obtêm ERRO
declare
  wdata date;
begin
  wdata := to_date('21/05/2009', 'dd/mm');
  wdata := to_date('21/05', 'dd/mm/yyyy');
end;
/

-- Exemplo to_date
begin
  for r1 in (select ename, hiredate from emp where hiredate > to_date('010182','ddmmrr') ) loop
    dbms_output.put_line('Empregado: ' || r1.ename || ' - Data de Admissão: ' || r1.hiredate);
  end loop;
end;
/


declare
  wdate date;
begin
  wdate := to_date('21.05.2009', 'dd.mm.yyyy');
  dbms_output.put_line('Data: ' || wdate);
end;
/


declare
  wdate date;
begin
  wdate := to_date('April 21', 'month dd', 'nls_date_language = american');
  dbms_output.put_line('Data: ' || wdate);
end;
/


declare
  wdate date;
begin
  wdate := to_date('Abril 21', 'month dd', 'nls_date_language=''BRAZILIAN PORTUGUESE''');
  dbms_output.put_line('Data: ' || wdate);
end;
/

declare
  wdate daye;
begin
  wdate := to_date('Abril 21', 'month xx', 'nls_date_language =''BRAZILIAN PORTUGUESE''' );
  dbms_output.put_line('Data: ' || wdate);
end;
/


declare
  wdate date;
begin
  wdate := to_date('2008','yyyy');
  dbms_output.put_line('Data: ' || wdate);
  
  wdate := to_date(200,'ddd');
  dbms_output.put_line('Data: ' || wdate);
end;
/


declare
  wdate varchar(50);
begin
  wdate := to_char(sydate, 'dd/mm/yyyy');
  dbms_output.put_line('Data: ' || wdate);

  wdate := to_char( to_char('01/01/49', 'dd/mm/yyyy'), 'dd//mm/yyyy' );
  dbms_output.put_line('Data: ' || wdate);

  wdate := to_char( to_char('01/01/50', 'dd/mm/yy'), 'dd/mm/yyyy' );
  dbms_output.put_line('Data: ' || wdate);
  
  wdate := to_char( to_char('01/01/49', 'dd/mm/rr'), 'dd/mm/rrrr' );
  dbms_output.put_line('Data: ' || wdate);
  
  wdate := to_char( to_char('01/01/50', 'dd/mm/rr'), 'dd/mm/rrrr' );
  dbms_output.put_line('Data: ' || wdate);
  
end;
/


--Obtêm ERRo por conta na conversão por conta da pontuação
declare
  wvalor number;
begin
  wvalor := to_number('4.569.900,87'); -- ERRO
  dbms_output.put_line('Valor: ' || wvalor);

  wvalor := to_number('4,569,900.87'); -- ERRO
  dbms_output.put_line('Valor: ' || wvalor);

  wvalor := to_number('4.569.900,87', '9G999G999D00'); -- ERRO
  dbms_output.put_line('Valor: ' || wvalor);

  wvalor := to_number('4,569,900.87', '9G999G999D00'); -- Funcionou Pois nesta sessão Oracle, esta definido como casa decimal o ponto, e não virgula.
  dbms_output.put_line('Valor: ' || wvalor);
end;
/

-- Alterando apenas na Sessão - O parâmetro de separador de casa decimal e centena
alter session set nls_numeric_characters = '.,';
alter session set nls_language = 'BRAZILIAN PORTUGUESE';
alter session set nls_date_language = 'PORTUGUESE';
alter session set nls_date_format = 'DD/MM/RRRR';

declare
  wvalor number;
begin
  wvalor := to_number('4,569,900.87','9G999G999D00');
  dbms_output.put_line('Valor: ' || wvalor);
end;
/


alter session set nls_numeric_characters = '.,';

declare
  wvalor number;
begin
  wvalor := to_number('4.569.900,87','9G999G999D00');
  dbms_output.put_line('Valor: ' || wvalor);
end;
/

declare
  wvalor number;
begin
  wvalor := to_number('4.569.900,87', '9G999G999D00', 'nls_numeric_characters =,.');
  dbms_output.put_line('Valor: ' || wvalor);
end;
/

# TO_DATE
declare
  wdate date;
begin
  wdate := to_date('02-APR-81'); -- Utilizando to_date sem definir uma formato / mascara
  dbms_output.put_line('Data: ' || wdate);
end;
/


declare
  wfate date;
begin
  wdate := to_date('05/21/2009'); -- Obtêm EEOO
  dbms_output.put_line('Data: ' || wdate);
end;
/

declare
  wdate date;
begin
  wdate := to_date('05/21/2009', 'mm/dd/yyyy');
  dbms_output.put_line('Data: ' || wdate);
end;
/

# TO_CHAR
declare
  wsal varchar2(50);
begin
  for r1 in (select ename, sal from emp) loop
    wsal := to_char(r1.sal, '9G999G999D00', 'nls_numeric_characters = '','' ');
    dbms_output.put_line('Nome: ' || r1.ename || ' Salário: ' || wsal);
  end loop;
end;
/


begin
  for r1 in (select count(*) qt_admitidos, to_char(hiredate, 'mm') MES from emp group by to_char(hiredate, 'mm') ) loop
    dbms_output.put_line('Admitidos: ' || r1.qt_admitidos || 'Mês: ' || r1.mes);
  end loop;
end;
/

declare
  wdata_extenso varchar2(100);
begin
  wdata_extendo := '22 de agosto de 2009 será dia ' || to_char(to_date('22/08/2009', 'dd/mm/yyyy'), 'ddd' ) || ' do ano';
  dbms_output.put_line(wdata_extenso);
end;
/

declare
  wdia_semana varchar2(50);
begin
  for r1 in (selecct ename, hiredate from emp) loop
    wdia_semana := to_char(r1.hiredate, 'day');
    dbms_output.put_line('nome: ' || r1.ename || ' Admissão: ' || r1.hiredate || ' Dia da Semana ' || wdia_semana);  
  end loop;
end;
/


declare
  wdata_extenso varchar2(100);
begin
  wdata-extenso := 'Joinville, ' || to_char(sysdate, 'dd') || ' de ' || initcap( to_char(sysdate, 'fmmonth') ) || ' de ' || to_char(sysdate, 'yyyy') || '.';
  dbms_output.put_line(wdata_extenso);
end;
/

begin
  for r1 in (select ename, hiredate from emp where to_char(hiredate, 'yyyy') = '1982' ) loop
    dbms_output.put_line('Nome: ' || r1.ename || ' Admissão: ' || r1.hiredate);
  end loop;
end;
/

declare
  wsal_formato varchar2(100);
begin
  for r1 in (select sal from emp) loop
    wsal_formatado := 'R$' || to_char( r1.sal, 'fm9G999G990D00');
    dbms_output.put_line('Salario ' || r1.sal || 'Salário Formatada: ' || wsal_formato);
  end loop;
emn;


declare
  wsal_formatado varchar2(50);
begin
  for r1 in (select sal from emp) loop
    wsal_formatado := to_char( r1.sal, 'fmL9G999G990D00' );
    dbms_output.put_line('Salário : ' || r1.sal || 'Salário Formatado: ' || wsal_formatado)
  end loop;
end;
/

declare
  wpositivo varchar2(100);
  wnegativo varchar2(100);
begin
  wpositivo := to_char(174984283.75,'fm999,999,999.00S');
  wnegativo := to_char(100-1000,'fm999,999,999.00S');
  dbms_output.put_line('Positivo: ' || wpositivo || ' - Negativo: ' || wnegativo);
end;
/


# Capítulo 15 - Funções Condicionais
DECODE
NULLIF
NVL
CASE
GREATEST
LEAST

# CASE - PADRÃO SQL ANSI
declare
  cursor c1 is
  select  job,
          SUM(CASE WHEN deptno = 10 THEN sal ELSE 0 END)  depart_10,
          SUM(CASE WHEN deptno = 20 THEN sal ELSE 0 END)  depart_20,
          SUM(CASE WHEN deptno = 30 THEN sal ELSE 0 END)  depart_30,
          SUM(sal)  total_job
  from    emp
  group by job;
begin
  for r1 in c1 loop
    dbms_output.put_line(r1.job || ' - Depart. 10: ' || r1.depart_10 || ' - Depart. 20: ' || r1.depart_20 || ' - Depart. 30: ' || r1.depart_30 || ' - Total: ' || r1.total_job);
  end loop;
end;
/

# DECODE - PADRÃO ORACLE
declare
  cursor c1 is
  select  job,
          SUM( DECODE(deptno, 10, sal, 0) )  depart_10,
          SUM( DECODE(deptno, 20, sal, 0) )  depart_20,
          SUM( DECODE(deptno, 30, sal, 0) )  depart_30,
          SUM(sal)  total_job
  from    emp
  group by job;
begin
  for r1 in c1 loop
    dbms_output.put_line(r1.job || ' - Depart. 10: ' || r1.depart_10 || ' - Depart. 20: ' || r1.depart_20 || ' - Depart. 30: ' || r1.depart_30 || ' - Total: ' || r1.total_job);
  end loop;
end;
/


# NVL
declare
  wsal_comm1 number;
  wsal_comm2 number;
begin
  select sum(sal + comm) into wsal_comm1 from emp;
  select sum(sal + nvl(comm, 0) ) into wsal_comm2 from emp;
  dbms_output.put_line('Sal. Comm1: ' || wsal_comm1 || ' - Sal. Comm2: ' || wsal_comm2);
end;
/


# GREATEST & LEAST
declare
  wmaior_letra varchar2(1);
  wmenor_letra varchar2(1);
begin
  select greatest('b','x','t','u','a') into wmaior_letra from dual;
  select least('b','x','t','u','a') into wmenor_letra from dual;
  dbms_output.put_line('Maior Letra: ' || wmaior_letra || 'Menor Letra: ' || wmenor_letra);
end;
/


# DECORE / NULLIF
declare
  comparacao1 varchar2(100);
  comparacao2 varchar2(100);
begin
  select decode( nullif('abacaxi', 'abacaxi'), null, 'são iguais', 'são diferentes' ) into comparacao1 from dual;
  select decode( nullif('abacaxi', 'morango'), null, 'são iguais', 'são diferentes' ) into comparacao2 from dual;
dbms_output.put_line('Comparação 1: ' || comparacao1 || ' - Comparação 2: ' || comparação2);
end;
/

# DECODE x CASE
declare
  cursor c1 is
    select  job,
            sum(case when deptno = 10 then sal else 0 end)  depart_10,
            sum(case when deptno = 20 then sal else 0 end)  depart_20,
            sum(case when deptno = 30 then sal else 0 end)  depart_30,
            sum(sal)  total_job
    from emp
    group by job;
begin
  for r1 in c1 loop
    dbms_output.put_line(r1.job || ' - Depart. 10: ' || r1.depart_10 || ' - Depart. 20: ' || r1.depart_20 || ' - Depart. 30: ' || r1.depart_30 || ' - Total: ' r1.total_job);
  end loop;
end;
/

declare
  cursor c1 is
    select  job,
            sum( decode(deptno, 10, sal, 0) ) depart_10,
            sum( decode(deptno, 20, sal, 0) ) depart_20,
            sum( decode(deptno, 30, sal, 0) ) depart_30,
            sum( sal ) total_job
    from    emp
    group by job
begin
  for r1 in c1 loop
    dbms_output.put_line(r1.job || ' - Depart. 10: ' || r1.depart_10 || ' - Depart. 20: ' || r1.depart_20 || ' - Depart. 30: ' || r1.depart_30 || ' - Total: ' r1.total_job);
  end loop;
end;
/


declare
  cursor c1 is
    select    ename,
              job,
              mgr,
              case
                    when mrg = 7902 then 'MENSALISTA'
                    when mgr = 7902 then 'MENSALISTA'
                    when mgr = 7839 then 'COMISSIONADO'
                    when mgr = 7566 then 'MENSAL/HORISTA'
              else
                    'OUTROS'
              end   tipo
      from    emp;
begin
  for r1 in c1 loop
    dbms_output.put_line('Nome: ' || r1.ename || ' - Cargo: ' || r1.job || ' - Gerente: ' || r1.mgr || ' - Tipo: ' || r1.tipo);
  end loop;
end;
/


declare
  cursor c1 is
      select    ename,
                job,
                mgr,
                decode( mgr, 7902, 'MENSALISTA', 7839, 'COMISSIONADO', 7566, 'MENSAL/HORISTA', 'OUTROS' ) tipo
      from      emp;
begin
  for r1 in c1 loop
    dbms_output.put_line('Nome: ' || r1.ename || ' - Cargo: ' || r1.job || ' - Gerente: ' || r1.mgr || ' - Tipo: ' || r1.tipo);
  end loop;
end;
/


# Programas Armazenados - (PROCEDURES / FUNCTIONS / PACKAGES)

create procedure calc is
  x1 number := 10;
  x2 number := 5;
  op varchar2(1) := '+';
  res number;
begin
  if (x1 + x2) = 0 then
    dnms_output.put_line('Resultado: 0');
  elsif op = '*' then
    res := x1 * x2;
  elsif op = '/' then
    if x2 = 0 then
      dbms_output.put_line('Erro de divisão por zero|');
    else
      res := x1 / x2;
    end if;
  elsif op = '-' then
    res := x1 - x2;
    if res = 0 then
      dbms_output.put_line('Resultado igual a zero!');
    elsif res < 0 then
      dbms_output.put_line('Resultado menor que zero!');
    elsif res > 0 then
      dbms_output.put_line('Resultado maior que zero!');
    end if;
  elsif op = '+' then
    res := x1 + x2;
  else
    dbms_output.put_line('Operador Inválido!');
  end if;
    dbms_output.put_line('Resultado do cálculo: ' || res);
end;
/

-- ## FUNCTIONS
create function valida_cpf return varchar2 is
  m_total   number  default 0;
  m_digito  number  default 0;
  cpf       varchar2(50)  default '02411848430';
begin
  for i in 1..9 loop
    m_total := m_total + substr(cpf, i, 1) * (11 - 1)
  end loop;

  m_digito := 11 - mod(m_total, 11);
  
  if m_digito > 9 then
    m_digito := 0;
  end if;
  
  if m_digito != substr(cpf, 10, 1) then
    return 'I';
  end if;
  
  m_digito := 0;
  m_total := 0;

  for i in 1..10 loop
    m_total := m_total + substr(cpf, i, 1) * (12 - i)
  end loop;
  
  m_digito := 11 - mod(m_total, 11);

  if m_digito > 9 then
    m_digito := 0;
  end if;
  
  if m_digito != substr(cpf, 11, 1) then
    return 'I';
  end if;
  
  return 'V';
  
end valida_cpf;
/


declare
	procedure calc is
		x1	number := 10;
		x2	number := 5;
		op	varchar2(1) : '+';
		res	number;
	begin
		if (x1 + x2) = 0 then
			dbms_output.put_line('Resultado: 0');
		elsif op = '*' then
			res := x1 * x2;
		elsif op = '/' then
			if x2 = 0 then
				dbms_output.put_line('Erro de divisão por zero!');
			else
				res := x1 / x2;
			end if;
		elsif op = '-' then
			res := x1 - x2;
			if res = 0 then
				dbms_output.put_line('Resultado igual a zero!');
			elsif res < 0 then
				dbms_output.put_line('Resultado menor que zero!');
			elsif res > 0 then
				dbms_output.put_line('Resultado maior que zero!');
			end if;
		elsif op = '+' then
			res := x1 + x2;
		else
			dbms_output.put_line('Operador inválido!');
		end if;
		dbms_output.put_line('Resultado do cálculo: ' || res);
	end;
	
	begin
		calc;
	end;
	/


declare
	res varchar2(1) default null;
	
	function valida_cpf return varchar2 is
		m_total	number 	default 0;
		m_digito number default 0;
		cpf varchar2(50) default '02411848430';
	begin
		for i in 1..9 loop
			m_total := m_total + substr(cpf, i, 1) * (11 - i);
		end loop;
		
		m_digito := 11 - mod(m_total, 11);

		if m_digito > 9 then
			m_digito := 0;
		end if;
		
		if m_digito != substr(cpf, 10, 1) then
			return 'I';
		end if;
		
		m_digito := 0;
		m_total := 0;
		
		for i in 1..10 loop
			m_total := m_total + substr(cpf, i, 1) * (12 - i);
		end loop;
		
		m_digito := 11 - mod(m_total, 11);
		
		if m_digito > 9 then
			m_digito := 0;
		end if;
		
		if m_digito != substr(cpf, 11, 1) then
			return 'I';
		end if;
		
		return 'V';

	end valida_cpf;
	
	begin
		res := valida_cpf;
		
		if res = 'V' then
			dbms_output.put_line('CPF válido');
		else
			dbms_output.put_line('CPF inválido');
		end if;
	end;
	/

-- Exemplos de chamada de Função
execute calc;

begin
	calc;
end;
/


declare
	res varchar2(1) default null;
begin
	res := valida_cpf;
	if res = 'V' then
		dbms_output.put_line('CPF válido');
	else
		dbms_output.put_line('CPF inválido');
	end if;
end;
/


select decode(valida_cpf, 'V', 'Válido', 'Inválido') CPF from dual;


			  
			  -- Concedendo acesso a procedures e functions

grant execute on calc to public;
grant execute on valida_cpf to TSQL2;

Sinônimos - Alias para o Objeto
create public synonym calc_valores for tsql.calc;
create synonym tsql2.valida_cpf for tsql.valida_cpf;

-- REPLACE

create or replace procedure calc is
	x1	number := 10;
	x2 	number := 5;
	op	varchar2(1) := '+';
	res	number;
begin
	if (x1 + x2) = 0 then
		dbms_output.put_line('Resultado: 0');
	elsif op = '*' then
		res := x1 * x2;
	elsif op = '/' then
		if x2 = 0 then
			dbms_output.put_line('Erro de divisão por zero!');
		else
			res := x1 / x2;
		end if;
	elsif op = '-' then
		res := x1 - x2;
		if res = 0 then
			dbms_output.put_line('Resultado igual a zero!');
		elsif res < 0 then
			dbms_output.put_line('Resultado menor que zero!');
		elsif res > 0 then
			dbms_output.put_line('Resultado maior que zero!');
		end if;
	elsif op = '+' then
		res := x1 + x2;
	else
		dbms_output.put_line('Operador Inválido!');
	end if;
	dbms_output.put_line('Resultado do cálculo: ' || res);
end;
/

-- ## Recompilando programas armazenados

alter procedure calc compile;
alter function valida_cpf compile;

-- ## Catálogo de Dados - recuperando Informações
user_objects, all_objects e dba_objects -- Informações gerais e status dos objetos do banco

select
	owner,
	object_type,
	status,
	created,
	last_ddl_time
from 	all_objects
where
	object_name = 'CALC';

desc ou describe

desc CALC

-- ## Recuperando códigos de Objetos do banco
user_source, all_source ou dba_source

column text format a100
set pages 1000
select line, text from all_source where name = 'CALC';

-- ## Visualizando ERROS de compilação
show error
user_erros, all_errors, dba_erros

select
	line,
	position,
	text
from	user_erros
where	name = 'CALC';

-- ## Passando parâmetros
Tipos = IN / OUT / IN OUT
Quanto o tipo não é definido, o padrão é IN.
IN = Entrada
OUT = Saída
IN OUT = Entrada e Saída

procedure exemplo (param1 in number, param2 out number, param3 in out number) is
	x number;
	y number;
	z number;
begin
	x := param1; -- uso correto
	param1 := x; -- uso incorreto
	
	y := param2; -- uso incorreto
	param2 := y; -- uso correto
	
	z := param3; -- uso correto
	param3 := z; -- uso correto
end;
/


create or replace calc(x1 in number, x2 in number, op in varchar2, res out varchar2) is
begin
	if (x1 + x2) = 0 then
 		res := 0;
 	elsif op = '*' then
 		res := x1 * x2;
 	elsif op = '/' then
 		if x2 = 0 then
 			res := 'Erro de divisão por zero!';
 		else
 			res := x1 / x2;
 		end if;
 	elsif op = '-' then
 		res := x1 - x2;
 		if res = 0 then
 			res := 'Resultado igual a zero: '||res;
 		elsif res < 0 then
 			res := 'Resultado menor que zero: '||res;
 		elsif res > 0 then
 			res := 'Resultado maior que zero: '||res;
 		end if;
 	elsif op = '+' then
 		res := x1 + x2;
 	else
 		res := 'Operador inválido!';
	end if;
end;
/

declare
	wres varchar2(100);
begin
	calc(x1 => 10, x2 => 5, op => '*', res => wres);
	dbms_output.put_line('Resultado Calc 1: '||wres);

	calc( 10 ,5 ,'/' ,wres);
	dbms_output.put_line('Resultado Calc 2: '||wres);
end;
/

create or replace function valida_cpf (cpf in char)
return varchar2 is
	m_total	number default 0;
	m_digito number default 0;
begin
	for i in 1..9 loop
		m_total := m_total + substr(cpf, i, 1) * (11 - i);
	end loop

	m_digito := 11 - mod(m_total, 11);
	
	if m_digito > 9 then
		m_digito := 0;
	end if;
	
	if m_digito != substr(cpf, 10, 1) then
		return 'I';
	end if;
	
	m_digito := 0;
	m_total := 0;

	for i in 1..10 loop
		m_total := m_total + substr(cpf, i, 1) * (12 - i);
	end loop;

	m_digito := 11 - mod(m_total, 11);

	if m_digito > 9 then
		m_digito := 0;
	end if;

	if m_digito != substr(cpf, 11, 1) then
		return 'I';
	end if;
	
	return 'V';
end valida_cpf;
/


valida_cpf:

declare
	res varchar2(1) default null;
begin
	res := valida_cpf(cpf => '02091678520');
	
	if res = 'V' then
		dbms_output.put_line('CPF válido: 02091678520');
	else
		dbms_out.put_line('02091678520')
	
	if res = 'V'
		dbms_output.put_line('CPF válido: 02011648920')
	else
		dbms_output.put_line("CPF válido : 02011648920")
	end if;
end;
/



-- ## Dependência de Objetos

create or replace procedure prod4 is
begin
	dbms_output.put_line('proc. 4!!!')
end;
/

create or replace procedure proc3 is
begin
	dbms_output.putline('proc. 3!!!');
	proc4;
end;
/


create or replace procedure proc2 is
begin
	dbms_output.put_line('proc. 2!!!');
	proc3;
end;
/

create or replace procedure proc1 is
begin
	dbms_output.put_line('proc. 1!!!');
	proc2;
end;


-- VIEW que contêm todas as dependências entre os objetos do banco de dados
all_dependencies


select
	name || ' => ' ||
	referenced_name "Referências"
from 	all_dependencies
where
	owner	= 'TSQL'
and 	name	in('PROC1','PROC2','PROC3','PROC4')
and 	referenced_type = 'procedure'
order by	name;
/

-- Verificar o status dos objetos
all_objetcs

select
	object_name,
	status
from	all_objetcs
where
	owner	= 'TSQL'
and	object_name in('PROC1','PROC2','PROC3','PROC4')
and 	object_type = 'procedure'

drop procedure proc1;
drop procedure proc2;
drop procedure proc3;
drop procedure proc4;


-- Advertência: Procedimento criado com erros de compilação.
create or replace procedure proc1 is
begin
	dbms_output.put_line('proc. 1!!!');
	proc2;
end;
/


-- Advertência: Procedimento criado com erros de compilação.
create or replace procedure proc2 is
begin
	dbms_output.put_line('proc. 2!!!');
	proc3;
end;
/

-- Advertência: Procedimento criado com erros de compilação.
create or replace procedure proc3 is
begin
	dbms_output.put_line('proc. 3!!!');
	proc4;
end;
/

-- Procedure criado com sucesso!
create or replace procedure proc4 is
begin
	dbms_output.put_line('proc. 4!!!');
end;
/


-- Verificando o status dos Objetos Criados
select
	object_name,
	status
from 	all_objects
where
	owner	= 'TSQL'
and 	object_name in('PROC1','PROC2','PROC3','PROC4')
and 	object_type = 'procedure';

alter procedure proc2 compile;
execute proc1;

-- ## Packages
-- Estrutura de um package

-- Podemos ter no especification
1 - Especificação de Procedures e Function
2 - Declaração de variáveis e constantes
3 - Declaração de cursores
4 - Declaração de exceptions
5 - Declaração de types

-- Podemos ter no body
1 - Códigos PL/SQL
2 - Códigos de procedures e functions
3 - Declaração de variáveis e constantes
4 - Declaração de cursores
5 - Declaração de exceptions
6 - Declaração de types

-- Exemplo de especification
-- Quando não informamos o tipo body, automaticamente o Oracle cria o package como sendo do tipo especification.

create package listagem is
	--
	cursor c1 is
	select
		d.departmen_if,
		department_name,
		first_name,
		hire_date,
		salary
	from 	departments d,
		employees e
	where 	d.manager_id = e.employee_id
	order by department_name;
	
	type tab is table of c1%rowtype index by binary_integer;
	
	tbgerente tab;
	n number;
	
	procedure lista_gerente_por_depto;

end listagem;
/

create package body listagem is
	procedure lista_gerente_por_depto is
	begin
		for r1 in c1 loop
			tbgerente(r1.department_id) := r1;
		end loop;
		
		n := tbgerente.first;
		
		while n <= tbgerente.last loop
			dbms_output.put_line('Depto: ' || tbgerente(n).department_name || ' ' ||
					     'Gerente: ' || tbgerente(n).first_name || ' ' ||
					     'Dt. Admi.: ' || tbgerente(n).hire_date || ' ' ||
					     'Sal.: ' || to_char(tbgerente(n).salary, 'fm$999g999g990d00') );
			n := tbgerente.next(n);
		end loop;
	end lista_gerente_por_depto;
end listagem;


create package calculo as
	function soma(x1 number, x2 number) return number;
	function subtrai(x1 number3 x2 number) return number;
	function multiplica(x1 number, x2 number) return number;
	function divide(x1 number, x2 number) return number;
end calculo;
/

create package body calculo as
	res number;
	procedure imprime_msg(msg varchar2) is
	begin
		dbms_output.put_line(msg);
	end;

	function soma(x1 number, x2 number) return number is
	begin
		res := x1 + x2;
		return res;
	end;
	
	function subtrai(x1 number, x2 number) return number is
	begin
		res := x1 - x2;
		if res = 0 then
			imprime_msg('Resultado igual a zero: ' || res);
		elsif res < 0 then
			imprime_msg('Resultado menor que zero: ' || res);
		elsif res > 0 then
			imprime_msg('Resultado maior que zero: ' || res);
		end if;
		return res;
	end;

	function multiplica(x1 number, x2 number) return number is
	begin
		res := x1 * x2;
		return res;
	end;

	function divide(x1 number, x2 number) return number is
	begin
		if x2 = 0 then
			res := null;
			imprime_msg('Erro de divisão por zero!');
		else
			res := x1 / x2;
		end if;
		return res;
	end;
end calculo;
/


-- ## Executando o package calculo
declare
	res number;
begin
	res := calculo.soma(450, 550);
	dbms_output.put_line('450 + 550 = ' || res)
end;
/


declare
	res number;
begin
	res := calculo.subtrai(350, 650);
	dbms_output.put_line('350 - 650 = ' || res);
end;
/


declare
	res number;
begin
	res:= calculo.multiplica(20, 10);
	dbms_output.put_line('20 * 10 = ' || res);
end;
/


declare
	res number;
begin
	res := calculo.divide(50, 5);
	dbms_output.put_line('50 / 5 = ' || res);
end;
/


-- Erro - Tentando acessar objeto fora do Escopo
declare
	res number;
begin
	res := calculo.divide(50, 5);
	calculo.imprime_msg('50 / 5 = ' || res);
end;
/

begin
	calculo.res := calculo.divide(50, 5);
	dbms_output.put_line('50 / 5 = ' || calculo.res);
end;
/

-- ## Recompilando Packages
alter package listagem compile;

-- ## Recuperando Informações - Status de Criação de Objetos
VIEW's user_objects, all_objetcs ou dba_objects

select
	owner,
	object_type,
	status,
	created,
	last_ddl_time
from	all_objects
where
	object_name = 'listagem'

-- Usando o comando DESCRIBE
desc listagem

-- ## Recuperando Códigos
VIEW's - user_source, all_source ou dba_source

column text format a300
set lines 1000
set pages 1000

select
	lines,
	text
from	all_source
where
	name = 'listagem';


-- ## Visualizando ERROS de compilação
show error

create or replace package listagem is
	cursor c1 is
	select
		d.department_id,
		department_name,
		first_name,
		hire_date,
		salary
	from 	departments d,
		employees   e
	where
		d.manager_id = e.employee_id
	order by department_name;

	type tab is table of c1%rowtype index by binary_integer;
	
	tbgerente tab;
	n number;
	
	procedure lista_gerente_por_depto;
	;	-- provocando um erro de sintaxe.
end listagem;
/

-- Advertência: Pacote criado com erros de compilação
show error
user_erros, all_erros ou dba_erros

select
	line,
	position,
	text
from 	user_erros
where
	name = 'listagem'


-- Exemplo de uma transação AUTONOMA
declare
	procedure lista_dept is
	
	pragma autonomous_transaction;
	begin
		dbms_output.new_line;
		dbms_output.put_line('----------- Lista Departamentos -----------');
		dbms_output.new_line;
		for i in (select * from dept order by deptno) loop
			dbms_output.put_line(i.deptno || ' - ' || i.dname);
		end loop;
		commit;
	end;

	begin
		insert into dept (deptno, dname, loc) values (43, 'ORDER MANAGER', 'BRASIL');
		lista_dept;
		commit;
		lista_dept;
	end;


-- Segundo Exemplo de transação autonoma
create procedure lista_pais(num_lista number) is
begin
	dbms_output.put_line('Executando procedure: LISTA_PAIS');
	dbms_output.new_line;
	dbms_output.new_line('----------- Lista País - ' || num_lista || '-----------');
	dbms_output.new_line;

	for i in (select * from contries where region_id = 1 order by country_name) loop
		dbms_output.put_line(i.country_id || ' - ' || i.country_name);
	end loop;
end;
/

create procedure insere_pais_portugal is
	pragma autonomous_transaction;
	begin
		dbms_output.put_line('Executando procedure: INSERE_PAIS_PORTUGAL');
		insert into countries (country_id, country_name, region_id) 10 values ('PT', 'Portugal', 1);
		lista_pais(2);
		commit;
	end;
	/

create procedure chama_insere_pais_portugal is
	begin
		dbms_output.put_line('Executando procedure: CHAMA_INSERE_PAIS_PORTUGAL');
		insere_pais_portual;
	end;
/

create procedure insere_pais_espanha is
	begin
		dbms_output.put_line('Executando procedure: INSERE_PAIS_ESPANHA');
		insert into countries (country_id, country_name, region_id) values ('ES', 'Espanha', 1);
		lista_pais(1);
		chama_insere_pais_portugal;
		rollback;
		lista_pais(3);
	end;
/

begin
	insere_pais_espanha;
end;
/

			  create trigger tipo_tabela
	before delete or insert or update of sal on emp
begin
end;


create table tab_audit_emp (
	nr_registros	  number,
	vl_total_salario  number,
 	vl_total_comissao number
);


create trigger tig_audit_emp
	after insert or delete or update of sal, comm on emp
declare
	wnr_registros		number default 0;
	wvl_total_salario	number default 0;
	wvl_total_comissao 	number default 0;
	wnr_registros_audit 	number default 0;
begin
	select 	count(*)
	into	wnr_registros
	from 	emp;
	
	select	sum(sal)
	into	wvl_total_salario
	from 	emp;
	
	select 	sum(comm)
	into 	wvl_total_comissao
	from 	emp;
	
	select 	count(*)
	into	wnr_registros_audit
	from 	tab_audit_emp;
	
	if wnr_registros_audit = 0 then
		insert into tab_audit_emp
		(nr_registros, vl_total_salario, vl_total_comissao)
		values (wnr_registros, wvl_total_salario, wvl_total_comissao);
	else
		update tab_audit_emp
		set nr_registros	= wnr_registros,
		    vl_total_salario	= wvl_total_salario,
		    vl_total_comissao 	= wvl_total_comissao;
	end if;
end;
/

update emp
set	sal = sal + (sal * 10 / 100)
where 	deptno = 20;

delete from emp where deptno = 10;

insert into emp
(empno, ename, job, mgr, hiredate, sal, comm, deptno)
values
(7935, 'PAULO', 'CLERK', 7902, to_date('17/09/2011','dd/mm/yyyy'), 1000, null, 20);


-- ## TRIGGER DE LINHA

create or replace trigger tipo_linha
	after update on func
	referencing old as V
		    new as N
	for each row
begin

end;
/


create table tab_hist_cargo_emp (
	empno			number,
	job_anterior 		varchar2(9),
	job_atual 		varchar2(9),
	dt_alteracao_cargo	date,
	ds_historico		varchar2(2000)
);

create trigger tig_hist_cargo_emp
	after update of job on emp
	referencing old as v
		    new as n
	for each row
begin
	insert into tab_hist_cargo_emp
	(empno, job_anterior, job_atual, dt_alteracao_cargo,, ds_historico)
	values
	(:n.empno, :v.job, :n.job, sysdate, 'O empregado ' || :n.ename || ' passou para o cargo ' || :n.job || ' em carater de promoção.');
end;
/

update	emp
set 	job = 'MANAGER'
where	empno = 7499;

alter table emp add pc_com_sal number;

create trigger tig_pc_com_sal_emp
	before insert or update of sal, comm on emp
	referencing old as v
		    new as n
	for each row when (n.job = 'SALESMAN')
begin
	:n.pc_com_sal := nvl(:n.comm, 0) * 100 / :n.sal;
end;
/


update emp set sal = sal;

insert into emp (empno, ename, job, mgr, hiredate, sal, comm, deptno)
values (7940,'PEDRO','CLERK',7788, to_date('05/09/2011','dd/mm/rrrr'),750,100,30);

insert into emp (empno, ename, job, mgr, hiredate, sal, comm, deptno)
values (7941,'JOAO','SALESMAN',7698,to_date('05/09/2011','dd/mm/rrrr'),1200,350,30);

select empno, ename, job, sal, comm, pc_com_sal from emp;

-- Utilizando os predicados INSERTING / UPDATING / DELETING

create table tab_hist_dept (
	deptno 		number,
	dt_historico	date,
	ds_historico	varchar2(2000)
);


create or replace trigger tig_hist_dep
	after insert or delete or update on dept
	for each row
declare
	wacao varchar2(200) default null;
begin
	if 	inserting 	then
		wacao := 'inserido';
	elsif 	updating 	then
		wacao := 'atualizado';
	elsif 	deleting 	then
		wacao := 'excluído';
	end if;
	
	insert into tab_hist_dept (deptno, dt_historico, ds_historico)
	values (nvl(:new.deptno,:old.deptno), sysdate, ,'O departamento '|| nvl(:new.dname,:old.dname) || 'foi '||wacao||'.' );
end;
/

update dept set dname = dname;
insert into dept values (50,'TI','BRASIL');
delete dept where deptno = 50;

select * from tab_hist_dept;


create or replace trigger tig_hist_cargo_emp
	after update of job on emp
	referencing old as v new as n
for each row
begin
	insert into tab_hist_cargo_emp (empno, job_anterior, job_atual, dt_alteracao_cargo, ds_historico)
	values (:n.empno, :v.job, :n.job, sysdate, 'O empregado ' || :n.ename || 'passou para o cargo ' || :n.job || 'em carater de promoção.');
end;
/

alter trigger tig_hist_cargo_emp compile;

-- Desativando e Inativando uma Trigger
alter trigger tig_hist_cargo_emp disable;
alter trigger tig_hist_cargo_emp enable;

-- Desativando todas as triggers de uma tabela
alter table emp disable all triggers;
alter table emp enable all triggers;

drop trigger tig_hist-cargo_emp;

-- Aplicando acesso
grant create trigger to tsql;

grant create any trigger to tsql;

user_triggers, all_trigger ou dba_triggers

select trigger_body from user_trigger where trigger_name = 'TIG_PC_COM_SAL_EMP';



-- Trigger Mutante
create or replace trigger tig_emp_pragma
	after update on emp
	for each row
declare
	wcont_registro number default 0;
begin
	select count(*) into wcont_registro from emp;
	dbms_output.put_line('Quantidade de registros na tabela EMP: ' || wcont_registro);
end;
/

-- Gerado ERRO ao executar o UPDATE devido a Trigger Mutante
update emp set sal = sal;

-- Reescrevendo a Trigger
create or replace trigger tig_emp_pragma
	after update on emp
declare
	wcont_registro number default 0;
begin
	select count(*) into wcont_registro from emp;
	dbms_output.put_line('Quantidade de registros na tabela EMP: ' || wcont_registros);
end;
/

update emp set sal = sal;


create or replace trigger tig_emp_pragma
	before update on emp
	for each row
declare
	pragma autonomous_transaction;
	wcont_registro number default 0;
begin
	select count(*) into wcount_registro from emp;
	
	if nvl(:old.comm, 0) < 300 then
		:new.comm := :new.sal * 10 / 100;
	end if;
	
	dbms_output.put_line('Quantidade de registros na tabela EMP: ' || wcont_registro);
	commit;
end;
/

update emp set sal = sal;


create or replace trigger tig_emp_pragma
	before update or insert on emp
	for each row
declare
	pragma autonomous_transaction;
	wcont_registro number default 0;
begin
	select count(*) into wcont_registro from emp;
	
	if nvl(:old.comm, 0) < 300 then
		:new.comm := :new.sal * 10 / 100;
	end if;
	
	dbms_output.put_line('Quantidade de registros na tabela EMP: ' || wcont_registro);
	commit;
end;
/


insert into emp (empno, ename, job, mgr, hiredate, sal, comm, deptno, pc_com_sal)
values (7935, 'PAUL', 'SALESMAN', 7698, to_date('15-MAR-1980', 'dd-mon-rrrr'), 1000, 100, 30, null);

-- Trigger de Sistema
startup - quando o banco de dados é aberto
shutdown - antes de o banco de dados iniciar o shutdown(fechamento). Se for shutdown abort este evento não é disparado.
servererror - quando um erro ocorre.
after logon - depois de uma conexão ser comtemplada no banco de dados.
before logoff - quando o usuário desconecta do banco de dados.
before create / after create - quando o objeto é criado no banco de dados, exceto do comando create database.
befote alter / after alter - quando um objeto é alterado no banco de dados, com exceção do comando alter database.
before drop / after drop - quando um objeto é eliminado do banco de dados.
before analyze / after analyze - quando o comando analyze é executado. Este comando é utilizado
para gerar estatísticas relacionadas ao desempenho de comandos SQL e processos do banco de dados.
before commit / after commit - quando um commit é executado
before ddl / after ddl - quando um comando ddl é executado, com execeção dos comandos alter database,
create controlfile, create database e ddl executados a partit de interface PL/SQL.
before grant / after grant - quando o comando grant é executado.
before rename / after rename - quando o rename é executado.
before revoke / after revoke - quando o comando revoke é executado.
before truncate / after truncate - quando o truncate é executado.

			  create table hist_usuario (
	nm_usuario	varchar2(50),
	dt_historico	date,
	ds_historico	varchar2(4000)
);
/

create or replace trigger tgr_hist_conexao_usuario
	after logon on database
begin
	insert into hist_usuario values
	(ORA_LOGIN_USER, sysdate, 'Conexão com banco de dados' || ORA_DATABASE_NAME);
end;
/

select * from hist_usuario;

create or replace trigger tgr_hist_criatab_usuario
	after create on database
begin
	insert into hist_usuario values
	(ORA_LOGIN_USER, sysdate, 'O Objeto ' || ORA_DICT_OBJ_NAME || ' foi criado no banco de dados.');
end;
/


create table teste_trigger (
	id_campo	varchar2(),
	nm_campo	date,
	ds_campo	varchar2(4000)
);
/

select * from hist_usuario;

-- TRIGGER DE VIEW

create view emp_dept_v as
select e.empno, e.ename, e.job, e.sal, d.dname
from emp e, dept d
where e.deptno = d.deptno

select * from emp_dept_v;

-- Criando TRIGGER com INSTEAD OF para manipulação de dados

create or replace trigger trg_emp_dept_v
instead of
insert or delete or update
on emp_dept_v
referencing new as new old as old
declare
	cursor c1(pdeptno dept.deptno%type) is
	select deptno, dname
	from dept
	where deptno = pdeptno;

	cursor c2(pempno emp.empno%type) is
	select empno, ename
	from emp
	where empno = pempno;
	
	wdeptno dept.deptno%type;
	wdname	dept.dname%type;
	wempno 	emp.empno%type;
	wename 	emp.ename%type;

begin
	if inserting then
		-- verifica se existe departamento.
		open c1 (:new.deptno);
		fetch c1 into wdeptno, wdname;
		
		if c1%notfound then
			insert into dept (deptno, dname, loc) values (:new.deptno, :new.dname, null);
			dbms_output.put_line('Departamento Cadastrado com Sucesso.');
		else
			dbms_output.put_line('Departamento Existente: ' || wdeptno || ' - ' || wdname || '.');
		end if;
		
		-- Verifica se Existe Empregado
		open c2(:new.empno);
		fetch c2 into wempno, wename;
		
		if c2%notfound then
			insert into emp (empno, ename, job, sal, mgr, deptno)
			values (:new.empno, :new.ename, :new.job, :new.sal, :new.mgr, :new.deptno);
			dbms_output.put_line('Funcionario cadastrado com Sucesso.');
		else
			dbms_output.put_line('Funcionario Existente: ' || wempno || ' - ' || wename || '.');
		end if;
	end if;
end;
/

insert into emp_dept_v (empno, ename, job, sal, mgr, deptno, dname) values (8000, 'BRUCE', 'MANAGER', 1000, 7839, 20, 'RESEARCH');
insert into emp_dept_v (empno, ename, job, sal, mgr, deptno, dname) values (8000, 'BRUCE', 'MANAGER', 1000, 7839, 20, 'RESEARCH');
insert into emp_dept_v (empno, ename, job, sal, mgr, deptno, dname) values (8001, 'SILVESTER', 'MANAGER', 1000, 7839, 80, 'S&E');
insert into emp_dept_v (empno, ename, job, sal, mgr, deptno, dname) values (8001, 'SILVESTER', 'MANAGER', 1000, 7839, 90, 'FINANCIAL');
insert into emp_dept_v (empno, ename, job, sal, mgr, deptno, dname) values (8002, 'WILL', 'MANAGER', 1000, 7839, 90, 'FINANCIAL');


create or replace trigger tgr_emp_dept_v
	instead of
	insert or delete or update
	on emp_dept_v
	referencing new as new old as old
declare
	cursor c1(pdeptno dept.deptno%type) is
	select 	deptno, dname
	from	dept
	where	deptno = pdeptno;
	
	cursor c2(pempno emp.empno%type) is
	select	empno, ename
	fromm 	emp
	where 	empno = pempno;
	
	wdeptno	dept.deptno%type;
	wdname 	dept.dname%type;
	wempno	emp.empno%type;
	wename 	emp.ename%type;
begin
	if inserting then
		-- verifica se existe departamento.
		open c1(:new.deptno);
		fetch c1 into wdeptno, wdename;
	
	if c1%notfound then
		insert into dept (deptno, dname, loc) values (:new.deptno, :new.dname, null);
		dbms_output.put_line('Departamento Cadastrado com Sucesso.');
	else
		dbms_output.put_line('Departamento existente: ' || wdeptno || ' - ' || wdname || '.');
	
	end if;
	
	-- Verifica se existe empregado.
	open c2 (:new.empno);
	fetch c2 into wempno, wename;
	
	if c2%notfound then
		insert into (empno, ename, job, sal, mgr, deptno) values (:new.empno, :new.ename, :new.job, :new.sal,:new.mgr, :new.deptno);
		dbms_output.put_line('Funcionário Cadastrado com Sucesso.');
	else
		dbms_output.put_line('Funcionário existente: ' || wempno || ' - ' || wename || '.');
	end if;
	
	elsif updating then
		-- verifica se existe departamento.
		open c1(:new.deptno);
		fetch c1 into wdeptno, wdname;
		
		if c1%notfound then
			dbms_output.put_line('Departamento não existe.');
		else
			update dept set dname = :new.dname where deptno = :new.deptno;
			dbms_output.put_line('Departamento atualizado com sucesso: ' || :new.dname || '.');
		end if;
		
		-- verifica se existe empregado.
		open c2(:new.empno);
		fetch c2 into wempno, wename;
		
		if c2%notfound then
			dbms_output.put_line('Funcionário não cadastrado.');
		else
			update emp set ename = :new.ename, job = :new.job,
			sal = :new.sal, mgr = :new.mgr, deptno = :new.deptno
			where empno = :new.empno;
			
			dbms_output.put_line('Funcionário atualizado com sucesso: ' || :new.ename || '.');
		end if;
	end if;
end;
/


select * from emp_dept_v where empno = 8000;

select * from emp_dept_v where empno = 8000;

update emp_dept_v set ename = 'BRUCEW', job = 'ANALYST', sal = 1500, deptno = 20, dname = 'RESEARCH'
where empno = 8000;

select * from emp_dept_v where empno = 8000;
select * from emp_dept_v where deptno = 20;

update emp_dept_v set dname = 'PESQUISA' where deptno = 20;

select * from emp_dept_v where deptno = 20;


create or replace trigger trg_emp_dept_v
insted of
insert or delete or update
or emp_dept_v
referencing new as new old as old
declare
	cursor c1(pdeptno dept.deptno%type) is
	select deptno, dname from dept where deptno = pdeptno;
	
	cursor c2(pempno emp.empno%type) is
	select empno, ename from emp where empno = pempno;
	
	cursor c3(pdeptno dept.deptno%type) is
	select count(*) from emp where deptno = pdeptno;
	
	wdeptno dept.deptno%type;
	wdname	dept.dname%type;
	wempno	emp.empno%type;
	wename 	emp.ename%type;
	qt_empno number default 0;
begin
	if inserting then
		-- verifica se existe departamento.
		open c1(:new.deptno);
		fetch c1 into wdeptno, wdname;

		if c1%notfound then
			insert into dept (deptno, dname, loc) values (:new.deptno, :new.dname, null);
			dbms_output.put_line('Departamento Cadastrado com Sucesso.');
		else
			dbms_output.put_line('Departamento existente: ' || wdeptno || ' - ' || wdname || '.');
		end if;
		
		-- verifica se existe empregado
		open c2(:new.empno);
		fetch c2 into wempno, wename;
		
		if c2%notfound then
			insert into emp (empno, ename, job, sal, mgr, deptno)
			values ((:new.empno, :new.ename, :new.job, :new.sal, :new.mgr, :new.deptno);
			dbms_output.put_line('Funcionário cadastrado com sucesso.');
		else
			dbms_output.put_line('Funcionário existente: ' || wempno || ' - ' || wename || '.');
		end if;
	
	elsif updating then
		-- verifica se existe departamento
		open c1(:new.deptno);
		fetch c1 into wdeptno, wdname;
		
		if c1%notfound then
			dbms_output.put_line('Departamento não existe.');
		else
			update dept set dname = :new.dname where deptno = :new.deptno;
			dbms_output.put_line('Departamento atualizado com sucesso: ' || :new.dname || '.');
		end if;
		
		-- verifica se existe empregado
		open c2(:new.empno);
		fetch c2 into wempno, wename;
		
		if c2%notfound then
			dbms_output.put_line('Funcionário não cadastrado.');
		else
			update emp set ename = :new.ename, job = :new.job, sal = :new.sal,
			mgr = :new.deptno where empno = :new.empno;
			dbms_output.put_line('Funcionário atualizado com sucesso: ' || :new.ename || '.');
		end if;
	
	elsif deleting then
		-- verifica se existe empregado.
		open c2(:old.empno);
		fetch c2 into wempno, wename;
		
		if c2%notfound then
			dbms_output.put_line('Funcionário não cadastrado.');
		else
			delete from emp where empno = :old.empno;
			dbms_output.put_line('Funcionário excluído com sucesso: ' || :old.ename || '.');
		end if;

		-- verifica se existe departamento
		open c1(:old.deptno);
		fetch c1 into wdeptno, wdname;
		
		if c1%notfound then
			dbms_output.put_line('Departamento não existe.');
		else
			-- verifica se existe departamento
			open c3(:old.deptno);
			fetch c3 into qt_empno;
			
			if qt_empno = 0 then
				delete from dept where deptno = :old.deptno;
				dbms_output.put_line('departamento excluído com sucesso: ' || :old.dname || '.');
			else
				dbms_output.put_line('O departamento ' || :old.dname || 'não pode ser excluído.');
			end if;
		end if;				
	end if;
end;
/


select * from emp_dept_v;
delete from emp_dept_v where empno = 8000;
delete from emp_dept_v where deptno = 20;
select * from emp_dept_v;


declare
	type deptnotab is table of number index by binary_integer;
	type dnametab  is table of deppt.dname%type index by binary_integer;
	type loctab    is table of varchar2(200) index by binary_integer;

	wdeptnotab	deptnotab;
	wdnametab 	dnametab;
	wloctab 	loctab;

	idx	binary_integer default 0;
begin
	for r1 in(select deptno, dname, loc from dept) loop
		idx := idx + 1;
		wdeptnotab(idx) := r1.deptno;
		wdnametab(idx)  := r1.dname;
		wloctab(idx) 	:= r1.loc;
	end loop;

	for i in 1..wdeptnotab.last loop
		dbms_output.put_line('Departamento: ' || wdeptnotab(i) || ' - ' || wdnametab(i) || ' - Local: ' || wloctab(i) );
	end loop;
end;
/


-- Segundo Exemplo
declare
	cursor c1 is select d.department_id, department_name, first_name,
	hire_date, salary from departments d, employees e
	where d.manager_id = e.employee_id
	order by department_name;
	
	type tab is table of c1%rowtype index by binary_integer;
	
	tbgerente tab;
	n number;
	
begin
	for r1 in c1 loop
		tbgerente(r1.department_id) :=  r1;
	end loop;
	
	n := tbgerente.first;
	
	while n <= tbgerente.last loop
		dbms_output.put_line(
		'Depto: '||tbgerente(n).department_name||' '||
		'Gerente: '||tbgerente(n).first_name||' '||
		'Dt. Admi.: '||tbgerente(n).hire_date||' '||
		'Sal.: '||to_char(tbgerente(n).salary, 'fm$999g999g990d00')
		);
		n := tbgerente.next(n);
	end loop;
end;
/

-- Exemplo utilizando tabela (%rowtype)

declare
	type deptab is table of dept%rowtype index by binary_integer;
	wdeptab deptab;
	idx binary_integer default 0;
begin
	for r1 in (select * from dept) loop
		idx := idx + 1;
		wdeptab(idx) := r1;
	end loop;
	
	for i in 1..wdeptab.last loop
		dbms_output.put_line('Departamento: ' || wdeptab(i).deptno || ' - ' 
		|| wdeptab(i).dname || ' - Local: ' || wdeptab(i).loc);
	end loop;
end;
/

-- PL/SQL Records (Estruturas Heterogêneas)

declare
	type deprec is record (
		deptno number(2,0),
		dname varchar2(14),
		loc varchar2(13)
	);
	wdeprec deprec;
begin
	select	*
	into	wdeprec
	from	dept
	where	deptno = 10;

	dbms_output.put_line('Departamento: ' || wdeprec.deptno || ' - ' || wdeprec.dname || ' - Local: ' || wdeprec.loc);
end;
/


declare
	type deprec is record (	deptno number(2,0),
				dname varchar2(14),
				loc varchar2(13)
			      );
	type deptab is table of deprec index by binary_integer;
	
	wdeptab deptab;
	idx	binary_integer default 0;
begin
	for r1 in (select * from dept) loop
		idx := idx + 1;
		wdeptab(idx) := r1;
	end loop;
	for i in 1..wdeptab.last loop
		dbms_output.put_line('Departamento: ' || wdeptab(i).deptno || ' - ' || wdeptab(i).dname ||
				     ' - Local: ' || wdeptab(i).loc );
	end loop;
end;
/

-- Pacote utl_file
-- Este pacote trabalha com recursos que possibilita a comunicação entre o banco de dados Oracle e o sistema operacional, fazendo com que
-- consigamos ler ou gerar arquivos externamente ao banco de dados

select * from v$parameter;

-- Criando um Objeto DIRECTORY

create directory dir_principal as 'C:\tmp\arquivos';

-- concedendo permissão de leitura e escrita
grant read, write on directory dir_principal to TSQL;

-- Consultar os objetos directory cadastrados
select * from all_directories where directory_name = 'DIR_PRINCIPAL';

--create or replace directory dir_principal as 'C:\tmp\';

grant execute on UTL_FILE to TSQL;

-- Funções e Procedimentos do uso UTL_FILE
fclose - fecha o arquivo
pricedure fclose(file in out file_type);

fclose_all - fecha todos os arquivos
procedure fclose_all;

fflush - descarrega todos os dados em buffer par serem gravados em disco imediatamente.
procedure fflush(file in file_type);

fopen - abre o arquivo
function fopen(location in varchar2, filename in varchar2, openmode in varchar2)
return file_type;%%

r - read / w - write / a - append
location - nome do diretório
filename - nome do arquivo
max_linesize - tamanho máximo de linha
function fopen(	location in varchar2,
		filename in varchar2,
		openmode in varchar2,
		max_linesize in binary_integer)
return file_type;

file - nome do arquivo
buffer - é o lugar onde o conteúdo lido da linha dever ser inserido.
get_line - lê uma linha de um arquivo
procedure get_line(file in file_type, buffer out varchar2);

is_open - verifica se um arquivo está aberto
procedure is_open(file in file_type) return boolean;

new_line - grava um caractere newline em um arquivo.
procedure new_line(file in file_type, lines in natural := 1);

put - grava uma string de caracteres em um arquivo, mas não coloca uma newline depois dela.
procedure put(file in file_type, buffer in varchar2);

put_line - grava uma linha em um arquivo
procedure put_line(file in file_type, buffer in varchar2);

putf - formata e grava saída. Essa é uma imitação bruta do procedimento PRINTF();
procedure putf(	file in file_type, format in varchar2,
		arg1 in varchar2 default null,
		arg2 in varchar2 default null,
		arg3 in varchar2 default null,
		arg4 in varchar2 default null,
		arg5 in varchar2 default null);

-- Exemplo
declare
	cursor c1 is
	select a.deptno, dname, empno, ename from dept a, emp b
	where a.deptno = b.deptno
	order by a.deptno;
	
	r1 c1%rowtype;
	
	mu_arquivo utl_file.file_type;
begin
	meu_arquivo := utl_fine.fopen('DIR_PRINCIPAL', 'empregados.txt', 'w');
	open c1;
	
	loop
		fetch c1 into r1;
		exit when c1%notfound;
		utl_file.put_line(meu_arquivo, r1,deptno || ';' ||
				  r1.dname || '; ' || r1.empno || ';' || r1.ename);
	end loop;
	close c1;
	utl_file.fclose(meu_arquivo);
	
	exception
		when utl_file.invalid_path then
			utl_file.fclose(meu_arquivo);
			dbms_output.put_line('caminho ou nome do arquivo inválido');
		when utl_file.invalid_mode then
			utl_file.fclose(meu_arquivo);
			dbms_output.put_line('Modo de abertura inválido');

end;
/

-- Lendo um arquivo gerado e exibindo as informações em tela

declare
	meu_arquivo	utl_file.file_type;
	linha		varchar2(32000);
	
	wdeptno		emp.deptno%type;
	wdname		dept.dname%type;
	wempno		emp.empno%type;
	wename		emp.ename%type;
begin
	meu_arquivp := utl_file.fopen('DIR_PRINCIPAL', 'empregados.txt', 'r');
	
	loop
		utl_file.get_line(meu_arquivo, linha);
		exit when linha is null;
		
		wdeptno :=	rtrim( substr(linha, 1, (instr(linha, ';', 1, 1) -1) ) );
		wdname	:=	rtrim( substr(linha, (instr(linha, ';',1, 1) + 1 )
						   , (instr(linha, ';',1, 2) - 1 ) -
						     (instr(linha, ';',1, 1) + (1 - 1) ) ) );
		wempno 	:=	rtrim( substr(linha, (instr(linha, ';',1, 2) + 1)
						   , (instr(linha, ';',1, 3) - 1) -
						     (instr(linha, ';',1, 2) + (1 - 1) ) ) );
		wename	:=	rtrim( rtrim(substr(linha, (instr(linha, ';', 1, 3) + 1 ) ), chr(13) ) );

		dbms_output.put_line('Cód. Departamento: ' || wdeptno);
		dbms_output.put_line('Nome Departamento: ' || wdname);
		dbms_output.put_line('Cód. Empregado: 	 ' || wempno);
		dbms_output.put_line('Nome Empregado: 	 ' || wename);
		dbms_output.put_line('_');		
	end loop;
	
	utl_file.fclose(meu_arquivo);
	
	exception
		when no_data_found then
			utl_file.fclose(meu_arquivo);
			dbms_output.put_line('Final do Arquivo.');
		when utl_file.invalid_path then
			utl_file.fclose(meu_arquivo);
			dbms_output.put_line('Caminho ou nome do arquivo inválido');
		when utl_file.invalid_mode then
			utl_file.fclose(meu_arquivo);
			dbms_output.put_line('Modo de abertura inválido');
end;
/


-- Geração de arquivos com layouts de números fixos para o tamanho das colunas.
declare
	cursor c1 is
	select a.deptno, dname, empno, ename
	from	dept a, emp b
	where	a.deptno = b.deptno
	order by a.deptno;
	
	r1 c1%rowtype;
	meu_arquivo	utl_file.file_type;
begin
	meu_arquivo := utl_file.fopen('DIR_PRINCIPAL', 'empregados.txt', 'w');
	
	open c1;
	loop
		fetch c1 into r1;
		exit when c1%notfound;
		utl_file.put_line(meu_arquivo, rpad(r1.deptno, 2, ' ') ||
					       rpad(r1.dname, 14, ' ') ||
					       rpad(r1.empno, 4, ' ') ||
					       rpad(r1.ename, 10, ' ')
				 );
	end loop;
	close c1;
	utl_file.fclose(meu_arquivo);
	
	exception
		when utl_file.invalid_path then
			utl_file.fclose(meu_arquivo);
			dbms_output.put_line('Caminho ou nome do arquivo inválido');
		when utl_file.invalid_mode then
			utl_file.fclose(meu_arquivo);
			dbms_output.put_line('Modo de abertura inválido');
end;
/

-- Leitura do Arquivo

declare
	meu_arquivo utl_file.file_type;
	linha	varchar2(32000);
	
	wdeptno	emp.deptno%type;
	wdname	dept.dname%type;
	wempno	emp.empno%type;
	wename	emp.ename%type;
begin
	meu_arquivo := utl_file.fopen('DIR_PRINCIPAL', 'empregados.txt', 'r');
	
	loop
		utl_file.get_line(meu_arquivo, linha);
		exit when linha is null;
		
		wdeptno := rtrim(ltrim(substr(linha,1,2)));
		wdname := rtrim(ltrim(substr(linha,3,14)));
		wempno := rtrim(ltrim(substr(linha,17,4)));
		wename := rtrim(ltrim(substr(linha,21,10)));
		
		dbms_output.put_line('Cód. Departamento: '||wdeptno);
		dbms_output.put_line('Nome Departamento: '||wdname);
		dbms_output.put_line('Cód. Empregado: '||wempno);
		dbms_output.put_line('Nome Empregado: '||wename);
		dbms_output.put_line('_');
	end loop;
	utl_file.fclose(meu_arquivo);
	
	exception
		when no_data_found then
			utl_file.fclose(meu_arquivo);
			dbms_output.put_line ('Final do Arquivo.');
		when utl_file.invalid_path then
			utl_file.fclose(meu_arquivo);
			dbms_output.put_line('Caminho ou nome do arquivo inválido');
		when utl_file.invalid_mode then
			utl_file.fclose(meu_arquivo);
			dbms_output.put_line ('Modo de abertura inválido');
end;
/

-- Exemplo com INSERT - Execute immediate
declare
	winsert_emp 	varchar2(4000) default null;
	winsert_dept	varchar2(4000) default null;
	
	wempno		emp.empno%type;
	wename 		emp.ename%type;
	wjob		emp.job%type;
	wmgr 		emp.mgr%type;
	whiredate 	emp.hiredate%type;
	wsal 		emp.sal%type;
	wcomm		emp.comm%type;
	wdeptno 	emp.deptno%type;
begin
	wempno		:= 9999;
	wename		:= 'BONO';
	wjob 		:= 'SALESMAN';
	wmgr		:= 7698;
	whiredate 	:= 1000;
	wcomm		:= 0;
	wdeptno 	:= 30;
	
	winsert_emp	:= 'insert into emp (empno, ename, job, mgr, hiredate, sal, comm, deptno)
			    values (:empno, :ename, :job, :mgr, :hiredate, :sal, :comm, :deptno)';
	
	execute immediate winsert_emp using wempno, wename, wjob, wmgr, whiredate, wsal, wcomm, wdeptno;
	
	winsert_dept	:= 'insert into dept values (:deptno, :dname, :loc)';
	
	execute immediate winsert_dept using 99, 'RH', 'BRASIL';
end;
/

-- Exemplo DELETE e UPDATE
declare
begin
	execute immediate 'delete from emp where empno = :empno ' using 9999;
	execute immediate 'update dept set loc = :loc where deptno = :deptno' using 'AUSTRALIA', 99;
end;
/


-- Exemplos CREATE / ALTER - EXECUTE IMMEDIATE
declare
begin
	execute immediate 'create tabela func (cd_func number, nm_func varchar2(50) )';
	execute immediate 'alter table func modify cd_func number not null';
end;
/

declare
	watualiza_dept	varchar2(2000);
	
	wdname	dept.dname%type;
	wloc_re	dept.loc%type;
	
	wloc	dept.loc%type default 'CHILE';
	wdeptno	dept.deptno%type default 99;
begin
	watualiza_dept := 'update dept set loc = :1 where deptno ; :2 returning dname, loc into :3, :4';
	execute immediate watualiza_dept using wloc, wdeptno, out wdname, out wloc_re;
	dbms_output.put_line('Localização atualizada para o departamento ' || wdname || ' (Loc: ' || wloc || ').' );
end;
/


declare
	watualiza_dept	varchar2(2000);
	
	wdname		dept.dname%type;
	wloc_re		dept.loc%type;
	
	wloc 		dept.loc%type	default 'ARGENTINA';
	wdeptno 	dept.deptno%type default 99;
begin
	watualiza_dept 	:= 'update dept set loc = :1 where deptno ; :2 returning dname, loc into :3, :4';
	execute immediate watualiza_dept using wloc, wdeptno returning into wdname, wloc_re;
	dbms_output_line('Localização atualizada para o departamento ' || wdname || ' (Loc: ' || wloc || ').' );
end;
/

-- Exemplo com FUNÇÂO
create function rows_deleted (table_name in varchar2, condition in varchar2)
return integer as
begin
	execute immediate 'delete from ' || table_name || ' where ' ||condition;
	return sql%rowcount;
end;
/
--cursor implícito sql%rowcount para retornar a quantidade de linhas excluídas.

declare
	wnr_linhas number;
begin
	wnr_linhas := rows_deleted('EMP', 'empno = 7935');
	dbms_output.put_line('Linhas Excluídas: ' || wnr_linhas);
end;
/


-- Exemplo com PROCEDURE
create or replace procedure cria_dept (
pdeptno in number, pdname in varchar2, ploc in varchar2, pstatus in out varchar2) is
begin
	insert into dept values (pdeptno, pdname, ploc);
	pstauts := 'OK';
	commit;
	exception
		when others then
			pstatus := sqlerrm;
end;
/

declare
	winsere_dept	varchar2(2000);
	
	wdname	dept.dname%type default 'RH';
	wloc 	dept.loc%type default 'ARGENTINA';
	wdeptno	dept.deptno%type default 88;
	
	wstatus varchar2(4000);
begin
	winsere_dept := 'begin cria_dept(:a, :b, :c, :d); end; ';
	
	execute immediate winsere_dept using in wdeptno, in wdname, in wloc, in out wstatus;
	
	if wstatus = 'OK' then
		dbms_output.put_line('Departamento inserido com sucesso.');
	else
		dbms_output.put_line('Erro ao inserir departamento. Erro: ' || wstatus);
	end if;
end;


-- Cursores do Tipo - ref cursor
declare
	type empcurtyp is ref cursor;
	emp_cv	empcurtyp;
	
	my_ename	varchar2(15);
	my_sal 		number default 1000;
begin
	open emp_cv for
		'select ename, sal from emp where sal > :s' using my_sal;
	loop
		fetch emp_cv into my_ename, my_sal;
		exit when emp_cv%notfound;
		dbms_output.put_line('Empregado: ' || my_ename || ' Salário: ' || my_sal);
	end loop;
end;
/

declare
	type empcurtyp is ref cursor;
	emp_cv empcurtyp;
	emp_rec	emp%rowtype;
	
	sql_stmt varchar2(200);
	my_job	varchar2(15) := 'CLERK';
begin
	sql_stmt := 'select * from emp where job = :j';
	
	open emp_cv for sql_stmt using my_job;
	loop
		fetch emp_cv into emp_rec;
		exit when emp_cv%notfound;
		dbms_output.put_line('Empregado: ' || emp_rec.ename || 'Salário: ' || emp_rec.sal);
	end loop;
	close emp_cv;
end;
/


create procedure print_table (tab_name varchar2) is
	type refcurtyp is ref cursor;
	cv refcurtyp;
	wdname dept.dname%type;
	wloc dept.loc%type;
begin
	open cv for 'select dname, loc from ' || tab_name;
	loop
		fetch cv into wdname, wloc;
		exit when cv%motfound;
		dbms_output.put_line('Departamento: ' || wdname || 'Localização: ' || wloc);
	end loop;
	close cv;
end;


begin print_table (tab_name => 'DEPT'); end;


declare
	type empcurtyp is ref cursor;
	type numlist is table of number;
	type namelist is table of varchar2(15);
	
	emp_cv empcurtyp;
	empnos numlist;
	enames namelist;
	
	sals numlist;
begin
	open emp_cv for 'select empno, ename from emp';
	fetch emp_cv bulk collect into empnos, enames;
	close emp_cv;
	
	for r in 1..empnos.count loop
		dbms_output.put_line('Cód.: ' || empnos(r) || ' - Empregado: ' || ename(r) );
	end loop;
	
	execute immediate 'select sal from emp' bulk collect into sals;
	
	for r in 1.sals.count loop
		dbms_output.put_line('Salário: ' || sals(r) );
	end loop;
end;
/

create function row_count(tab_name varchar2) return integer as
row integer;
begin
	execute immediate 'select count(*) from ' || tab_name into rows;
	return rows;
end;
/

select row_count('EMP') from dual;

select table_name from user_tables;
select comments from user_tab_comments where table_name = 'EMPLOYEES';
desc employees;
desc departments;
select * from user_constrains;
select * from user_cons_columns;

select
		cons.table_name ||
		'.' || cons_col.column_name ||
		' faz ligação com ' ||
		cons_depend.table_name || '.' ||
		cons_col_depend.column_name || ' ' ||
		"Dependências"
from 		-- tabela pesquisa
		user_constraints cons
		,user_cons_columns cons_col
		-- tabela dependencia
		,user_constraints cons_depend
		,user_cons_columns cons_col_depend
where 		cons.constraint_name = cons_col.constraint_name
and 		cons.table_name = cons_col.table_name
and 		cons.table_name = 'EMPLOYEES' -- tabela para pesquisa
and 		cons.constraint_type = 'R' -- Foreign key (ligação entre as tabelas)
and 		cons_depend.constraint_name = cons_col_depend.constraint_name
and 		cons_depend.table_name = cons_col_depend.table_name
and 		cons_depend.constraint_name = cons.r_constraint_name
order 		by 1
