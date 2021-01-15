# Banco de Dados Oracle
(8i / 10g / 11g / 12c / 19c)
# (i - Internet) / (g - Grid) / (c - Cloud)

1 - DDL Linguagem de Definição de Dados

2 - Catálago de Dados

# Ferramentas utilizadas para Administração
1 - SQL Plus : Ferramenta desktop sem Interface Gráfica, de linha de comando, é instalada na instalação do Oracle DataBase.
2 - PL/SQL Developer : Ferramenta desktop de Interface Gráfica, paga e versão Trial.
3 - OEM - Ferramenta web Oracle Enterprise Manager, é disponibilizada na instalação do Oracle DataBase.
4 - SQL Developer - Ferramenta desktop e free fornecida pela Oracle para a Administração do Banco de Dados.
5 - 

# Estrutura Física
1 - .dbf DataFiles (Estruturas físicas de armazenamento do Banco de Dados, é vinculado a um Tablespace)

2 - ControlFiles (Contém o controle e todas as informações de funcionamento do Banco de Dados, todo banco tem pelo menos 1 e no máximo 8 para redundância e multiplexação)

3 - Redo Log Files (Contêm todos os registro de Log de transações do Banco de Dados). Pode operar em Modo Archive e Noarchive.

4 - Arquivos de Parãmetro (SPFILE - Arquivo Binário e permanente, precisa de reinicialização) e (PFILE - Arquivo de Texto e editável, não precisa de reinicialização).

5 - Arquivos de monitoramento do Banco, chamados de TRACE ou .trc.

6 - Arquivos de Alert Logs.

# Estrutura Lógica
1 - Tablespace (Maior Agrupamento de Dados, um TableSpace é vinculado a um ou mais arquivos de Dados .dbf). As TableSpaces padrão são SYSTEM e SYSAUX, auxiliam na ADM. do Banco de Dados. TableSpace UNDO, na integridade das operações de COMMIT e ROLLBACK caso precise desfazer algo. E a TableSpace TEMP, que auxilia a memória do Oracle em no processamento de operações. Todo Objeto é criado por padrão na TableSpace USERS exceto quando se esta logado com o usuário SYSTEM, onde o objeto será criado na TableSpace SYSTEM.

2 - DataBlocks (Blocos no Disco)
Compostos de (Header/Espaço/Dados) com tamanhos de 2K, 4K, 8K, 16K, 32K. Por padrão o tamanho é 8K e atende tanto ambientes OLTP e OLAP

OLTP - On-line Transaction Processing (Recomendado 2K, 4K, 8K). Melhor Desempenho para Insert/Delete/Update (Write)

OLAP - On-line Analytical Processing (Recomendado 8K, 16K, 32K). Melhor Desempenho para Select (Read)

3 - Segments (Segmentos - Objetos do Banco de Dados)
Tabelas, Índices, View, Procedures, Functios e demais objetos.

4 - Extends (Tamanho ocupado pelos segmentos)

# Estrutura Memória
Oracle possui duas grandes estruturas de memória em sua INSTÂNCIA que gerencia e controla todo o acesso a estrutura Física e Lógica.

1 - SGA - System Global Area - Compartilhada
(Large Pool, Database Buffer Cache, Redolog Buffer, Java Pool, Shared Pool e outros.)

2 - PGA - Program Global Area - Dedicada
