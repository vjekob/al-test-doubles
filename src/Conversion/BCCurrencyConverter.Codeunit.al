codeunit 50113 "BC Currency Converter" implements ICurrencyConverter
{
    procedure Convert(AtDate: Date; FromCurrencyCode: Code[10]; ToCurrencyCode: Code[10]; Amount: Decimal): Decimal
    var
        ExchRate: Record "Currency Exchange Rate";
    begin
        exit(ExchRate.ExchangeAmtFCYToFCY(AtDate, FromCurrencyCode, ToCurrencyCode, Amount));
    end;
}
