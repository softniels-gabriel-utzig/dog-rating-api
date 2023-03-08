unit JSON.Deserializer;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  MVCFramework.Serializer.Intf,
  MVCFramework.Serializer.Defaults,
  MVCFramework.Serializer.Commons;

type
  TComumDeserialize = class
  public
    class procedure JSONToEntity(AJSON: string; AObject: TObject);
    class procedure JSONToObjecList<T: class>( //
      AJSON: string;                           //
      AObjectList: TObjectList<T>);            //
  end;

implementation

{ TComumDeserialize<T> }

class procedure TComumDeserialize.JSONToEntity(AJSON: string; AObject: TObject);
var
  LSerializer: IMVCSerializer;
begin
  LSerializer := GetDefaultSerializer;
  LSerializer.DeserializeObject(AJSON, AObject);
end;

class procedure TComumDeserialize.JSONToObjecList<T>( //
  AJSON: string;                                      //
  AObjectList: TObjectList<T>);
var
  LSerializer: IMVCSerializer;
begin
  LSerializer := GetDefaultSerializer;
  LSerializer.DeserializeCollection(AJSON, AObjectList, T);
end;

end.
