
/*
 * RESPOSTAS DA ATIVIDADE
 *
 * RODRIGO GASPERIN, 2020
 */


 -- USA BASE DE DADOS 'OPERTUR'
----------------------------------------------------------------------------------------------------
USE OPERTUR
GO


-- EXERCICIO #1
----------------------------------------------------------------------------------------------------
SELECT P.Nome, A.Turno FROM PESSOA AS P
INNER JOIN ATENDENTE AS A ON P.CPF = A.CPF_Atendente
GO

-- EXERCICIO #2
----------------------------------------------------------------------------------------------------
SELECT P.Nome, P.Nacionalidade FROM PESSOA AS P
INNER JOIN GUIA_TURISTICO AS G ON P.CPF = G.CPF_Guia
GO

-- EXERCICIO #3
----------------------------------------------------------------------------------------------------
-- Adiciona campo extra na tabela 'PESSOA' (Data_Admissao)
ALTER TABLE PESSOA ADD Data_Admissao DATE
GO

-- Adiciona a data em que os funcionarios (Atendentes e Guias) foram contratados
UPDATE PESSOA SET Data_Admissao = '2013-04-21' WHERE CPF = '00000000001'
UPDATE PESSOA SET Data_Admissao = '2017-05-13' WHERE CPF = '00000000002'
UPDATE PESSOA SET Data_Admissao = '2003-01-08' WHERE CPF = '00000000003'
UPDATE PESSOA SET Data_Admissao = '2019-10-10' WHERE CPF = '00000000004'
UPDATE PESSOA SET Data_Admissao = '2018-03-27' WHERE CPF = '00000000005'
GO

UPDATE PESSOA SET Data_Admissao = '2009-03-12' WHERE CPF = '00000000006'
UPDATE PESSOA SET Data_Admissao = '2007-12-04' WHERE CPF = '00000000007'
UPDATE PESSOA SET Data_Admissao = '2012-04-24' WHERE CPF = '00000000008'
UPDATE PESSOA SET Data_Admissao = '2003-08-23' WHERE CPF = '00000000009'
UPDATE PESSOA SET Data_Admissao = '2014-05-15' WHERE CPF = '00000000010'
UPDATE PESSOA SET Data_Admissao = '2015-01-19' WHERE CPF = '00000000011'
UPDATE PESSOA SET Data_Admissao = '2003-01-08' WHERE CPF = '00000000012'
UPDATE PESSOA SET Data_Admissao = '2016-02-02' WHERE CPF = '00000000013'
UPDATE PESSOA SET Data_Admissao = '2017-07-07' WHERE CPF = '00000000014'
UPDATE PESSOA SET Data_Admissao = '2005-09-29' WHERE CPF = '00000000015'
GO

-- Consulta os dados do guia mais antigo
SELECT G.Salario, P.Nome, P.Data_Admissao FROM PESSOA AS P
INNER JOIN GUIA_TURISTICO AS G ON P.CPF = G.CPF_Guia
WHERE P.Data_Admissao =
	(SELECT MIN(P.Data_Admissao) FROM PESSOA AS P
	INNER JOIN GUIA_TURISTICO AS G ON P.CPF = G.CPF_Guia)
GO

-- EXERCICIO #4
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
