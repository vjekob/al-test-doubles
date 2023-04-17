codeunit 50131 "Mock Invoker - 401" implements IHttpInvoker
{
    procedure Get(Request: HttpRequestMessage) Content: JsonObject;
    begin
        Error('An error has occurred while placing the call: 401');
    end;
}
