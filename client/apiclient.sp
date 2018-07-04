#include <ripext>

HTTPClient httpClient;
Handle TebexCallbacks;
Handle TebexDatas;

public void TebexApiClientInit()
{
    Msg( "// API Client 0.1            //" );

    char baseUrl[64];
    TebexConfig.GetString("baseUrl", baseUrl, 64);

    httpClient = new HTTPClient(baseUrl);

    TebexCallbacks = CreateArray(42,0);
    TebexDatas = CreateArray(42,50);

}

void TebexSetHeader()
{
    char secret[64];
    TebexConfig.GetString("secret", secret, 64);

    httpClient.SetHeader("X-Buycraft-Secret", secret);
}

public void TebexApiGet(const char[] endpoint, const char[] success, const char[] failure)
{

    TebexSetHeader();
    char callbacks[42];
    Format(callbacks, 42, "%s|%s", success, failure);

    int idx = PushArrayString(TebexCallbacks, callbacks);

    httpClient.Get(endpoint, OnRequestComplete, idx);
}


public void TebexApiGetCB(const char[] endpoint, const char[] success, const char[] failure, KeyValues data)
{

    TebexSetHeader();
    char callbacks[42];
    Format(callbacks, 42, "%s|%s", success, failure);

    int idx = PushArrayString(TebexCallbacks, callbacks);

    SetArrayCell(TebexDatas, idx, data);

    httpClient.Get(endpoint, OnRequestCompleteCB, idx);
}

public void TebexApiDelete(const char[] endpoint, const char[] success, const char[] failure)
{

    TebexSetHeader();
    httpClient.Delete(endpoint, BlackHole);
}

public void BlackHole(HTTPResponse response, int callbackIdx)
{

}

public void OnRequestComplete(HTTPResponse response, int callbackIdx)
{

    char value[42];
    GetArrayString(TebexCallbacks, callbackIdx, value, 42);

    char handlers[2][21];
    ExplodeString(value, "|", handlers, 2, 21, false);

    RemoveFromArray(TebexCallbacks, callbackIdx);

    if (response.Data == null) {
        Tebex_err("There was a problem parsing the response to this request. Please try again");
        return;
    }

    // Indicate that the response is a JSON object
    JSONObject json = view_as<JSONObject>(response.Data);

    if (response.Status == HTTPStatus_OK || response.Status == HTTPStatus_NoContent)
    {
        Call_StartFunction(INVALID_HANDLE, GetFunctionByName(INVALID_HANDLE, handlers[0]));
        Call_PushCell(json);
        Call_Finish();
    } else {
        Call_StartFunction(INVALID_HANDLE, GetFunctionByName(INVALID_HANDLE, handlers[1]));
        Call_PushCell(json);
        Call_Finish();
    }
}


public void OnRequestCompleteCB(HTTPResponse response, int callbackIdx)
{

    char value[42];
    GetArrayString(TebexCallbacks, callbackIdx, value, 42);

    char handlers[2][21];
    ExplodeString(value, "|", handlers, 2, 21, false);

    RemoveFromArray(TebexCallbacks, callbackIdx);

    if (response.Data == null) {
        Tebex_err("There was a problem parsing the response to this request. Please try again");
        return;
    }

    // Indicate that the response is a JSON object
    JSONObject json = view_as<JSONObject>(response.Data);

    if (response.Status == HTTPStatus_OK || response.Status == HTTPStatus_NoContent)
    {
        Call_StartFunction(INVALID_HANDLE, GetFunctionByName(INVALID_HANDLE, handlers[0]));
        Call_PushCell(json);
        Call_PushCell(GetArrayCell(TebexDatas, callbackIdx));
        Call_Finish();
    } else {
        Call_StartFunction(INVALID_HANDLE, GetFunctionByName(INVALID_HANDLE, handlers[1]));
        Call_PushCell(json);
        Call_Finish();
    }
}