codeunit 50111 "Database Permission Checker" implements IPermissionChecker
{
    procedure CanConvert(FromCurrencyCode: Code[20]; ToCurrencyCode: Code[20]; User: Text[50]): Boolean;
    var
        Permission: Record "Demo Currency Exch. Permission";
    begin
        Permission.SetRange("User ID", User);
        Permission.SetFilter("From Currency Code", '%1|%2', '', FromCurrencyCode);
        Permission.SetFilter("To Currency Code", '%1|%2', '', ToCurrencyCode);
        exit(not Permission.IsEmpty());
    end;
}
