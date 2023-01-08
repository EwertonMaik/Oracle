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
