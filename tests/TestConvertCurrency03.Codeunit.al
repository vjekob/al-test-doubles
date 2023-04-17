codeunit 50142 "Test Covert Currency - 03"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        Assert: Codeunit Assert;
        ConvertCurrency: Codeunit "Demo Convert Currency 02";

    [Test]
    procedure Test_01_DatabasePermissionChecker_Success()
    var
        Permission: Record "Demo Currency Exch. Permission";
        PermissionChecker: Codeunit "Database Permission Checker";
        Result: Boolean;
    begin
        // [GIVEN] Permission to convert
        Permission."From Currency Code" := 'DUMMY_FROM';
        Permission."To Currency Code" := 'DUMMY_TO';
        Permission."User ID" := 'DUMMY';
        Permission.Insert(false);

        // [WHEN] Checking permission
        Result := PermissionChecker.CanConvert('DUMMY_FROM', 'DUMMY_TO', 'DUMMY');

        // [THEN] Conversion is allowed
        Assert.IsTrue(Result, 'Conversion is not allowed');
    end;

    [Test]
    procedure Test_02_DatabasePermissionChecker_Failure()
    var
        PermissionChecker: Codeunit "Database Permission Checker";
        Result: Boolean;
    begin
        // [GIVEN] No permission to convert

        // [WHEN] Checking permission
        Result := PermissionChecker.CanConvert('DUMMY_F01', 'DUMMY_F02', 'DUMMY_U02');

        // [THEN] Conversion is allowed
        Assert.IsFalse(Result, 'Conversion is allowed');
    end;

    [Test]
    procedure Test_03_DatabaseLogger()
    var
        Logger: Codeunit "Database Logger";
        ExchangeLog: Record "Demo Currency Exchange Log";
    begin
        // [WHEN] Logging a conversion entry
        Logger.Log('DUMMY_FROM', 'DUMMY_TO', 1, 2, 'DUMMY');

        // [THEN] Expected data is written
        ExchangeLog.FindLast();
        Assert.AreEqual('DUMMY_FROM', ExchangeLog."From Currency Code", 'From currency code is not correct');
        Assert.AreEqual('DUMMY_TO', ExchangeLog."To Currency Code", 'To currency code is not correct');
        Assert.AreEqual(1, ExchangeLog."From Amount", 'From amount is not correct');
        Assert.AreEqual(2, ExchangeLog."To Amount", 'To amount is not correct');
        Assert.AreEqual('DUMMY', ExchangeLog."User ID", 'User ID is not correct');
    end;

    [Test]
    procedure Test_04_ConversionInvokesLogger()
    var
        Factory: Codeunit Factory;
        StubPermissionChecker: Codeunit "Stub Permission Checker";
        DummyCurrencyConverter: Codeunit "Dummy Currency Converter";
        SpyLogger: Codeunit "Spy Logger";
    begin
        StubPermissionChecker.SetAllowed(true);
        Factory.SetLogger(SpyLogger);
        Factory.SetPermissionChecker(StubPermissionChecker);
        Factory.SetCurrencyConverter(DummyCurrencyConverter);

        // [WHEN] Performing conversion
        ConvertCurrency.Convert(1, 'DUMMY_FROM', 'DUMMY_TO', Factory);

        // [THEN] Logger is invoked
        Assert.IsTrue(SpyLogger.IsInvoked(), 'Logger is not invoked');
    end;

    [Test]
    procedure Test_05_HasPermission_Success()
    var
        Factory: Codeunit Factory;
        StubPermissionChecker: Codeunit "Stub Permission Checker";
        SpyCurrencyConverter: Codeunit "Spy Currency Converter";
        DummyLogger: Codeunit "Dummy Logger";
    begin
        Factory.SetLogger(DummyLogger);
        Factory.SetPermissionChecker(StubPermissionChecker);
        Factory.SetCurrencyConverter(SpyCurrencyConverter);

        // [GIVEN] Permission to convert
        StubPermissionChecker.SetAllowed(true);

        // [WHEN] Performing conversion
        ConvertCurrency.Convert(1, 'DUMMY_FROM', 'DUMMY_TO', Factory);

        // [THEN] Conversion is invoked
        Assert.IsTrue(SpyCurrencyConverter.IsInvoked(), 'Conversion is not performed');
    end;

    [Test]
    procedure Test_06_NoPermission_Failure()
    var
        Factory: Codeunit Factory;
        StubPermissionChecker: Codeunit "Stub Permission Checker";
        SpyCurrencyConverter: Codeunit "Spy Currency Converter";
        DummyLogger: Codeunit "Dummy Logger";
    begin
        Factory.SetLogger(DummyLogger);
        Factory.SetPermissionChecker(StubPermissionChecker);
        Factory.SetCurrencyConverter(SpyCurrencyConverter);

        // [GIVEN] No permission to convert

        // [WHEN] Attempting to perform conversion
        asserterror ConvertCurrency.Convert(1, 'DUMMY_FROM', 'DUMMY_TO', Factory);

        // [THEN] Expected error has occurred
        Assert.IsSubstring(GetLastErrorText(), 'Currency exchange is not allowed');

        // [THEN] Conversion is not invoked
        Assert.IsFalse(SpyCurrencyConverter.IsInvoked(), 'Conversion is performed');
    end;

    [Test]
    procedure Test_07_RESTConvertSuccess()
    var
        RESTConverter: Codeunit "Demo REST Currency Converter";
        MockSuccess: Codeunit "Mock Invoker - Success";
        Factory: Codeunit Factory;
        StubPermissionChecker: Codeunit "Stub Permission Checker";
        DummyLogger: Codeunit "Dummy Logger";
        Amount: Decimal;
    begin
        Factory.SetLogger(DummyLogger);
        Factory.SetPermissionChecker(StubPermissionChecker);
        Factory.SetCurrencyConverter(RESTConverter);
        RESTConverter.Create(Factory);
        Factory.SetHttpInvoker(MockSuccess);

        // [GIVEN] Permission to convert
        StubPermissionChecker.SetAllowed(true);

        // [GIVEN] REST converter is configured as default currency converter
        Factory.SetCurrencyConverter(RESTConverter);

        // [WHEN] When successfully invoked
        Amount := ConvertCurrency.Convert(10, 'EUR', 'HRK', Factory);

        // [THEN] Then Expected Output 
        Assert.AreEqual(75, Amount, 'Configured converter was not executed.');
    end;

    [Test]
    procedure Test_08_RESTConvert401()
    var
        RESTConverter: Codeunit "Demo REST Currency Converter";
        Mock401: Codeunit "Mock Invoker - 401";
        Factory: Codeunit Factory;
        StubPermissionChecker: Codeunit "Stub Permission Checker";
        DummyLogger: Codeunit "Dummy Logger";
        Amount: Decimal;
    begin
        RESTConverter.Create(Factory);
        Factory.SetHttpInvoker(Mock401);
        Factory.SetLogger(DummyLogger);
        Factory.SetPermissionChecker(StubPermissionChecker);
        Factory.SetCurrencyConverter(RESTConverter);

        // [GIVEN] Permission to convert
        StubPermissionChecker.SetAllowed(true);

        // [WHEN] When failing to invoke
        asserterror Amount := ConvertCurrency.Convert(10, 'EUR', 'HRK', Factory);

        // [THEN] Then the expected friendly error must be shown. It wasn't user's fault.
        Assert.ExpectedError('Your system is not authorized to invoke currency exchange service.\\This is not a user error, but a result of incorrect system configuration.');
    end;

    [Test]
    procedure Test_09_RESTConvertInvalidJSON()
    var
        RESTConverter: Codeunit "Demo REST Currency Converter";
        MockInvalidJson: Codeunit "Mock Invoker - Invalid JSON";
        Factory: Codeunit Factory;
        StubPermissionChecker: Codeunit "Stub Permission Checker";
        DummyLogger: Codeunit "Dummy Logger";
        Amount: Decimal;
    begin
        RESTConverter.Create(Factory);
        Factory.SetHttpInvoker(MockInvalidJson);
        Factory.SetLogger(DummyLogger);
        Factory.SetPermissionChecker(StubPermissionChecker);
        Factory.SetCurrencyConverter(RESTConverter);

        // [GIVEN] Permission to convert
        StubPermissionChecker.SetAllowed(true);

        // [WHEN] When failing to invoke
        asserterror Amount := ConvertCurrency.Convert(10, 'EUR', 'HRK', Factory);

        // [THEN] Then the expected friendly error must be shown. It wasn't user's fault.
        Assert.ExpectedError('You might have enterred an incorrect or unsupported currency code. Can you check and try again?');
    end;

    [Test]
    procedure Test_10_RESTConvertBlockedByEnvironment()
    var
        RESTConverter: Codeunit "Demo REST Currency Converter";
        MockBlockedByEnv: Codeunit "Mock Invoker - Blocked by Env.";
        Factory: Codeunit Factory;
        StubPermissionChecker: Codeunit "Stub Permission Checker";
        DummyLogger: Codeunit "Dummy Logger";
        Amount: Decimal;
    begin
        RESTConverter.Create(Factory);
        Factory.SetHttpInvoker(MockBlockedByEnv);
        Factory.SetLogger(DummyLogger);
        Factory.SetPermissionChecker(StubPermissionChecker);
        Factory.SetCurrencyConverter(RESTConverter);

        // [GIVEN] Permission to convert
        StubPermissionChecker.SetAllowed(true);

        // [WHEN] When failing to invoke
        asserterror Amount := ConvertCurrency.Convert(10, 'EUR', 'HRK', Factory);

        // [THEN] Then the expected friendly error must be shown. It wasn't user's fault.
        Assert.ExpectedError('You have chosen to disallow placing calls to REST services. Please, enable it, and try again.');
    end;

}
