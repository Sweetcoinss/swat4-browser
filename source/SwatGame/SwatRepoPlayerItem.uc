class SwatRepoPlayerItem extends Object;

var int SwatPlayerID;
var int TeamID;
var private int PreferredTeamID;
var bool bHasEnteredFirstRound;
var bool bIsReadyToSpawn;
var bool bIsAReconnectingClient;
var bool bConnected;
var Class<Actor> RepoLoadOutSpec[25];
var string LastAdminPassword;

function SetPocketItemClass(HandheldEquipment.Pocket Pocket, Class<Actor> ItemClass)
{
	RepoLoadOutSpec[int(Pocket)] = ItemClass;
	return;
}

function SetPocketItemClassName(HandheldEquipment.Pocket Pocket, string ItemClassName)
{
	local Class<Actor> ItemClass;

	if(NotEqual_StrStr(ItemClassName, ""))
	{
		ItemClass = Class<HandheldEquipment>(DynamicLoadObject(ItemClassName, Class'Core.Class'));
	}
	SetPocketItemClass(Pocket, ItemClass);
	return;
}

function Class<Actor> GetPocketItem(HandheldEquipment.Pocket Pocket)
{
	return RepoLoadOutSpec[int(Pocket)];
	return;
}

simulated function PrintLoadOutSpecToMPLog()
{
	local int i;

	MPLog("LoadOutSpec contains:");
	i = 0;
	J0x24:

	if(Less_IntInt(i, int(25)))
	{
		MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr("...RepoLoadOutSpec[", string(GetEnum(Enum'Engine.HandheldEquipment.Pocket', i))), "]="), string(RepoLoadOutSpec[i])));
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x24;
	}
	return;
}

function SetTeamID(int NewTeamID)
{
	Log(Concat_StrStr(Concat_StrStr(string(self), " in SwatRepoPlayerItem::SetTeamID(). TeamID="), string(TeamID)));
	TeamID = NewTeamID;
	return;
}

function int GetTeamID()
{
	Log(Concat_StrStr(Concat_StrStr(string(self), " in SwatRepoPlayerItem::GetTeamID(). TeamID="), string(TeamID)));
	return TeamID;
	return;
}

function SetPreferredTeamID(int NewPreferredTeamID)
{
	PreferredTeamID = NewPreferredTeamID;
	Log(Concat_StrStr(Concat_StrStr(string(self), " in SwatRepoPlayerItem::SetPreferredTeamID(). PreferredTeamID="), string(PreferredTeamID)));
	return;
}

function int GetPreferredTeamID()
{
	Log(Concat_StrStr(Concat_StrStr(string(self), " in SwatRepoPlayerItem::GetPreferredTeamID(). PreferredTeamID="), string(PreferredTeamID)));
	return PreferredTeamID;
	return;
}

function SetHasEnteredFirstRound()
{
	bHasEnteredFirstRound = true;
	return;
}

function bool HasEnteredFirstRound()
{
	return bHasEnteredFirstRound;
	return;
}

function SetReadyToSpawn()
{
	bIsReadyToSpawn = true;
	return;
}

function bool IsReadyToSpawn()
{
	return bIsReadyToSpawn;
	return;
}
