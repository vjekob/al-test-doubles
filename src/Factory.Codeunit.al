codeunit 50110 Factory
{
    var
        _logger: Interface ILogger;
        _permissionChecker: Interface IPermissionChecker;
        _currencyConverter: Interface ICurrencyConverter;
        _httpInvoker: Interface IHttpInvoker;
        _loggerDefined: Boolean;
        _permissionCheckerDefined: Boolean;
        _currencyConverterDefined: Boolean;
        _httpInvokerDefined: Boolean;

    procedure Logger(): Interface ILogger
    var
        Logger: Codeunit "Database Logger";
    begin
        if not _loggerDefined then
            SetLogger(Logger);

        exit(_logger);
    end;

    procedure PermissionChecker(): Interface IPermissionChecker
    var
        PermissionChecker: Codeunit "Database Permission Checker";
    begin
        if not _permissionCheckerDefined then
            SetPermissionChecker(PermissionChecker);

        exit(_permissionChecker);
    end;

    procedure CurrencyConverter(): Interface ICurrencyConverter
    var
        CurrencyConverter: Codeunit "BC Currency Converter";
    begin
        if not _currencyConverterDefined then
            SetCurrencyConverter(CurrencyConverter);

        exit(_currencyConverter);
    end;

    procedure HttpInvoker(): Interface IHttpInvoker
    var
        HttpInvoker: Codeunit "HttpClient Http Invoker";
    begin
        if not _httpInvokerDefined then
            SetHttpInvoker(HttpInvoker);

        exit(_httpInvoker);
    end;

    procedure SetLogger(logger: Interface ILogger)
    begin
        _logger := logger;
        _loggerDefined := true;
    end;

    procedure SetPermissionChecker(permissionChecker: Interface IPermissionChecker)
    begin
        _permissionChecker := permissionChecker;
        _permissionCheckerDefined := true;
    end;

    procedure SetCurrencyConverter(currencyConverter: Interface ICurrencyConverter)
    begin
        _currencyConverter := currencyConverter;
        _currencyConverterDefined := true;
    end;

    procedure SetHttpInvoker(httpInvoker: Interface IHttpInvoker)
    begin
        _httpInvoker := httpInvoker;
        _httpInvokerDefined := true;
    end;
}

