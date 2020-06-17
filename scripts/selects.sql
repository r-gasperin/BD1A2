
/*
 * RESPOSTAS DA ATIVIDADE
 *
 * RODRIGO GASPERIN, 2020
 */


-- USA BASE DE DADOS 'OPERTUR'
----------------------------------------------------------------------------------------------------
USE OPERTUR
GO


-- CRIA TABELAS QUE RELACIONAM PASSAGENS, HOTEIS E PASSEIOS COM DESTINOS
-- Considerando o arquivo 'destinos.txt'...
----------------------------------------------------------------------------------------------------

-- 1 DESTINO - N COMPANHIAS <-> 1 COMPANHIA - N DESTINOS
-- 1 DESTINO - N HOTEIS     <-> 1 HOTEL - 1 DESTINO
-- 1 DESTINO - N PASSEIOS   <-> 1 PASSEIO - 1 DESTINO

-- Tabela 'DESTINO'
CREATE TABLE DESTINO (
	Cod INTEGER,
	Destino VARCHAR(50) UNIQUE NOT NULL,

	CONSTRAINT PK_DESTINO PRIMARY KEY(Cod)
)
GO

INSERT INTO DESTINO VALUES (0, 'Rio de Janeiro')
INSERT INTO DESTINO VALUES (1, 'Fernando de Noronha')
INSERT INTO DESTINO VALUES (2, 'Florianópolis')
INSERT INTO DESTINO VALUES (3, 'Fortaleza')
INSERT INTO DESTINO VALUES (4, 'Salvador')
INSERT INTO DESTINO VALUES (5, 'Natal')
INSERT INTO DESTINO VALUES (6, 'Manaus')
INSERT INTO DESTINO VALUES (7, 'Brasília')
INSERT INTO DESTINO VALUES (8, 'Bogotá')
INSERT INTO DESTINO VALUES (9, 'Santiago')
INSERT INTO DESTINO VALUES (10, 'Montevidéu')
SELECT * FROM DESTINO ORDER BY Cod
GO

-- Atualiza as tabelas 'HOTEL' e 'PASSEIO', para contemplar o 'DESTINO' a qual pertencem...
ALTER TABLE HOTEL ADD Cod_Destino INTEGER
ALTER TABLE HOTEL ADD CONSTRAINT FK_HOTEL_DESTINO FOREIGN KEY(Cod_Destino) REFERENCES DESTINO(Cod)
GO

UPDATE HOTEL SET Cod_Destino = 0 WHERE Cod = 0
UPDATE HOTEL SET Cod_Destino = 0 WHERE Cod = 1
UPDATE HOTEL SET Cod_Destino = 1 WHERE Cod = 2
UPDATE HOTEL SET Cod_Destino = 1 WHERE Cod = 3
UPDATE HOTEL SET Cod_Destino = 2 WHERE Cod = 4
UPDATE HOTEL SET Cod_Destino = 2 WHERE Cod = 5
UPDATE HOTEL SET Cod_Destino = 3 WHERE Cod = 6
UPDATE HOTEL SET Cod_Destino = 3 WHERE Cod = 7
UPDATE HOTEL SET Cod_Destino = 4 WHERE Cod = 8
UPDATE HOTEL SET Cod_Destino = 4 WHERE Cod = 9
UPDATE HOTEL SET Cod_Destino = 5 WHERE Cod = 10
UPDATE HOTEL SET Cod_Destino = 5 WHERE Cod = 11
UPDATE HOTEL SET Cod_Destino = 6 WHERE Cod = 12
UPDATE HOTEL SET Cod_Destino = 6 WHERE Cod = 13
UPDATE HOTEL SET Cod_Destino = 7 WHERE Cod = 14
UPDATE HOTEL SET Cod_Destino = 7 WHERE Cod = 15
UPDATE HOTEL SET Cod_Destino = 8 WHERE Cod = 16
UPDATE HOTEL SET Cod_Destino = 8 WHERE Cod = 17
UPDATE HOTEL SET Cod_Destino = 9 WHERE Cod = 18
UPDATE HOTEL SET Cod_Destino = 9 WHERE Cod = 19
SELECT Cod, Nome, Cod_Destino FROM HOTEL
GO

ALTER TABLE PASSEIO ADD Cod_Destino INTEGER
ALTER TABLE PASSEIO ADD CONSTRAINT FK_PASSEIO_DESTINO FOREIGN KEY(Cod_Destino) REFERENCES DESTINO(Cod)
GO

UPDATE PASSEIO SET Cod_Destino = 0 WHERE Cod = 0
UPDATE PASSEIO SET Cod_Destino = 0 WHERE Cod = 1
UPDATE PASSEIO SET Cod_Destino = 1 WHERE Cod = 2
UPDATE PASSEIO SET Cod_Destino = 1 WHERE Cod = 3
UPDATE PASSEIO SET Cod_Destino = 2 WHERE Cod = 4
UPDATE PASSEIO SET Cod_Destino = 2 WHERE Cod = 5
UPDATE PASSEIO SET Cod_Destino = 3 WHERE Cod = 6
UPDATE PASSEIO SET Cod_Destino = 3 WHERE Cod = 7
UPDATE PASSEIO SET Cod_Destino = 4 WHERE Cod = 8
UPDATE PASSEIO SET Cod_Destino = 4 WHERE Cod = 9
UPDATE PASSEIO SET Cod_Destino = 5 WHERE Cod = 10
UPDATE PASSEIO SET Cod_Destino = 5 WHERE Cod = 11
UPDATE PASSEIO SET Cod_Destino = 6 WHERE Cod = 12
UPDATE PASSEIO SET Cod_Destino = 6 WHERE Cod = 13
UPDATE PASSEIO SET Cod_Destino = 7 WHERE Cod = 14
UPDATE PASSEIO SET Cod_Destino = 7 WHERE Cod = 15
UPDATE PASSEIO SET Cod_Destino = 8 WHERE Cod = 16
UPDATE PASSEIO SET Cod_Destino = 8 WHERE Cod = 17
UPDATE PASSEIO SET Cod_Destino = 9 WHERE Cod = 18
UPDATE PASSEIO SET Cod_Destino = 9 WHERE Cod = 19
SELECT Cod, Destino, Cod_Destino FROM PASSEIO
GO

-- Tabela 'COMPANHIA'
CREATE TABLE COMPANHIA (
	Cod INTEGER,
	Companhia VARCHAR(50) UNIQUE NOT NULL,

	CONSTRAINT PK_COMPANHIA PRIMARY KEY(Cod)
)
GO

INSERT INTO COMPANHIA VALUES (0, 'Companhia 1')
INSERT INTO COMPANHIA VALUES (1, 'Companhia 2')
INSERT INTO COMPANHIA VALUES (2, 'Companhia 3')
SELECT * FROM COMPANHIA
GO

-- Tabela 'DESTINO_COMPANHIA'
CREATE TABLE DESTINO_COMPANHIA (
	Cod_Destino INTEGER,
	Cod_Companhia INTEGER,
	Preco NUMERIC(7,2),

	CONSTRAINT PK_DESTINO_COMPANHIA PRIMARY KEY(Cod_Destino, Cod_Companhia),
	CONSTRAINT FK_DESTINO_COMPANHIA_DESTINO FOREIGN KEY(Cod_Destino) REFERENCES DESTINO(Cod),
	CONSTRAINT FK_DESTINO_COMPANHIA_COMPANHIA FOREIGN KEY(Cod_Companhia) REFERENCES COMPANHIA(Cod)
)
GO

INSERT INTO DESTINO_COMPANHIA VALUES (0, 0, 250.00)
INSERT INTO DESTINO_COMPANHIA VALUES (0, 1, 300.00)
INSERT INTO DESTINO_COMPANHIA VALUES (1, 0, 350.00)
INSERT INTO DESTINO_COMPANHIA VALUES (1, 1, 400.00)
INSERT INTO DESTINO_COMPANHIA VALUES (2, 0, 250.00)
INSERT INTO DESTINO_COMPANHIA VALUES (2, 1, 300.00)
INSERT INTO DESTINO_COMPANHIA VALUES (3, 0, 350.00)
INSERT INTO DESTINO_COMPANHIA VALUES (3, 1, 400.00)
INSERT INTO DESTINO_COMPANHIA VALUES (4, 0, 350.00)
INSERT INTO DESTINO_COMPANHIA VALUES (4, 1, 400.00)
INSERT INTO DESTINO_COMPANHIA VALUES (5, 0, 350.00)
INSERT INTO DESTINO_COMPANHIA VALUES (5, 1, 400.00)
INSERT INTO DESTINO_COMPANHIA VALUES (6, 0, 250.00)
INSERT INTO DESTINO_COMPANHIA VALUES (6, 1, 300.00)
INSERT INTO DESTINO_COMPANHIA VALUES (7, 0, 250.00)
INSERT INTO DESTINO_COMPANHIA VALUES (7, 1, 300.00)
INSERT INTO DESTINO_COMPANHIA VALUES (8, 2, 450.00)
INSERT INTO DESTINO_COMPANHIA VALUES (9, 2, 450.00)
INSERT INTO DESTINO_COMPANHIA VALUES (10, 2, 450.00)
SELECT * FROM DESTINO_COMPANHIA
GO


-- EXERCICIO #1
-- Quais os nomes dos atendentes e respectivos turnos de trabalho?
----------------------------------------------------------------------------------------------------
SELECT P.Nome, A.Turno FROM PESSOA AS P
INNER JOIN ATENDENTE AS A ON P.CPF = A.CPF_Atendente
GO

-- EXERCICIO #2
-- Quais os nomes dos guias e respectivas nacionalidades?
----------------------------------------------------------------------------------------------------
SELECT P.Nome, P.Nacionalidade FROM PESSOA AS P
INNER JOIN GUIA_TURISTICO AS G ON P.CPF = G.CPF_Guia
GO

-- EXERCICIO #3
-- Qual o salário do guia mais antigo? Qual o nome dele e quando começou a trabalhar para a operadora de turismo?
----------------------------------------------------------------------------------------------------
-- Adiciona campo extra na tabela 'PESSOA' (Data_Admissao)
ALTER TABLE PESSOA ADD Data_Admissao DATE
GO

-- Adiciona a data em que os funcionarios (Atendentes e Guias) foram contratados
UPDATE PESSOA SET Data_Admissao = '2013-04-21' WHERE CPF = '00000000001'
UPDATE PESSOA SET Data_Admissao = '2017-05-13' WHERE CPF = '00000000002'
UPDATE PESSOA SET Data_Admissao = '2003-01-08' WHERE CPF = '00000000003'
UPDATE PESSOA SET Data_Admissao = '2019-10-10' WHERE CPF = '00000000004'
UPDATE PESSOA SET Data_Admissao = '2005-09-29' WHERE CPF = '00000000005'
GO

UPDATE PESSOA SET Data_Admissao = '2003-01-08' WHERE CPF = '00000000006'
UPDATE PESSOA SET Data_Admissao = '2019-10-10' WHERE CPF = '00000000007'
UPDATE PESSOA SET Data_Admissao = '2003-08-23' WHERE CPF = '00000000008'
UPDATE PESSOA SET Data_Admissao = '2012-04-24' WHERE CPF = '00000000009'
UPDATE PESSOA SET Data_Admissao = '2014-05-15' WHERE CPF = '00000000010'
UPDATE PESSOA SET Data_Admissao = '2015-01-19' WHERE CPF = '00000000011'
UPDATE PESSOA SET Data_Admissao = '2009-03-12' WHERE CPF = '00000000012'
UPDATE PESSOA SET Data_Admissao = '2016-02-02' WHERE CPF = '00000000013'
UPDATE PESSOA SET Data_Admissao = '2017-07-07' WHERE CPF = '00000000014'
UPDATE PESSOA SET Data_Admissao = '2018-03-27' WHERE CPF = '00000000015'
GO

-- Consulta os dados do guia mais antigo
SELECT G.Salario, P.Nome, P.Data_Admissao FROM PESSOA AS P
INNER JOIN GUIA_TURISTICO AS G ON P.CPF = G.CPF_Guia
WHERE P.Data_Admissao =
	(SELECT MIN(P.Data_Admissao) FROM PESSOA AS P
	INNER JOIN GUIA_TURISTICO AS G ON P.CPF = G.CPF_Guia)
GO

-- EXERCICIO #4
-- Há quantos anos trabalha na operadora de turismo a pessoa que trabalha há mais tempo?
----------------------------------------------------------------------------------------------------
-- Dados dos funcionarios mais antigos da operadora
CREATE VIEW DT_FUNC_MAIS_ANTIGOS
AS
	SELECT Nome, Data_Admissao,
	DATEDIFF(YEAR, (SELECT Data_Admissao FROM PESSOA WHERE CPF = P.CPF), GETDATE()) AS [Anos trabalhados],
	Data_Nasc, DATEDIFF(YEAR, (SELECT Data_Nasc FROM PESSOA WHERE CPF = P.CPF), GETDATE()) AS Idade
	FROM PESSOA AS P
	WHERE Data_Admissao = (SELECT MIN(Data_Admissao) FROM PESSOA)
GO

-- Exibe todos os funcionarios
SELECT * FROM DT_FUNC_MAIS_ANTIGOS
GO

-- Filtra os dados do funcionario de maior idade (criterio de desempate)
SELECT * FROM DT_FUNC_MAIS_ANTIGOS
WHERE Data_Nasc = (SELECT MIN(Data_Nasc) FROM DT_FUNC_MAIS_ANTIGOS)
GO

-- EXERCICIO #5
-- Há quantos anos trabalha na operadora de turismo a pessoa que trabalha há menos tempo?
----------------------------------------------------------------------------------------------------
-- Dados dos funcionarios mais recentes da operadora
CREATE VIEW DT_FUNC_MAIS_RECENTES
AS
	SELECT Nome, Data_Admissao,
	DATEDIFF(YEAR, (SELECT Data_Admissao FROM PESSOA WHERE CPF = P.CPF), GETDATE()) AS [Anos trabalhados],
	Data_Nasc, DATEDIFF(YEAR, (SELECT Data_Nasc FROM PESSOA WHERE CPF = P.CPF), GETDATE()) AS Idade
	FROM PESSOA AS P
	WHERE Data_Admissao = (SELECT MAX(Data_Admissao) FROM PESSOA)
GO

-- Exibe todos os funcionarios
SELECT * FROM DT_FUNC_MAIS_RECENTES
GO

-- Filtra os dados do funcionario de menor idade (criterio de desempate)
SELECT * FROM DT_FUNC_MAIS_RECENTES
WHERE Data_Nasc = (SELECT MAX(Data_Nasc) FROM DT_FUNC_MAIS_RECENTES)
GO

-- EXERCICIO #6
-- Quantos pessoas trabalham na operadora de turismo?
----------------------------------------------------------------------------------------------------
SELECT (
	(SELECT COUNT(*) FROM PESSOA AS P
	INNER JOIN ATENDENTE AS A ON P.CPF = A.CPF_Atendente)
	+
	(SELECT COUNT(*) FROM PESSOA AS P
	INNER JOIN GUIA_TURISTICO AS G ON P.CPF = G.CPF_Guia)
) AS [Total de funcionarios]
GO

-- EXERCICIO #7
-- Quais passagens estão disponíveis para o destino escolhido, e seu preço?
----------------------------------------------------------------------------------------------------
SELECT C.Companhia, DC.Preco FROM DESTINO AS D
INNER JOIN DESTINO_COMPANHIA AS DC ON D.Cod = DC.Cod_Destino
INNER JOIN COMPANHIA AS C ON DC.Cod_Companhia = C.Cod
WHERE D.Destino = 'Rio de Janeiro' -- Destino aqui...
GO

-- EXERCICIO #8
-- Quais hotéis estão disponíveis para o destino escolhido, e seu preço?
----------------------------------------------------------------------------------------------------
SELECT H.Cod, H.Nome, H.Rua, H.CEP, H.Preco FROM HOTEL AS H
INNER JOIN DESTINO AS D ON H.Cod_Destino = D.Cod
WHERE D.Destino = 'Fernando de Noronha' -- Destino aqui...
GO

-- EXERCICIO #9
-- Quais passeios estão disponíveis para o destino escolhido, e seu preço?
----------------------------------------------------------------------------------------------------
SELECT PA.Cod, PA.Destino, PA.Hora, PE.Nome as [Nome Guia], PA.Preco FROM PASSEIO AS PA
INNER JOIN DESTINO AS D ON PA.Cod_Destino = D.Cod
INNER JOIN PESSOA AS PE ON PA.CPF_Guia = PE.CPF
WHERE D.Destino = 'Florianópolis' -- Destino aqui...
GO

-- EXERCICIO #10
-- Quais os 10 destinos mais visitados?
----------------------------------------------------------------------------------------------------
SELECT PA.Destino, COUNT(*) AS [Num. de visitas] FROM PACOTE AS PC
INNER JOIN P_PASSAGEM AS PP ON PC.Cod = PP.Cod_Pacote
INNER JOIN PASSAGEM AS PA ON PP.Cod_Passagem = PA.Cod
GROUP BY PA.Destino
ORDER BY [Num. de visitas] DESC
OFFSET 0 ROWS FETCH FIRST 10 ROWS ONLY
GO

-- EXERCICIO #11
-- Quais passagens estão disponíveis para um destino escolhido ordenado de menor para maior preço?
----------------------------------------------------------------------------------------------------
SELECT C.Companhia, DC.Preco FROM DESTINO AS D
INNER JOIN DESTINO_COMPANHIA AS DC ON D.Cod = DC.Cod_Destino
INNER JOIN COMPANHIA AS C ON DC.Cod_Companhia = C.Cod
WHERE D.Destino = 'Fortaleza' -- Destino aqui...
ORDER BY DC.Preco ASC
GO

-- EXERCICIO #12
-- Quais hotéis estão disponíveis para um destino escolhido ordenado de menor para maior preço?
----------------------------------------------------------------------------------------------------
SELECT H.Cod, H.Nome, H.Rua, H.CEP, H.Preco FROM HOTEL AS H
INNER JOIN DESTINO AS D ON H.Cod_Destino = D.Cod
WHERE D.Destino = 'Salvador' -- Destino aqui...
ORDER BY H.Preco ASC
GO

-- EXERCICIO #13
-- Quais passeios estão disponíveis para um destino escolhido ordenado de menor para maior preço?
----------------------------------------------------------------------------------------------------
SELECT PA.Cod, PA.Destino, PA.Hora, PE.Nome as [Nome Guia], PA.Preco FROM PASSEIO AS PA
INNER JOIN DESTINO AS D ON PA.Cod_Destino = D.Cod
INNER JOIN PESSOA AS PE ON PA.CPF_Guia = PE.CPF
WHERE D.Destino = 'Natal' -- Destino aqui...
ORDER BY PA.Preco ASC
GO

-- EXERCICIO #14
-- Quais passagens estão disponíveis para um destino escolhido ordenado de maior para menor preço?
----------------------------------------------------------------------------------------------------
SELECT C.Companhia, DC.Preco FROM DESTINO AS D
INNER JOIN DESTINO_COMPANHIA AS DC ON D.Cod = DC.Cod_Destino
INNER JOIN COMPANHIA AS C ON DC.Cod_Companhia = C.Cod
WHERE D.Destino = 'Manaus' -- Destino aqui...
ORDER BY DC.Preco DESC
GO

-- EXERCICIO #15
-- Quais hotéis estão disponíveis para um destino escolhido ordenado de maior para menor preço?
----------------------------------------------------------------------------------------------------
SELECT H.Cod, H.Nome, H.Rua, H.CEP, H.Preco FROM HOTEL AS H
INNER JOIN DESTINO AS D ON H.Cod_Destino = D.Cod
WHERE D.Destino = 'Brasília' -- Destino aqui...
ORDER BY H.Preco DESC
GO

-- EXERCICIO #16
-- Quais passeios estão disponíveis para um destino escolhido ordenado de maior para menor preço?
----------------------------------------------------------------------------------------------------
SELECT PA.Cod, PA.Destino, PA.Hora, PE.Nome as [Nome Guia], PA.Preco FROM PASSEIO AS PA
INNER JOIN DESTINO AS D ON PA.Cod_Destino = D.Cod
INNER JOIN PESSOA AS PE ON PA.CPF_Guia = PE.CPF
WHERE D.Destino = 'Bogotá' -- Destino aqui...
ORDER BY PA.Preco DESC
GO
