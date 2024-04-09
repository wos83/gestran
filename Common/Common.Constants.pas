unit Common.Constants;

interface

const
   SQL_VENDEDORES = //
      'SELECT DISTINCT(Vendedor) as Vendedor' + sLineBreak + //
      'FROM VENDAS WITH (NOLOCK)' + sLineBreak + //
      'WHERE 1 = 1' + sLineBreak + //
      '';

   SQL_VENDAS = //
      'SELECT' + sLineBreak + //
      '"Id da Venda" as IdVenda' + sLineBreak + //
      ',"Data" as Data' + sLineBreak + //
      ',"Vendedor" as Vendedor' + sLineBreak + //
      ',CAST("Valor da Venda" AS FLOAT) as Venda' + sLineBreak + //
      ',CAST("Valor do Desconto" AS FLOAT) as Desconto' + sLineBreak + //
      ',CAST("Valor Total" AS FLOAT) as Total' + sLineBreak + //
      'FROM VENDAS WITH (NOLOCK)' + sLineBreak + //
      'WHERE 1 = 1' + sLineBreak + //
      '';

   SQL_VENDAS_PERIODO = //
      SQL_VENDAS + //
      'AND "Data" BETWEEN %s AND %s' + sLineBreak + //
      '%s' + sLineBreak + //
      'ORDER BY "Data"';

   SQL_VENDAS_AGRUPADA_PERIODO = //
      'SELECT' + sLineBreak + //
      '    "Id da Venda" as IdVenda' + sLineBreak + //
      '    ,"Data" as Data' + sLineBreak + //
      '	  ,"Vendedor" as Vendedor' + sLineBreak + //
      '    ,CAST(SUM("Valor da Venda") AS FLOAT) as Venda' + sLineBreak + //
      '    ,CAST(SUM("Valor do Desconto") AS FLOAT) as Desconto' + sLineBreak + //
      '    ,CAST(SUM("Valor Total") AS FLOAT) as Total' + sLineBreak + //
      'FROM VENDAS' + sLineBreak + //
      'WHERE 1 = 1' + sLineBreak + //
      'AND "Data" BETWEEN %s AND %s' + sLineBreak + //
      'GROUP BY' + sLineBreak + //
      '    "Id da Venda"' + sLineBreak + //
      '    ,"Data"' + sLineBreak + //
      '    ,Vendedor' + sLineBreak + //
      'ORDER BY' + sLineBreak + //
      '     Vendedor' + sLineBreak + //
      '    ,"Data"' + sLineBreak + //
      '';

   SQL_VENDEDORES_RANKING = //
      'WITH VENDEDORES_RANKING AS (                                       ' + sLineBreak + //
      '   SELECT                                                          ' + sLineBreak + //
      '   "Vendedor",                                                     ' + sLineBreak + //
      '   SUM("Valor Total") AS "Total de Vendas",                        ' + sLineBreak + //
      '   DENSE_RANK() OVER (ORDER BY SUM("Valor Total") ASC) AS Ranking  ' + sLineBreak + //
      'FROM                                                               ' + sLineBreak + //
      '   VENDAS  WITH (NOLOCK)                                           ' + sLineBreak + //
      'WHERE 1 = 1                                                        ' + sLineBreak + //
      '   AND "Data" BETWEEN %s AND %s                                    ' + sLineBreak + //
      'GROUP BY                                                           ' + sLineBreak + //
      '   "Vendedor"                                                      ' + sLineBreak + //
      ')                                                                  ' + sLineBreak + //
      '   SELECT                                                          ' + sLineBreak + //
      '      VR."Vendedor",                                               ' + sLineBreak + //
      '      VR."Total de Vendas",                                        ' + sLineBreak + //
      '      CASE                                                         ' + sLineBreak + //
      '      WHEN VR.Ranking = 1 THEN  VR."Total de Vendas" * 0.05        ' + sLineBreak + //
      '      WHEN VR.Ranking = 2 THEN  VR."Total de Vendas" * 0.10        ' + sLineBreak + //
      '      WHEN VR.Ranking = 3 THEN (VR."Total de Vendas" * 0.10) * 1.2 ' + sLineBreak + //
      '      END AS "Comissao"                                            ' + sLineBreak + //
      '   FROM                                                            ' + sLineBreak + //
      '      VENDEDORES_RANKING VR                                        ' + sLineBreak + //
      '   WHERE 1 = 1                                                     ' + sLineBreak + //
      '   %s                                                              ' + sLineBreak + //
      '   ORDER BY                                                        ' + sLineBreak + //
      '      VR.Ranking                                                   ' + sLineBreak + //
      '';

implementation
end.
