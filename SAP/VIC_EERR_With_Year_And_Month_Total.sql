

SET LANGUAGE 'spanish'
SELECT
       TABLA.Year            [Year]
	  ,TABLA.MonthName       [MonthName]
	  ,TABLA.Month           [Month]
	  ,TABLA.AcctGroup       [AcctGroup]
	  ,SUM(TABLA.CargoAbono) [CargoAbono]

FROM (
		SELECT
					   YEAR(T0.RefDate) AS Year,
					   T0.Account AS Cuenta,
					   CASE
						 WHEN T1.U_VIC_CambioNivel2 > 0 THEN (SELECT AcctName FROM dbo.OACT WHERE  AcctCode LIKE (SELECT FatherNum
																   FROM dbo.OACT
																  WHERE AcctCode = T1.U_VIC_CambioNivel2))
						ELSE  (SELECT AcctName FROM dbo.OACT WHERE  AcctCode LIKE (SELECT FatherNum FROM dbo.OACT WHERE  AcctCode LIKE T1.FatherNum))
					   END                      AS   AcctGroupFirst,
					   CASE
						 WHEN T1.U_VIC_CambioNivel2 > 0 THEN
														   CASE (SELECT GroupMask
																   FROM dbo.OACT
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
					   DATENAME(MONTH,T0.RefDate)       'MonthName',
					   CASE
						   WHEN MONTH(T0.RefDate) = 12 THEN SUM(T0.Credit-T0.Debit)
						   ELSE                SUM(T0.Credit-T0.Debit)
					   END 'CargoAbono'
				   FROM dbo.JDT1 T0
				   INNER JOIN dbo.OACT T1 ON T1.AcctCode=T0.Account
				   LEFT JOIN dbo.OPRC T2 ON T2.PrcCode=T0.ProfitCode
				   WHERE YEAR(T0.RefDate) IN (2018,2019) AND T1.GroupMask BETWEEN 1 AND 10
					 AND T1.GroupMask NOT IN (1,2,3)
					 AND T2.PrcName IS NOT NULL
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
) AS TABLA
  GROUP BY
           TABLA.Year
	      ,TABLA.Month
		  ,TABLA.MonthName
          ,TABLA.AcctGroup
  ORDER BY
           TABLA.Year
		  ,TABLA.Month
		  ,TABLA.MonthName
		  ,TABLA.AcctGroup
	     