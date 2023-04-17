codeunit 50132 "Mock Invoker - Blocked by Env." implements IHttpInvoker
{
    procedure Get(Request: HttpRequestMessage) Content: JsonObject;
    begin
        Error('Your operation was blocked by your current system configuration');
    end;
}
