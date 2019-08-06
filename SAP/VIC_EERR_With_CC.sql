DECLARE @ANIO SMALLINT
 
SET @ANIO = (SELECT A.Year FROM dbo.OACP A WHERE A.Year ='2018')
 
SELECT 
    P.[Cuenta],
	P.[AcctGroup],
	P.[Segment],
	SUM(ISNULL(P.[ZFI.184],0))      [ZFI.184],
	SUM(ISNULL(P.[ZFI.1010],0))     [ZFI.1010],
	SUM(ISNULL(P.[ZFI.2002],0))     [ZFI.2002],
	SUM(ISNULL(P.[ZFI.2077],0))     [ZFI.2077],
	SUM(ISNULL(P.[ZFI.1132],0))     [ZFI.1132],
	SUM(ISNULL(P.[ZFI.6115],0))     [ZFI.6115],
	SUM(ISNULL(P.[ZFI.6130],0))     [ZFI.6130],
	SUM(ISNULL(P.[ZFI.13-1],0))     [ZFI.13-1],
	SUM(ISNULL(P.[ZFI.13-2],0))     [ZFI.13-2],
	SUM(ISNULL(P.[ZFI.13-6],0))     [ZFI.13-6],
	SUM(ISNULL(P.[ZFI.1623],0))     [ZFI.1623],
	SUM(ISNULL(P.[ZFI.17SZ],0))     [ZFI.17SZ],
	SUM(ISNULL(P.[ZFI.1245],0))     [ZFI.1245],
	SUM(ISNULL(P.[ECM.2002],0))     [ECM.2002],
	SUM(ISNULL(P.[G.ADMIN],0))      [G.ADMIN],
	SUM(ISNULL(P.[G.GRAL],0))       [G.GRAL],
	SUM(ISNULL(P.[G.COMER],0))      [G.COMER],
	SUM(ISNULL(P.[G.CONTA],0))      [G.CONTA],
	SUM(ISNULL(P.[MANT],0))         [MANT],
	SUM(ISNULL(P.[INFOR],0))        [INFOR],
	SUM(ISNULL(P.[CORDOVA],0))      [CORDOVA],
	SUM(ISNULL(P.[NULL],0))         [NULL]

 
FROM (
	SELECT
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
		T1.Segment_0+'-'+T1.Segment_1+'-'+T1.AcctName  AS Segment,
		T2.PrcCode AS PrcCode,
		T2.PrcName AS CCosto,
		SUM(T0.Credit-T0.Debit)'CargoAbono' 
 
	FROM dbo.JDT1 T0
	INNER JOIN dbo.OACT T1 ON T1.AcctCode=T0.Account
	LEFT JOIN dbo.OPRC T2 ON T2.PrcCode=T0.ProfitCode
 
	WHERE YEAR(T0.RefDate)= @ANIO 
	  AND T1.GroupMask BETWEEN 1 AND 10
	  AND T1.GroupMask NOT IN (1,2,3)
	   AND T2.PrcName IS NOT NULL
	GROUP BY 
	         YEAR(T0.RefDate),
			 T0.Account,
	         T1.GroupMask,
			 T1.AcctName,
			 T1.Segment_0,
			 T1.Segment_1,
			 T2.PrcName,
			 T2.PrcCode 
) P
 
PIVOT (
	SUM(CargoAbono)
	FOR PrcCode IN ([ZFI.184],
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

GROUP BY P.Cuenta,P.AcctGroup,P.Segment
ORDER BY P.[AcctGroup]
