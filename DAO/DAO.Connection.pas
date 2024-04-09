unit DAO.Connection;

interface

uses
   Data.DB,

   FireDAC.Comp.Client,
   FireDAC.Comp.DataSet,
   FireDAC.DApt,
   FireDAC.DApt.Intf,
   FireDAC.DatS,
   FireDAC.Phys,
   FireDAC.Phys.Intf,
   FireDAC.Phys.Meta,
   FireDAC.Stan.ASync,
   FireDAC.Stan.Def,
   FireDAC.Stan.Error,
   FireDAC.Stan.Intf,
   FireDAC.Stan.Option,
   FireDAC.Stan.Param,
   FireDAC.Stan.Pool,
   FireDAC.UI.Intf,
   FireDAC.VCLUI.Wait,

   {$IF COMPILERVERSION >= 33}
   FireDAC.Phys.MSSQLDef,
   FireDAC.Phys.MSSQLCli,
   FireDAC.Phys.MSSQLWrapper,
   {$ENDIF}
   FireDAC.Phys.ODBCBase,
   FireDAC.Phys.MSSQL,
   FireDAC.Phys.MSSQLMeta,

   System.Classes,
   System.IniFiles,
   System.SysUtils,

   Vcl.Dialogs,
   Vcl.Forms;

type
   TDAOConnection = class
   private
      class var FDriver: TFDPhysMSSQLDriverLink;
      class var FConn: TFDConnection;
   public
      constructor Create;
      destructor Destroy; override;

      class function getConnection: TFDConnection;
      class function newQuery: TFDQuery;
   end;

implementation

uses
   Common.Libraries;

constructor TDAOConnection.Create;
var
   LIniFile: TIniFile;
begin
   inherited Create;

   FDriver := TFDPhysMSSQLDriverLink.Create(nil);
   FConn := TFDConnection.Create(nil);

   FConn.LoginPrompt := False;
   FConn.FetchOptions.Mode := fmAll;
   FConn.ResourceOptions.SilentMode := True;
   FConn.Params.Clear;

   FConn.DriverName := 'MSSQL';
   {$IF COMPILERVERSION >= 33}
   FConn.Params.DriverID := 'MSSQL';
   {$ENDIF}
   FConn.Params.Values['Server'] := LoadIni('DB', 'SERVER', EmptyStr);
   FConn.Params.Values['Port'] := LoadIni('DB', 'PORT', EmptyStr);
   FConn.Params.Values['Database'] := LoadIni('DB', 'DATABASE', EmptyStr);
   FConn.Params.Values['User_Name'] := LoadIni('DB', 'USERNAME', EmptyStr);
   FConn.Params.Values['Password'] := LoadIni('DB', 'PASSWORD', EmptyStr);

   try
      FConn.ExecSQL('SET DATEFORMAT YMD');
   except
      on E: Exception do
      begin
         ShowMessage( //
            'Não foi possível acessar o banco de dados!' + sLineBreak + //
            'Favor vericar os dados de acesso.' + sLineBreak + //
            EmptyStr + sLineBreak + //
            E.ClassName + '. ' + E.Message);

         Application.Terminate;
      end;
   end;
end;

destructor TDAOConnection.Destroy;
begin
   FreeAndNil(FConn);
   FreeAndNil(FDriver);

   inherited;
end;

class function TDAOConnection.getConnection: TFDConnection;
begin
   Result := FConn;
end;

class function TDAOConnection.newQuery: TFDQuery;
var
   LQry: TFDQuery;
begin
   LQry := TFDQuery.Create(nil);
   LQry.Name := 'Qry' + FormatDateTime('yyyymmddhhnnsszzz', Now);
   LQry.Connection := FConn;
   Result := LQry;
end;

end.
