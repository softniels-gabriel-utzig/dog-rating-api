unit Rate.DAO;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  Uni,
  System.JSON,
  Data.Connection,
  Rate.Entity,
  Rating.Entity,
  Dog.Entity;

type
  TRateDao = class
    FDataStream: TDataStream;
  public
    constructor Create(ADataStream: TDataStream); overload;
    procedure Insert(ARate: TRateEntity);
    function GetDogRating(AIdDog: string): TRating;
  end;

implementation

constructor TRateDao.Create(ADataStream: TDataStream);
begin
  FDataStream := ADataStream;
end;

procedure TRateDao.Insert(ARate: TRateEntity);
var
  LSQLQuery: TUniQuery;
begin
  LSQLQuery := nil;
  try
    LSQLQuery            := TUniQuery.Create(nil);
    LSQLQuery.Connection := FDataStream.con;

    LSQLQuery.SQL.Add('INSERT INTO rate(rate, id_dog) ' + //
      'VALUES (:rate, :id_dog)');
    LSQLQuery.ParamByName('rate').AsInteger  := ARate.Rate;
    LSQLQuery.ParamByName('id_dog').AsString := ARate.IdDog;

    LSQLQuery.Execute;
  finally
    LSQLQuery.Free;
  end;
end;

function TRateDao.GetDogRating(AIdDog: String): TRating;
var
  LSQLQuery: TUniQuery;
  LRating  : TRating;
begin
  LRating := nil;
  try
    LSQLQuery            := TUniQuery.Create(nil);
    LSQLQuery.Connection := FDataStream.con;
    LSQLQuery.SQL.Add('SELECT AVG(rate) AS rating, COUNT(id_dog) AS rate_number FROM rate WHERE id_dog = :id_dog;');
    LSQLQuery.ParamByName('id_dog').AsString := AIdDog;
    LSQLQuery.Execute;
    LSQLQuery.Open;

    if LSQLQuery.IsEmpty then
      raise Exception.Create('Id not Found');
    LRating := TRating.Create;

    LRating.RateNumber := LSQLQuery.FieldByName('rate_number').AsInteger;
    LRating.Rating     := LSQLQuery.FieldByName('rating').AsCurrency;

    Result := LRating;
  finally
    LSQLQuery.Free;
    LRating.Free;
  end;
end;

end.
