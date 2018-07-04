public void TebexForcecheckInit() {
    Msg( "// Command tebex:forcecheck  //" );
}

public void Tebex_Forcecheck() {
    Tebex_warn("Checking for commands to be executed...");

    TebexApiGet("/queue", "TebexFcSuccess", "TebexFcFail");
}


public void TebexFcFail(JSONObject json)
{
    char error[256];
    json.GetString("error_message", error, sizeof(error));
    Tebex_err(error);
}

public void TebexFcSuccess(JSONObject json)
{
    JSONObject meta = json.Get("meta");
    int nextCheck = meta.GetInt("next_check");
    if (nextCheck > 0) {
        Tebex_nextCheck = nextCheck;
    }

    if (meta.GetBool("execute_offline")) {
        TebexDoOfflineCommands();
    }

    JSONArray players = json.Get("players");

    int count = players.Length;
    int x = 0;
    while (x < count) {
        JSONObject player = view_as<JSONObject>(players.Get(x));
        char steamId[64];
        player.GetString("uuid", steamId, 64);

        int client = GetClientFromSteamId(steamId);

        int pluginId = player.GetInt("id");

        if (client > -1) {
            char playerName[64];
            GetClientName(client, playerName, sizeof(playerName));
            //Do Online Command playerId, playerName, SteamId
            TebexDoOnlineCommands(pluginId, playerName, steamId);

        }
        x++;
    }

}

int GetClientFromSteamId(const String:auth[])
{

    new String:clientAuth[32];
    for(new i=1; i <= MaxClients; i++)
    {
        if(IsClientInGame(i) && !IsFakeClient(i))
        {
            GetClientAuthId(i, AuthId_SteamID64,  clientAuth, sizeof(clientAuth));

            if(StrEqual(auth, clientAuth))
            {
                return i;
            }
        }
    }

    return -1;
}