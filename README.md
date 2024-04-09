# GESTRAN

## Teste (Delphi & SQL Server)

### Recomendações

1. O arquivo para o banco de dados do SQL Sever "vendas deplhi.csv" enviado por WhatsApp, deve primeiramente substituir "," por ";" para facilitar a importação dos dados.

2. Se quiser pode usar minha configuração de identação do codigo-fonte.

> #### _Use o arquivo que está no fonte_ [Formatter_WOS.config](Formatter_WOS.config)

### Componente

- #### [Fortes Report CE] (https://github.com/fortesinformatica/fortesreport-ce.git)

### Teste de compilação realizado nas versões do Delphi:

- #### Delphi XE6 UPdate 1 (build 20.0.15596.9843)
- #### Delphi 10.2.3 Tokyo (build 25.0.29899.2631)
- #### Delphi 10.4.2 Sydney (build 27.0.40680.4203)
- #### Delphi 11.3 Alexandria (build 28.0.47991.2819)

### Para executar o aplicativo:

1. #### Abra o projeto na sua versão do Delphi com o componentes do FortesReport instalado e faça o "Build" (Shift+F9).
2. #### na pasta Binary você deve configurar o arquivo [RelatorioVendas.ini](/Binary/RelatorioVendas.ini).
```
[DB]
SERVER=<seu-servidor>
PORT=<sua-porta>
DATABASE=<seu-banco>
USERNAME=<seu-usuario>
PASSWORD=<sua-senha>
```
#### por exemplo,
```
[DB]
SERVER=.\SQLEXPRESS
PORT=1433
DATABASE=GESTRAN
USERNAME=sa
PASSWORD=12345678
```

3. #### Ao executar você pode selecionar a data inicial e final desejada, selecionar o Tipo de relatório e clicar em "Gerar Relatório". Irá abrir automaticamente.

   [Tela do Projeto](https://i.imgur.com/uSrrHnE.png).

4. #### Os arquivos em PDF gerados ficam na pasta "Binary" da máquina local, caso precise consultar.

### Sobre o Projeto

#### Quero agradecer a oportunidade de ser testado por vocês, analisei a empresa e achei incrível como vocês trabalham. Muito Grato mesmo! #VivaTecnologia
