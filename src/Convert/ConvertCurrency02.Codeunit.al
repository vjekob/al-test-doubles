codeunit 50101 "Demo Convert Currency 02"
{
    procedure Convert(FromAmount: Decimal; FromCurrencyCode: Code[10]; ToCurrencyCode: Code[10]; Factory: Codeunit Factory) Result: Decimal
    var
        Logger: Interface ILogger;
        PermissionChecker: Interface IPermissionChecker;
        CurrencyConverter: Interface ICurrencyConverter;
    begin
        // Obtain dependencies
        Logger := Factory.Logger();
        PermissionChecker := Factory.PermissionChecker();
        CurrencyConverter := Factory.CurrencyConverter();

        // Perform the process
        if not PermissionChecker.CanConvert(FromCurrencyCode, ToCurrencyCode, UserId()) then
            Error('Currency exchange is not allowed for %1 from %2 to %3.', UserId, FromCurrencyCode, ToCurrencyCode);
        Result := CurrencyConverter.Convert(WorkDate(), FromCurrencyCode, ToCurrencyCode, FromAmount);
        Logger.Log(FromCurrencyCode, ToCurrencyCode, FromAmount, Result, UserId());
    end;
}
