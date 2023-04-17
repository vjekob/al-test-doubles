codeunit 50145 "Spy Currency Converter" implements ICurrencyConverter
{
    var
        _invoked: boolean;

    procedure Convert(AtDate: Date; FromCurrencyCode: Code[10]; ToCurrencyCode: Code[10]; Amount: Decimal): Decimal
    begin
        _invoked := true;
    end;

    procedure IsInvoked(): Boolean
    begin
        exit(_invoked);
    end;
}


