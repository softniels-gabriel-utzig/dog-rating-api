unit Data.Source;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  MVCFramework.RESTClient,
  JSON.Deserializer,
  dog.DTO;

type
  TDataSoruce = class
  private
    FAPIClient: IMVCRESTClient;
  Public
    constructor Create; overload;
    function GetDogs(ALimit: Integer = 0): TObjectList<TDogDTO>;
    destructor Destroy; override;
  end;

implementation

constructor TDataSoruce.Create;
begin
  FAPIClient := TMVCRESTClient.Create;
  FAPIClient.BaseURL('https://api.thedogapi.com/v1/');
end;

function TDataSoruce.GetDogs(ALimit: Integer = 0): TObjectList<TDogDTO>;
Var
  LAPIResponse: IMVCRESTResponse;

begin
  LAPIResponse := nil;
  result       := TObjectList<TDogDTO>.Create;

  LAPIResponse := FAPIClient.Get('images/search/?limit=' + IntToStr(ALimit));
  if not LAPIResponse.Success then
    Exit;

  TComumDeserialize.JSONToObjecList<TDogDTO>(LAPIResponse.Content, result);

end;

destructor TDataSoruce.Destroy;
begin
  if FAPIClient <> nil then
    inherited;
end;

end.
