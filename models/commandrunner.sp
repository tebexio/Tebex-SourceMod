int TebexDeleteAfter = 5;

public void TebexCommandRunnerInit()
{
    Msg( "// CommandRunner v0.1        //" );
}

public void TebexDoOfflineCommands()
{
    TebexApiGet("/queue/offline-commands", "TebexOffSuccess", "TebexOffFail");
}

public void TebexDoOnlineCommands(int playerPluginId, const char[] playerName, const char[] playerId)
{
    char lineOut[512];
    Format(lineOut, 512, "[Tebex™] Running online commands for %s (%s)", playerName, playerId);
    Tebex_warn(lineOut);
    char endpoint[128];

    char ppId[10];
    IntToString(playerPluginId, ppId, 10);
    Format(endpoint, 128, "/queue/online-commands/%s", ppId);

    KeyValues data = new KeyValues("data");
    data.SetEscapeSequences(true);

    data.SetNum("playerPluginId", playerPluginId);
    data.SetString("playerName", playerName);
    data.SetString("playerId", playerId);

    TebexApiGetCB(endpoint, "TebexOnSuccess", "TebexOffFail", data);
}

public void TebexOnSuccess(JSONObject json, KeyValues data)
{
    int exCount = 0;
    int executedCommands[10];

    JSONArray commands = json.Get("commands");
    int cmdcount = commands.Length;

    int pos = 0;

    while (pos < cmdcount) {
        JSONObject command = view_as<JSONObject>(commands.Get(pos));
        char commandToRun[512];

        char baseCommand[512];
        command.GetString("command", baseCommand, sizeof(baseCommand));

        char playerName[126];
        data.GetString("playerName", playerName, 126);

        char playerId[56];
        data.GetString("playerId", playerId, sizeof(playerId));

        ReplaceString(baseCommand, 512, "{id}", playerId);
        ReplaceString(baseCommand, 512, "{username}", playerName);

        ServerCommand(baseCommand);
        executedCommands[exCount] = command.GetInt("id");
        exCount++;

        if (exCount % TebexDeleteAfter == 0 ) {
            TebexDeleteCommands(executedCommands);
            int executedCommands[10];
            exCount = 0;
        }
        pos++;
    }

    if (exCount % TebexDeleteAfter > 0 ) {
        TebexDeleteCommands(executedCommands);
        int executedCommands[10];
        exCount = 0;
    }
}

public void TebexOffSuccess(JSONObject json)
{
    int exCount = 0;
    int executedCommands[10];

    JSONArray commands = json.Get("commands");
    int cmdcount = commands.Length;

    int pos = 0;

    while (pos < cmdcount) {
        JSONObject command = view_as<JSONObject>(commands.Get(pos));
        JSONObject player = command.Get("player");
        char commandToRun[512];

        char baseCommand[512];
        command.GetString("command", baseCommand, sizeof(baseCommand));

        char playerName[126];
        player.GetString("name", playerName, sizeof(playerName));

        char playerId[56];
        player.GetString("uuid", playerId, sizeof(playerId));

        ReplaceString(baseCommand, 512, "{id}", playerId);
        ReplaceString(baseCommand, 512, "{username}", playerName);

        ServerCommand(baseCommand);
        executedCommands[exCount] = command.GetInt("id");
        exCount++;

        if (exCount % TebexDeleteAfter == 0 ) {
            TebexDeleteCommands(executedCommands);
            int executedCommands[10];
            exCount = 0;
        }
        pos++;
    }

    if (exCount % TebexDeleteAfter > 0 ) {
        TebexDeleteCommands(executedCommands);
        int executedCommands[10];
        exCount = 0;
    }
}

public void TebexDeleteCommands(int[] commands)
{
    char endpoint[512] = "/queue?";
    int x = 0;
    while (x < TebexDeleteAfter) {
        char cmdId[10];
        IntToString(commands[x], cmdId, 10);
        if (StrEqual(cmdId, "0", false) == false) {
            char temp[512];
            strcopy(temp, 512, endpoint);
            if (x == 0) {
                Format(endpoint, 512, "%sids[]=%s", temp, cmdId);
            } else {
                Format(endpoint, 512, "%s&ids[]=%s", temp, cmdId);
            }
        }
        x++;
    }
    TebexApiDelete(endpoint, "TebexDelSuccess", "TebexOffFail");
}

public void TebexDelSuccess(JSONObject json)
{
    Msg("[Tebex™] Commands deleted");
}

public void TebexOffFail(JSONObject json)
{
    char error[256];
    json.GetString("error_message", error, sizeof(error));
    Tebex_err(error);
}
