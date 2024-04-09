program RelatorioVendas;

uses
   System.ShareMem,
   Vcl.Forms,

   Controller.Connection in 'DAO\Controller.Connection.pas',
   DAO.Connection in 'DAO\DAO.Connection.pas',

   Common.Libraries in 'Common\Common.Libraries.pas',
   Common.Constants in 'Common\Common.Constants.pas',

   uFrmReportCenario1 in 'uFrmReportCenario1.pas' {FrmReportCenario1} ,
   uFrmReportCenario2 in 'uFrmReportCenario2.pas' {FrmReportCenario2} ,
   uFrmMain in 'uFrmMain.pas' {FrmMain} ,

   Vcl.Themes,
   Vcl.Styles;

{$R *.res}

begin
   Application.Initialize;
   TStyleManager.TrySetStyle('Luna');
   Application.Title := 'GESTRAN - Relatório de Vendas';
   Application.MainFormOnTaskbar := True;
   Application.CreateForm(TFrmMain, FrmMain);
   Application.Run;
end.
