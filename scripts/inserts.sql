
/*
 * SCRIPT PARA POPULAR AS TABELAS
 *
 * RODRIGO GASPERIN, 2020
 */


-- USA BASE DE DADOS 'OPERTUR'
----------------------------------------------------------------------------------------------------
USE OPERTUR
GO


-- CRIA OPERACOES UTEIS...
----------------------------------------------------------------------------------------------------

-- ATUALIZA PRECO DA PASSAGEM, SEMPRE QUE ESTA FOR INSERIDA COM UMA PROMOCAO
----------------------------------------------------------------------------------------------------
CREATE TRIGGER Ins_Promocao_Passagem
ON PASSAGEM
FOR INSERT
AS BEGIN

	DECLARE @Cod_Passagem INT, @Cod_Promocao INT
	SELECT @Cod_Passagem = Cod FROM INSERTED
	SELECT @Cod_Promocao = Cod_Promocao FROM INSERTED

	DECLARE @Preco_Antes NUMERIC(7,2)
	SELECT @Preco_Antes = Preco FROM INSERTED

	IF (@Cod_Promocao IS NULL)
	BEGIN
		PRINT 'Nenhum desconto aplicado. Preço: ' + CAST((@Preco_Antes) AS VARCHAR(10))
	END
	ELSE
	BEGIN
		DECLARE @Perc_Desconto NUMERIC(3,2)
		SELECT @Perc_Desconto = Desconto FROM PROMOCAO WHERE Cod = @Cod_Promocao

		DECLARE @Preco_Depois NUMERIC(7,2)
		SET @Preco_Depois = @Preco_Antes * (1 - @Perc_Desconto)

		UPDATE PASSAGEM SET Preco = @Preco_Depois WHERE Cod = @Cod_Passagem
		PRINT 'Desconto aplicado. Novo preço: ' + CAST((@Preco_Depois) AS VARCHAR(10))
	END

END
GO

-- ATUALIZA PRECO DA PASSAGEM, SEMPRE QUE ESTA TIVER UMA PROMOCAO ADICIONADA/ALTERADA/REMOVIDA
----------------------------------------------------------------------------------------------------
CREATE TRIGGER Upd_Promocao_Passagem
ON PASSAGEM
FOR UPDATE
AS BEGIN

	DECLARE @Cod_Passagem INT, @Cod_Promocao_Antes INT, @Cod_Promocao_Depois INT
	SELECT @Cod_Passagem = Cod FROM INSERTED
	SELECT @Cod_Promocao_Antes = Cod_Promocao FROM DELETED
	SELECT @Cod_Promocao_Depois = Cod_Promocao FROM INSERTED

	IF (@Cod_Promocao_Antes = @Cod_Promocao_Depois)
	BEGIN
		PRINT 'Campo Cod_Promocao não foi alterado.'
	END
	ELSE
	BEGIN
		DECLARE @Perc_Desconto NUMERIC(3,2) -- ARMAZENA OS PERCENTUAIS DE DESCONTO...

		/* PRECO ANTES DO UPDATE (COM OU SEM DESCONTO) */
		/**************************************************/
		DECLARE @Preco_Antes NUMERIC(7,2)
		SELECT @Preco_Antes = Preco FROM DELETED
		/**************************************************/

		/* PRECO NORMAL DA PASSAGEM (SEM DESCONTOS) */
		/**************************************************/
		DECLARE @Preco NUMERIC(7,2)

		IF (@Cod_Promocao_Antes IS NULL)
		BEGIN
			SET @Preco = @Preco_Antes -- PRECO NAO TINHA DESCONTO
			PRINT 'Preço anterior não tinha desconto.'
		END
		ELSE
		BEGIN
			SELECT @Perc_Desconto = Desconto FROM PROMOCAO WHERE Cod = @Cod_Promocao_Antes
			SET @Preco = @Preco_Antes / (1 - @Perc_Desconto) -- REMOVE DESCONTO
		END
		/**************************************************/

		/* CALCULA NOVO PRECO (COM OU SEM DESCONTO) */
		/**************************************************/
		DECLARE @Preco_Depois NUMERIC(7,2)

		IF (@Cod_Promocao_Depois IS NULL)
		BEGIN
			SET @Preco_Depois = @Preco -- NOVO PRECO NAO TEM DESCONTO
			PRINT 'Desconto removido.'
		END
		ELSE
		BEGIN
			SELECT @Perc_Desconto = Desconto FROM PROMOCAO WHERE Cod = @Cod_Promocao_Depois
			SET @Preco_Depois = @Preco * (1 - @Perc_Desconto) -- APLICA DESCONTO
			PRINT 'Desconto aplicado.'
		END
		/**************************************************/

		/* APLICA NOVO PRECO */
		/**************************************************/
		UPDATE PASSAGEM SET Preco = @Preco_Depois WHERE Cod = @Cod_Passagem
		PRINT 'Novo preço: ' + CAST((@Preco_Depois) AS VARCHAR(10))
		/**************************************************/
	END

END
GO

-- CALCULA PRECO DO PACOTE COM BASE NOS ITENS - PASSAGENS, HOTEIS E/OU PASSEIOS - QUE O COMPOEM
----------------------------------------------------------------------------------------------------
CREATE FUNCTION Preco_Pacote(@Cod INT)
RETURNS NUMERIC(8,2)
AS BEGIN

	DECLARE @Preco NUMERIC(8,2)
	
	SET @Preco = (SELECT
		COALESCE((SELECT SUM(P.Preco) AS Total_Passagens FROM PASSAGEM AS P
			INNER JOIN P_PASSAGEM AS PP ON P.Cod = PP.Cod_Passagem
			INNER JOIN PACOTE AS PC ON PP.Cod_Pacote = PC.Cod
			WHERE PC.Cod = @Cod), 0) +

		COALESCE((SELECT SUM(H.Preco) AS Total_Hoteis FROM HOTEL AS H
			INNER JOIN P_HOTEL AS PH ON H.Cod = PH.Cod_Hotel
			INNER JOIN PACOTE AS PC ON PH.Cod_Pacote = PC.Cod
			WHERE PC.Cod = @Cod), 0) +

		COALESCE((SELECT SUM(P.Preco) AS Total_Passeios FROM PASSEIO AS P
			INNER JOIN P_PASSEIO AS PP ON P.Cod = PP.Cod_Passeio
			INNER JOIN PACOTE AS PC ON PP.Cod_Pacote = PC.Cod
			WHERE PC.Cod = @Cod), 0)
	AS Total_Pacote)

	RETURN @Preco

END
GO


-- POPULA TABELA 'HOTEL'
----------------------------------------------------------------------------------------------------
INSERT INTO HOTEL (Cod, Preco, Nome, Rua, CEP) VALUES (0, 299.90, 'Hotel 1', 'Rua das Castanhas', '00000001')
INSERT INTO HOTEL (Cod, Preco, Nome, Rua, CEP) VALUES (1, 599.90, 'Hotel 2', 'Rua das Maçãs', '00000002')
INSERT INTO HOTEL (Cod, Preco, Nome, Rua, CEP) VALUES (2, 299.90, 'Hotel 3', 'Rua da Cachoeira', '00000003')
INSERT INTO HOTEL (Cod, Preco, Nome, Rua, CEP) VALUES (3, 599.90, 'Hotel 4', 'Rua das Peras', '00000004')
INSERT INTO HOTEL (Cod, Preco, Nome, Rua, CEP) VALUES (4, 299.90, 'Hotel 5', 'Rua da Lagoa', '00000005')
INSERT INTO HOTEL (Cod, Preco, Nome, Rua, CEP) VALUES (5, 599.90, 'Hotel 6', 'Rua das Limas', '00000006')
INSERT INTO HOTEL (Cod, Preco, Nome, Rua, CEP) VALUES (6, 299.90, 'Hotel 7', 'Rua das Laranjas', '00000007')
INSERT INTO HOTEL (Cod, Preco, Nome, Rua, CEP) VALUES (7, 599.90, 'Hotel 8', 'Rua do Rio', '00000008')
INSERT INTO HOTEL (Cod, Preco, Nome, Rua, CEP) VALUES (8, 299.90, 'Hotel 9', 'Rua do Canyon', '00000009')
INSERT INTO HOTEL (Cod, Preco, Nome, Rua, CEP) VALUES (9, 599.90, 'Hotel 10', 'Rua dos Limões', '00000010')
INSERT INTO HOTEL (Cod, Preco, Nome, Rua, CEP) VALUES (10, 299.90, 'Hotel 11', 'Rua do Cajú', '00000011')
INSERT INTO HOTEL (Cod, Preco, Nome, Rua, CEP) VALUES (11, 599.90, 'Hotel 12', 'Rua do Penhasco', '00000012')
INSERT INTO HOTEL (Cod, Preco, Nome, Rua, CEP) VALUES (12, 299.90, 'Hotel 13', 'Rua das Olivas', '00000013')
INSERT INTO HOTEL (Cod, Preco, Nome, Rua, CEP) VALUES (13, 599.90, 'Hotel 14', 'Rua 14 de maio', '00000014')
INSERT INTO HOTEL (Cod, Preco, Nome, Rua, CEP) VALUES (14, 299.90, 'Hotel 15', 'Rua 27 de novembro', '00000015')
INSERT INTO HOTEL (Cod, Preco, Nome, Rua, CEP) VALUES (15, 599.90, 'Hotel 16', 'Rua das Uvas', '00000016')
INSERT INTO HOTEL (Cod, Preco, Nome, Rua, CEP) VALUES (16, 299.90, 'Hotel 17', 'Rua das Melancias', '00000017')
INSERT INTO HOTEL (Cod, Preco, Nome, Rua, CEP) VALUES (17, 599.90, 'Hotel 18', 'Rua da Colina', '00000018')
INSERT INTO HOTEL (Cod, Preco, Nome, Rua, CEP) VALUES (18, 299.90, 'Hotel 19', 'Rua do Mar', '00000019')
INSERT INTO HOTEL (Cod, Preco, Nome, Rua, CEP) VALUES (19, 599.90, 'Hotel 20', 'Rua dos Tomates', '00000020')
SELECT * FROM HOTEL
GO

-- POPULA TABELA 'PESSOA'
----------------------------------------------------------------------------------------------------
INSERT INTO PESSOA (CPF, Nome, Data_Nasc, Nacionalidade, RG, Logradouro, Numero, CEP) VALUES ('00000000001', 'Maria A.', '1978-01-01', 'Brasil', '000000001', 'Rua Primeiro de Janeiro', 10, '00000021')
INSERT INTO PESSOA (CPF, Nome, Data_Nasc, Nacionalidade, RG, Logradouro, Numero, CEP) VALUES ('00000000002', 'José B.', '1979-02-02', 'Brasil', '000000002', 'Rua Dois de Fevereiro', 20, '00000022')
INSERT INTO PESSOA (CPF, Nome, Data_Nasc, Nacionalidade, RG, Logradouro, Numero, CEP) VALUES ('00000000003', 'Ana C.', '1980-03-03', 'Brasil', '000000003', 'Rua Três de Março', 30, '00000023')
INSERT INTO PESSOA (CPF, Nome, Data_Nasc, Nacionalidade, RG, Logradouro, Numero, CEP) VALUES ('00000000004', 'João D.', '1981-04-04', 'Brasil', '000000004', 'Rua Quatro de Abril', 40, '00000024')
INSERT INTO PESSOA (CPF, Nome, Data_Nasc, Nacionalidade, RG, Logradouro, Numero, CEP) VALUES ('00000000005', 'Francisca E.', '1982-05-05', 'Brasil', '000000005', 'Rua Cinco de Maio', 50, '00000025')
INSERT INTO PESSOA (CPF, Nome, Data_Nasc, Nacionalidade, RG, Logradouro, Numero, CEP) VALUES ('00000000006', 'Antônio F.', '1983-06-06', 'Brasil', '000000006', 'Rua Seis de Junho', 60, '00000026')
INSERT INTO PESSOA (CPF, Nome, Data_Nasc, Nacionalidade, RG, Logradouro, Numero, CEP) VALUES ('00000000007', 'Antônia G.', '1984-07-07', 'Brasil', '000000007', 'Rua Sete de Julho', 70, '00000027')
INSERT INTO PESSOA (CPF, Nome, Data_Nasc, Nacionalidade, RG, Logradouro, Numero, CEP) VALUES ('00000000008', 'Francisco H.', '1985-08-08', 'Brasil', '000000008', 'Rua Oito de Agosto', 80, '00000028')
INSERT INTO PESSOA (CPF, Nome, Data_Nasc, Nacionalidade, RG, Logradouro, Numero, CEP) VALUES ('00000000009', 'Adriana I.', '1986-09-09', 'Brasil', '000000009', 'Rua Nove de Setembro', 90, '00000029')
INSERT INTO PESSOA (CPF, Nome, Data_Nasc, Nacionalidade, RG, Logradouro, Numero, CEP) VALUES ('00000000010', 'Carlos J.', '1987-10-10', 'Brasil', '000000010', 'Rua Dez de Outubro', 1010, '00000030')
INSERT INTO PESSOA (CPF, Nome, Data_Nasc, Nacionalidade, RG, Logradouro, Numero, CEP) VALUES ('00000000011', 'Juliana K.', '1988-11-11', 'Brasil', '000000011', 'Rua 11 de Novembro', 1020, '00000031')
INSERT INTO PESSOA (CPF, Nome, Data_Nasc, Nacionalidade, RG, Logradouro, Numero, CEP) VALUES ('00000000012', 'Paulo L.', '1989-12-12', 'Brasil', '000000012', 'Rua 12 de Dezembro', 1030, '00000032')
INSERT INTO PESSOA (CPF, Nome, Data_Nasc, Nacionalidade, RG, Logradouro, Numero, CEP) VALUES ('00000000013', 'Márcia M.', '1990-01-13', 'Brasil', '000000013', 'Rua 13 de Janeiro', 1040, '00000033')
INSERT INTO PESSOA (CPF, Nome, Data_Nasc, Nacionalidade, RG, Logradouro, Numero, CEP) VALUES ('00000000014', 'Pedro N.', '1991-02-14', 'Brasil', '000000014', 'Rua 14 de Fevereiro', 1050, '00000034')
INSERT INTO PESSOA (CPF, Nome, Data_Nasc, Nacionalidade, RG, Logradouro, Numero, CEP) VALUES ('00000000015', 'Fernanda O.', '1992-03-15', 'Brasil', '000000015', 'Rua 15 de Março', 1060, '00000035')
INSERT INTO PESSOA (CPF, Nome, Data_Nasc, Nacionalidade, RG, Logradouro, Numero, CEP) VALUES ('00000000016', 'Lucas P.', '1993-04-16', 'Brasil', '000000016', 'Rua 16 de Abril', 1070, '00000036')
INSERT INTO PESSOA (CPF, Nome, Data_Nasc, Nacionalidade, RG, Logradouro, Numero, CEP) VALUES ('00000000017', 'Patrícia Q.', '1994-05-17', 'Brasil', '000000017', 'Rua 17 de Maio', 1080, '00000037')
INSERT INTO PESSOA (CPF, Nome, Data_Nasc, Nacionalidade, RG, Logradouro, Numero, CEP) VALUES ('00000000018', 'Luiz R.', '1995-06-18', 'Brasil', '000000018', 'Rua 18 de Junho', 1090, '00000038')
INSERT INTO PESSOA (CPF, Nome, Data_Nasc, Nacionalidade, RG, Logradouro, Numero, CEP) VALUES ('00000000019', 'Aline S.', '1996-07-19', 'Brasil', '000000019', 'Rua 19 de Julho', 2010, '00000039')
INSERT INTO PESSOA (CPF, Nome, Data_Nasc, Nacionalidade, RG, Logradouro, Numero, CEP) VALUES ('00000000020', 'Marcos T.', '1997-08-20', 'Brasil', '000000020', 'Rua 20 de Agosto', 2020, '00000040')
INSERT INTO PESSOA (CPF, Nome, Data_Nasc, Nacionalidade, RG, Logradouro, Numero, CEP) VALUES ('00000000021', 'Sandra U.', '1998-09-21', 'Argentina', '000000021', 'Rua 21 de Setembro', 2030, '00000041')
INSERT INTO PESSOA (CPF, Nome, Data_Nasc, Nacionalidade, RG, Logradouro, Numero, CEP) VALUES ('00000000022', 'Luís V.', '1999-10-22', 'Argentina', '000000022', 'Rua 22 de Outubro', 2040, '00000042')
INSERT INTO PESSOA (CPF, Nome, Data_Nasc, Nacionalidade, RG, Logradouro, Numero, CEP) VALUES ('00000000023', 'Camila X.', '2000-11-23', 'Colômbia', '000000023', 'Rua 23 de Novembro', 2050, '00000043')
INSERT INTO PESSOA (CPF, Nome, Data_Nasc, Nacionalidade, RG, Logradouro, Numero, CEP) VALUES ('00000000024', 'Gabriel Y.', '2001-12-24', 'Chile', '000000024', 'Rua 24 de Dezembro', 2060, '00000044')
INSERT INTO PESSOA (CPF, Nome, Data_Nasc, Nacionalidade, RG, Logradouro, Numero, CEP) VALUES ('00000000025', 'Amanda Z.', '2002-01-25', 'Uruguai', '000000025', 'Rua 25 de Janeiro', 2070, '00000045')
SELECT * FROM PESSOA
GO

-- POPULA TABELA 'PESSOA_TELEFONE'
----------------------------------------------------------------------------------------------------
INSERT INTO PESSOA_TELEFONE VALUES ('00000000001', '55000000001')
INSERT INTO PESSOA_TELEFONE VALUES ('00000000002', '55000000002')
INSERT INTO PESSOA_TELEFONE VALUES ('00000000003', '55000000003')
INSERT INTO PESSOA_TELEFONE VALUES ('00000000004', '55000000004')
INSERT INTO PESSOA_TELEFONE VALUES ('00000000005', '55000000005')
INSERT INTO PESSOA_TELEFONE VALUES ('00000000006', '55000000006')
INSERT INTO PESSOA_TELEFONE VALUES ('00000000007', '55000000007')
INSERT INTO PESSOA_TELEFONE VALUES ('00000000008', '55000000008')
INSERT INTO PESSOA_TELEFONE VALUES ('00000000009', '55000000009')
INSERT INTO PESSOA_TELEFONE VALUES ('00000000010', '55000000010')
INSERT INTO PESSOA_TELEFONE VALUES ('00000000011', '55000000011')
INSERT INTO PESSOA_TELEFONE VALUES ('00000000012', '55000000012')
INSERT INTO PESSOA_TELEFONE VALUES ('00000000013', '55000000013')
INSERT INTO PESSOA_TELEFONE VALUES ('00000000014', '55000000014')
INSERT INTO PESSOA_TELEFONE VALUES ('00000000015', '55000000015')
INSERT INTO PESSOA_TELEFONE VALUES ('00000000016', '55000000016')
INSERT INTO PESSOA_TELEFONE VALUES ('00000000017', '55000000017')
INSERT INTO PESSOA_TELEFONE VALUES ('00000000018', '55000000018')
INSERT INTO PESSOA_TELEFONE VALUES ('00000000019', '55000000019')
INSERT INTO PESSOA_TELEFONE VALUES ('00000000020', '55000000020')
INSERT INTO PESSOA_TELEFONE VALUES ('00000000021', '54000000021')
INSERT INTO PESSOA_TELEFONE VALUES ('00000000022', '54000000022')
INSERT INTO PESSOA_TELEFONE VALUES ('00000000023', '57000000023')
INSERT INTO PESSOA_TELEFONE VALUES ('00000000024', '56000000024')
INSERT INTO PESSOA_TELEFONE VALUES ('00000000025', '59800000025')
SELECT * FROM PESSOA_TELEFONE
GO

-- POPULA TABELA 'ATENDENTE'
----------------------------------------------------------------------------------------------------
INSERT INTO ATENDENTE VALUES ('00000000001', 1, 1750.00, 'M')
INSERT INTO ATENDENTE VALUES ('00000000002', 1, 1750.00, 'V')
INSERT INTO ATENDENTE VALUES ('00000000003', 2, 1950.00, 'D')
INSERT INTO ATENDENTE VALUES ('00000000004', 3, 1750.00, 'M')
INSERT INTO ATENDENTE VALUES ('00000000005', 3, 1750.00, 'V')
SELECT * FROM ATENDENTE
GO

-- POPULA TABELA 'GUIA_TURISTICO'
----------------------------------------------------------------------------------------------------
INSERT INTO GUIA_TURISTICO (CPF_Guia, Cod_Empresa, Salario, Registro, Validade) VALUES ('00000000006', 2, 2800.00, 10, '2021-12-31T23:59:59') -- SUPERVISOR #1
INSERT INTO GUIA_TURISTICO VALUES ('00000000007', 1, 2300.00, 11, '2024-12-31T23:59:59', '00000000006')
INSERT INTO GUIA_TURISTICO VALUES ('00000000008', 1, 2300.00, 12, '2024-12-31T23:59:59', '00000000006')
INSERT INTO GUIA_TURISTICO VALUES ('00000000009', 1, 2300.00, 13, '2024-12-31T23:59:59', '00000000006')
INSERT INTO GUIA_TURISTICO VALUES ('00000000010', 1, 2300.00, 14, '2024-12-31T23:59:59', '00000000006')
INSERT INTO GUIA_TURISTICO (CPF_Guia, Cod_Empresa, Salario, Registro, Validade) VALUES ('00000000011', 2, 2800.00, 20, '2021-12-31T23:59:59') -- SUPERVISOR #2
INSERT INTO GUIA_TURISTICO VALUES ('00000000012', 3, 2300.00, 21, '2024-12-31T23:59:59', '00000000011')
INSERT INTO GUIA_TURISTICO VALUES ('00000000013', 3, 2300.00, 22, '2024-12-31T23:59:59', '00000000011')
INSERT INTO GUIA_TURISTICO VALUES ('00000000014', 3, 2300.00, 23, '2024-12-31T23:59:59', '00000000011')
INSERT INTO GUIA_TURISTICO VALUES ('00000000015', 3, 2300.00, 24, '2024-12-31T23:59:59', '00000000011')
SELECT * FROM GUIA_TURISTICO
GO

-- POPULA TABELA 'PASSEIO'
----------------------------------------------------------------------------------------------------
INSERT INTO PASSEIO VALUES (0, 57.99, '16:00:00', 'Área verde', '00000000006')
INSERT INTO PASSEIO VALUES (1, 51.99, '09:30:00', 'Zoológico', '00000000006')
INSERT INTO PASSEIO VALUES (2, 69.99, '15:00:00', 'Trilha', '00000000007')
INSERT INTO PASSEIO VALUES (3, 139.99, '13:30:00', 'Cataratas', '00000000007')
INSERT INTO PASSEIO VALUES (4, 132.99, '08:30:00', 'Canyon', '00000000008')
INSERT INTO PASSEIO VALUES (5, 138.99, '18:00:00', 'Excursão gastronômica', '00000000008')
INSERT INTO PASSEIO VALUES (6, 73.99, '20:00:00', 'Estádio', '00000000009')
INSERT INTO PASSEIO VALUES (7, 145.99, '10:00:00', 'Passeio de barco', '00000000009')
INSERT INTO PASSEIO VALUES (8, 67.99, '11:00:00', 'Praia', '00000000010')
INSERT INTO PASSEIO VALUES (9, 70.99, '15:30:00', 'Aquário', '00000000010')
INSERT INTO PASSEIO VALUES (10, 72.99, '16:00:00', 'Kart', '00000000011')
INSERT INTO PASSEIO VALUES (11, 130.99, '21:30:00', 'Museu', '00000000011')
INSERT INTO PASSEIO VALUES (12, 68.99, '17:00:00', 'Colinas', '00000000012')
INSERT INTO PASSEIO VALUES (13, 141.99, '22:00:00', 'Teatro', '00000000012')
INSERT INTO PASSEIO VALUES (14, 64.99, '19:30:00', 'Circo', '00000000013')
INSERT INTO PASSEIO VALUES (15, 149.99, '16:00:00', 'Passeio de asa delta', '00000000013')
INSERT INTO PASSEIO VALUES (16, 133.99, '09:00:00', 'Fazenda', '00000000014')
INSERT INTO PASSEIO VALUES (17, 144.99, '10:00:00', 'Tour pela cidade', '00000000014')
INSERT INTO PASSEIO VALUES (18, 74.99, '16:30:00', 'Centro', '00000000015')
INSERT INTO PASSEIO VALUES (19, 147.99, '14:30:00', 'Parque de diversões', '00000000015')
SELECT * FROM PASSEIO
GO

-- POPULA TABELA 'PROMOCAO'
----------------------------------------------------------------------------------------------------
INSERT INTO PROMOCAO VALUES (0, 0.05) -- 5% DESCONTO
INSERT INTO PROMOCAO VALUES (1, 0.10) -- 10% DESCONTO
INSERT INTO PROMOCAO VALUES (2, 0.15) -- 15% DESCONTO
INSERT INTO PROMOCAO VALUES (3, 0.20) -- 20% DESCONTO
INSERT INTO PROMOCAO VALUES (4, 0.30) -- 30% DESCONTO
INSERT INTO PROMOCAO VALUES (5, 0.50) -- 50% DESCONTO
INSERT INTO PROMOCAO VALUES (6, 0.70) -- 70% DESCONTO
INSERT INTO PROMOCAO VALUES (7, 1.00) -- 100% DESCONTO
SELECT * FROM PROMOCAO
GO


-- MONTA OS PACOTES DE CADA PESSOA
-- PARA SIMPLIFICACAO, CADA PACOTE TERA' UMA UNICA PASSAGEM
----------------------------------------------------------------------------------------------------

-- LUCAS P. (CPF 00000000016) - PACOTES #0, #1, #2, #3
----------------------------------------------------------------------------------------------------
-- MONTA PACOTE #0
INSERT INTO PACOTE (Cod) VALUES (0)
-- ADD PASSAGEM
INSERT INTO PASSAGEM (Cod, Preco, Companhia, Destino, CPF_Pessoa, Data, Cod_Promocao) VALUES (0, 250.00, 'Companhia 1', 'Rio de Janeiro', '00000000016', '2020-06-12', NULL)
INSERT INTO P_PASSAGEM VALUES (0, 0)
-- ADD HOTEL
UPDATE PESSOA SET Cod_Hotel = 0 WHERE CPF = '00000000016'
INSERT INTO P_HOTEL VALUES (0, 0)
-- ADD PASSEIO
INSERT INTO AGENDA VALUES ('00000000016', 0)
INSERT INTO P_PASSEIO VALUES (0, 0)
-- FECHA PACOTE #0
UPDATE PACOTE SET Preco = (SELECT dbo.Preco_Pacote(0)) WHERE Cod = 0
GO
