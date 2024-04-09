unit uFrmMain;

interface

uses
   Data.DB,
   FireDAC.Comp.Client,

   System.Classes,
   System.SysUtils,
   System.Variants,

   Vcl.ComCtrls,
   Vcl.Controls,
   Vcl.DBGrids,
   Vcl.Dialogs,
   Vcl.ExtCtrls,
   Vcl.Forms,
   Vcl.Graphics,
   Vcl.Grids,
   Vcl.Imaging.jpeg,
   Vcl.Imaging.pngimage,
   Vcl.StdCtrls,

   Winapi.Messages,
   Winapi.ShellAPI,
   Winapi.Windows,

   Controller.Connection,

   Common.Constants,
   Common.Libraries;

type
   TFrmMain = class(TForm)
      btnGerarRelatorio: TButton;
      cbbVendedor: TComboBox;
      edtDataFinal: TDateTimePicker;
      edtDataInicial: TDateTimePicker;
      grdMain: TDBGrid;
      imgLogo: TImage;
      lblDataFinal: TLabel;
      lblDataInicial: TLabel;
      lblVendedor: TLabel;
      pnlFiltro: TPanel;
      rdgCenarios: TRadioGroup;
      stbMain: TStatusBar;

      procedure FormCreate(Sender: TObject);
      procedure FormDestroy(Sender: TObject);
      procedure FormShow(Sender: TObject);

      procedure btnGerarRelatorioClick(Sender: TObject);
      procedure rdgCenariosClick(Sender: TObject);
   private
      procedure ListarVendedores(ACenario: integer);

      procedure DeletarArquivoPDF(AArquivoPDF: string);
      procedure AbrirArquivoPDF(AArquivoPDF: string);
      { Private declarations }
   public
      FQryFiltro: TFDQuery;
      FDatasourceFiltro: TDatasource;

      FQryComissao: TFDQuery;
      FDatasourceComissao: TDatasource;
      { Public declarations }
   end;

var
   FrmMain: TFrmMain;

implementation

uses
   uFrmReportCenario1,
   uFrmReportCenario2;

{$R *.dfm}

procedure TFrmMain.ListarVendedores(ACenario: integer);
var
   LQry: TFDQuery;
begin
   TThread.Queue(nil,
      procedure
      begin
         try
            LQry := //
               TControllerConnection //
               .Instance //
               .DAOConnection //
               .newQuery;

            cbbVendedor.Items.Clear;

            if (ACenario = 1) or (ACenario = 2) then
               cbbVendedor.Items.Add('Todos');

            if (ACenario = 0) or (ACenario = 2) then
            begin
               LQry.Open(SQL_VENDEDORES);

               if not LQry.IsEmpty then
               begin
                  LQry.First;

                  while not LQry.Eof do
                  begin
                     cbbVendedor.Items.Add(LQry.Fields[0].AsString);
                     LQry.Next;
                  end;
               end;
            end;

            cbbVendedor.ItemIndex := 0;
         finally
            FreeAndNil(LQry);
         end;
      end);
end;

procedure TFrmMain.DeletarArquivoPDF(AArquivoPDF: string);
begin
   try
      if FileExists(AArquivoPDF) then
      begin
         DeleteFile(PChar(AArquivoPDF));
      end;
   except
      on E: Exception do
      begin
         MessageBox(Handle //
            , PChar('Não foi possível deletar arquivo!' + sLineBreak + //
            E.ClassName + '. ' + E.Message) //
            , PChar(Application.Title), MB_OK + MB_ICONWARNING);

         Exit;
      end;
   end;
end;

procedure TFrmMain.AbrirArquivoPDF(AArquivoPDF: string);
begin
   if FileExists(AArquivoPDF) then
   begin
      ShellExecute(Handle, 'open', PChar(AArquivoPDF), nil, nil, 0);
   end;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
   Self.Caption := Application.Title;
   Self.Position := TPosition.poScreenCenter;

   Self.KeyPreview := True;
   Self.ShowHint := True;

   FQryFiltro := TFDQuery.Create(nil);
   FDatasourceFiltro := TDatasource.Create(nil);

   grdMain.DataSource := FDatasourceFiltro;

   FQryComissao := TFDQuery.Create(nil);
   FDatasourceComissao := TDatasource.Create(nil);
end;

procedure TFrmMain.FormShow(Sender: TObject);
begin
   edtDataInicial.Date := PrimeiroDiaDoMes(Now);
   edtDataFinal.Date := UltimoDiaDoMes(Now);

   rdgCenariosClick(Self);
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
begin
   grdMain.DataSource := nil;

   FreeAndNil(FDatasourceComissao);
   FreeAndNil(FQryComissao);

   FreeAndNil(FDatasourceFiltro);
   FreeAndNil(FQryFiltro);
end;

procedure TFrmMain.rdgCenariosClick(Sender: TObject);
begin
   ListarVendedores(rdgCenarios.ItemIndex);
end;

procedure TFrmMain.btnGerarRelatorioClick(Sender: TObject);
var
   LSQL: string;

   LDataInicial: string;
   LDataFinal: string;
   LVendedor: string;

   LArquivoPDF: string;

   LReportCenario1: TFrmReportCenario1;
   LReportCenario2: TFrmReportCenario2;
const
   cArquivoPDF = 'GESTRAN_RELAT_VENDAS_%s_CENARIO_%s.pdf';
begin
   case rdgCenarios.ItemIndex of
      0: { todo: Cenario 1 }
         begin
            {$REGION 'Cenario 1'}
            TThread.Queue(nil,
               procedure
               begin
                  {$REGION 'Executa o Filtro'}
                  FQryFiltro := //
                     TControllerConnection //
                     .Instance //
                     .DAOConnection //
                     .newQuery;

                  LDataInicial := FormatDateTime('yyyy-mm-dd', edtDataInicial.Date);
                  LDataFinal := FormatDateTime('yyyy-mm-dd', edtDataFinal.Date);
                  LVendedor := cbbVendedor.Items.Strings[cbbVendedor.ItemIndex];

                  LSQL := //
                     Format(SQL_VENDAS_PERIODO //
                     , [QuotedStr(LDataInicial), QuotedStr(LDataFinal) //
                     , 'AND VENDEDOR = ' + QuotedStr(LVendedor)]);

                  FDatasourceFiltro.DataSet := FQryFiltro;
                  FQryFiltro.Close;
                  FQryFiltro.Open(LSQL);
                  {$ENDREGION}
                  if not FQryFiltro.IsEmpty then
                  begin
                     {$REGION 'Executa a Comissao'}
                     FQryComissao := //
                        TControllerConnection //
                        .Instance //
                        .DAOConnection //
                        .newQuery;

                     LSQL := //
                        Format(SQL_VENDEDORES_RANKING //
                        , [QuotedStr(LDataInicial), QuotedStr(LDataFinal) //
                        , 'AND VR.VENDEDOR = ' + QuotedStr(LVendedor)]);

                     FDatasourceComissao.DataSet := FQryComissao;
                     FQryComissao.Close;
                     FQryComissao.Open(LSQL);
                     {$ENDREGION}
                     LReportCenario1 := TFrmReportCenario1.Create(nil);
                     try
                        {$REGION 'Mostra o Relatório'}
                        LArquivoPDF := ExtractFilePath(ParamStr(0)) + Format(cArquivoPDF, [StringReplace(UpperCase(LVendedor), ' ', '_', [rfReplaceAll]), (rdgCenarios.ItemIndex + 1).ToString]);
                        DeletarArquivoPDF(LArquivoPDF);
                        LReportCenario1.RLReportCenario1.SaveToFile(LArquivoPDF);
                        AbrirArquivoPDF(LArquivoPDF);
                        {$ENDREGION}
                     finally
                        FreeAndNil(LReportCenario1);
                     end;
                  end;
               end);
            {$ENDREGION}
         end;
      1: { todo: Cenario 2 }
         begin
            {$REGION 'Cenario 2'}
            TThread.Queue(nil,
               procedure
               begin
                  {$REGION 'Executa o Filtro'}
                  FQryFiltro := //
                     TControllerConnection //
                     .Instance //
                     .DAOConnection //
                     .newQuery;

                  LDataInicial := FormatDateTime('yyyy-mm-dd', edtDataInicial.Date);
                  LDataFinal := FormatDateTime('yyyy-mm-dd', edtDataFinal.Date);
                  LVendedor := cbbVendedor.Items.Strings[cbbVendedor.ItemIndex];

                  LSQL := //
                     Format(SQL_VENDAS_AGRUPADA_PERIODO //
                     , [QuotedStr(LDataInicial), QuotedStr(LDataFinal)]);

                  FDatasourceFiltro.DataSet := FQryFiltro;
                  FQryFiltro.Close;
                  FQryFiltro.Open(LSQL);
                  {$ENDREGION}
                  if not FQryFiltro.IsEmpty then
                  begin
                     {$REGION 'Executa a Comissao'}
                     FQryComissao := //
                        TControllerConnection //
                        .Instance //
                        .DAOConnection //
                        .newQuery;

                     LSQL := //
                        Format(SQL_VENDEDORES_RANKING //
                        , [QuotedStr(LDataInicial), QuotedStr(LDataFinal) //
                        , EmptyStr]);

                     FDatasourceComissao.DataSet := FQryComissao;
                     FQryComissao.Close;
                     FQryComissao.Open(LSQL);
                     {$ENDREGION}
                     LReportCenario2 := TFrmReportCenario2.Create(nil);
                     try
                        {$REGION 'Mostra o Relatório'}
                        LArquivoPDF := ExtractFilePath(ParamStr(0)) + Format(cArquivoPDF, [StringReplace(UpperCase(LVendedor), ' ', '_', [rfReplaceAll]), (rdgCenarios.ItemIndex + 1).ToString]);
                        DeletarArquivoPDF(LArquivoPDF);
                        LReportCenario2.RLReportCenario2.SaveToFile(LArquivoPDF);
                        AbrirArquivoPDF(LArquivoPDF);
                        {$ENDREGION}
                     finally
                        FreeAndNil(LReportCenario2);
                     end;
                  end;
               end);
            {$ENDREGION}
         end;
   end;
end;

end.
