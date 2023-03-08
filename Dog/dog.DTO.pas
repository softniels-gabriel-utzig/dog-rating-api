unit dog.DTO;
interface
type TDogDTO = class
  private
    FId: string;
    FUrl: string;
  public
  property id: string read Fid write Fid;
  property url: string read Furl write Furl;

end;

implementation

end.
