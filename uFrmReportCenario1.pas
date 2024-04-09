unit uFrmReportCenario1;

interface

uses
   Data.DB,
   FireDAC.Comp.Client,

   RLConsts,
   RLFilters,
   RLPDFFilter,
   RLReport,
   RLTypes,
   RLUtils,

   System.SysUtils,
   System.Variants,
   System.Classes,

   Vcl.Graphics,
   Vcl.Controls,
   Vcl.Forms,
   Vcl.Dialogs,
   Vcl.Imaging.jpeg,

   Winapi.Windows,
   Winapi.Messages,

   Controller.Connection,

   Common.Constants,
   Common.Libraries;

type
   TFrmReportCenario1 = class(TForm)
      bndCabecalho: TRLBand;
      bndColunas: TRLBand;
      bndDetalhes: TRLBand;
      bndRodape: TRLBand;
      bndSumario: TRLBand;
      imgLogo: TRLImage;
      lblData: TRLDBText;
      lblDataHora: TRLSystemInfo;
      lblData_: TRLLabel;
      lblDesconto: TRLDBText;
      lblDesconto_: TRLLabel;
      lblIdVenda: TRLDBText;
      lblIdVenda_: TRLLabel;
      lblPagina: TRLSystemInfo;
      lblResumo_: TRLLabel;
      lblSeparador: TRLLabel;
      lblTitulo: TRLLabel;
      lblTotal: TRLDBText;
      lblTotalComissao: TRLDBText;
      lblTotalComissao_: TRLLabel;
      lblTotalDesconto: TRLDBResult;
      lblTotalGeral: TRLDBResult;
      lblTotalVendas: TRLDBResult;
      lblTotal_: TRLLabel;
      lblUltimaPagina: TRLSystemInfo;
      lblVenda: TRLDBText;
      lblVendas_: TRLLabel;
      lblVendedor: TRLDBText;
      lblVendedor_: TRLLabel;
      RLLabel1: TRLLabel;
      RLPDFFilter: TRLPDFFilter;
      RLReportCenario1: TRLReport;

      procedure FormCreate(Sender: TObject);
   private
      procedure ConfigurarComponentes;
      { Private declarations }
   public

      { Public declarations }
   end;

var
   FrmReportCenario1: TFrmReportCenario1;

implementation
{$R *.dfm}

uses
   uFrmMain;

procedure TFrmReportCenario1.ConfigurarComponentes;
var
   LInt: integer;
begin
   for LInt := 0 to Pred(Self.ComponentCount) do
   begin
      if Components[LInt] is TRLReport then
      begin
         TRLReport(Components[LInt]).DataSource := FrmMain.FDatasourceFiltro;
      end;

      if Components[LInt] is TRLBand then
      begin
         TRLBand(Components[LInt]).Options := [boOptimisticPageBreak];
      end;

      if Components[LInt] is TRLDBText then
      begin
         if (TRLDBText(Components[LInt]).Tag = 0) then
            TRLDBText(Components[LInt]).DataSource := FrmMain.FDatasourceFiltro;

         if (TRLDBText(Components[LInt]).Tag = 1) then
            TRLDBText(Components[LInt]).DataSource := FrmMain.FDatasourceComissao;
      end;

      if Components[LInt] is TRLDBResult then
      begin
         TRLDBResult(Components[LInt]).DataSource := FrmMain.FDatasourceFiltro;
      end;
   end;

   RLPDFFilter.DocumentInfo.Title := 'GESTRAN - Relatório de Vendas (Cenário 1)';
   RLPDFFilter.DocumentInfo.Subject := //
      'por Período ( de ' + FormatDateTime('dd/mm/yyyy', FrmMain.edtDataInicial.Date) + //
      ' até ' + FormatDateTime('dd/mm/yyyy', FrmMain.edtDataFinal.Date);
   RLPDFFilter.DocumentInfo.Creator := 'Relatório gerado pelo Sistema da Gestran';
   RLPDFFilter.DocumentInfo.Producer := 'Versão 1.0.0.0';
end;

procedure TFrmReportCenario1.FormCreate(Sender: TObject);
const
   maskValue = ',.00';
begin
   ConfigurarComponentes;

   lblIdVenda.DataField := 'IdVenda';
   lblData.DataField := 'Data';
   lblVendedor.DataField := 'Vendedor';

   lblVenda.DataField := 'Venda';
   lblVenda.DisplayMask := maskValue;

   lblDesconto.DataField := 'Desconto';
   lblDesconto.DisplayMask := maskValue;

   lblTotal.DataField := 'Total';
   lblTotal.DisplayMask := maskValue;

   lblTotalVendas.DataField := 'Venda';
   lblTotalVendas.Info := TRLResultInfo.riSum;
   lblTotalVendas.DisplayMask := maskValue;

   lblTotalDesconto.DataField := 'Desconto';
   lblTotalDesconto.Info := TRLResultInfo.riSum;
   lblTotalDesconto.DisplayMask := maskValue;

   lblTotalGeral.DataField := 'Total';
   lblTotalGeral.Info := TRLResultInfo.riSum;
   lblTotalGeral.DisplayMask := maskValue;

   lblTotalComissao.DataField := 'Comissao';
   lblTotalComissao.DisplayMask := maskValue;
end;

end.
