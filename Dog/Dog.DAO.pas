unit Dog.DAO;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  Uni,
  Data.Connection,
  Dog.Entity,
  Rate.DAO,
  Rate.Entity,
  Rating.Entity;

type
  TDogDAO = class
    FDataStream: TDataStream;
  public
    constructor Create(ADataStream: TDataStream); overload;
    procedure Insert(ADog: TDogEntity);
    procedure Rate(AIdDog: String; ARating: Integer);
    function FindById(AIdApiDog: String): TDogEntity;
    // function FindAll: TObjectList<TDogEntity>;
  end;

implementation

constructor TDogDAO.Create(ADataStream: TDataStream);
begin
  FDataStream := ADataStream;
end;

procedure TDogDAO.Insert(ADog: TDogEntity);
var
  LSQLQuery: TUniQuery;
begin
  try
    LSQLQuery            := TUniQuery.Create(nil);
    LSQLQuery.Connection := FDataStream.con;

    LSQLQuery.SQL.Add('INSERT INTO dog(id_dog, rate_number, rating, url) ' + //
      'VALUES (:id_dog, :rate_number, :rating, :url)');
    LSQLQuery.ParamByName('id_dog').AsString       := ADog.IdDog;
    LSQLQuery.ParamByName('rate_number').AsInteger := ADog.RateNumber;
    LSQLQuery.ParamByName('rating').AsCurrency     := ADog.Rating;
    LSQLQuery.ParamByName('url').AsString          := ADog.Url;

    LSQLQuery.Execute;
  finally
    LSQLQuery.Free;
  end;
end;

procedure TDogDAO.Rate(AIdDog: String; ARating: Integer);
var
  LSQLQuery  : TUniQuery;
  LRateDAO   : TRateDao;
  LRateEntity: TRateEntity;
  LDogEntity : TDogEntity;
  LRating    : TRating;
begin
  LRateDAO    := nil;
  LRateEntity := nil;
  LDogEntity  := nil;
  LRating     := nil;
  LSQLQuery   := nil;

  if (ARating < 0) OR (ARating > 5) then
    raise Exception.Create('Rating must be between 1 and 5.');

  try
    LDogEntity := self.FindById(AIdDog);
    if not Assigned(LDogEntity) then
      raise Exception.Create('Dog not found');

    LRateDAO    := TRateDao.Create(FDataStream);
    LRateEntity := TRateEntity.Create;

    LRateEntity.Rate  := ARating;
    LRateEntity.IdDog := LDogEntity.IdDog;
    LRateDAO.Insert(LRateEntity);

    LSQLQuery            := TUniQuery.Create(nil);
    LSQLQuery.Connection := FDataStream.con;

    LSQLQuery.SQL.Add('UPDATE dog SET rate_number = :rate_number, rating = :rating WHERE id_dog = :id_dog');

    LRating := LRateDAO.GetDogRating(AIdDog);

    LSQLQuery.ParamByName('rating').AsCurrency     := LRating.Rating;
    LSQLQuery.ParamByName('rate_number').AsInteger := LRating.RateNumber;
    LSQLQuery.ParamByName('id_dog').AsString       := LDogEntity.IdDog;

    LSQLQuery.Execute;
  finally
    LSQLQuery.Free;
  end;

end;

function TDogDAO.FindById(AIdApiDog: String): TDogEntity;
var
  LSQLQuery: TUniQuery;
begin
  try
    LSQLQuery            := TUniQuery.Create(nil);
    LSQLQuery.Connection := FDataStream.con;
    LSQLQuery.SQL.Add('SELECT * FROM dog where id_dog = :id_dog');
    LSQLQuery.ParamByName('id_dog').AsString := AIdApiDog;
    LSQLQuery.Execute;
    LSQLQuery.Open;

    if LSQLQuery.IsEmpty then
      exit(nil);

    Result            := TDogEntity.Create;
    Result.IdDog      := LSQLQuery.FieldByName('id_dog').AsString;
    Result.RateNumber := LSQLQuery.FieldByName('rate_number').AsInteger;
    Result.Rating     := LSQLQuery.FieldByName('rating').AsCurrency;
    Result.Url        := LSQLQuery.FieldByName('url').AsString;
  finally
    LSQLQuery.Free;
  end;
end;

end.
