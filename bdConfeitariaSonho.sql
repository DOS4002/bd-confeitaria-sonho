--DRO DATABASE bdConfeitariaSonho;
CREATE DATABASE bdConfeitariaSonho

GO
USE bdConfeitariaSonho

CREATE TABLE tbCliente(
	codCliente INT PRIMARY KEY IDENTITY (1,1) 
	,nomeCliente VARCHAR(40) NOT NULL
	,dataNascimentoCliente DATE NOT NULL
	,cpfCliente VARCHAR(15) NOT NULL
	,ruaCliente VARCHAR (40) NOT NULL
	,numCasaCliente INT NOT NULL
	,cepCliente VARCHAR(10) NOT NULL
	,bairroCliente VARCHAR(40) NOT NULL
	,sexoCliente VARCHAR (8) NOT NULL
)

CREATE TABLE tbCategoriaProduto(
	codCategoriaProduto INT PRIMARY KEY IDENTITY(1,1) NOT NULL
	,nomeCategoriaProduto VARCHAR (30) NOT NULL
)

CREATE TABLE tbProduto(
	codProduto INT PRIMARY KEY IDENTITY(1,1)
	,nomeProduto VARCHAR (40) NOT NULL
	,precoKiloProduto SMALLINT NOT NULL
	,codCategoriaProduto  INT FOREIGN KEY REFERENCES tbCategoriaProduto (codCategoriaProduto)
)

CREATE TABLE tbEncomenda(
	codEncomenda INT PRIMARY KEY IDENTITY (1,1)
	,dataEncomenda DATE NOT NULL
	,codCliente INT FOREIGN KEY REFERENCES tbCliente (codCliente)
	,valorTotalEncomenda SMALLMONEY NOT NULL
	,dataEntregaEncomenda DATE NOT NULL
)

CREATE TABLE tbItensEncomenda(
	codItensEncomenda INT PRIMARY KEY IDENTITY(1,1)
	,codEncomenda INT FOREIGN KEY REFERENCES tbEncomenda (codEncomenda) 
	,codProduto INT FOREIGN KEY REFERENCES tbProduto(codProduto)
	,quantitadeKilos INT NOT NULL
	,subTotal SMALLMONEY NOT NULL
)


