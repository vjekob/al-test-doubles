interface IPermissionChecker
{
    procedure CanConvert(FromCurrencyCode: Code[20]; ToCurrencyCode: Code[20]; User: Text[50]): Boolean;
}
