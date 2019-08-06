DECLARE @ANIO SMALLINT
 
SET @ANIO = (SELECT A.Year FROM dbo.OACP A WHERE A.Year ='2015')
 
SELECT 
	P.[Cuenta],
	P.[AcctGroup],
	P.[Nombre],
	P.[PrcCode],
	P.[CCosto],
	isnull([2015],0) as [2015],
	isnull([2016],0) as [2016],
	isnull([2017],0) as [2017],
	isnull([2018],0) as [2018],
	isnull([2019],0) as [2019]
	--isnull([2015],0)+isnull([2016],0)+isnull([2017],0) as [Total]
 
FROM (
	SELECT
	    YEAR(T0.RefDate) AS Year,
		T0.Account AS Cuenta,
		CASE T1.GroupMask
          WHEN 1 THEN '1 Activo'
          WHEN 2 THEN '2 Pasivo'
          WHEN 3 THEN '3 Patrimonio'
		  -- No van cuentas superiores
          WHEN 4 THEN '4 Ingresos Oper.'
          WHEN 5 THEN '5 Costos Oper.'
          WHEN 6 THEN '6 Gastos Oper.'
          WHEN 7 THEN '7 Otros Ingresos'
          WHEN 8 THEN '8 Otros Gastos'
        END                                    AS   AcctGroup,
		T1.AcctName AS Nombre,
		T2.PrcCode AS PrcCode,
		T2.PrcName AS CCosto,
		MONTH(T0.RefDate)'Month',
		SUM(T0.Credit-T0.Debit)'CargoAbono' 
 
	FROM dbo.JDT1 T0
	INNER JOIN dbo.OACT T1 ON T1.AcctCode=T0.Account
	LEFT JOIN dbo.OPRC T2 ON T2.PrcCode=T0.ProfitCode
 
	WHERE YEAR(T0.RefDate)>= @ANIO 
	  AND T1.GroupMask BETWEEN 1 AND 10
	  AND T1.GroupMask NOT IN (1,2,3)
	  AND T2.PrcName IS NOT NULL
	GROUP BY YEAR(T0.RefDate), T0.Account,
	T1.GroupMask, T1.AcctName, T2.PrcName,T2.PrcCode ,MONTH(T0.RefDate)
) P
 
PIVOT (
	SUM(CargoAbono)
	FOR [Year] IN ([2015],[2016],[2017],[2018],[2019])
) P
 
ORDER BY P.[AcctGroup]