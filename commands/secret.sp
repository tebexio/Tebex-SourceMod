public void TebexSecretInit()
{
    Msg( "// Command tebex:secret      //" );
}

public void Tebex_Secret(const char[] secret)
{
    TebexSetConfig("secret", secret);

    TebexApiGet("/information", "TebexSecSuccess", "TebexSecFail");
}

public void TebexSecSuccess(JSONObject json)
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

    char infoLine[256];
    TebexInformation.GetString("name", buffer, 256);
    Format(infoLine, 256, "[Tebex™] Your secret key has been validated! Webstore Name: %s", buffer);
    Tebex_ok(infoLine);
}

public void TebexSecFail(JSONObject json)
{
    char error[256];
    json.GetString("error_message", error, sizeof(error));
    Tebex_err(error);
}
