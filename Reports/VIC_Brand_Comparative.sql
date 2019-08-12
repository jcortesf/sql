SELECT
     /* AÑO ACTUAL */
	  ROW_NUMBER() OVER(ORDER BY T1.TotalCLP DESC) AS Rank
     ,ISNULL(T1.[Marca],T2.[Marca]) [Marca]
     ,ISNULL(T1.Cantidad,0)         [Cantidad]
     ,ISNULL(T1.TotalCLP,0)         [TotalCLP]
     ,ISNULL(T1.Media,0)            [Media]
     ,ISNULL(T1.TotalCIF,0)         [TotalCIF]  
     ,ISNULL(T1.TotalUSD,0)         [TotalUSD]
     ,ISNULL(T1.Rentabilidad,0)     [Rentabilidad]
     ,CASE
	   WHEN  ISNULL(T1.TotalCIF,0) = 0 THEN 0
	   ELSE  (ISNULL(T1.TotalUSD,0)
             /ISNULL(T1.TotalCIF,0))*ISNULL(T1.TC,0) 
	  END                           [MargenBruto]
     ,ISNULL(T1.TC,0)               [TC]
     /* AÑO ANTERIOR */
	 ,ROW_NUMBER() OVER(ORDER BY T2.TotalCLP DESC) AS Rank2
     ,ISNULL(T2.[Marca],T1.[Marca]) [Marca2]
     ,ISNULL(T2.Cantidad,0)         [Cantidad2]
     ,ISNULL(T2.TotalCLP,0)         [TotalCLP2]
     ,ISNULL(T2.Media,0)            [Media2]
     ,ISNULL(T2.TotalCIF,0)         [TotalCIF2] 
     ,ISNULL(T2.TotalUSD,0)         [TotalUSD2]
     ,ISNULL(T2.Rentabilidad,0)     [Rentabilidad2]
     ,CASE
	   WHEN  ISNULL(T2.TotalCIF,0) = 0 THEN 0
	   ELSE  (ISNULL(T2.TotalUSD,0)
             /ISNULL(T2.TotalCIF,0))*ISNULL(T2.TC,0)
	  END                           [MargenBruto2]
     ,ISNULL(T2.TC,0)               [TC2]
   /* RENTABILIDADES E INDICADORES */
   ,CASE
	   WHEN  ISNULL(T1.Cantidad,0) = 0 THEN 0
	   ELSE  ((ISNULL(T2.Cantidad,0)/ISNULL(T1.Cantidad,0))-1)*100
	END                             [%Cantidad]
   ,CASE
	   WHEN  ISNULL(T1.TotalCLP,0) = 0 THEN 0
	   ELSE  ((ISNULL(T2.TotalCLP,0)/ISNULL(T1.TotalCLP,0))-1)*100
	END                             [%TotalCLP]
   ,CASE
	   WHEN  ISNULL(T1.Media,0) = 0 THEN 0
	   ELSE  ((ISNULL(T2.Media,0)/ISNULL(T1.Media,0))-1)*100
	END                             [%Media]
   ,CASE
	   WHEN  ISNULL(T1.TotalCIF,0) = 0 THEN 0
	   ELSE  ((ISNULL(T2.TotalCIF,0)/ISNULL(T1.TotalCIF,0))-1)*100
	END                             [%TotalCIF]
   ,CASE
	   WHEN  ISNULL(T1.TotalUSD,0) = 0 THEN 0
	   ELSE  ((ISNULL(T2.TotalUSD,0)/ISNULL(T1.TotalUSD,0))-1)*100
	END                             [%TotalUSD]
   ,CASE
	   WHEN  ISNULL(T2.TotalCIF,0) = 0 OR ISNULL(T1.TotalUSD,0) = 0 OR ISNULL(T1.TotalCIF,0) = 0 THEN 0
	   ELSE  (((((ISNULL(T2.TotalUSD,0)/ISNULL(T2.TotalCIF,0))*ISNULL(T2.TC,0))
   /((ISNULL(T1.TotalUSD,0)/ISNULL(T1.TotalCIF,0))*ISNULL(T1.TC,0)))-1)*100)
    END                             [%Margen]
   ,[SBO_Imp_Eximben_SAC].[dbo].[stockMarcaSlim](T2.[Marca]) [Stock]
   
  FROM
(SELECT 
       /*[Empresa] 
      ,*/[Marca] 
      ,SUM([Cantidad]) [Cantidad] 
      ,SUM([TotalCLP]) [TotalCLP] 
      ,SUM([TotalCLP]) / NULLIF(SUM([Cantidad]),0) [Media] 
      ,SUM([TotalCIF]) [TotalCIF] ,SUM([TotalUSD]) [TotalUSD] 
    ,(((SUM([TotalUSD]) - SUM([TotalCIF]))*100) /SUM([TotalUSD])) [Rentabilidad]
    ,(SUM([TotalCLP]) /SUM([TotalUSD])) [TC]
 FROM [SBO_Imp_Eximben_SAC].[dbo].[VIC_VW_VTASREPROSLIM]
WHERE (DocDate >= DATEADD (m, DATEDIFF (m, 0, GETDATE ()), 0))
  AND (DocDate <= CAST(GETDATE() AS DATE)) 
  AND Empresa NOT LIKE 'EXB_AEROP'
  AND TipoProducto = 'Producto Regular'
GROUP BY [Marca]
  ) AS T1 FULL OUTER JOIN  (SELECT 
       /*[Empresa]
      ,*/[Marca]
      ,SUM([Cantidad]) [Cantidad] 
      ,SUM([TotalCLP]) [TotalCLP] 
      ,SUM([TotalCLP]) / NULLIF(SUM([Cantidad]),0) [Media] 
      ,SUM([TotalCIF]) [TotalCIF] ,SUM([TotalUSD]) [TotalUSD] 
    ,(((SUM([TotalUSD]) - SUM([TotalCIF]))*100) /SUM([TotalUSD])) [Rentabilidad]
    ,(SUM([TotalCLP]) /SUM([TotalUSD])) [TC]
 FROM [SBO_Imp_Eximben_SAC].[dbo].[VIC_VW_VTASREPROSLIM]
  WHERE 1=1
     AND (DocDate >= DATEADD(year, -1, DATEADD (m, DATEDIFF (m, 0, GETDATE ()), 0)))  
     AND (DocDate <= DATEADD(year, -1,GETDATE()))
  AND Empresa NOT LIKE 'EXB_AEROP'
  AND TipoProducto = 'Producto Regular'
GROUP BY /*[Empresa] ,*/[Marca]
  ) AS T2 ON T1.[Marca] = T2.[Marca]
   ORDER BY  T1.[TotalCLP] DESC
    