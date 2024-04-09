unit Controller.Connection;

interface

uses
   System.SysUtils,
   DAO.Connection;

type
   TControllerConnection = class
   private
      FDAOConn: TDAOConnection;
   public
      constructor Create;
      destructor Destroy; override;

      property DAOConnection: TDAOConnection read FDAOConn write FDAOConn;
      class function Instance: TControllerConnection;
   end;

implementation

var
   DB: TControllerConnection;

constructor TControllerConnection.Create;
begin
   inherited Create;
   FDAOConn := TDAOConnection.Create;
end;

destructor TControllerConnection.Destroy;
begin
   FreeAndNil(FDAOConn);

   inherited;
end;

class function TControllerConnection.Instance: TControllerConnection;
begin
   if (DB = nil) then
   begin
      DB := TControllerConnection.Create;
   end;

   Result := DB;
end;

initialization
DB := nil;

finalization
if not(DB = nil) then
begin
   FreeAndNil(DB);
end;

end.
