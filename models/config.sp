KeyValues TebexConfig;
char TebexConfigFile[256];

public void TebexConfigInit() {
	Msg( "// Tebex™ SourceMod Config Library 0.1		   //" );

	TebexConfig = new KeyValues("config");
	TebexConfig.SetEscapeSequences(true);

	TebexConfig.SetString("buyEnabled", "1");
	TebexConfig.SetString("secret", "0");
	TebexConfig.SetString("buyCommand", "!donate");
	TebexConfig.SetString("baseUrl", "https://plugin.buycraft.net:443");

	/* As a compatibility shim, we use the old file if it exists. */
	BuildPath(Path_SM, TebexConfigFile, 255, "configs/tebex.cfg");
	if (FileExists(TebexConfigFile)) {
		Msg("Load config");
		CloseHandle(TebexConfig);
		TebexConfig = new KeyValues("config");
		FileToKeyValues(TebexConfig, TebexConfigFile);
	}
	else {
		Msg("No config file found... create a new one");
		KeyValuesToFile(TebexConfig, TebexConfigFile);
	}
}

public void TebexSetConfig(const char[] key, const char[] value) {
	TebexConfig.SetString(key, value);
	KeyValuesToFile(TebexConfig, TebexConfigFile);
	Msg("Config updated");
}
