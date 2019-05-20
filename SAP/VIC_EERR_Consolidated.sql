DECLARE @ANIO SMALLINT
 
SET @ANIO = (SELECT A.Year FROM dbo.OACP A WHERE A.Year ='2018')
 
SELECT 
	P.[Cuenta],
	P.[AcctGroup],
	P.[Nombre],
	P.[PrcCode],
	isnull([EXIMBEN],0) as [EXIMBEN],
	isnull([SERVIMEX],0) as [SERVIMEX],
	isnull([VILU],0) as [VILU],
	isnull([EXIMBENREG],0) as [EXIMBENREG],
	isnull([LOSRISCOS],0) as [LOSRISCOS]
 
FROM (	
			SELECT
					'EXIMBEN'        [Empresa],
					YEAR(T0.RefDate) AS Year,
					T0.Account AS Cuenta,
					CASE T1.GroupMask
					  WHEN 1 THEN '1 Activo'
					  WHEN 2 THEN '2 Pasivo'
					  WHEN 3 THEN '3 Patrimonio'
					  --No van cuentas superiores
					  WHEN 4 THEN '4 Ingresos Por Venta'
					  WHEN 5 THEN '5 Costos De Venta'
					  WHEN 6 THEN '6 Gastos De Admnistración'
					  WHEN 7 THEN '7 Ingresos Financieros'
					  WHEN 8 THEN '8 Gastos Financieros'
					END                                    AS   AcctGroup,
					T1.AcctName AS Nombre,
					T2.PrcCode AS PrcCode,
					SUM(T0.Credit-T0.Debit) 'CargoAbono' 
 
				FROM [SBO_Imp_Eximben_SAC].dbo.JDT1 T0
				INNER JOIN  [SBO_Imp_Eximben_SAC].dbo.OACT T1 ON T1.AcctCode=T0.Account
				LEFT JOIN  [SBO_Imp_Eximben_SAC].dbo.OPRC T2 ON T2.PrcCode=T0.ProfitCode
 
				WHERE YEAR(T0.RefDate)= @ANIO
				  AND T1.GroupMask BETWEEN 1 AND 10
				  AND T1.GroupMask NOT IN (1,2,3)
				GROUP BY 
						 YEAR(T0.RefDate),
						 T0.Account,
						 T1.GroupMask,
						 T1.AcctName,
						 T2.PrcCode 
	
			--
			UNION ALL
			--

			SELECT
					'SERVIMEX'        [Empresa],
					YEAR(T0.RefDate) AS Year,
					T0.Account AS Cuenta,
					CASE T1.GroupMask
					  WHEN 1 THEN '1 Activo'
					  WHEN 2 THEN '2 Pasivo'
					  WHEN 3 THEN '3 Patrimonio'
					  --No van cuentas superiores
					  WHEN 4 THEN '4 Ingresos Por Venta'
					  WHEN 5 THEN '5 Costos De Venta'
					  WHEN 6 THEN '6 Gastos De Admnistración'
					  WHEN 7 THEN '7 Ingresos Financieros'
					  WHEN 8 THEN '8 Gastos Financieros'
					END                                    AS   AcctGroup,
					T1.AcctName AS Nombre,
					T2.PrcCode AS PrcCode,
					SUM(T0.Credit-T0.Debit) 'CargoAbono' 
 
				FROM [SBO_Inv_Servimex].dbo.JDT1 T0
				INNER JOIN [SBO_Inv_Servimex].dbo.OACT T1 ON T1.AcctCode=T0.Account
				 LEFT JOIN [SBO_Inv_Servimex].dbo.OPRC T2 ON T2.PrcCode=T0.ProfitCode
 
				WHERE YEAR(T0.RefDate)= @ANIO
				  AND T1.GroupMask BETWEEN 1 AND 10
				  AND T1.GroupMask NOT IN (1,2,3)
				GROUP BY 
						 YEAR(T0.RefDate),
						 T0.Account,
						 T1.GroupMask,
						 T1.AcctName,
						 T2.PrcCode 

			--
			UNION ALL
			--

			SELECT
					'VILU'        [Empresa],
					YEAR(T0.RefDate) AS Year,
					T0.Account AS Cuenta,
					CASE T1.GroupMask
					  WHEN 1 THEN '1 Activo'
					  WHEN 2 THEN '2 Pasivo'
					  WHEN 3 THEN '3 Patrimonio'
					  --No van cuentas superiores
					  WHEN 4 THEN '4 Ingresos Por Venta'
					  WHEN 5 THEN '5 Costos De Venta'
					  WHEN 6 THEN '6 Gastos De Admnistración'
					  WHEN 7 THEN '7 Ingresos Financieros'
					  WHEN 8 THEN '8 Gastos Financieros'
					END                                    AS   AcctGroup,
					T1.AcctName AS Nombre,
					T2.PrcCode AS PrcCode,
					SUM(T0.Credit-T0.Debit) 'CargoAbono' 
 
				FROM [SBO_VILUSA].dbo.JDT1 T0
				INNER JOIN [SBO_VILUSA].dbo.OACT T1 ON T1.AcctCode=T0.Account
				 LEFT JOIN [SBO_VILUSA].dbo.OPRC T2 ON T2.PrcCode=T0.ProfitCode
 
				WHERE YEAR(T0.RefDate)= @ANIO
				  AND T1.GroupMask BETWEEN 1 AND 10
				  AND T1.GroupMask NOT IN (1,2,3)
				GROUP BY 
						 YEAR(T0.RefDate),
						 T0.Account,
						 T1.GroupMask,
						 T1.AcctName,
						 T2.PrcCode 

			--
			UNION ALL
			--

			SELECT
					'EXIMBENREG'        [Empresa],
					YEAR(T0.RefDate) AS Year,
					T0.Account AS Cuenta,
					CASE T1.GroupMask
					  WHEN 1 THEN '1 Activo'
					  WHEN 2 THEN '2 Pasivo'
					  WHEN 3 THEN '3 Patrimonio'
					  --No van cuentas superiores
					  WHEN 4 THEN '4 Ingresos Por Venta'
					  WHEN 5 THEN '5 Costos De Venta'
					  WHEN 6 THEN '6 Gastos De Admnistración'
					  WHEN 7 THEN '7 Ingresos Financieros'
					  WHEN 8 THEN '8 Gastos Financieros'
					END                                    AS   AcctGroup,
					T1.AcctName AS Nombre,
					T2.PrcCode AS PrcCode,
					SUM(T0.Credit-T0.Debit) 'CargoAbono' 
 
				FROM [SBO_Eximben_RegGen].dbo.JDT1 T0
				INNER JOIN [SBO_Eximben_RegGen].dbo.OACT T1 ON T1.AcctCode=T0.Account
				 LEFT JOIN [SBO_Eximben_RegGen].dbo.OPRC T2 ON T2.PrcCode=T0.ProfitCode
 
				WHERE YEAR(T0.RefDate)= @ANIO
				  AND T1.GroupMask BETWEEN 1 AND 10
				  AND T1.GroupMask NOT IN (1,2,3)
				GROUP BY 
						 YEAR(T0.RefDate),
						 T0.Account,
						 T1.GroupMask,
						 T1.AcctName,
						 T2.PrcCode 

			--
			UNION ALL
			--

			SELECT
					'LOSRISCOS'        [Empresa],
					YEAR(T0.RefDate) AS Year,
					T0.Account AS Cuenta,
					CASE T1.GroupMask
					  WHEN 1 THEN '1 Activo'
					  WHEN 2 THEN '2 Pasivo'
					  WHEN 3 THEN '3 Patrimonio'
					  --No van cuentas superiores
					  WHEN 4 THEN '4 Ingresos Por Venta'
					  WHEN 5 THEN '5 Costos De Venta'
					  WHEN 6 THEN '6 Gastos De Admnistración'
					  WHEN 7 THEN '7 Ingresos Financieros'
					  WHEN 8 THEN '8 Gastos Financieros'
					END                                    AS   AcctGroup,
					T1.AcctName AS Nombre,
					T2.PrcCode AS PrcCode,
					SUM(T0.Credit-T0.Debit) 'CargoAbono' 
 
				FROM [SBO_LOS_RISCOS].dbo.JDT1 T0
				INNER JOIN [SBO_LOS_RISCOS].dbo.OACT T1 ON T1.AcctCode=T0.Account
				 LEFT JOIN [SBO_LOS_RISCOS].dbo.OPRC T2 ON T2.PrcCode=T0.ProfitCode
 
				WHERE YEAR(T0.RefDate)= @ANIO
				  AND T1.GroupMask BETWEEN 1 AND 10
				  AND T1.GroupMask NOT IN (1,2,3)
				GROUP BY 
						 YEAR(T0.RefDate),
						 T0.Account,
						 T1.GroupMask,
						 T1.AcctName,
						 T2.PrcCode 
) P
 
PIVOT (
	SUM(CargoAbono)
	FOR [Empresa] IN ([EXIMBEN],[SERVIMEX],[VILU],[EXIMBENREG],[LOSRISCOS])
) P
 
ORDER BY P.[Nombre]