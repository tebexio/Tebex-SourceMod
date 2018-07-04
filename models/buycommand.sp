public void TebexBuyCommandInit() {
        Msg( "// Buy Command v0.1          //" );
        HookEvent("player_say", evPlayerSay);
}

public Action evPlayerSay(Handle event, const char[] szName, bool dontBroadcast)
{
    char buyCommand[30];
    TebexConfig.GetString("buyCommand", buyCommand, sizeof(buyCommand));

    char domain[256];
    TebexInformation.GetString("domain", domain, 256);

    char msg[30];
    GetEventString(event, "text", msg, sizeof(msg));
    dontBroadcast = true;

    int client = GetClientOfUserId(GetEventInt(event, "userid"));

    char outMsg[256];
    Format(outMsg, 256, "To access our store, please visit %s", domain);


    if (StrEqual(msg, buyCommand, false)) {
        ShowMOTDPanel(client, "Server Store", domain, MOTDPANEL_TYPE_URL);
        PrintToChat(client, outMsg);
    }
}
