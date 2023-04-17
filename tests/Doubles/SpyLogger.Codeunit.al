codeunit 50146 "Spy Logger" implements ILogger
{
    var
        _invoked: Boolean;

    procedure Log(FromCurrencyCode: Code[10]; ToCurrencyCode: Code[10]; FromAmount: Decimal; ToAmount: Decimal; User: Text[50]);
    begin
        _invoked := true;
    end;

    procedure IsInvoked(): Boolean
    begin
        exit(_invoked);
    end;
}
