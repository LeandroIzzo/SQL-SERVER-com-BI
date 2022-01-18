--------------------------
------DIMENS�O TEMPO------
--------------------------

--EXIBINDO A DATA ATUAL (PADR�O BRASIL) DATA, MES, ANO

PRINT CONVERT(VARCHAR,GETDATE(),113)

-- INICIO DAS DATAS EM 2500, PARA DAR A POSSIBILIDADE
-- DE ADICIONAR DATAS ANTERIORES

DBCC CHECKIDENT (DIM_TEMPO, RESEED, 2500)

--INSER��O DE DADOS NA DIMENS�O TEMPO

DECLARE @DATAINICIO DATETIME, @DATAFIM DATETIME, @DATA DATETIME 

PRINT GETDATE() 

		SELECT @DATAINICIO = '1/1/1980', 
				@DATAFIM = '1/1/2100'

		SELECT @DATA = @DATAINICIO

	WHILE @DATA < @DATAFIM
		BEGIN
		INSERT INTO DIM_TEMPO
			( 
				  DATA, 
				  DIA,
				  DIA_SEMANA, 
				  MES,
				  NOME_MES, 
				  QUARTO,
				  NOME_QUARTO, 
				  ANO 
			) 
			SELECT @DATA AS DATA, DATEPART(DAY,@DATA) AS DIA, 

				 CASE DATEPART(DW, @DATA) 
            
					WHEN 1 THEN 'Domingo'
					WHEN 2 THEN 'Segunda' 
					WHEN 3 THEN 'Ter�a' 
					WHEN 4 THEN 'Quarta' 
					WHEN 5 THEN 'Quinta' 
					WHEN 6 THEN 'Sexta' 
					WHEN 7 THEN 'S�bado' 
             
				END AS DIA_SEMANA,

				 DATEPART(MONTH,@DATA) AS MES, 

				 CASE DATENAME(MONTH,@DATA) 
	/* Essa parte s� funciona caso seu sql server esteja em ingl�s */
					WHEN 'January' THEN 'Janeiro'
					WHEN 'February' THEN 'Fevereiro'
					WHEN 'March' THEN 'Mar�o'
					WHEN 'April' THEN 'Abril'
					WHEN 'May' THEN 'Maio'
					WHEN 'June' THEN 'Junho'
					WHEN 'July' THEN 'Julho'
					WHEN 'August' THEN 'Agosto'
					WHEN 'September' THEN 'Setembro'
					WHEN 'October' THEN 'Outubro'
					WHEN 'November' THEN 'Novembro'
					WHEN 'December' THEN 'Dezembro'
		
				END AS NOME_MES,
		 
				 DATEPART(qq,@DATA) QUARTO, 

				 CASE DATEPART(qq,@DATA) 
					WHEN 1 THEN 'Primeiro' 
					WHEN 2 THEN 'Segundo' 
					WHEN 3 THEN 'Terceiro' 
					WHEN 4 THEN 'Quarto' 
				END AS NOME_QUARTO 
				, DATEPART(YEAR,@DATA) ANO
	
			SELECT @DATA = DATEADD(dd,1,@DATA)
		END

		UPDATE DIM_TEMPO
		SET DIA = '0' + DIA 
		WHERE LEN(DIA) = 1 

		UPDATE DIM_TEMPO 
		SET MES = '0' + MES 
		WHERE LEN(MES) = 1 

		UPDATE DIM_TEMPO 
		SET DATA_COMPLETA = ANO + MES + DIA 
		GO

		select * from DIM_TEMPO

		----------------------------------------------
		----------FINS DE SEMANA E ESTA��ES-----------
		----------------------------------------------

		DECLARE C_TEMPO CURSOR FOR	
			SELECT IDSK, DATA_COMPLETA, DIA_SEMANA, ANO FROM DIM_TEMPO
		DECLARE			
					@ID INT,
					@DATA varchar(10),
					@DIASEMANA VARCHAR(20),
					@ANO CHAR(4),
					@FIMSEMANA CHAR(3),
					@ESTACAO VARCHAR(15)
					
		OPEN C_TEMPO
			FETCH NEXT FROM C_TEMPO
			INTO @ID, @DATA, @DIASEMANA, @ANO
		WHILE @@FETCH_STATUS = 0
		BEGIN
			
					 IF @DIASEMANA in ('Domingo','S�bado') 
						SET @FIMSEMANA = 'S'
					 ELSE 
						SET @FIMSEMANA = 'N'

					--ATUALIZANDO ESTACOES

					IF @DATA BETWEEN CONVERT(CHAR(4),@ano)+'0923' 
					AND CONVERT(CHAR(4),@ANO)+'1220'
						SET @ESTACAO = 'Primavera'

					ELSE IF @DATA BETWEEN CONVERT(CHAR(4),@ano)+'0321' 
					AND CONVERT(CHAR(4),@ANO)+'0620'
						SET @ESTACAO = 'Outono'

					ELSE IF @DATA BETWEEN CONVERT(CHAR(4),@ano)+'0621' 
					AND CONVERT(CHAR(4),@ANO)+'0922'
						SET @ESTACAO = 'Inverno'

					ELSE -- @data between 21/12 e 20/03
						SET @ESTACAO = 'Ver�o'

					--ATUALIZANDO FINS DE SEMANA
	
					UPDATE DIM_TEMPO SET FIM_SEMANA = @FIMSEMANA
					WHERE IDSK = @ID

					--ATUALIZANDO

					UPDATE DIM_TEMPO SET ESTACAO_ANO = @ESTACAO
					WHERE IDSK = @ID
		
			FETCH NEXT FROM C_TEMPO
			INTO @ID, @DATA, @DIASEMANA, @ANO	
		END
		CLOSE C_TEMPO
		DEALLOCATE C_TEMPO
		GO