SELECT 
     TABLA.Cuenta
    ,TABLA.AcctGroup
	,TABLA.Segment
	,SUM([EneOld]) [EneroOld]
	,SUM([Ene])    [Enero]

	,SUM([FebOld]) [FebreroOld]
	,SUM([Feb])    [Febrero]

	,SUM([MarOld]) [MarzoOld]
	,SUM([Mar])    [Marzo]

	,SUM([AbrOld]) [AbrilOld]
	,SUM([Abr])    [Abril]

	,SUM([MayOld]) [MayoOld]
	,SUM([May])    [Mayo]

	,SUM([JunOld]) [JunioOld]
	,SUM([Jun])    [Junio]

	--

	,SUM([JulOld]) [JulioOld]
	,SUM([Jul])    [Julio]

	,SUM([AgoOld]) [AgostoOld]
	,SUM([Ago])    [Agosto]

	,SUM([SepOld]) [SeptiembreOld]
	,SUM([Sep])    [Septiembre]

	,SUM([OctOld]) [OctubreOld]
	,SUM([Oct])    [Octubre]

	,SUM([NovOld]) [NoviembreOld]
	,SUM([Nov])    [Noviembre]

	,SUM([DicOld]) [DiciembreOld]
	,SUM([Dic])    [Diciembre]

FROM(
		SELECT 
					P.[Cuenta],
					P.[AcctGroup],
					P.[Segment],
					P.Year,
					ISNULL(P.[1],0) as [Ene],
					ISNULL(P.[2],0) as [Feb],
					ISNULL(P.[3],0) as [Mar],
					ISNULL(P.[4],0) as [Abr], 
					ISNULL(P.[5],0) as [May],
					ISNULL(P.[6],0) as [Jun],
					ISNULL(P.[7],0) as [Jul],
					ISNULL(P.[8],0) as [Ago],
					ISNULL(P.[9],0) as [Sep],
					ISNULL(P.[10],0) as [Oct],
					ISNULL(P.[11],0) as [Nov],
					ISNULL(P.[12],0) as [Dic],

					ISNULL(P.[OLD-01],0) as [EneOld],
					ISNULL(P.[OLD-02],0) as [FebOld],
					ISNULL(P.[OLD-03],0) as [MarOld],
					ISNULL(P.[OLD-04],0) as [AbrOld], 
					ISNULL(P.[OLD-05],0) as [MayOld],
					ISNULL(P.[OLD-06],0) as [JunOld],
					ISNULL(P.[OLD-07],0) as [JulOld],
					ISNULL(P.[OLD-08],0) as [AgoOld],
					ISNULL(P.[OLD-09],0) as [SepOld],
					ISNULL(P.[OLD-10],0) as [OctOld],
					ISNULL(P.[OLD-11],0) as [NovOld],
					ISNULL(P.[OLD-12],0) as [DicOld]
 
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
								--'OLD-'+MONTH(T0.RefDate)              'Month2',
								'OLD-'+
								REPLACE(STR(MONTH(T0.RefDate),2,0),' ', 0)   [Periodo],
								DATENAME(MONTH,T0.RefDate)       'MonthName',
								CASE
									WHEN YEAR(T0.RefDate) = YEAR(DATEADD(year,-1,GETDATE())) THEN 
									CASE
										WHEN MONTH(T0.RefDate) = 12 THEN SUM(T0.Credit-T0.Debit)
										ELSE                SUM(T0.Credit-T0.Debit)
									END 
								END  'CargoAbono',
								CASE
								WHEN YEAR(T0.RefDate) = YEAR(GETDATE())THEN
									CASE
										WHEN MONTH(T0.RefDate) = 12 THEN SUM(T0.Credit-T0.Debit)
										ELSE                SUM(T0.Credit-T0.Debit)
									END 
								END 'CargoAbono2'
							FROM dbo.JDT1 T0
							INNER JOIN dbo.OACT T1 ON T1.AcctCode=T0.Account
							LEFT JOIN dbo.OPRC T2 ON T2.PrcCode=T0.ProfitCode
							WHERE YEAR(T0.RefDate) IN (2018,2019) AND T1.GroupMask BETWEEN 1 AND 10
								AND T1.GroupMask NOT IN (1,2,3)
								--AND T2.PrcName IS NOT NULL
								--AND T0.Account = '_SYS00000000149'
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
					FOR [Month] IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
				) P
		
				PIVOT (
					SUM(CargoAbono2)
					FOR [Periodo] IN ([OLD-01],[OLD-02],[OLD-03],[OLD-04],[OLD-05],[OLD-06],[OLD-07],[OLD-08],[OLD-09],[OLD-10],[OLD-11],[OLD-12])
				) P

) AS TABLA

GROUP BY
		TABLA.Cuenta
	   ,TABLA.AcctGroup
	   ,TABLA.Segment
ORDER BY 
        TABLA.AcctGroup