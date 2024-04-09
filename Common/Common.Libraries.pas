unit Common.Libraries;

interface

uses
   System.Classes,
   System.DateUtils,
   System.IniFiles,
   System.SysUtils;

procedure SaveIni(ASession, AField, AValue: string);
function LoadIni(ASession, AField, AValue: string): string;

function PrimeiroDiaDoMes(AData: TDateTime): TDateTime;
function UltimoDiaDoMes(AData: TDateTime): TDateTime;

implementation

procedure SaveIni(ASession, AField, AValue: string);
var
   LFile: string;
   LFileIni: TIniFile;
begin
   LFile := ExtractFilePath(ParamStr(0)) + ExtractFileName(ChangeFileExt(ParamStr(0), '.ini'));

   LFileIni := TIniFile.Create(LFile);
   try
      LFileIni.WriteString(ASession, AField, AValue);
      LFileIni.UpdateFile;
   finally
      FreeAndNil(LFileIni);
   end;
end;

function LoadIni(ASession, AField, AValue: string): string;
var
   LFile: string;
   LFileIni: TIniFile;
begin
   LFile := ExtractFilePath(ParamStr(0)) + ExtractFileName(ChangeFileExt(ParamStr(0), '.ini'));

   LFileIni := TIniFile.Create(LFile);
   try
      if not LFileIni.ValueExists(ASession, AField) then
      begin
         LFileIni.WriteString(ASession, AField, AValue);
         LFileIni.UpdateFile;
      end;

      Result := LFileIni.ReadString(ASession, AField, AValue);
   finally
      FreeAndNil(LFileIni);
   end;
end;

function PrimeiroDiaDoMes(AData: TDateTime): TDateTime;
begin
   Result := EncodeDate(YearOf(AData), MonthOf(AData), 1);
end;

function UltimoDiaDoMes(AData: TDateTime): TDateTime;
var
   Ano, Mes, Dia: Word;
begin
   DecodeDate(AData, Ano, Mes, Dia);
   if Mes = 12 then
   begin
      Inc(Ano);
      Mes := 0;
   end;
   Result := EncodeDate(Ano, Mes + 1, 1) - 1;
end;

end.
