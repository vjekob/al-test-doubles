codeunit 50144 "Stub Permission Checker" implements IPermissionChecker
{
    var
        _allowed: Boolean;

    procedure CanConvert(FromCurrencyCode: Code[20]; ToCurrencyCode: Code[20]; User: Text[50]): Boolean;
    begin
        exit(_allowed);
    end;

    procedure SetAllowed(Allowed: Boolean);
    begin
        _allowed := Allowed;
    end;
}
