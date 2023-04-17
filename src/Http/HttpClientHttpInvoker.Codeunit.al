codeunit 50106 "HttpClient Http Invoker" implements IHttpInvoker
{
    procedure Get(Request: HttpRequestMessage) Content: JsonObject
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        MyApiKey: Label 'a1NGBy0hU2BhXHvHMVh7CCKUN8n1B4rb';
        Token: JsonToken;
        Body: Text;
    begin
        Client.Send(Request, Response);

        case true of
            Response.IsBlockedByEnvironment():
                Error('Your operation was blocked by your current system configuration');

            not Response.IsSuccessStatusCode():
                Error('An error has occurred while placing the call: %1', Response.HttpStatusCode);
        end;

        Response.Content.ReadAs(Body);
        Content.ReadFrom(Body);
    end;

}
