codeunit 50133 "Mock Invoker - Invalid JSON" implements IHttpInvoker
{
    procedure Get(Request: HttpRequestMessage) Content: JsonObject;
    begin
        Content.ReadFrom('{}');
    end;
}
