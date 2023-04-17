codeunit 50143 "Dummy Logger" implements ILogger
{
    procedure Log(FromCurrencyCode: Code[10]; ToCurrencyCode: Code[10]; FromAmount: Decimal; ToAmount: Decimal; User: Text[50]);
    begin
        // Does nothing
    end;
}

