class ActionGetGameMode extends Action
	editinlinenew
	collapsecategories
	hidecategories(Object);

latent function Variable execute()
{
	local string GameModeString;

	if(EqualEqual_IntInt(int(parentScript.Level.NetMode), int(NM_Standalone)))
	{
		GameModeString = "Standalone";
	}
	else
	{
		GameModeString = string(GetEnum(Enum'Engine.Repo.EMPMode', int(ServerSettings(parentScript.Level.CurrentServerSettings).GameType)));
	}
	Log(Concat_StrStr(Concat_StrStr(string(self), "::execute() ... Game Mode  =  "), GameModeString));
	return newTemporaryVariable(Class'Scripting.VariableName', GameModeString);
	return;
}

function editorDisplayString(out string S)
{
	S = "Get the Current Game Mode.";
	return;
}

defaultproperties
{
	actionDisplayName="Get the Current Game Mode."
	actionHelp="Get the Current Game Mode."
	returnType=Class'Scripting.Variable'
	category="Variable"
}