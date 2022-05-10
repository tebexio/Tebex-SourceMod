KeyValues TebexInformation;

public void TebexInformationInit() {
	Msg( "// Information Model		   //" );

	TebexInformation = new KeyValues("information");
	TebexInformation.SetEscapeSequences(true);

	TebexInformation.SetNum("id", 0);
	TebexInformation.SetString("name", "");
	TebexInformation.SetString("domain", "");
	TebexInformation.SetString("currency", "");
	TebexInformation.SetString("currencySymbol", "");
	TebexInformation.SetString("gameType", "");
	TebexInformation.SetString("serverName", "");
	TebexInformation.SetNum("serverId", 0);
}
