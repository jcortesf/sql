SELECT 
     TABLA.Cuenta
    ,TABLA.AcctGroup
	,TABLA.Segment

	,SUM(ISNULL([ZFI.184],0))     as [ZFI.184]
	,SUM(ISNULL([OLDZFI.184],0))  as [OLDZFI.184]

	,SUM(ISNULL([ZFI.1010],0))    as [ZFI.1010]
	,SUM(ISNULL([OLDZFI.1010],0)) as [OLDZFI.1010]

	,SUM(ISNULL([ZFI.2002],0))    as [ZFI.2002]
	,SUM(ISNULL([OLDZFI.2002],0)) as [OLDZFI.2002]

	,SUM(ISNULL([ZFI.2077],0))    as [ZFI.2077]
	,SUM(ISNULL([OLDZFI.2077],0)) as [OLDZFI.2077] 

	,SUM(ISNULL([ZFI.1132],0))    as [ZFI.1132]
	,SUM(ISNULL([OLDZFI.1132],0)) as [OLDZFI.1132]

	,SUM(ISNULL([ZFI.6115],0))    as [ZFI.6115]
	,SUM(ISNULL([OLDZFI.6115],0)) as [OLDZFI.6115]

	,SUM(ISNULL([ZFI.6130],0))    as [ZFI.6130]
	,SUM(ISNULL([OLDZFI.6130],0)) as [OLDZFI.6130]

	,SUM(ISNULL([ZFI.13-1],0))    as [ZFI.13-1]
	,SUM(ISNULL([OLDZFI.13-1],0)) as [OLDZFI.13-1]

	,SUM(ISNULL([ZFI.13-2],0))    as [ZFI.13-2]
	,SUM(ISNULL([OLDZFI.13-2],0)) as [OLDZFI.13-2]

	,SUM(ISNULL([ZFI.13-6],0))    as [ZFI.13-6]
	,SUM(ISNULL([OLDZFI.13-6],0)) as [OLDZFI.13-6]

	,SUM(ISNULL([ZFI.1623],0))    as [ZFI.1623]
	,SUM(ISNULL([OLDZFI.1623],0)) as [OLDZFI.1623]

	,SUM(ISNULL([ZFI.17SZ],0))    as [ZFI.17SZ]
	,SUM(ISNULL([OLDZFI.17SZ],0)) as [OLDZFI.17SZ]

	,SUM(ISNULL([ZFI.1245],0))    as [ZFI.1245]
	,SUM(ISNULL([OLDZFI.1245],0)) as [OLDZFI.1245]

	,SUM(ISNULL([ECM.2002],0))    as [ECM.2002]
	,SUM(ISNULL([OLDECM.2002],0)) as [OLDECM.2002]

	,SUM(ISNULL([G.GRAL],0))      as [G.GRAL]
	,SUM(ISNULL([OLDG.GRAL],0))   as [OLDG.GRAL]

	,SUM(ISNULL([G.COMER],0))     as [G.COMER]
	,SUM(ISNULL([OLDG.COMER],0))  as [OLDG.COMER]

	,SUM(ISNULL([G.CONTA],0))     as [G.CONTA]
	,SUM(ISNULL([OLDG.CONTA],0))  as [OLDG.CONTA]

	,SUM(ISNULL([MANT],0))        as [MANT]
	,SUM(ISNULL([OLDMANT],0))     as [OLDMANT]

	,SUM(ISNULL([INFOR],0))       as [INFOR]
	,SUM(ISNULL([OLDINFOR],0))    as [OLDINFOR]

	,SUM(ISNULL([CORDOVA],0))     as [CORDOVA]
	,SUM(ISNULL([OLDCORDOVA],0))  as [OLDCORDOVA]

	,SUM(ISNULL([NULL],0))        as [NULL]
	,SUM(ISNULL([OLDNULL],0))     as [OLDNULL]

	--

	
FROM(
		SELECT 
					P.[Cuenta],
					P.[AcctGroup],
					P.[Segment],
					P.Year,
					ISNULL(P.[ZFI.184],0)  as [ZFI.184],
					ISNULL(P.[ZFI.1010],0) as [ZFI.1010],
					ISNULL(P.[ZFI.2002],0) as [ZFI.2002],
					ISNULL(P.[ZFI.2077],0) as [ZFI.2077], 
					ISNULL(P.[ZFI.1132],0) as [ZFI.1132],
					ISNULL(P.[ZFI.6115],0) as [ZFI.6115],
					ISNULL(P.[ZFI.6130],0) as [ZFI.6130],
					ISNULL(P.[ZFI.13-1],0) as [ZFI.13-1],
					ISNULL(P.[ZFI.13-2],0) as [ZFI.13-2],
					ISNULL(P.[ZFI.13-6],0) as [ZFI.13-6],
					ISNULL(P.[ZFI.1623],0) as [ZFI.1623],
					ISNULL(P.[ZFI.17SZ],0) as [ZFI.17SZ],
					ISNULL(P.[ZFI.1245],0) as [ZFI.1245],
					ISNULL(P.[ECM.2002],0) as [ECM.2002],
					ISNULL(P.[G.GRAL],0)   as [G.GRAL],
					ISNULL(P.[G.COMER],0)  as [G.COMER],
					ISNULL(P.[G.CONTA],0)  as [G.CONTA],
					ISNULL(P.[MANT],0)     as [MANT],
					ISNULL(P.[INFOR],0)    as [INFOR],
					ISNULL(P.[CORDOVA],0)  as [CORDOVA],
					ISNULL(P.[NULL],0)     as [NULL],

					ISNULL(P.[OLDZFI.184],0)  as [OLDZFI.184],
					ISNULL(P.[OLDZFI.1010],0) as [OLDZFI.1010],
					ISNULL(P.[OLDZFI.2002],0) as [OLDZFI.2002],
					ISNULL(P.[OLDZFI.2077],0) as [OLDZFI.2077], 
					ISNULL(P.[OLDZFI.1132],0) as [OLDZFI.1132],
					ISNULL(P.[OLDZFI.6115],0) as [OLDZFI.6115],
					ISNULL(P.[OLDZFI.6130],0) as [OLDZFI.6130],
					ISNULL(P.[OLDZFI.13-1],0) as [OLDZFI.13-1],
					ISNULL(P.[OLDZFI.13-2],0) as [OLDZFI.13-2],
					ISNULL(P.[OLDZFI.13-6],0) as [OLDZFI.13-6],
					ISNULL(P.[OLDZFI.1623],0) as [OLDZFI.1623],
					ISNULL(P.[OLDZFI.17SZ],0) as [OLDZFI.17SZ],
					ISNULL(P.[OLDZFI.1245],0) as [OLDZFI.1245],
					ISNULL(P.[OLDECM.2002],0) as [OLDECM.2002],
					ISNULL(P.[OLDG.GRAL],0)   as [OLDG.GRAL],
					ISNULL(P.[OLDG.COMER],0)  as [OLDG.COMER],
					ISNULL(P.[OLDG.CONTA],0)  as [OLDG.CONTA],
					ISNULL(P.[OLDMANT],0)     as [OLDMANT],
					ISNULL(P.[OLDINFOR],0)    as [OLDINFOR],
					ISNULL(P.[OLDCORDOVA],0)  as [OLDCORDOVA],
					ISNULL(P.[OLDNULL],0)     as [OLDNULL]
					
				
 
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
								T2.PrcCode               AS CCostoCode,
								'OLD'+T2.PrcCode        AS CCostoCodeOld,
								MONTH(T0.RefDate)                'Month',
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
							WHERE YEAR(T0.RefDate) IN (2018,2019)
							    AND MONTH(T0.RefDate) <= MONTH (DATEADD(m,-1,GETDATE()))
							    AND T1.GroupMask BETWEEN 1 AND 10
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
									T2.PrcCode,
									YEAR(T0.RefDate),
									DATENAME(MONTH,T0.RefDate),
									MONTH(T0.RefDate)
				) P
 
				PIVOT (
					SUM(CargoAbono)
					FOR [CCostoCode] IN ([ZFI.184],
									[ZFI.1010],
									[ZFI.2002],
									[ZFI.2077],
									[ZFI.1132],
									[ZFI.6115],
									[ZFI.6130],
									[ZFI.13-1],
									[ZFI.13-2],
									[ZFI.13-6],
									[ZFI.1623],
									[ZFI.17SZ],
									[ZFI.1245],
									[ECM.2002],
									[G.ADMIN],
									[G.GRAL],
									[G.COMER],
									[G.CONTA],
									[MANT],
									[INFOR],
									[CORDOVA],
									[NULL]
									)
				) P
		
				PIVOT (
					SUM(CargoAbono2)
					FOR [CCostoCodeOld]  IN ([OLDZFI.184],
										[OLDZFI.1010],
										[OLDZFI.2002],
										[OLDZFI.2077],
										[OLDZFI.1132],
										[OLDZFI.6115],
										[OLDZFI.6130],
										[OLDZFI.13-1],
										[OLDZFI.13-2],
										[OLDZFI.13-6],
										[OLDZFI.1623],
										[OLDZFI.17SZ],
										[OLDZFI.1245],
										[OLDECM.2002],
										[OLDG.ADMIN],
										[OLDG.GRAL],
										[OLDG.COMER],
										[OLDG.CONTA],
										[OLDMANT],
										[OLDINFOR],
										[OLDCORDOVA],
										[OLDNULL]
										)
				) P

) AS TABLA

GROUP BY
		TABLA.Cuenta
	   ,TABLA.AcctGroup
	   ,TABLA.Segment
ORDER BY 
        TABLA.AcctGroup

		--SELECT MONTH (DATEADD(m,-1,GETDATE())) 'Ayer'