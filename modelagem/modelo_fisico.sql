
/*
 * MODELO FISICO DO BANCO DE DADOS 'OPERTUR'
 * SCRIPT PARA CRIACAO DAS TABELAS
 *
 * RODRIGO GASPERIN, 2020
 */


-- COMANDOS PARA DROPAR AS TABELAS
----------------------------------------------------------------------------------------------------
DROP TABLE P_PASSEIO
DROP TABLE P_HOTEL
DROP TABLE P_PASSAGEM
DROP TABLE AGENDA
DROP TABLE OFERECE
DROP TABLE PASSEIO
DROP TABLE PASSAGEM
DROP TABLE PROMOCAO
DROP TABLE PACOTE
DROP TABLE GUIA_TURISTICO
DROP TABLE ATENDENTE
DROP TABLE PESSOA_TELEFONE
DROP TABLE PESSOA
DROP TABLE HOTEL
GO

-- DROPAR TODA BASE DE DADOS
DROP DATABASE OPERTUR
GO


-- CRIA BASE DE DADOS 'OPERTUR'
----------------------------------------------------------------------------------------------------
CREATE DATABASE OPERTUR
USE OPERTUR
GO


-- TABELA 'HOTEL'
----------------------------------------------------------------------------------------------------
CREATE TABLE HOTEL (
	Cod INTEGER,
	Preco NUMERIC(7,2),
	Nome VARCHAR(255) NOT NULL,
	Rua VARCHAR(50),
	Logradouro VARCHAR(50),
	CEP VARCHAR(8),
	Complemento VARCHAR(50),

	CONSTRAINT PK_HOTEL PRIMARY KEY(Cod)
)
GO

-- TABELA 'PESSOA'
----------------------------------------------------------------------------------------------------
CREATE TABLE PESSOA (
	CPF VARCHAR(11),
	Nome VARCHAR(255) NOT NULL,
	Data_Nasc DATE NOT NULL,
	Nacionalidade VARCHAR(50),
	RG VARCHAR(9) UNIQUE NOT NULL,
	Logradouro VARCHAR(50),
	Numero INTEGER,
	CEP VARCHAR(8),
	Complemento VARCHAR(50),
	Cod_Hotel INTEGER,

	CONSTRAINT PK_PESSOA PRIMARY KEY(CPF),
	CONSTRAINT FK_PESSOA_HOTEL FOREIGN KEY(Cod_Hotel) REFERENCES HOTEL(Cod)
)
GO

-- TABELA 'PESSOA_TELEFONE'
----------------------------------------------------------------------------------------------------
CREATE TABLE PESSOA_TELEFONE (
	CPF_Pessoa VARCHAR(11),
	Telefone VARCHAR(11),

	CONSTRAINT PK_PESSOA_TELEFONE PRIMARY KEY(CPF_Pessoa, Telefone),
	CONSTRAINT FK_PESSOA_TELEFONE_PESSOA FOREIGN KEY(CPF_Pessoa) REFERENCES PESSOA(CPF)
)
GO

-- TABELA 'ATENDENTE'
----------------------------------------------------------------------------------------------------
CREATE TABLE ATENDENTE (
	CPF_Atendente VARCHAR(11),
	Cod_Empresa SMALLINT NOT NULL,
	Salario NUMERIC(7,2),
	Turno CHAR,

	CONSTRAINT PK_ATENDENTE PRIMARY KEY(CPF_Atendente),
	CONSTRAINT FK_ATENDENTE_PESSOA FOREIGN KEY(CPF_Atendente) REFERENCES PESSOA(CPF)
)
GO

-- TABELA 'GUIA_TURISTICO'
----------------------------------------------------------------------------------------------------
CREATE TABLE GUIA_TURISTICO (
	CPF_Guia VARCHAR(11),
	Cod_Empresa SMALLINT NOT NULL,
	Salario NUMERIC(7,2),
	Registro INTEGER UNIQUE NOT NULL,
	Validade DATETIME NOT NULL,
	CPF_Supervisor VARCHAR(11),

	CONSTRAINT PK_GUIA_TURISTICO PRIMARY KEY(CPF_Guia),
	CONSTRAINT FK_GUIA_TURISTICO_PESSOA FOREIGN KEY(CPF_Guia) REFERENCES PESSOA(CPF),
	CONSTRAINT FK_GUIA_TURISTICO_GUIA_TURISTICO FOREIGN KEY(CPF_Supervisor) REFERENCES GUIA_TURISTICO(CPF_Guia)
)
GO

-- TABELA 'PACOTE'
----------------------------------------------------------------------------------------------------
CREATE TABLE PACOTE (
	Cod INTEGER,
	Preco NUMERIC(7,2),

	CONSTRAINT PK_PACOTE PRIMARY KEY(Cod)
)
GO

-- TABELA 'PROMOCAO'
----------------------------------------------------------------------------------------------------
CREATE TABLE PROMOCAO (
	Cod INTEGER,
	Desconto NUMERIC(3,2) UNIQUE NOT NULL,

	CONSTRAINT PK_PROMOCAO PRIMARY KEY(Cod)
)
GO

-- TABELA 'PASSAGEM'
----------------------------------------------------------------------------------------------------
CREATE TABLE PASSAGEM (
	Cod INTEGER,
	Preco NUMERIC(7,2),
	Companhia VARCHAR(50) NOT NULL,
	Destino VARCHAR(50) NOT NULL,
	Saida DATETIME,
	Chegada DATETIME,
	CPF_Pessoa VARCHAR(11) NOT NULL,
	Data DATETIME,
	Cod_Promocao INTEGER,

	CONSTRAINT PK_PASSAGEM PRIMARY KEY(Cod),
	CONSTRAINT FK_PASSAGEM_PESSOA FOREIGN KEY(CPF_Pessoa) REFERENCES PESSOA(CPF),
	CONSTRAINT FK_PASSAGEM_PROMOCAO FOREIGN KEY(Cod_Promocao) REFERENCES PROMOCAO(Cod)
)
GO

-- TABELA 'PASSEIO'
----------------------------------------------------------------------------------------------------
CREATE TABLE PASSEIO (
	Cod INTEGER,
	Preco NUMERIC(7,2),
	Hora TIME,
	Destino VARCHAR(50) NOT NULL,
	CPF_Guia VARCHAR(11) NOT NULL,

	CONSTRAINT PK_PASSEIO PRIMARY KEY(Cod),
	CONSTRAINT FK_PASSEIO_GUIA_TURISTICO FOREIGN KEY(CPF_Guia) REFERENCES GUIA_TURISTICO(CPF_Guia)
)
GO

-- TABELA 'OFERECE'
----------------------------------------------------------------------------------------------------
CREATE TABLE OFERECE (
	CPF_Pessoa VARCHAR(11),
	Cod_Pacote INTEGER,
	CPF_Atendente VARCHAR(11) NOT NULL,

	CONSTRAINT PK_OFERECE PRIMARY KEY(CPF_Pessoa, Cod_Pacote),
	CONSTRAINT FK_OFERECE_PESSOA FOREIGN KEY(CPF_Pessoa) REFERENCES PESSOA(CPF),
	CONSTRAINT FK_OFERECE_PACOTE FOREIGN KEY(Cod_Pacote) REFERENCES PACOTE(Cod),
	CONSTRAINT FK_OFERECE_ATENDENTE FOREIGN KEY(CPF_Atendente) REFERENCES ATENDENTE(CPF_Atendente)
)
GO

-- TABELA 'AGENDA'
----------------------------------------------------------------------------------------------------
CREATE TABLE AGENDA (
	CPF_Pessoa VARCHAR(11),
	Cod_Passeio INTEGER,

	CONSTRAINT PK_AGENDA PRIMARY KEY(CPF_Pessoa, Cod_Passeio),
	CONSTRAINT FK_AGENDA_PESSOA FOREIGN KEY(CPF_Pessoa) REFERENCES PESSOA(CPF),
	CONSTRAINT FK_AGENDA_PASSEIO FOREIGN KEY(Cod_Passeio) REFERENCES PASSEIO(Cod)
)
GO

-- TABELA 'P_PASSAGEM'
----------------------------------------------------------------------------------------------------
CREATE TABLE P_PASSAGEM (
	Cod_Pacote INTEGER,
	Cod_Passagem INTEGER,

	CONSTRAINT PK_P_PASSAGEM PRIMARY KEY(Cod_Pacote, Cod_Passagem),
	CONSTRAINT FK_P_PASSAGEM_PACOTE FOREIGN KEY(Cod_Pacote) REFERENCES PACOTE(Cod),
	CONSTRAINT FK_P_PASSAGEM_PASSAGEM FOREIGN KEY(Cod_Passagem) REFERENCES PASSAGEM(Cod)
)
GO

-- TABELA 'P_HOTEL'
----------------------------------------------------------------------------------------------------
CREATE TABLE P_HOTEL (
	Cod_Pacote INTEGER,
	Cod_Hotel INTEGER,

	CONSTRAINT PK_P_HOTEL PRIMARY KEY(Cod_Pacote, Cod_Hotel),
	CONSTRAINT FK_P_HOTEL_PACOTE FOREIGN KEY(Cod_Pacote) REFERENCES PACOTE(Cod),
	CONSTRAINT FK_P_HOTEL_HOTEL FOREIGN KEY(Cod_Hotel) REFERENCES HOTEL(Cod)
)
GO

-- TABELA 'P_PASSEIO'
----------------------------------------------------------------------------------------------------
CREATE TABLE P_PASSEIO (
	Cod_Pacote INTEGER,
	Cod_Passeio INTEGER,

	CONSTRAINT PK_P_PASSEIO PRIMARY KEY(Cod_Pacote, Cod_Passeio),
	CONSTRAINT FK_P_PASSEIO_PACOTE FOREIGN KEY(Cod_Pacote) REFERENCES PACOTE(Cod),
	CONSTRAINT FK_P_PASSEIO_PASSEIO FOREIGN KEY(Cod_Passeio) REFERENCES PASSEIO(Cod)
)
GO
