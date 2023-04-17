codeunit 50134 "Mock Invoker - Success" implements IHttpInvoker
{
    procedure Get(Request: HttpRequestMessage) Content: JsonObject;
    begin
        Content.ReadFrom('{"success": true,"timestamp":1667985543,"base":"EUR","date":"2022-11-09","rates":{"HRK":7.5}}');
    end;
}
