class ActionSetSpawnClusterEnabled extends Action
	editinlinenew
	collapsecategories
	hidecategories(Object);

var name SpawnCluster;
var bool Enabled;

latent function Variable execute()
{
	local GameMode TheGameMode;

	MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr("In ActionSetSpawnClusterEnabled::Execute(). SpawnCluster=", string(SpawnCluster)), ", Enabled="), string(Enabled)));
	TheGameMode = SwatGameInfo(parentScript.Level.Game).GetGameMode();
	if(NotEqual_NameName(SpawnCluster, 'None'))
	{
		TheGameMode.SetSpawnClusterEnabled(SpawnCluster, Enabled);
	}
	return none;
	return;
}

function editorDisplayString(out string S)
{
	local string SpawnClusterString;

	SpawnClusterString = string(SpawnCluster);
	if(EqualEqual_StrStr(SpawnClusterString, ""))
	{
		SpawnClusterString = "a Spawn Cluster";
	}
	if(Enabled)
	{
		S = Concat_StrStr("Enable ", SpawnClusterString);
	}
	else
	{
		S = Concat_StrStr("Disable ", SpawnClusterString);
	}
	return;
}

defaultproperties
{
	actionDisplayName="Enable/Disable a Spawn Cluster"
	actionHelp="Enable/Disable a Spawn Cluster"
	category="Script"
}