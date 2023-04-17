codeunit 50147 "Dummy Currency Converter" implements ICurrencyConverter
{
    procedure Convert(AtDate: Date; FromCurrencyCode: Code[10]; ToCurrencyCode: Code[10]; Amount: Decimal): Decimal;
    begin
        // Does nothing
    end;
}
