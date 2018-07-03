#include <sourcemod>
#include <sdktools>

public Plugin myinfo =
        {
                name = "Tebex SourceMod",
                author = "Tebex",
                description = "Official SourceMod plugin for the Tebex platform",
                version = "0.1.0",
                url = "https://www.tebex.io/"
        }

public void OnPluginStart()
{
    PrintToServer("This is a test");
}
