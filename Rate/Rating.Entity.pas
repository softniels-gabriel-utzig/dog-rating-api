unit Rating.Entity;

interface
type
  TRating = class
  private
    FRateNumber : Integer;
    FRating : Currency;

  public
    property RateNumber: Integer read FRateNumber write FRateNumber;
    property Rating: Currency read FRating write FRating;
  end;

implementation

end.
