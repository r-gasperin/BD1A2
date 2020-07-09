
/*
 * TESTES COM OS DIVERSOS TIPOS DE JOIN
 * ESTE SCRIPT NAO FAZ PARTE DA ATIVIDADE
 *
 * RODRIGO GASPERIN, 2020
 */


-- USA BASE DE DADOS 'OPERTUR'
----------------------------------------------------------------------------------------------------
USE OPERTUR
GO

-- SELECIONA AS TABELAS PESSOA E HOTEL, UTILIZADAS NOS TESTES
----------------------------------------------------------------------------------------------------
SELECT * FROM PESSOA
SELECT * FROM HOTEL
GO


-- (INNER) JOIN - PESSOAS QUE RESERVARAM HOTEL
----------------------------------------------------------------------------------------------------
SELECT P.Nome, H.Nome FROM
PESSOA P JOIN HOTEL H
ON P.Cod_Hotel = H.Cod
GO

-- ALTERNATIVA
SELECT P.Nome, H.Nome FROM
PESSOA P LEFT JOIN HOTEL H
ON P.Cod_Hotel = H.Cod
INTERSECT
SELECT P.Nome, H.Nome FROM
PESSOA P RIGHT JOIN HOTEL H
ON P.Cod_Hotel = H.Cod
GO

-- LEFT (OUTER) JOIN - PESSOAS QUE RESERVARAM HOTEL + PESSOAS QUE NAO RESERVARAM HOTEL
----------------------------------------------------------------------------------------------------
SELECT P.Nome, H.Nome FROM
PESSOA P LEFT JOIN HOTEL H
ON P.Cod_Hotel = H.Cod
GO

-- RIGHT (OUTER) JOIN - HOTEIS QUE FORAM RESERVADOS POR PESSOAS + HOTEIS QUE NAO FORAM RESERVADOS POR PESSOAS
----------------------------------------------------------------------------------------------------
SELECT P.Nome, H.Nome FROM
PESSOA P RIGHT JOIN HOTEL H
ON P.Cod_Hotel = H.Cod
GO

-- FULL (OUTER) JOIN - (PESSOAS QUE RESERVARAM HOTEL + PESSOAS QUE NAO RESERVARAM HOTEL) +
--                     (HOTEIS QUE FORAM RESERVADOS POR PESSOAS + HOTEIS QUE NAO FORAM RESERVADOS POR PESSOAS)
----------------------------------------------------------------------------------------------------
SELECT P.Nome, H.Nome FROM
PESSOA P FULL JOIN HOTEL H
ON P.Cod_Hotel = H.Cod
GO

-- ALTERNATIVA
SELECT P.Nome, H.Nome FROM
PESSOA P LEFT JOIN HOTEL H
ON P.Cod_Hotel = H.Cod
UNION
SELECT P.Nome, H.Nome FROM
PESSOA P RIGHT JOIN HOTEL H
ON P.Cod_Hotel = H.Cod
GO

-- LEFT EXCLUDING JOIN - PESSOAS QUE NAO RESERVARAM HOTEL
----------------------------------------------------------------------------------------------------
SELECT P.Nome, H.Nome FROM
PESSOA P LEFT JOIN HOTEL H
ON P.Cod_Hotel = H.Cod
WHERE H.Cod IS NULL
GO

-- ALTERNATIVA
SELECT P.Nome, H.Nome FROM
PESSOA P LEFT JOIN HOTEL H
ON P.Cod_Hotel = H.Cod
EXCEPT
SELECT P.Nome, H.Nome FROM
PESSOA P JOIN HOTEL H
ON P.Cod_Hotel = H.Cod
GO

-- RIGHT EXCLUDING JOIN - HOTEIS QUE NAO FORAM RESERVADOS POR PESSOAS
----------------------------------------------------------------------------------------------------
SELECT P.Nome, H.Nome FROM
PESSOA P RIGHT JOIN HOTEL H
ON P.Cod_Hotel = H.Cod
WHERE P.Cod_Hotel IS NULL
GO

-- ALTERNATIVA
SELECT P.Nome, H.Nome FROM
PESSOA P RIGHT JOIN HOTEL H
ON P.Cod_Hotel = H.Cod
EXCEPT
SELECT P.Nome, H.Nome FROM
PESSOA P JOIN HOTEL H
ON P.Cod_Hotel = H.Cod
GO

-- OUTER EXCLUDING JOIN - PESSOAS QUE NAO RESERVARAM HOTEL + HOTEIS QUE NAO FORAM RESERVADOS POR PESSOAS
----------------------------------------------------------------------------------------------------
SELECT P.Nome, H.Nome FROM
PESSOA P FULL JOIN HOTEL H
ON P.Cod_Hotel = H.Cod
WHERE P.Cod_Hotel IS NULL OR H.Cod IS NULL
GO

-- ALTERNATIVA
SELECT P.Nome, H.Nome FROM
PESSOA P FULL JOIN HOTEL H
ON P.Cod_Hotel = H.Cod
EXCEPT
SELECT P.Nome, H.Nome FROM
PESSOA P JOIN HOTEL H
ON P.Cod_Hotel = H.Cod
GO

-- CROSS JOIN - PRODUTO CARTESIANO ENTRE PESSOAS E HOTEIS
----------------------------------------------------------------------------------------------------
SELECT P.Nome, H.Nome FROM
PESSOA P CROSS JOIN HOTEL H
GO

-- ALTERNATIVA
SELECT DISTINCT P.Nome, H.Nome FROM
PESSOA P, HOTEL H
GO

-- TOTAL DE COMBINACOES
SELECT COUNT(*) AS [# Combinacoes] FROM
PESSOA CROSS JOIN HOTEL
-- |PESSOA X HOTEL| = |PESSOA| * |HOTEL| = 25 * 20 = 500 (P.F.C.)
GO
