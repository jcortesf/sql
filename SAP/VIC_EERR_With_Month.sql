DECLARE @ANIO SMALLINT
 
SET @ANIO = (SELECT A.Year FROM dbo.OACP A WHERE A.Year='2018')
 
SELECT 
	P.[Cuenta],
	P.[AcctGroup],
	P.[Nombre],
	P.[CCosto],
	[1] as [Ene],
	[2] as [Feb],
	[3] as [Mar],
	[4] as [Abr], 
	[5] as [May],
	[6] as [Jun],
	[7] as [Jul],
	[8] as [Ago],
	[9] as [Sep],
	[10] as [Oct],
	[11] as [Nov],
	[12] as [Dic]
 
FROM (
	SELECT
		T0.Account AS Cuenta,
		CASE T1.GroupMask
          WHEN 1 THEN '1 Activo'
          WHEN 2 THEN '2 Pasivo'
          WHEN 3 THEN '3 Patrimonio'
          WHEN 4 THEN '4 Ingresos Oper.'
          WHEN 5 THEN '5 Costos Oper.'
          WHEN 6 THEN '6 Gastos Oper.'
          WHEN 7 THEN '7 Otros Ingresos'
          WHEN 8 THEN '8 Otros Gastos'
        END                      AS   AcctGroup,
		T1.AcctName              AS Nombre,
		T2.PrcName               AS CCosto,
		MONTH(T0.RefDate)       'Month',
		SUM(T0.Credit-T0.Debit) 'CargoAbono' 
 
	FROM dbo.JDT1 T0
	INNER JOIN dbo.OACT T1 ON T1.AcctCode=T0.Account
	LEFT JOIN dbo.OPRC T2 ON T2.PrcCode=T0.ProfitCode
 
	WHERE YEAR(T0.RefDate)=@ANIO AND T1.GroupMask BETWEEN 1 AND 10
	  AND T1.GroupMask NOT IN (1,2,3)
	  AND T2.PrcName IS NOT NULL
	GROUP BY 
	      T0.Account,
	      T1.GroupMask,
		  T1.AcctName,
		  T2.PrcName,
		  MONTH(T0.RefDate)
) P
 
PIVOT (
	SUM(CargoAbono)
	FOR [Month] IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
) P
 
ORDER BY P.[AcctGroup]