DECLARE @ANIO SMALLINT
 
SET @ANIO = (SELECT A.Year FROM dbo.OACP A WHERE A.Year ='2018')
 

SELECT 
	P.[Cuenta],
	P.[AcctGroup],
	P.[Nombre],
	P.[CCosto],
	isnull([EXIMBEN],0)    as [EXIMBEN],
	isnull([SERVIMEX],0)   as [SERVIMEX],
	isnull([VILU],0)       as [VILU],
	isnull([EXIMBENREG],0) as [EXIMBENREG],
	isnull([LOSRISCOS],0)  as [LOSRISCOS]
 
FROM (	
			SELECT
					'EXIMBEN'        [Empresa],
					YEAR(T0.RefDate) AS Year,
                       T0.Account AS Cuenta,
                       CASE
                         WHEN T1.U_VIC_CambioNivel2 > 0 THEN (SELECT AcctName FROM [SBO_Imp_Eximben_SAC].dbo.OACT WHERE  AcctCode LIKE (SELECT FatherNum
                                                                   FROM [SBO_Imp_Eximben_SAC].dbo.OACT
                                                                  WHERE AcctCode = T1.U_VIC_CambioNivel2))
                        ELSE  (SELECT AcctName FROM [SBO_Imp_Eximben_SAC].dbo.OACT WHERE  AcctCode LIKE (SELECT FatherNum FROM [SBO_Imp_Eximben_SAC].dbo.OACT WHERE  AcctCode LIKE T1.FatherNum))
                       END                      AS   AcctGroupFirst,
                       CASE
                         WHEN T1.U_VIC_CambioNivel2 > 0 THEN
                                                           CASE (SELECT GroupMask
                                                                   FROM [SBO_Imp_Eximben_SAC].dbo.OACT
                                                                  WHERE AcctCode = T1.U_VIC_CambioNivel2)
                                                               WHEN 1 THEN '1 Activo'
                                                               WHEN 2 THEN '2 Pasivo'
                                                               WHEN 3 THEN '3 Patrimonio'
                                                               WHEN 4 THEN '4 INGRESOS POR VENTA'
                                                               WHEN 5 THEN '5 COSTOS DE VENTA'
                                                               WHEN 6 THEN '6 GASTOS DE ADMNISTRACION'
                                                               WHEN 7 THEN '7 INGRESOS FINANCIEROS'
                                                               WHEN 8 THEN '8 GASTOS FINANCIEROS'
                                                           END
                        ELSE
                                                           CASE T1.GroupMask
                                                               WHEN 1 THEN '1 Activo'
                                                               WHEN 2 THEN '2 Pasivo'
                                                               WHEN 3 THEN '3 Patrimonio'
                                                               WHEN 4 THEN '4 INGRESOS POR VENTA'
                                                               WHEN 5 THEN '5 COSTOS DE VENTA'
                                                               WHEN 6 THEN '6 GASTOS DE ADMNISTRACION'
                                                               WHEN 7 THEN '7 INGRESOS FINANCIEROS'
                                                               WHEN 8 THEN '8 GASTOS FINANCIEROS'
                                                           END
                       END                      AS   AcctGroup,
                       T1.AcctName              AS Nombre,
                       T1.Segment_0+'-'+T1.Segment_1+'-'+T1.AcctName  AS Segment,
                       T2.PrcName               AS CCosto,
                       MONTH(T0.RefDate)                'Month',
					   --'OLD-'+MONTH(T0.RefDate)              'Month2',
					   'OLD-'+
                       REPLACE(STR(MONTH(T0.RefDate),2,0),' ', 0)   [Periodo],
                       DATENAME(MONTH,T0.RefDate)       'MonthName',
                       SUM(T0.Credit-T0.Debit) 'CargoAbono' 
                   FROM dbo.JDT1 T0
                   INNER JOIN [SBO_Imp_Eximben_SAC].dbo.OACT T1 ON T1.AcctCode=T0.Account
                   LEFT JOIN [SBO_Imp_Eximben_SAC].dbo.OPRC T2 ON T2.PrcCode=T0.ProfitCode
                   WHERE YEAR(T0.RefDate) IN (2019) AND T1.GroupMask BETWEEN 1 AND 10
                     AND T1.GroupMask NOT IN (1,2,3)
                     --AND T2.PrcName IS NOT NULL
					 --AND T0.Account = '_SYS00000000149'
					 --AND T1.GroupMask IN (8)
                   GROUP BY
                         T0.Account,
                         T1.GroupMask,
                         T1.U_VIC_CambioNivel2,
                         T1.FatherNum,
                         T1.AcctCode,
                         t1.Levels,
                         T1.AcctName,
                         T1.Segment_0,
                         T1.Segment_1,
                         T2.PrcName,
                         YEAR(T0.RefDate),
                         DATENAME(MONTH,T0.RefDate),
                         MONTH(T0.RefDate)
		--
        UNION ALL
		--

		SELECT
					'LOSRISCOS'        [Empresa],
					YEAR(T0.RefDate) AS Year,
                       T0.Account AS Cuenta,
                       CASE
                         WHEN T1.U_VIC_CambioNivel2 > 0 THEN (SELECT AcctName FROM dbo.OACT WHERE  AcctCode LIKE (SELECT FatherNum
                                                                   FROM [SBO_LOS_RISCOS].dbo.OACT
                                                                  WHERE AcctCode = T1.U_VIC_CambioNivel2))
                        ELSE  (SELECT AcctName FROM [SBO_LOS_RISCOS].dbo.OACT WHERE  AcctCode LIKE (SELECT FatherNum FROM [SBO_LOS_RISCOS].dbo.OACT WHERE  AcctCode LIKE T1.FatherNum))
                       END                      AS   AcctGroupFirst,
                       CASE
                         WHEN T1.U_VIC_CambioNivel2 > 0 THEN
                                                           CASE (SELECT GroupMask
                                                                   FROM [SBO_LOS_RISCOS].dbo.OACT
                                                                  WHERE AcctCode = T1.U_VIC_CambioNivel2)
                                                               WHEN 1 THEN '1 Activo'
                                                               WHEN 2 THEN '2 Pasivo'
                                                               WHEN 3 THEN '3 Patrimonio'
                                                               WHEN 4 THEN '4 INGRESOS POR VENTA'
                                                               WHEN 5 THEN '5 COSTOS DE VENTA'
                                                               WHEN 6 THEN '6 GASTOS DE ADMNISTRACION'
                                                               WHEN 7 THEN '7 INGRESOS FINANCIEROS'
                                                               WHEN 8 THEN '8 GASTOS FINANCIEROS'
                                                           END
                        ELSE
                                                           CASE T1.GroupMask
                                                               WHEN 1 THEN '1 Activo'
                                                               WHEN 2 THEN '2 Pasivo'
                                                               WHEN 3 THEN '3 Patrimonio'
                                                               WHEN 4 THEN '4 INGRESOS POR VENTA'
                                                               WHEN 5 THEN '5 COSTOS DE VENTA'
                                                               WHEN 6 THEN '6 GASTOS DE ADMNISTRACION'
                                                               WHEN 7 THEN '7 INGRESOS FINANCIEROS'
                                                               WHEN 8 THEN '8 GASTOS FINANCIEROS'
                                                           END
                       END                      AS   AcctGroup,
                       T1.AcctName              AS Nombre,
                       T1.Segment_0+'-'+T1.Segment_1+'-'+T1.AcctName  AS Segment,
                       T2.PrcName               AS CCosto,
                       MONTH(T0.RefDate)                'Month',
					   'OLD-'+
                       REPLACE(STR(MONTH(T0.RefDate),2,0),' ', 0)   [Periodo],
                       DATENAME(MONTH,T0.RefDate)       'MonthName',
                       SUM(T0.Credit-T0.Debit) 'CargoAbono' 
                   FROM dbo.JDT1 T0
                   INNER JOIN [SBO_LOS_RISCOS].dbo.OACT T1 ON T1.AcctCode=T0.Account
                   LEFT JOIN [SBO_LOS_RISCOS].dbo.OPRC T2 ON T2.PrcCode=T0.ProfitCode
                   WHERE YEAR(T0.RefDate) IN (2019) AND T1.GroupMask BETWEEN 1 AND 10
                     AND T1.GroupMask NOT IN (1,2,3)
                   GROUP BY
                         T0.Account,
                         T1.GroupMask,
                         T1.U_VIC_CambioNivel2,
                         T1.FatherNum,
                         T1.AcctCode,
                         t1.Levels,
                         T1.AcctName,
                         T1.Segment_0,
                         T1.Segment_1,
                         T2.PrcName,
                         YEAR(T0.RefDate),
                         DATENAME(MONTH,T0.RefDate),
                         MONTH(T0.RefDate)
		--
        UNION ALL
		--

		SELECT
					'EXIMBENREG'        [Empresa],
					YEAR(T0.RefDate) AS Year,
                       T0.Account AS Cuenta,
                       CASE
                         WHEN T1.U_VIC_CambioNivel2 > 0 THEN (SELECT AcctName FROM dbo.OACT WHERE  AcctCode LIKE (SELECT FatherNum
                                                                   FROM [SBO_Eximben_RegGen].dbo.OACT
                                                                  WHERE AcctCode = T1.U_VIC_CambioNivel2))
                        ELSE  (SELECT AcctName FROM [SBO_Eximben_RegGen].dbo.OACT WHERE  AcctCode LIKE (SELECT FatherNum FROM [SBO_Eximben_RegGen].dbo.OACT WHERE  AcctCode LIKE T1.FatherNum))
                       END                      AS   AcctGroupFirst,
                       CASE
                         WHEN T1.U_VIC_CambioNivel2 > 0 THEN
                                                           CASE (SELECT GroupMask
                                                                   FROM [SBO_Eximben_RegGen].dbo.OACT
                                                                  WHERE AcctCode = T1.U_VIC_CambioNivel2)
                                                               WHEN 1 THEN '1 Activo'
                                                               WHEN 2 THEN '2 Pasivo'
                                                               WHEN 3 THEN '3 Patrimonio'
                                                               WHEN 4 THEN '4 INGRESOS POR VENTA'
                                                               WHEN 5 THEN '5 COSTOS DE VENTA'
                                                               WHEN 6 THEN '6 GASTOS DE ADMNISTRACION'
                                                               WHEN 7 THEN '7 INGRESOS FINANCIEROS'
                                                               WHEN 8 THEN '8 GASTOS FINANCIEROS'
                                                           END
                        ELSE
                                                           CASE T1.GroupMask
                                                               WHEN 1 THEN '1 Activo'
                                                               WHEN 2 THEN '2 Pasivo'
                                                               WHEN 3 THEN '3 Patrimonio'
                                                               WHEN 4 THEN '4 INGRESOS POR VENTA'
                                                               WHEN 5 THEN '5 COSTOS DE VENTA'
                                                               WHEN 6 THEN '6 GASTOS DE ADMNISTRACION'
                                                               WHEN 7 THEN '7 INGRESOS FINANCIEROS'
                                                               WHEN 8 THEN '8 GASTOS FINANCIEROS'
                                                           END
                       END                      AS   AcctGroup,
                       T1.AcctName              AS Nombre,
                       T1.Segment_0+'-'+T1.Segment_1+'-'+T1.AcctName  AS Segment,
                       T2.PrcName               AS CCosto,
                       MONTH(T0.RefDate)                'Month',
					   'OLD-'+
                       REPLACE(STR(MONTH(T0.RefDate),2,0),' ', 0)   [Periodo],
                       DATENAME(MONTH,T0.RefDate)       'MonthName',
                       SUM(T0.Credit-T0.Debit) 'CargoAbono' 
                   FROM dbo.JDT1 T0
                   INNER JOIN [SBO_Eximben_RegGen].dbo.OACT T1 ON T1.AcctCode=T0.Account
                   LEFT JOIN [SBO_Eximben_RegGen].dbo.OPRC T2 ON T2.PrcCode=T0.ProfitCode
                   WHERE YEAR(T0.RefDate) IN (2019) AND T1.GroupMask BETWEEN 1 AND 10
                     AND T1.GroupMask NOT IN (1,2,3)
                   GROUP BY
                         T0.Account,
                         T1.GroupMask,
                         T1.U_VIC_CambioNivel2,
                         T1.FatherNum,
                         T1.AcctCode,
                         t1.Levels,
                         T1.AcctName,
                         T1.Segment_0,
                         T1.Segment_1,
                         T2.PrcName,
                         YEAR(T0.RefDate),
                         DATENAME(MONTH,T0.RefDate),
                         MONTH(T0.RefDate)

        --
        UNION ALL
		--

		SELECT
					'VILU'        [Empresa],
					YEAR(T0.RefDate) AS Year,
                       T0.Account AS Cuenta,
                       CASE
                         WHEN T1.U_VIC_CambioNivel2 > 0 THEN (SELECT AcctName FROM [SBO_VILU_SA].dbo.OACT WHERE  AcctCode LIKE (SELECT FatherNum
                                                                   FROM [SBO_VILU_SA].dbo.OACT
                                                                  WHERE AcctCode = T1.U_VIC_CambioNivel2))
                        ELSE  (SELECT AcctName FROM [SBO_Eximben_RegGen].dbo.OACT WHERE  AcctCode LIKE (SELECT FatherNum FROM [SBO_VILU_SA].dbo.OACT WHERE  AcctCode LIKE T1.FatherNum))
                       END                      AS   AcctGroupFirst,
                       CASE
                         WHEN T1.U_VIC_CambioNivel2 > 0 THEN
                                                           CASE (SELECT GroupMask
                                                                   FROM [SBO_VILU_SA].dbo.OACT
                                                                  WHERE AcctCode = T1.U_VIC_CambioNivel2)
                                                               WHEN 1 THEN '1 Activo'
                                                               WHEN 2 THEN '2 Pasivo'
                                                               WHEN 3 THEN '3 Patrimonio'
                                                               WHEN 4 THEN '4 INGRESOS POR VENTA'
                                                               WHEN 5 THEN '5 COSTOS DE VENTA'
                                                               WHEN 6 THEN '6 GASTOS DE ADMNISTRACION'
                                                               WHEN 7 THEN '7 INGRESOS FINANCIEROS'
                                                               WHEN 8 THEN '8 GASTOS FINANCIEROS'
                                                           END
                        ELSE
                                                           CASE T1.GroupMask
                                                               WHEN 1 THEN '1 Activo'
                                                               WHEN 2 THEN '2 Pasivo'
                                                               WHEN 3 THEN '3 Patrimonio'
                                                               WHEN 4 THEN '4 INGRESOS POR VENTA'
                                                               WHEN 5 THEN '5 COSTOS DE VENTA'
                                                               WHEN 6 THEN '6 GASTOS DE ADMNISTRACION'
                                                               WHEN 7 THEN '7 INGRESOS FINANCIEROS'
                                                               WHEN 8 THEN '8 GASTOS FINANCIEROS'
                                                           END
                       END                      AS   AcctGroup,
                       T1.AcctName              AS Nombre,
                       T1.Segment_0+'-'+T1.Segment_1+'-'+T1.AcctName  AS Segment,
                       T2.PrcName               AS CCosto,
                       MONTH(T0.RefDate)                'Month',
					   'OLD-'+
                       REPLACE(STR(MONTH(T0.RefDate),2,0),' ', 0)   [Periodo],
                       DATENAME(MONTH,T0.RefDate)       'MonthName',
                       SUM(T0.Credit-T0.Debit) 'CargoAbono' 
                   FROM dbo.JDT1 T0
                   INNER JOIN [SBO_VILU_SA].dbo.OACT T1 ON T1.AcctCode=T0.Account
                   LEFT JOIN [SBO_VILU_SA].dbo.OPRC T2 ON T2.PrcCode=T0.ProfitCode
                   WHERE YEAR(T0.RefDate) IN (2019) AND T1.GroupMask BETWEEN 1 AND 10
                     AND T1.GroupMask NOT IN (1,2,3)
                   GROUP BY
                         T0.Account,
                         T1.GroupMask,
                         T1.U_VIC_CambioNivel2,
                         T1.FatherNum,
                         T1.AcctCode,
                         t1.Levels,
                         T1.AcctName,
                         T1.Segment_0,
                         T1.Segment_1,
                         T2.PrcName,
                         YEAR(T0.RefDate),
                         DATENAME(MONTH,T0.RefDate),
                         MONTH(T0.RefDate)

	    --
        UNION ALL
		--

		SELECT
					'SERVIMEX'        [Empresa],
					YEAR(T0.RefDate) AS Year,
                       T0.Account AS Cuenta,
                       CASE
                         WHEN T1.U_VIC_CambioNivel2 > 0 THEN (SELECT AcctName FROM [SBO_Inv_Servimex].dbo.OACT WHERE  AcctCode LIKE (SELECT FatherNum
                                                                   FROM  [SBO_Inv_Servimex].dbo.OACT
                                                                  WHERE AcctCode = T1.U_VIC_CambioNivel2))
                        ELSE  (SELECT AcctName FROM  [SBO_Inv_Servimex].dbo.OACT WHERE  AcctCode LIKE (SELECT FatherNum FROM  [SBO_Inv_Servimex].dbo.OACT WHERE  AcctCode LIKE T1.FatherNum))
                       END                      AS   AcctGroupFirst,
                       CASE
                         WHEN T1.U_VIC_CambioNivel2 > 0 THEN
                                                           CASE (SELECT GroupMask
                                                                   FROM  [SBO_Inv_Servimex].dbo.OACT
                                                                  WHERE AcctCode = T1.U_VIC_CambioNivel2)
                                                               WHEN 1 THEN '1 Activo'
                                                               WHEN 2 THEN '2 Pasivo'
                                                               WHEN 3 THEN '3 Patrimonio'
                                                               WHEN 4 THEN '4 INGRESOS POR VENTA'
                                                               WHEN 5 THEN '5 COSTOS DE VENTA'
                                                               WHEN 6 THEN '6 GASTOS DE ADMNISTRACION'
                                                               WHEN 7 THEN '7 INGRESOS FINANCIEROS'
                                                               WHEN 8 THEN '8 GASTOS FINANCIEROS'
                                                           END
                        ELSE
                                                           CASE T1.GroupMask
                                                               WHEN 1 THEN '1 Activo'
                                                               WHEN 2 THEN '2 Pasivo'
                                                               WHEN 3 THEN '3 Patrimonio'
                                                               WHEN 4 THEN '4 INGRESOS POR VENTA'
                                                               WHEN 5 THEN '5 COSTOS DE VENTA'
                                                               WHEN 6 THEN '6 GASTOS DE ADMNISTRACION'
                                                               WHEN 7 THEN '7 INGRESOS FINANCIEROS'
                                                               WHEN 8 THEN '8 GASTOS FINANCIEROS'
                                                           END
                       END                      AS   AcctGroup,
                       T1.AcctName              AS Nombre,
                       T1.Segment_0+'-'+T1.Segment_1+'-'+T1.AcctName  AS Segment,
                       T2.PrcName               AS CCosto,
                       MONTH(T0.RefDate)                'Month',
					   'OLD-'+
                       REPLACE(STR(MONTH(T0.RefDate),2,0),' ', 0)   [Periodo],
                       DATENAME(MONTH,T0.RefDate)       'MonthName',
                       SUM(T0.Credit-T0.Debit) 'CargoAbono' 
                   FROM dbo.JDT1 T0
                   INNER JOIN  [SBO_Inv_Servimex].dbo.OACT T1 ON T1.AcctCode=T0.Account
                   LEFT JOIN  [SBO_Inv_Servimex].dbo.OPRC T2 ON T2.PrcCode=T0.ProfitCode
                   WHERE YEAR(T0.RefDate) IN (2019) AND T1.GroupMask BETWEEN 1 AND 10
                     AND T1.GroupMask NOT IN (1,2,3)
                   GROUP BY
                         T0.Account,
                         T1.GroupMask,
                         T1.U_VIC_CambioNivel2,
                         T1.FatherNum,
                         T1.AcctCode,
                         t1.Levels,
                         T1.AcctName,
                         T1.Segment_0,
                         T1.Segment_1,
                         T2.PrcName,
                         YEAR(T0.RefDate),
                         DATENAME(MONTH,T0.RefDate),
                         MONTH(T0.RefDate)
) P
 
PIVOT (
	SUM(CargoAbono)
	FOR [Empresa] IN ([EXIMBEN],[SERVIMEX],[VILU],[EXIMBENREG],[LOSRISCOS])
) P
 
