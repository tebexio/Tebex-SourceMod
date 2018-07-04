#pragma semicolon 1

#include <sourcemod>
#include <sdktools>

public Plugin myinfo =
        {
                name = "Tebex SourceMod",
                author = "Tebex",
                description = "Test",
                version = "0.0.1",
                url = "https://www.tebex.io/"
        };


int Tebex_nextCheck = 0;
int Tebex_lastCalled = 0;


/**
 * Some initial aliases to allow us to convert code from existing plugins easily
 */

public void Msg(const char[] message)
{
    PrintToServer(message);
}

public void Tebex_warn(const char[] message)
{
    PrintToServer(message);
}

public void Tebex_err(const char[] message)
{
    PrintToServer(message);
}

public void Tebex_ok(const char[] message)
{
    PrintToServer(message);
}

/**
 * Startup
 */
#include "models/config.sp"
#include "models/information.sp"
#include "client/apiclient.sp"
#include "models/buycommand.sp"


#include "commands/info.sp"
#include "commands/secret.sp"
#include "commands/forcecheck.sp"

#include "models/commandrunner.sp"

public void OnConfigsExecuted()
{

}


public void OnPluginStart()
{
    Msg( "\n///////////////////////////////" );
    Msg( "//    TebexSourceMod v0.1    //" );
    Msg( "//   https://www.tebex.io/   //" );
    Msg( "///////////////////////////////" );
    Msg( "// Loading...                //" );

    TebexConfigInit();
    TebexInformationInit();
    TebexApiClientInit();
    TebexBuyCommandInit();
    TebexInfoInit();
    TebexSecretInit();
    TebexForcecheckInit();

    TebexCommandRunnerInit();

    RegServerCmd("tebex", Tebex_DoCmd);

    Tebex_nextCheck = 15 * 60;
    Tebex_lastCalled = GetTime() - (14 * 60);

    char secret[32];

    TebexConfig.GetString("secret", secret, 32);
    if (StrEqual(secret, "0", false)) {
        Tebex_err( "You have not yet defined your secret key. Use tebex:secret <secret> to define your key" );
    } else {
        Tebex_Info();
    }

    CreateTimer(3.0, Tebex_DoCheck, _, TIMER_REPEAT);

    secret = "";
}


public Action Tebex_DoCmd(int args) {
    if (args < 1) {
        Tebex_err("Invalid command");
    }

    char cmd[15];

    GetCmdArg(2, cmd, sizeof(cmd));

    if (StrEqual(cmd, "info", false)) {
        Tebex_Info();
    } else if (StrEqual(cmd, "secret", false)) {
        char secret[64];
        GetCmdArg(3, secret, 64);
        Tebex_Secret(secret);
    } else if (StrEqual(cmd, "forcecheck", false)) {
        Tebex_Forcecheck();
    } else {
        char err[50] = "Unknon command - tebex:";
        StrCat(err, 50, cmd);
        Msg( err );
    }
}

public Action Tebex_DoCheck(Handle timer)
{

    if ((GetTime() - Tebex_lastCalled) > Tebex_nextCheck){
        Tebex_lastCalled = GetTime();

        Tebex_Forcecheck();
    }
}

