unit Dog.Controller;

interface

uses
  MVCFramework,
  MVCFramework.Commons,
  MVCFramework.Serializer.Commons;

type

  [MVCPath('/api')]
  TDogs = class(TMVCController)

  public
    [MVCPath]
    [MVCHTTPMethod([httpGET])]
    procedure Index;

    [MVCPath('/dogs')]
    [MVCHTTPMethod([httpGET])]
    procedure GetDogs;

    [MVCPath('/dogs/($id)')]
    [MVCHTTPMethod([httpGET])]
    procedure getDog(id: String);

    [MVCPath('/dogs/rate/($id)')]
    [MVCHTTPMethod([httpPOST])]
    procedure RateDog(id: String);

  end;

implementation

uses
  System.SysUtils,
  System.Generics.Collections,
  MVCFramework.Logger,
  System.StrUtils,
  MVCFramework.RESTClient,
  MVCFramework.RESTClient.Intf,
  System.JSON,
  REST.JSON,
  Data.Connection,
  Dog.DAO,
  Dog.Entity,
  Dog.DTO,
  Data.Source,
  JSON.Deserializer;

procedure TDogs.Index;
begin
  render(200, '{"message":"Dog Rating API. =)"}')
end;

procedure TDogs.GetDogs;
var
  LDataConnection: TDataStream;
  LDataSource    : TDataSoruce;
  LDogDAO        : TDogDAO;
  LDogEntity     : TDogEntity;
  LDogListEntity : TObjectList<TDogEntity>;
  LDogListDTO    : TObjectList<TDogDTO>;

begin
  LDataConnection := nil;
  LDataSource     := nil;
  LDogDAO         := nil;
  LDogEntity      := nil;
  LDogListEntity  := nil;
  LDogListDTO     := nil;

  try
    LDataConnection := TDataStream.Create(nil);
    LDataSource     := TDataSoruce.Create;
    LDogDAO         := TDogDAO.Create(LDataConnection);
    LDogEntity      := TDogEntity.Create;
    LDogListEntity  := TObjectList<TDogEntity>.Create;
    LDogListDTO     := TObjectList<TDogDTO>.Create;
    LDogListDTO     := LDataSource.GetDogs;

    for var Dog in LDogListDTO do
    begin
      LDogEntity := LDogDAO.FindById(Dog.id);
      if not Assigned(LDogEntity) then
      begin
        LDogEntity            := TDogEntity.Create;
        LDogEntity.IdDog      := Dog.id;
        LDogEntity.Url        := Dog.Url;
        LDogEntity.RateNumber := 0;
        LDogEntity.Rating     := 0;
        LDogDAO.Insert(LDogEntity);
      end;
      LDogListEntity.add(LDogEntity);
    end;

    render(201, LDogListEntity);

  finally
    LDataConnection.free;
    LDogListDTO.free;
    LDogDAO.free;
    LDataSource.Destroy;
  end;
end;

procedure TDogs.getDog(id: String);
var
  LDataConnection: TDataStream;
  LDogDAO        : TDogDAO;
  LDogEntity     : TDogEntity;

begin
  LDataConnection := nil;
  LDogDAO         := nil;
  LDogEntity      := nil;
  try
    LDataConnection := TDataStream.Create(nil);
    LDogEntity      := TDogEntity.Create;
    LDogDAO         := TDogDAO.Create(LDataConnection);
    LDogEntity := LDogDAO.FindById(id);
    if Assigned(LDogEntity) then
      render(200, LDogEntity)
    else
      render(404, '{"error":"Dog not found =("');

  finally
    LDogDAO.free;
    LDataConnection.free;
  end;

end;

procedure TDogs.RateDog(id: String);
var
  LDataConnection: TDataStream;
  LDogDAO        : TDogDAO;
  LDogEntity     : TDogEntity;
  LRating        : TJSONValue;

begin
  LDataConnection := nil;
  LDogDAO         := nil;
  LDogEntity      := nil;
  LRating         := nil;

  try
    LDataConnection := TDataStream.Create(nil);
    LDogDAO         := TDogDAO.Create(LDataConnection);
    LDogEntity      := TDogEntity.Create;
    try
      LRating := TJSONObject.ParseJSONValue(Context.Request.Body);
      LDogDAO.Rate(id, LRating.FindValue('rating').AsType<Integer>);
      LDogEntity := LDogDAO.FindById(id);
      render(200, LDogEntity);

    except
      on E: Exception do
      begin
        render(400, '{"Error":"'+E.Message+'"}');
      end;
    end;
  finally

  end;
end;

end.
