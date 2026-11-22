class Campaign extends Object
	config(Campaign)
	perobjectconfig;

var config localized string StringName;
var config array<name> MissionResultNames;
var array<MissionResults> MissionResults;
var private config int availableIndex;
var private config bool HACK_HasPlayedCreditsOnCampaignCompletion;

overloaded function Construct()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, MissionResultNames.Length))
	{
		MissionResults[i] = Class'SwatGame.MissionResults'.static.Allocate(self,, Concat_StrStr(Concat_StrStr(StringName, "_"), string(MissionResultNames[i]))).;
		Construct_Void();
		assert(NotEqual_ObjectObject(MissionResults[i], none));
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

final function int GetAvailableIndex()
{
	return availableIndex;
	return;
}

final function bool HasPlayedCreditsOnCampaignCompletion()
{
	return HACK_HasPlayedCreditsOnCampaignCompletion;
	return;
}

final function SetHasPlayedCreditsOnCampaignCompletion()
{
	HACK_HasPlayedCreditsOnCampaignCompletion = true;
	SaveConfig();
	return;
}

final function MissionEnded(name Mission, SwatGUIConfig.eDifficultyLevel Difficulty, bool Completed, int Score, bool bMetDifficultyScoreRequirement)
{
	local int Index;

	Log(Concat_StrStr("[dkaplan] Adding Mission result for mission: ", string(Mission)));
	Index = GetMissionIndex(Mission);
	if(GreaterEqual_IntInt(Index, MissionResults.Length))
	{
		MissionResults[Index] = Class'SwatGame.MissionResults'.static.Allocate(self,, Concat_StrStr(Concat_StrStr(StringName, "_"), string(Mission))).;
		Construct_Void();
		MissionResultNames[Index] = Mission;
	}
	assert(NotEqual_ObjectObject(MissionResults[Index], none));
	MissionResults[Index].AddResult(Difficulty, Completed, Score);
	if(AndAnd_BoolBool(AndAnd_BoolBool(Completed, bMetDifficultyScoreRequirement), EqualEqual_IntInt(availableIndex, Index)))
	{
		availableIndex = Add_IntInt(Index, 1);
	}
	SaveConfig();
	return;
}

final function MissionResults GetMissionResults(name Mission)
{
	local int Index;

	Index = GetMissionIndex(Mission);
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("[dkaplan] getting mission results for mission ", string(Mission)), ", index = "), string(Index)));
	return MissionResults[Index];
	return;
}

private function int GetMissionIndex(name Mission)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, MissionResults.Length))
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(MissionResults[i], none), EqualEqual_NameName(MissionResultNames[i], Mission)))
		{
			// [Explicit Break]
			goto J0x4C;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	J0x4C:

	return i;
	return;
}

function PreDelete()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, MissionResults.Length))
	{
		MissionResults[i].PreDelete();
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	MissionResults.Remove(0, MissionResults.Length);
	MissionResultNames.Remove(0, MissionResultNames.Length);
	availableIndex = 0;
	StringName = "";
	SaveConfig();
	return;
}
