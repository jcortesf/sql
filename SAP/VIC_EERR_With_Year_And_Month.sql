DECLARE @ANIO SMALLINT
 
SET @ANIO = (SELECT A.Year FROM dbo.OACP A WHERE A.Year='2017')

SELECT 
     TABLA.Cuenta
    ,TABLA.AcctGroup
	,TABLA.Segment
	,TABLA.Year
	,SUM([Ene]) [Enero]
	,SUM([Feb]) [Febrero]
	,SUM([Mar]) [Marzo]
	,SUM([Abr]) [Abril]
	,SUM([May]) [Mayo]
	,SUM([Jun]) [Junio]
	-- SUBTOTAL PRIMER SEMESTRE
	,SUM([Ene])+SUM([Feb])+SUM([Mar])+SUM([Abr])+SUM([May])+SUM([Jun])  [1erSemestre]

	,SUM([Jul]) [Julio]
	,SUM([Ago]) [Agosto]
	,SUM([Sep]) [Septiembre]
	,SUM([Oct]) [Octubre]
	,SUM([Nov]) [Noviembre]
	,SUM([Dic]) [Diciembre]

	-- SUBTOTAL PRIMER SEMESTRE
	,SUM([Ene])+SUM([Feb])+SUM([Mar])+SUM([Abr])+SUM([May])+SUM([Jun])  [1erSemestre]
	-- SUBTOTAL SEGUNDO SEMESTRE
	,SUM([Jul])+SUM([Ago])+SUM([Sep])+SUM([Oct])+SUM([Nov])+SUM([Dic]) [2doSemestre]

	-- TOTAL
	,SUM([Ene])+SUM([Feb])+SUM([Mar])+SUM([Abr])+SUM([May])+SUM([Jun])
	+SUM([Jul])+SUM([Ago])+SUM([Sep])+SUM([Oct])+SUM([Nov])+SUM([Dic]) [TotalAnual]



FROM(
 
		SELECT 
			P.[Cuenta],
			P.[AcctGroup],
			P.[Segment],
			P.Year,
			ISNULL([1],0) as [Ene],
			ISNULL([2],0) as [Feb],
			ISNULL([3],0) as [Mar],
			ISNULL([4],0) as [Abr], 
			ISNULL([5],0) as [May],
			ISNULL([6],0) as [Jun],
			ISNULL([7],0) as [Jul],
			ISNULL([8],0) as [Ago],
			ISNULL([9],0) as [Sep],
			ISNULL([10],0) as [Oct],
			ISNULL([11],0) as [Nov],
			ISNULL([12],0) as [Dic]
 
		FROM (
			SELECT
				YEAR(T0.RefDate) AS Year,
				T0.Account AS Cuenta,
				CASE T1.GroupMask
				  WHEN 1 THEN '1 Activo'
				  WHEN 2 THEN '2 Pasivo'
				  WHEN 3 THEN '3 Patrimonio'
				  WHEN 4 THEN '4 INGRESOS POR VENTA'
				  WHEN 5 THEN '5 COSTOS DE VENTA'
				  WHEN 6 THEN '6 GASTOS DE ADMNISTRACION'
				  WHEN 7 THEN '7 INGRESOS FINANCIEROS'
				  WHEN 8 THEN '8 GASTOS FINANCIEROS'
				END                      AS   AcctGroup,
				T1.AcctName              AS Nombre,
				T1.Segment_0+'-'+T1.Segment_1+'-'+T1.AcctName  AS Segment,
				T2.PrcName               AS CCosto,
				MONTH(T0.RefDate)       'Month',
				CASE 
					WHEN MONTH(T0.RefDate) = 12 THEN SUM(T0.Credit-T0.Debit) 
					ELSE 				SUM(T0.Credit-T0.Debit) 
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
				  T1.AcctName,
				  T1.Segment_0,
				  T1.Segment_1,
				  T2.PrcName,
				  YEAR(T0.RefDate),
				  MONTH(T0.RefDate)
		) P
 
		PIVOT (
			SUM(CargoAbono)
			FOR [Month] IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
		) P
) AS TABLA

GROUP BY
		TABLA.Cuenta
	   ,TABLA.AcctGroup
	   ,TABLA.Segment
	   ,TABLA.Year
ORDER BY 
        TABLA.AcctGroup