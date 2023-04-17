interface ILogger
{
    procedure Log(FromCurrencyCode: Code[10]; ToCurrencyCode: Code[10]; FromAmount: Decimal; ToAmount: Decimal; User: Text[50]);
}
