public void TebexInfoInit()
{
    Msg( "// Command tebex:info        //" );
}

public void Tebex_Info()
{
    TebexApiGet("/information", "TebexInfoSuccess", "TebexInfoFail");
}

public void TebexInfoSuccess(JSONObject json)
{
    JSONObject account = json.Get("account");

    JSONObject server = json.Get("server");

    JSONObject currency = account.Get("currency");
    char buffer[256];

    TebexInformation.SetNum("id", account.GetInt("id"));

    account.GetString("name", buffer, sizeof(buffer));
    TebexInformation.SetString("name", buffer);

    account.GetString("domain", buffer, sizeof(buffer));
    TebexInformation.SetString("domain", buffer);

    currency.GetString("iso_4217", buffer, sizeof(buffer));
    TebexInformation.SetString("currency", buffer);

    currency.GetString("symbol", buffer, sizeof(buffer));
    TebexInformation.SetString("currencySymbol", buffer);

    account.GetString("game_type", buffer, sizeof(buffer));
    TebexInformation.SetString("gameType", buffer);

    server.GetString("name", buffer, sizeof(buffer));
    TebexInformation.SetString("serverName", buffer);

    TebexInformation.SetNum("serverId", server.GetInt("id"));

    Tebex_ok("Server Information");
    Tebex_ok("=================");

    char infoLine[256];
    char buffer2[256];


    TebexInformation.GetString("serverName", buffer, 256);
    TebexInformation.GetString("name", buffer2, 256);
    Format(infoLine, 256, "Server %s for webstore %s", buffer, buffer2);
    Tebex_ok(infoLine);

    TebexInformation.GetString("currency", buffer, 256);
    Format(infoLine, 256, "Server prices are in %s", buffer);
    Tebex_ok(infoLine);

    TebexInformation.GetString("domain", buffer, 256);
    Format(infoLine, 256, "Webstore domain: %s", buffer);
    Tebex_ok(infoLine);
}

public void TebexInfoFail(JSONObject json)
{
    char error[256];
    json.GetString("error_message", error, sizeof(error));
    Tebex_err(error);
}