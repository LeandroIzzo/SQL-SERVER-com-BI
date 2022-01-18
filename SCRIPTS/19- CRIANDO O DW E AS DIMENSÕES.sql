CREATE DATABASE LOJA_DW
GO

USE LOJA_DW
GO

CREATE TABLE DIM_FUNCIONARIOS(
	IDSK INT IDENTITY,
	IDFUNCIONARIO INT,
	FUNCIONARIO VARCHAR(50),
	SEXO VARCHAR(6),
	CARGO VARCHAR(40),
	INICIO DATETIME,
	FIM DATETIME,
	CONSTRAINT SK_FUNCIONARIO PRIMARY KEY(IDSK) 
)
GO

CREATE TABLE DIM_PRODUTOS(
	IDSK INT IDENTITY,
	IDPRODUTO INT,
	PRODUTO VARCHAR(100),
	VALOR_UNIT NUMERIC(10,2),
	CUSTO_MEDIO NUMERIC(10,2),
	INICIO DATETIME,
	FIM DATETIME,
	CONSTRAINT SK_PRODUTOS PRIMARY KEY(IDSK) 
)
GO

CREATE TABLE DIM_CATEGORIAS(
	IDSK INT IDENTITY,
	IDCATEGORIA INT,
	CATEGORIA VARCHAR(40),
	CONSTRAINT SK_CATEGORIAS PRIMARY KEY (IDSK)
)
GO

CREATE TABLE DIM_FORNECEDORES(
	IDSK INT IDENTITY,
	IDFORNECEDOR INT,
	FORNECEDOR VARCHAR(30),
	INICIO DATETIME,
	FIM DATETIME,
	CONSTRAINT SK_FORNECEDORES PRIMARY KEY(IDSK)
)
GO

CREATE TABLE DIM_METODOS(
	IDSK INT IDENTITY,
	IDMETODO INT,
	FORMA_PAGAMENTO VARCHAR(45),
	CONSTRAINT SK_METODOS PRIMARY KEY(IDSK)
)
GO

CREATE TABLE DIM_NOTAS(
	IDSK INT IDENTITY,
	IDNOTA INT,
	CONSTRAINT SK_NOTAS PRIMARY KEY(IDSK)
)
GO

CREATE TABLE DIM_CLIENTES(
	IDSK INT IDENTITY,
	IDCLIENTE INT,
	NOME_COMPLETO VARCHAR(80),
	SEXO VARCHAR(6),
	NASCIMENTO DATE,
	CIDADE VARCHAR(20),
	UF VARCHAR(6),
	EMAIL VARCHAR(100),
	INICIO DATETIME,
	FIM DATETIME,
	CONSTRAINT SK_CLIENTES PRIMARY KEY (IDSK)
)
GO

CREATE TABLE DIM_TEMPO(
	IDSK INT IDENTITY,
	DATA DATE,
	DIA CHAR(2),
	DIA_SEMANA VARCHAR(10),
	MES CHAR(2),
	NOME_MES VARCHAR(20),
	QUARTO TINYINT,
	NOME_QUARTO VARCHAR(20),
	ANO CHAR(4),
	ESTACAO_ANO VARCHAR(20),
	FIM_SEMANA CHAR(1),
	DATA_COMPLETA VARCHAR(10),
	CONSTRAINT SK_TEMPO PRIMARY KEY (IDSK)
)
GO

CREATE TABLE DIM_MARCAS(
	IDSK INT IDENTITY,
	IDMARCA INT,
	MARCA VARCHAR(30),
	CONSTRAINT SK_MARCAS PRIMARY KEY (IDSK)
)
GO

CREATE TABLE DIM_SUBCATEGORIAS(
	IDSK INT IDENTITY,
	IDSUB INT,
	SUB_CATEGORIA VARCHAR(35),
	CONSTRAINT SK_SUB PRIMARY KEY (IDSK)
)
GO

CREATE TABLE FATO(
	ID_NOTA INT,
	ID_CLIENTE INT,
	ID_MARCA INT,
	ID_FUNCIONARIO INT,
	ID_METODO INT,
	ID_PRODUTO INT,
	ID_FORNECEDOR INT,
	ID_CATEGORIA INT,
	ID_SUB INT,
	ID_TEMPO INT,
	QUANTIDADE INT,
	TOTAL_ITEM DECIMAL (10,2),
	CUSTO_TOTAL DECIMAL (10,2),
	LUCRO_TOTAL DECIMAL (10,2)
)
GO