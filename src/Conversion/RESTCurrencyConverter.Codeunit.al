codeunit 50104 "Demo REST Currency Converter" implements ICurrencyConverter
{
    var
        _factory: Codeunit Factory;

    procedure Create(Factory: Codeunit Factory)
    begin
        _factory := Factory;
    end;

    procedure Convert(AtDate: Date; FromCurrencyCode: Code[10]; ToCurrencyCode: Code[10]; Amount: Decimal) Result: Decimal
    var
        ErrorText: Text;
    begin
        if (FromCurrencyCode = '') or (ToCurrencyCode = '') then
            exit(Amount);

        if not TryConvertCurrency(Amount, FromCurrencyCode, ToCurrencyCode, Result) then begin
            ErrorText := GetLastErrorText();
            case true of
                ErrorText.EndsWith('401'):
                    Error('Your system is not authorized to invoke currency exchange service.\\This is not a user error, but a result of incorrect system configuration.');

                ErrorText.Contains('blocked by your current system configuration'):
                    Error('You have chosen to disallow placing calls to REST services. Please, enable it, and try again.');

                else
                    Error('You might have enterred an incorrect or unsupported currency code. Can you check and try again?');
            end;
        end;
    end;

    [TryFunction]
    local procedure TryConvertCurrency(Amount: Decimal; FromCurrencyCode: Code[10]; ToCurrencyCode: Code[10]; var Result: Decimal)
    var
        HttpInvoker: Interface IHttpInvoker;
        Request: HttpRequestMessage;
        Headers: HttpHeaders;
        Url: Label 'https://api.apilayer.com/exchangerates_data/latest?base=%1&symbols=%2', Locked = true;
        MyApiKey: Label 'a1NGBy0hU2BhXHvHMVh7CCKUN8n1B4rb', Locked = true;
        Content: JsonObject;
        Token: JsonToken;
    begin
        HttpInvoker := GetInvoker();

        Request.SetRequestUri(StrSubstNo(Url, FromCurrencyCode, ToCurrencyCode));
        Request.Method := 'get';
        Request.GetHeaders(Headers);
        Headers.Add('apikey', MyApiKey);

        Content := HttpInvoker.Get(Request);

        Content.SelectToken(StrSubstNo('rates.%1', ToCurrencyCode), Token);
        Result := Amount * Token.AsValue().AsDecimal();
    end;

    local procedure GetInvoker(): Interface IHttpInvoker
    var
        HttpClientInvoker: Codeunit "HttpClient Http Invoker";
    begin
        exit(_factory.HttpInvoker());
    end;
}
