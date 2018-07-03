# Merge driver para conflitos locais

> Este projeto foi desenvolvido durante a disciplina Tópicos Avançados em Engenharia de Software no Centro de Informática - UFPE, sob a orientação do Prof. Dr. Paulo Borba

A proposta do projeto é, a princípio, capturar conflitos gerados a partir das funções de merge, rebase e stash do Git. Após esses comandos serem acionados pelo desenvolvedor através do Git, e houver algum conflito, o merge driver é chamado, salvado uma cópia dos arquivos conflitantes (as três revisões de cada) e registrando em uma planilha .csv onde as cópias foram armazenadas e o nome dos respectivos arquivos com sua revisão: base (ancestor), left (mine), right (yours).

## Como configurar
1. Copie o arquivo .jar em seu diretório $HOME
2. Edite seu arquivo .gitconfig e adicione as linhas abaixo
    ```
    [merge "my-merge"]
    	name = "merge driver para conflitos locais"
    	driver = java  -jar "\"$HOME/jFSTMerge.jar\"" -f %A %O %B -o %A -g -n %P
    ```
3. Edite seu arquivo .gitattributes e adicione a seguinte linha, caso ainda não exista esse arquivo em seu repositório local, crie-o.
    ```
    * merge=my-merge
    ```

## Como utilizar
O merge driver será chamado em toda situação em que houver conflito. A seguir listaremos alguns cenários que ocorre o funcionamento do merge driver, não estando limitado a apenas esses citados

### Cenários
#### Merge
1.  C1 é o commit mais recente no repositório remoto (master) e o seu local
2.  Você cria uma nova branch (branch-1) para a criação de uma feature
3.  Outros desenvolvedores atualizam a branch master enquanto você atualiza a branch-1
4.  Chega o momento de juntar a sua feature no repositório remoto (master)
5.  Ao realizar o merge das duas branches, ocorre conflitos, esses sendo capturados pelo merge driver
6.  Você os corrige e atualiza a branch master

#### Rebase
1.  O mesmo cenário de merge acontece aqui
2.  Porém, ao invés de realizar um merge nas branches (master e branch-1), você decide fazer um rebase
3.  O comando implicitamente chama o merge do Git, e ao ocorrer os conflitos, o merge driver captura-os
4.  Você corrige os conflitos e atualiza a branch master

#### Stash
1.  C1 é o commit mais recente no repositório remoto (master) e o seu local
2.  Você altera alguns arquivos (ainda na master), porém não realiza o commit dessa modificação
3.  Outro desenvolvedor (P1) realiza uma correção crítica, envia para o repositório remoto (master), gerando o commit C2, e pede para que todos atualizem os repositórios locais
4.  Você ainda não concluiu a sua modificação no arquivo e dá git pull
5.  As mudanças de C2 conflitam com as suas, que ainda não foram comitadas
6.  Você da stash nas suas mudanças, e vai haver um fast-forward no seu repositório, que agora ficará com C1 -> C2
7.  Quando você dá unstash (git stash apply), após atualizar seu repositório local, gera um conflito de merge e esse é capturado pelo merge driver
8.  Você resolve os conflitos, termina a mudança lógica que merece um commit, e dá git commit
9.  Seu repositório fica C1->C2->C3, sem commit de merge, mesmo tendo havido uma integração entre os códigos seu e P1

## Registros
Em seu diretório ```$HOME``` será criado uma pasta ```savedCopyFiles/``` contendo as revisões de cada arquivo conflitante e o arquivo ```mergeConflictsLog.csv``` armazenando em registro os arquivos salvos e onde estão.

Devido às limitações das informações fornecidas ao merge driver, não é possível ter uma identificação sobre os conflitos, como por exemplo a hash do último commit referente ao merge. Assim, como forma de identificação imediata, para cada arquivo conflitante, as cópias das três revisões são salvas em uma pasta com o nome composto por: nome do arquivo, data e hora do registro. 
Exemplo: Para um confilto com o arquivo ```configuration.properties``` em 20/06/2018 às 15:07:33, as revisões desse arquivos serão salvos no diretório: ```configuration_20-06-2018_15-07-33/``` e registrado no arquivo csv.

## Testes
Nesse repositório encontra-se três scripts batch simulando os três cenários: merge, stash e rebase.

Para executar, faça um clone desse repositório, realize os passos de como configurar, e execute os scripts no mesmo diretório.

## Merge driver
O merge driver utilizado é uma adaptação do merge driver feito por [Guilherme Cavalcanti](https://github.com/guilhermejccavalcanti), o [jFSTMerge](https://github.com/guilhermejccavalcanti/jFSTMerge). Originalmente esse merge driver tem como proposta ser uma Ferramenta de Merge Semi-estruturado. Esse merge driver compõe um módulo robusto para Merge Textual (não estruturado) similar ao realizado pelo Git.

A adaptação realizada foi o isolamento desse módulo de merge textual, com o objetivo de não alterar o comportamento do merge do git e adicionar um método para a cópia dos arquivos conflitantes e o registro em um arquivo csv.
