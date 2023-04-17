codeunit 50112 "Database Logger" implements ILogger
{
    procedure Log(FromCurrencyCode: Code[10]; ToCurrencyCode: Code[10]; FromAmount: Decimal; ToAmount: Decimal; User: Text[50]);
    var
        ExchangeLog: Record "Demo Currency Exchange Log";
    begin
        ExchangeLog."Date and Time" := CurrentDateTime;
        ExchangeLog."User ID" := User;
        ExchangeLog."From Currency Code" := FromCurrencyCode;
        ExchangeLog."To Currency Code" := ToCurrencyCode;
        ExchangeLog."From Amount" := FromAmount;
        ExchangeLog."To Amount" := ToAmount;
        ExchangeLog.Insert();
    end;
}
