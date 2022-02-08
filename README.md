# SQL SERVER COM BUSINESS INTELLIGENCE
Este repositório contém um projeto utilizando o SQL Server, e o Visual Studio 2015 (Business intelligence, Reporting Services, Integration Services, Analysis Services).
Esse é um projeto de estudo. Os scripts construidos foram feitos no Microsoft SQL Server Management Studio. As modelagens foram feitas no StarUML. E os processos de ETL foram feitos no Visual Studio 2015.

# INTRODUÇÃO
A loja musical necessita armazenar o seus funcionários, metodos de pagamento, o cadastro de clientes, produtos, fornecedores, marcas, categorias, subcategorias,
os protudos das notas fiscais, e as notas fiscais. Também querem guardar seus dados de vendas, custos e lucros. Não importando saber quem vendeu ou quantas vendas cada funcionário fez. Eles desejam saber em que época do ano tem mais vendas e também em quais meses. Gostariam de ter uma análise de vendas por categoria, subcategoria e marcas.

# OBJETIVO
O objetivo deste projeto é demonstrar a criação de um banco de dados relacional de uma loja musical. Fazendo a criação do Ambiente OLTP, Staging Area, Datawarehouse, Ambiente OLAP, CUBO(Analysis Services), Reporting Services para atender todas as necessidades da loja.

# ETAPA 1 - CRIAÇÃO DO AMBIENTE OLTP
Nesta primeira etapa, será criado o database, e a estrutura das tabelas com base na modelagem.

## MODELAGEM OLTP
![modelagemOLTP](https://github.com/LeandroIzzo/SQL-SERVER-com-BI/blob/main/MOGELAGEM%20DE%20DADOS/1.%20MODELAGEM%20OLTP.jpg?raw=true)

##### CRIAÇÃO DA DATABASE DA LOJA MUSICAL (OLTP):
```
  CREATE DATABASE LOJA_INSTRUMENTOS_OLTP
  GO
```

UTILIZANDO O DATABASE:
```
  USE LOJA_INSTRUMENTOS_OLTP
  GO
```

CRIAÇÃO DA TABELA PARA O ARMAZENAMENTO DOS PRODUTOS:
```
CREATE TABLE PRODUTOS(
	IDPRODUTO INT IDENTITY,
	PRODUTO VARCHAR(70) NOT NULL,
	VALOR NUMERIC(10,2) NOT NULL,
	CUSTO_MEDIO NUMERIC(10,2) NOT NULL,
	ID_CATEGORIA INT NOT NULL,
	ID_MARCA INT NOT NULL,
	ID_FORNECEDOR INT NOT NULL,
	ID_SUBCATEGORIAS INT NOT NULL,
	CONSTRAINT PK_PRODUTO PRIMARY KEY(IDPRODUTO) 
)
GO
```
CRIAÇÃO DA TABELA MARCAS:
```
CREATE TABLE MARCAS(
	IDMARCA INT IDENTITY,
	MARCA VARCHAR(25) NOT NULL,
	CONSTRAINT PK_MARCA PRIMARY KEY(IDMARCA) 
)
GO
```
CRIAÇÃO DA TABELA CATEGORIAS:
```
CREATE TABLE CATEGORIAS(
	IDCATEGORIA INT IDENTITY,
	CATEGORIA VARCHAR(25) NOT NULL,
	CONSTRAINT PK_CATEGORIA PRIMARY KEY(IDCATEGORIA)
)
GO
```
CRIAÇÃO DA TABELA SUBCATEGORIAS:
```
CREATE TABLE SUB_CATEGORIAS(
	IDSUB INT IDENTITY,
	SUB_CATEGORIA VARCHAR(30) NOT NULL,
	ID_CATEGORIA INT NOT NULL,
	CONSTRAINT PK_SUBCTG PRIMARY KEY(IDSUB) 
)
GO
```
CRIAÇÃO DA TABELA FORNECEDORES:
```
CREATE TABLE FORNECEDORES(
	IDFORNECEDOR INT IDENTITY,
	FORNECEDOR VARCHAR(25) NOT NULL,
	CONSTRAINT PK_FORNECEDOR PRIMARY KEY(IDFORNECEDOR)
)
GO
```
CRIAÇÃO DA TABELA CLIENTES:
```
CREATE TABLE CLIENTES(
	IDCLIENTE INT IDENTITY,
	NOME VARCHAR(20) NOT NULL,
	SOBRENOME VARCHAR(35) NOT NULL,
	SEXO CHAR(1) CONSTRAINT CK_SEXO CHECK (SEXO IN ('M', 'F')) NOT NULL,
	NASCIMENTO DATE NOT NULL,
	EMAIL VARCHAR(50) NOT NULL,
	RUA VARCHAR(30) NOT NULL,
	CIDADE VARCHAR(20) NOT NULL,
	UF CHAR(2) NOT NULL,
	CONSTRAINT PK_CLIENTE PRIMARY KEY(IDCLIENTE)
)
GO
```
CRIAÇÃO DA TABELA FUNCIONARIOS:
```
CREATE TABLE FUNCIONARIOS(
	IDFUNCIONARIO INT IDENTITY,
	FUNCIONARIO VARCHAR(45) NOT NULL,
	SEXO CHAR(1) CONSTRAINT CK_SEXO_FUN CHECK (SEXO IN ('M', 'F')) NOT NULL,
	NASCIMENTO DATE NOT NULL,
	EMAIL VARCHAR(40) NOT NULL,
	RUA VARCHAR(30) NOT NULL,
	CIDADE VARCHAR(20) NOT NULL,
	UF CHAR(2) NOT NULL,
	CARGO VARCHAR(30) NOT NULL,
	SALARIO NUMERIC(10,2) NOT NULL,
	CONSTRAINT PK_FUNCIONARIO PRIMARY KEY(IDFUNCIONARIO)
)
GO
```
CRIAÇÃO DA TABELA METODO DE PAGAMENTO:
```
CREATE TABLE METODO_PAGAMENTO(
	IDMETODO INT IDENTITY,
	FORMA_DE_PAGAMENTO VARCHAR(35) NOT NULL,
	CONSTRAINT PK_METODO PRIMARY KEY(IDMETODO)
)
GO
```
CRIAÇÃO DA TABELA NOTA FISCAL:
```
CREATE TABLE NOTA_FISCAL(
	IDNOTAFISCAL INT IDENTITY,
	DATA DATE DEFAULT GETDATE() NOT NULL,
	TOTAL DECIMAL(10,2),
	ID_FORMA INT NOT NULL,
	ID_CLIENTE INT NOT NULL,
	ID_FUNCIONARIO INT NOT NULL,
	CONSTRAINT PK_NOTA PRIMARY KEY(IDNOTAFISCAL)
)
GO
```
CRIAÇÃO DA TABELA ITENS DA NOTA FISCAL:
```
CREATE TABLE ITEM_NOTA(
	IDITEMNOTA INT IDENTITY,
	QUANTIDADE INT,
	VALOR NUMERIC(10,2),
	ID_PRODUTO INT NOT NULL,
	ID_NOTA_FISCAL INT NOT NULL,
	CONSTRAINT PK_ITEM PRIMARY KEY(IDITEMNOTA)
)
GO
```

# ETAPA 2 - RELACIONAMENTO ENTRA AS TABELAS
Nesta etapa iremos crias as Foreign Key(FK) para relacionar as tabelas. 
Elas foram criadas fora do script de criação de tabelas para termos um dicionário de dados.

CRIANDO OS RELACIONAMENTOS ENTRE TABELAS, FOREIGNS KEYS REFERENTES AS TABELAS:

PRODUTOS E CATEGORIAS:
```
ALTER TABLE PRODUTOS ADD CONSTRAINT FK_PROD_CATG
FOREIGN KEY(ID_CATEGORIA) REFERENCES CATEGORIAS(IDCATEGORIA)
GO
```
PRODUTOS E MARCAS:
```
ALTER TABLE PRODUTOS ADD CONSTRAINT FK_PROD_MARCA
FOREIGN KEY(ID_MARCA) REFERENCES MARCAS(IDMARCA)
GO
```
PRODUTOS E FORNECEDORES:
```
ALTER TABLE PRODUTOS ADD CONSTRAINT FK_PROD_FORNCEDORES 
FOREIGN KEY(ID_FORNECEDOR) REFERENCES FORNECEDORES(IDFORNECEDOR)
GO
```
NOTA FISCAL E FORMA DE PAGAMENTO:
```
ALTER TABLE NOTA_FISCAL ADD CONSTRAINT FK_NOTA_FORMA
FOREIGN KEY(ID_FORMA) REFERENCES METODO_PAGAMENTO(IDMETODO)
GO
```
NOTA FISCAL E CLIENTES:
```
ALTER TABLE NOTA_FISCAL ADD CONSTRAINT FK_NOTAS_CLIENTE
FOREIGN KEY(ID_CLIENTE) REFERENCES CLIENTES(IDCLIENTE)
GO
```
ITENS DE NOTA E PRODUTOS:
```
ALTER TABLE ITEM_NOTA ADD CONSTRAINT FK_ITEM_PROD
FOREIGN KEY(ID_PRODUTO) REFERENCES PRODUTOS(IDPRODUTO)
GO
```
ITENS DE NOTA E NOTA FISCAL:
```
ALTER TABLE ITEM_NOTA ADD CONSTRAINT FK_ITEM_NOTAFISCAL
FOREIGN KEY(ID_NOTA_FISCAL) REFERENCES NOTA_FISCAL(IDNOTAFISCAL)
GO
```
PRODUTOS E SUBCATEGORIAS:
```
ALTER TABLE PRODUTOS ADD CONSTRAINT FK_PRODUTO_SUBCATE 
FOREIGN KEY(ID_SUBCATEGORIAS) REFERENCES SUB_CATEGORIAS(IDSUB)
GO
```
SUBCATEGORIAS E CATEGORIAS:
```
ALTER TABLE SUB_CATEGORIAS ADD CONSTRAINT FK_SUBCATEG_CATEGO 
FOREIGN KEY(ID_CATEGORIA) REFERENCES CATEGORIAS(IDCATEGORIA)
GO
```
NOTA FISCAL E FUNCIONARIO:
```
ALTER TABLE NOTA_FISCAL ADD CONSTRAINT FK_NOTA_FUNC
FOREIGN KEY(ID_FUNCIONARIO) REFERENCES FUNCIONARIOS(IDFUNCIONARIO)
GO
```

# ETAPA 3 - ADICIONANDO DADOS
Nesta etapa iremos adicionar os dados de todas as tabelas.
OBS: Os dados completos de todas as tabelas, estão na pasta scripts.

ADICIONANDO DADOS NA TABELA CATEGORIAS:
```
	INSERT INTO CATEGORIAS VALUES('Acessórios')
	INSERT INTO CATEGORIAS VALUES('Igreja')
	INSERT INTO CATEGORIAS VALUES('Sopro')
	INSERT INTO CATEGORIAS VALUES('Teclas')
	INSERT INTO CATEGORIAS VALUES('Cordas')
	INSERT INTO CATEGORIAS VALUES('Livros')
	INSERT INTO CATEGORIAS VALUES('Outlet')
	INSERT INTO CATEGORIAS VALUES('Percussão')
	INSERT INTO CATEGORIAS VALUES('Áudio')
	GO
```
ADICIONANDO DADOS NA SUBCATEGORIAS:
```
-- Audio = 9
	INSERT INTO SUB_CATEGORIAS VALUES('Afinador/Metronomo', 9)
	INSERT INTO SUB_CATEGORIAS VALUES('Cabos e Adptadores', 9)

-- Percurssão = 8
	INSERT INTO SUB_CATEGORIAS VALUES('Pandeiros', 8)
	INSERT INTO SUB_CATEGORIAS VALUES('Baqueta', 8)

-- Outlet = 7
	INSERT INTO SUB_CATEGORIAS VALUES('Estojo', 7)
	INSERT INTO SUB_CATEGORIAS VALUES('Bíblias', 7)

-- Livros = 6
	INSERT INTO SUB_CATEGORIAS VALUES('Métodos Cordas', 6)
	INSERT INTO SUB_CATEGORIAS VALUES('Métodos Diversos', 6)

-- Cordas = 5
	INSERT INTO SUB_CATEGORIAS VALUES('Cavaquinhos', 5)
	INSERT INTO SUB_CATEGORIAS VALUES('Viola de Arco', 5)

-- Teclas = 4
	INSERT INTO SUB_CATEGORIAS VALUES('Escaleta', 4)
	INSERT INTO SUB_CATEGORIAS VALUES('Pianos', 4)

-- Sopro = 3
	INSERT INTO SUB_CATEGORIAS VALUES('Gaita', 3)
	INSERT INTO SUB_CATEGORIAS VALUES('Bombardinos', 3)
	INSERT INTO SUB_CATEGORIAS VALUES('Clarinetes', 3)

-- Igreja = 2
	INSERT INTO SUB_CATEGORIAS VALUES('Acessórios', 2)
	INSERT INTO SUB_CATEGORIAS VALUES('Caixa de Coleta', 2)

-- Acessorios = 1
	INSERT INTO SUB_CATEGORIAS VALUES('Abraçadeiras', 1)
	INSERT INTO SUB_CATEGORIAS VALUES('Arcos', 1)
	GO
```
ADICIONANDO MARCAS:
```
	INSERT INTO MARCAS VALUES('CSR')
	INSERT INTO MARCAS VALUES('Dolphin')
	INSERT INTO MARCAS VALUES('Free Sax')
	INSERT INTO MARCAS VALUES('Saty')
	INSERT INTO MARCAS VALUES('JBL')
	INSERT INTO MARCAS VALUES('Sony')
	INSERT INTO MARCAS VALUES('Philips')
	INSERT INTO MARCAS VALUES('Paganini')
	GO
```
ADICIONANDO METODO DE PAGAMENTOS:
```
	INSERT INTO METODO_PAGAMENTO VALUES('Tranferência - Vista')
	INSERT INTO METODO_PAGAMENTO VALUES('Depósito - Vista')
	INSERT INTO METODO_PAGAMENTO VALUES('Boleto - Vista')
	INSERT INTO METODO_PAGAMENTO VALUES('PicPay - Vista')
	INSERT INTO METODO_PAGAMENTO VALUES('Mercado Pago - Vista')
	INSERT INTO METODO_PAGAMENTO VALUES('Cartão Master 2 vezes')
	INSERT INTO METODO_PAGAMENTO VALUES('Cartão Visa 2 vezes')
	INSERT INTO METODO_PAGAMENTO VALUES('Cartão Visa 3 vezes')
	INSERT INTO METODO_PAGAMENTO VALUES('Cartão American 5 vezes')
	INSERT INTO METODO_PAGAMENTO VALUES('Cartão Visa 2 vezes')
	INSERT INTO METODO_PAGAMENTO VALUES('Pay Pall - 5 vezes')
	INSERT INTO METODO_PAGAMENTO VALUES('Pag Seguro Web - Vista')
	INSERT INTO METODO_PAGAMENTO VALUES('Cheque - Vista')
	INSERT INTO METODO_PAGAMENTO VALUES('Pic Pay - Vista')
	INSERT INTO METODO_PAGAMENTO VALUES('Mercado Pago - Vista')
	GO
```
ADICIONANDO FORNECEDORES:
```
	INSERT INTO FORNECEDORES VALUES('Alibaba')
	INSERT INTO FORNECEDORES VALUES('Oderço')
	INSERT INTO FORNECEDORES VALUES('ZadSom')
	INSERT INTO FORNECEDORES VALUES('Guimarães Comercial')
	INSERT INTO FORNECEDORES VALUES('Izzo Instrumentos')
	INSERT INTO FORNECEDORES VALUES('Hayamax')
	INSERT INTO FORNECEDORES VALUES('Musitech')
	INSERT INTO FORNECEDORES VALUES('Kyodday Comércio')
	GO
```
ADICIONANDO PRODUTOS:
```
	INSERT INTO PRODUTOS VALUES('Queixeira Guarnieri Violino 3/4 4/4 em Ébano Hill', 113.68,80.50,1,24,3,53)
	INSERT INTO PRODUTOS VALUES('Queixeira Violino 4/4 em Ébano', 120.00, 85.00, 1, 23, 2, 53)
	INSERT INTO PRODUTOS VALUES('Queixeira Violino 4/4 - Madeira', 105.00, 75.00, 1, 8, 1, 53)
	INSERT INTO PRODUTOS VALUES('Suporte Estante Dobrável Compacta para Partitura',339.00,280.00,1,30,7,52)
	INSERT INTO PRODUTOS VALUES('Estante para Piano Digital YAMAHA',869.00,680.00,1,10,3,52)
	INSERT INTO PRODUTOS VALUES('Polidor Instrumentos Niquelados',90.00,40.00,1,10,3,51)
	INSERT INTO PRODUTOS VALUES('Surdina para Trombone',230.00,175.00,1,1,2,50)
	INSERT INTO PRODUTOS VALUES('Surdina Tour te Round',12.87,4.13,1,43,4,50)
	INSERT INTO PRODUTOS VALUES('Surdina de Metal Violino',112.20,68.70,1,8,1,50)
	INSERT INTO PRODUTOS VALUES('Prendedor de Partitura Clave de Sol',18.00,7.00,1,8,8,49)
	INSERT INTO PRODUTOS VALUES('Palheta para violão Fina',13.20,5.20,1,8,8,48)
	INSERT INTO PRODUTOS VALUES('Palhetapara Sax Alto',35.00,20.00,1,45,2,48)
	INSERT INTO PRODUTOS VALUES('Plaheta para Sax ALto',23.00,9.00,1,26,1,48)
	INSERT INTO PRODUTOS VALUES('Bocal para trompa prateado nºW15 - VFH',78.00,32.00,1,17,5,47)
	INSERT INTO PRODUTOS VALUES('Bocal para Bombardino 6 1/2 AL',80.00,46.00,1,2,4,47)
	INSERT INTO PRODUTOS VALUES('Breu para Violino/Viola - Preto',15.00,6.00,1,8,3,46)
	INSERT INTO PRODUTOS VALUES('Breu para Violino e Viola Black',40.00,27.00,1,24,7,46)
	INSERT INTO PRODUTOS VALUES('Capa Preta para Violão ou Violão 12 Cordas',452.00,388.00,1,21,6,45)
	INSERT INTO PRODUTOS VALUES('Capa Capota Preta para Sax Alto',252.96,198.04,1,21,6,45)
```
# ETAPA 4 - CRIANDO DADOS PARA AS NOTAS FISCAIS E OS ITENS DE NOTA
CRIANDO E ADICIONANDO DADOS DE FORMA ALEATORIA NAS NOTAS FISCAIS, COMO SE FOSSEM COMPRAS FEITAS:
```
/* 
ADICIONANDO DADOS NAS NOTAS FISCAIS 
1- CLIENTE ALEATORIO;
2- FUNCIONARIO ALEATORIO;
3- FORMA DE PAGAMENTO/METODO DE PAGAMENTO ALEATORIA
4- ANO/MES/DIA ALEATORIO 
	OBS: RODAREI CADA ANO 5000 VEZES (2019,2020,2021)
	PARA CRIAR 15.000
*/

DECLARE
		@ID_CLIENTE INT, @ID_FUNCIONARIO INT, @ID_FORMA INT,
		@DATA DATE

BEGIN
		SET @ID_CLIENTE = 
		(SELECT TOP 1 IDCLIENTE FROM CLIENTES ORDER BY NEWID())

		SET @ID_FUNCIONARIO =
		(SELECT TOP 1 IDFUNCIONARIO FROM FUNCIONARIOS ORDER BY NEWID())

		SET @ID_FORMA =
		(SELECT TOP 1 IDMETODO FROM METODO_PAGAMENTO ORDER BY NEWID())
		
		/* CRIANDO UMA DATA ALEATORIA*/
		/* CADA VEZ QUE RODAR O COMANDO, ALTERE O 2019 POR 2020 E DEPOIS PARA 2021 */
		SET @DATA = (SELECT
					CONVERT(DATE, CONVERT(VARCHAR(15),'2019-' +
					CONVERT(VARCHAR(5),(CONVERT(INT,RAND()*12)) + 1) + '-' +
					CONVERT(VARCHAR(5),(CONVERT(INT,RAND()*27)) + 1))))

		INSERT INTO NOTA_FISCAL(ID_CLIENTE,ID_FUNCIONARIO,ID_FORMA, DATA)   
		VALUES			(@ID_CLIENTE,@ID_FUNCIONARIO,@ID_FORMA,@DATA)		 

END
GO 5000 --VAI EXECUTAR 5000 VEZES
```
ADICIONANDO ITENS NA NOTA FISCAL:
```
-- OBS: Execute esse comando de acordo com a nota fiscal
-- SELECT COUNT(*) FROM NOTA_FISCAL

DECLARE
		@ID_PRODUTO INT,
		@ID_NOTA_FISCAL INT,
		@QUANTIDADE INT,
		@VALOR NUMERIC(10,2),
		@VALOR_TOTAL NUMERIC(10,2)

BEGIN
		SET @ID_PRODUTO =
		(SELECT TOP 1 IDPRODUTO FROM PRODUTOS ORDER BY NEWID())

		SET @ID_NOTA_FISCAL =
		(SELECT TOP 1 IDNOTAFISCAL FROM NOTA_FISCAL ORDER BY NEWID())

		SET @QUANTIDADE =
		(SELECT ROUND(RAND() * 1 + 1, 0))

		SET @VALOR = 
		(SELECT VALOR FROM PRODUTOS WHERE IDPRODUTO = @ID_PRODUTO)

		SET @VALOR_TOTAL = @QUANTIDADE * @VALOR

		INSERT INTO ITEM_NOTA(ID_PRODUTO,ID_NOTA_FISCAL,QUANTIDADE,VALOR)
			VALUES	     (@ID_PRODUTO,@ID_NOTA_FISCAL,@QUANTIDADE,@VALOR_TOTAL)
END
GO 15000
```
VERIFICANDO AS NOTAS QUE NÃO FORAM PREENCHIDAS:
```
SELECT IDNOTAFISCAL FROM NOTA_FISCAL
WHERE IDNOTAFISCAL NOT IN(SELECT ID_NOTA_FISCAL FROM ITEM_NOTA)
GO
```
PREENCHENDO AS NOTAS FISCAIS SEM ITENS:
```
/* AS NOTAS SERÃO PREENCHIDAS APENAS COM 1 PRODUTO ALEATORIO */
DECLARE

        C_NOTAFISCAL CURSOR FOR
        SELECT IDNOTAFISCAL FROM NOTA_FISCAL
        WHERE IDNOTAFISCAL NOT IN(SELECT ID_NOTA_FISCAL FROM ITEM_NOTA)

DECLARE
        @IDNOTAFISCAL INT,
        @ID_PRODUTO INT,
        @VALOR DECIMAL(10,2)

OPEN C_NOTAFISCAL

FETCH NEXT FROM C_NOTAFISCAL
INTO @IDNOTAFISCAL

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @ID_PRODUTO =
    (SELECT TOP 1 IDPRODUTO FROM PRODUTOS ORDER BY NEWID())

    SET @VALOR =
    (SELECT VALOR FROM PRODUTOS WHERE IDPRODUTO = @ID_PRODUTO)

    INSERT INTO ITEM_NOTA(ID_PRODUTO, ID_NOTA_FISCAL, QUANTIDADE, VALOR)
    VALUES(@ID_PRODUTO, @IDNOTAFISCAL,1, @VALOR)

FETCH NEXT FROM C_NOTAFISCAL
INTO @IDNOTAFISCAL

END

CLOSE C_NOTAFISCAL
DEALLOCATE C_NOTAFISCAL
```
RELATORIO/VIEW DO TOTAL POR NOTA FISCAL:
```
CREATE VIEW V_TOTAL_NOTAFISCAL AS
SELECT ID_NOTA_FISCAL, SUM(VALOR) AS SOMA
FROM ITEM_NOTA
GROUP BY ID_NOTA_FISCAL
```
TOTAL DA SOMA NA CARGA NOTA FISCAL:
OBS: SOMA = TOTAL GASTO NA NOTA
```
CREATE VIEW V_CARGA_NOTAFISCAL AS
SELECT N.IDNOTAFISCAL, N.TOTAL AS TOTAL_NOTA, T.SOMA
FROM NOTA_FISCAL N
INNER JOIN V_TOTAL_NOTAFISCAL T
ON IDNOTAFISCAL = ID_NOTA_FISCAL
GO
```
SOMA = TOTAL DA NOTA
```
UPDATE V_CARGA_NOTAFISCAL SET TOTAL_NOTA = SOMA
GO
```

# ETAPA 5 - STAGING AREA
Nesta etapa iremos realizar os processos de ETL de acordo com as necessidades da loja musical.
Houve uma mudança nos requisitos e eles desejam que o nome e sobrenome do cliente, estejam na mesma coluna como nome completo.

## MODELAGEM STAGE
![modelagemSTAGE](https://github.com/LeandroIzzo/SQL-SERVER-com-BI/blob/main/MOGELAGEM%20DE%20DADOS/2.%20MODELAGEM%20STAGING%20AREA.jpg?raw=true)

### CRIAÇÃO DO DATABASE DA STAGE:
```
CREATE DATABASE LOJA_STAGE
GO
```
UTILIZANDO O DATABASE:
```
USE LOJA_STAGE
GO
```

CRIAÇÃO DA TABELA STAGE CLIENTES:
```
CREATE TABLE ST_CLIENTES(
	IDCLIENTE INT DEFAULT NULL,
	NOME_COMPLETO VARCHAR(80) DEFAULT NULL,
	SEXO VARCHAR(6) DEFAULT NULL,
	NASCIMENTO DATE DEFAULT NULL,
	CIDADE VARCHAR(20) DEFAULT NULL,
	UF VARCHAR(6) DEFAULT NULL,
	EMAIL VARCHAR(100) DEFAULT NULL
)
GO
```
CRIAÇÃO DA TABELA STAGE FUNCIONARIOS:
```
CREATE TABLE ST_FUNCIONARIOS(
	IDFUNCIONARIO INT DEFAULT NULL,
	FUNCIONARIO VARCHAR(50) DEFAULT NULL,
	SEXO VARCHAR(6) DEFAULT NULL,
	CARGO VARCHAR(40) DEFAULT NULL
)
GO
```
CRIAÇÃO DA TABELA STAGE CATEGORIAS:
```
CREATE TABLE ST_CATEGORIAS(
	IDCATEGORIA INT DEFAULT NULL,
	CATEGORIA VARCHAR(40) DEFAULT NULL,
)
GO
```
CRIAÇÃO DA TABELA STAGE SUBCATEGORIAS:
```
CREATE TABLE ST_SUBCATEGORIAS(
	IDSUB INT DEFAULT NULL,
	SUB_CATEGORIA VARCHAR(35) DEFAULT NULL
)
GO
```
CRIAÇÃO DA TABELA STAGE FORNECEDORES:
```
CREATE TABLE ST_FORNECEDORES(
	IDFORNECEDOR INT DEFAULT NULL,
	FORNECEDOR VARCHAR(30) DEFAULT NULL,
)
GO
```
CRIAÇÃO DA TABELA STAGE MARCAS:
```
CREATE TABLE ST_MARCAS(
	IDMARCA INT DEFAULT NULL,
	MARCA VARCHAR(30) DEFAULT NULL
)
GO
```
CRIAÇÃO DA TABELA STAGE PRODUTOS:
```
CREATE TABLE ST_PRODUTOS(
	IDPRODUTO INT DEFAULT NULL,
	PRODUTO VARCHAR(100) DEFAULT NULL,
	VALOR_UNIT NUMERIC(10,2) DEFAULT NULL,
	CUSTO_MEDIO NUMERIC(10,2) DEFAULT NULL
)
GO
```
CRIAÇÃO DA TABELA STAGE NOTAS:
```
CREATE TABLE ST_NOTAS(
	IDNOTA INT DEFAULT NULL
)
GO
```
CRIAÇÃO DA TABELA STAGE METODOS DE PAGAMENTO:
```
CREATE TABLE ST_METODOS(
	IDMETODO INT DEFAULT NULL,
	FORMA_PAGAMENTO VARCHAR(45) DEFAULT NULL
)
GO
```
### CRIAÇÃO DA TABELA FATO NO STAGE:
OBS: FATO -> SÃO AS MEDIDAS DO NEGOCIO
-- TOTAL
-- QUANTIDADE
-- LUCRO
-- CUSTO
-- DATA
```
CREATE TABLE ST_FATO(
	ID_CLIENTE INT DEFAULT NULL,
	ID_FUNCIONARIO INT DEFAULT NULL,
	ID_FORNECEDOR INT DEFAULT NULL,
	ID_PRODUTO INT DEFAULT NULL,
	ID_CATEGORIA INT DEFAULT NULL,
	ID_SUB INT DEFAULT NULL,
	ID_MARCA INT DEFAULT NULL,
	ID_NOTA INT DEFAULT NULL,
	ID_METODO INT DEFAULT NULL,
	DATA DATE DEFAULT NULL,
	QUANTIDADE INT DEFAULT NULL,
	TOTAL_ITEM NUMERIC(10,2) DEFAULT NULL,
	CUSTO_TOTAL NUMERIC(10,2) DEFAULT NULL,
	LUCRO_TOTAL NUMERIC(10,2) DEFAULT NULL
)
GO
```

### VIEW COMPLETO DA TABELA FATO
OBS: SERÁ USADO COMO A CARGA DA TABELA FATO.

```
CREATE VIEW RELATORIO_VENDAS_FATO AS
SELECT  C.IDCLIENTE,
		F.IDFUNCIONARIO,
		P.IDPRODUTO,
		CT.IDCATEGORIA,
		S.IDSUB,
		MA.IDMARCA,
		FO.IDFORNECEDOR,
		N.IDNOTAFISCAL,
		M.IDMETODO,
		I.QUANTIDADE,
		(I.QUANTIDADE * P.CUSTO_MEDIO) AS CUSTO_TOTAL,
		(I.VALOR - (I.QUANTIDADE * P.CUSTO_MEDIO)) AS LUCRO_TOTAL,
		I.VALOR AS VALOR_VENDA_TOTAL,
		N.DATA AS DATA
FROM NOTA_FISCAL N
INNER JOIN ITEM_NOTA I
ON N.IDNOTAFISCAL = I.ID_NOTA_FISCAL
INNER JOIN CLIENTES C
ON C.IDCLIENTE = N.ID_CLIENTE
INNER JOIN FUNCIONARIOS F
ON F.IDFUNCIONARIO = N.ID_FUNCIONARIO
INNER JOIN PRODUTOS P
ON P.IDPRODUTO = ID_PRODUTO
INNER JOIN METODO_PAGAMENTO M
ON M.IDMETODO = N.ID_FORMA
INNER JOIN FORNECEDORES FO
ON FO.IDFORNECEDOR = P.ID_FORNECEDOR
INNER JOIN CATEGORIAS CT
ON CT.IDCATEGORIA = P.ID_CATEGORIA
INNER JOIN SUB_CATEGORIAS S
ON S.IDSUB = P.ID_SUBCATEGORIAS
INNER JOIN MARCAS MA
ON MA.IDMARCA = P.ID_MARCA
GO
```

# ETAPA 6 - PROCESSOS DE ETL (VISUAL STUDIO 2015 - INTEGRATION SERVICES)
Nesta etapa será criado o projeto no visual studio 2015, e realizar as extrações, transformações e carregamento dos dados.

***
### CRIANDO O PROJETO
![VSPROJETO](https://github.com/LeandroIzzo/SQL-SERVER-com-BI/blob/main/VISUAL%20STUDIO%20PRINT/PASSO%201%20-%20CRIA%C3%87%C3%83O%20DO%20PROJETO.png?raw=true)
***

### CRIAÇÃO DA SOLUTION
![VSSOLUTION](https://github.com/LeandroIzzo/SQL-SERVER-com-BI/blob/main/VISUAL%20STUDIO%20PRINT/PASSO%202%20-%20CRIA%C3%87%C3%83O%20DA%20SOLUTION.png?raw=true)
***

### GERENCIANDO CONEXÕES
![VSCONEXÃO](https://github.com/LeandroIzzo/SQL-SERVER-com-BI/blob/main/VISUAL%20STUDIO%20PRINT/PASSO%203%20-%20GERENCIANDO%20CONEX%C3%95ES.png?raw=true)
- NOVA...

![VSCONEXÃO2](https://github.com/LeandroIzzo/SQL-SERVER-com-BI/blob/main/VISUAL%20STUDIO%20PRINT/PASSO%203,2%20-%20ESCOLHENDO%20AS%20CONEX%C3%95ES.png?raw=true)
- NAME SERVER: DIGITE UM "." OU SEU "NOME DO SERVIDOR";
- ESCOLHA AS CONEXÕES COM O OLTP E STAGE.
***

### CRIAÇÃO DO PACOTE
![VSPACOTE](https://github.com/LeandroIzzo/SQL-SERVER-com-BI/blob/main/VISUAL%20STUDIO%20PRINT/PASSO%204%20-%20CRIA%C3%87%C3%83O%20DO%20NOVO%20PACOTE.png?raw=true)
- TROQUE O NOME DO PACOTE EX: CARGA CLIENTE.
***

### CRIAÇÃO DA CARGA CLIENTES:
![VSCLIENTE](https://github.com/LeandroIzzo/SQL-SERVER-com-BI/blob/main/VISUAL%20STUDIO%20PRINT/PASSO%205%20-%20SQL%20TASK.png?raw=true)

- SEQUENCE CONTAINER: TODOS OS PROCESSOS SERÃO FEITOS DENTRO DE UM CONTAINER;
- EXECUTE SQL TASK: SERÁ EXECUTADO UM TRUNCATE TABLE "NOME DA TABELA STAGE";
- INSTRUÇÃO SQL, DENTRO DO SQL TASK: DEFINA A CONEXÃO COM O STAGE E ESPECIFIQUE A CONSULTA A SER EXECUTADA.

![VSCLIENTE2](https://github.com/LeandroIzzo/SQL-SERVER-com-BI/blob/main/VISUAL%20STUDIO%20PRINT/PASSO%205,2%20-%20CONNECTION%20E%20SQLSTATEMENT.png?raw=true)

#### CRIAÇÃO DO DATA FLOW TASK
- JOGUE O "EXECUTE SQL TASK" E O "DATA FLOW TASK" DENTRO DO CONTAINER.
![VSCLIENTE3](https://github.com/LeandroIzzo/SQL-SERVER-com-BI/blob/main/VISUAL%20STUDIO%20PRINT/PASSO%205,4%20-%20CONTAINER.png?raw=true)

- LIGUE O "EXECUTE SQL TASK" COM O "DATA FLOW TASK".

![VSCLIENTE4](https://github.com/LeandroIzzo/SQL-SERVER-com-BI/blob/main/VISUAL%20STUDIO%20PRINT/PASSO%205,3%20-%20DATA%20FLOW%20TASK.png?raw=true)
- OLE DB SOURCE: CRIE A ORIGEM DOS DADOS.

![VSCLIENTE5](https://github.com/LeandroIzzo/SQL-SERVER-com-BI/blob/main/VISUAL%20STUDIO%20PRINT/PASSO%205,4%20-%20CONEX%C3%83O%20OLE%20DB.png?raw=true)
- GERENCIADOR DE CONEXÕES: SELECIONE O DATABASE DA ORIGEM DOS DADOS;
- TABELA OU VIEW: SELECIONE A TABELA DA CARGA;
OBS: O MODO DE ACESSO PODE SER ALTERADO PARA "COMANDO DO SQL" E ENTÃO FEITO UM SELECT COM TODAS AS COLUNAS DA TABELA.

#### JUNÇÃO DO NOME COM SOBRENOME
- FAÇA A LIGAÇÃO DO "OLE DB SOURCE" COM "COLUNA DERIVADA".

![VSCLIENTE6](https://github.com/LeandroIzzo/SQL-SERVER-com-BI/blob/main/VISUAL%20STUDIO%20PRINT/PASSO%205,5%20-%20COLUNA%20DERIVADA%20(NOME%20COMPLETO).png?raw=true)
- NOME DA COLUNA DERIVADA: SERÁ O NOME DA NOVA COLUNA;
- EXPRESSÃO: AÇÃO A SER EXECUTADA, JUNTAR O NOME COM SOBRENOME.

#### FINALIZANDO A CARGA CLIENTE NO STAGE
CRIE O OLE DB DESTINATION
- OLE DB DESTINATION: DESTINO DOS DADOS;
- LIGUE "COLUNA DERIVADA" COM "OLE DB DESTINATION".

![VSCLIENTE7](https://github.com/LeandroIzzo/SQL-SERVER-com-BI/blob/main/VISUAL%20STUDIO%20PRINT/PASSO%205,6%20-%20DESTINO%20DOS%20DADOS.png?raw=true)
- GERENCIADOR DE CONEXÕES: SELECIONE A DATABASE DO DESTINO DOS DADOS;
- TABELA OU EXIBIÇÃO/VIEW: SELECIONE A TABELA DESTINO;
- OK.

![VSCLIENTE8](https://github.com/LeandroIzzo/SQL-SERVER-com-BI/blob/main/VISUAL%20STUDIO%20PRINT/PASSO%205,7%20-%20FINAL%20CLIENTE.png?raw=true)
***

#### CRIAÇÃO DA CARGA FUNCIONARIO:
O processo de criação das cargas será basicamente o mesmo, excluindo a coluna derivada.
- SEQUENCE CONTAINER: Será a divisão das cargas (STAGE E DW);
- EXECUTE SQL TASK: Feito o truncate table na tabela st_funcionarios;
- DATA FLOW TASK: Area do fluxo de dados;
![VSFUNC1](https://github.com/LeandroIzzo/SQL-SERVER-com-BI/blob/main/VISUAL%20STUDIO%20PRINT/PASSO%206%20-%20CARGA%20FUNCIONARIO.png?raw=true)

- OLE DB SOURCE: Origem dos dados, vindo da tabela funcionarios no banco OLTP;
- OLE DB DESTINATION: Destino dos dados, indo para a tabela st_funcionarios no banco STAGE.
![VSFUNC2](https://github.com/LeandroIzzo/SQL-SERVER-com-BI/blob/main/VISUAL%20STUDIO%20PRINT/PASSO%206,2%20-%20FLUXO%20DOS%20DADOS%20FUNC.png?raw=true)

#### CRIAÇÃO DA CARGA CATEGORIAS:
- SEQUENCE CONTAINER: Será a divisão das cargas (STAGE E DW);
- EXECUTE SQL TASK: Feito o truncate table na tabela st_categorias;
- DATA FLOW TASK: Leva a Area do fluxo de dados;
![VSCATG1](https://github.com/LeandroIzzo/SQL-SERVER-com-BI/blob/main/VISUAL%20STUDIO%20PRINT/PASSO%207%20-%20CARGA%20CATEGORIAS.png?raw=true)

- OLE DB SOURCE: Origem dos dados, vindo da tabela categorias no banco OLTP;
- OLE DB DESTINATION: Destino dos dados, indo para a tabela st_categorias banco STAGE.
![VSCATG2](https://github.com/LeandroIzzo/SQL-SERVER-com-BI/blob/main/VISUAL%20STUDIO%20PRINT/PASSO%207,2%20-%20FLUXO%20DOS%20DADOS%20CATEGORIAS.png?raw=true)

#### CRIAÇÃO DA CARGA SUBCATEGORIAS:
- SEQUENCE CONTAINER: Será a divisão das cargas (STAGE E DW);
- EXECUTE SQL TASK: Feito o truncate table na tabela st_subcategorias;
- DATA FLOW TASK: Leva a Area do fluxo de dados;
![VSSUB1](https://github.com/LeandroIzzo/SQL-SERVER-com-BI/blob/main/VISUAL%20STUDIO%20PRINT/PASSO%208%20-%20CARGA%20SUB.png?raw=true)

- OLE DB SOURCE: Origem dos dados, vindo da tabela sub_categorias no banco OLTP;
- OLE DB DESTINATION: Destino dos dados, indo para a tabela st_subcategorias banco STAGE.
![VSSUB2](https://github.com/LeandroIzzo/SQL-SERVER-com-BI/blob/main/VISUAL%20STUDIO%20PRINT/PASSO%208,2%20-%20FLUXO%20DOS%20DADOS%20SUB.png?raw=true)




