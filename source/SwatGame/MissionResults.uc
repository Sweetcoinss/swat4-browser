class MissionResults extends Object;

var private MissionResult Results[4];

overloaded function Construct()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, int(4)))
	{
		Results[i] = Class'SwatGame.MissionResult'.static.Allocate(self,, Concat_StrStr(Concat_StrStr(string(self.Name), "_"), string(GetEnum(Enum'SwatGame.SwatGUIConfig.eDifficultyLevel', i)))).;
		Construct_Void();
		assert(NotEqual_ObjectObject(Results[i], none));
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

function AddResult(SwatGUIConfig.eDifficultyLevel Difficulty, bool bCompleted, int Score)
{
	if(Not_PreBool(Results[int(Difficulty)].Played))
	{
		Results[int(Difficulty)].Played = true;
		Results[int(Difficulty)].Difficulty = Difficulty;
		Results[int(Difficulty)].Completed = bCompleted;
		Results[int(Difficulty)].Score = Score;
	}
	else
	{
		Results[int(Difficulty)].Completed = OrOr_BoolBool(Results[int(Difficulty)].Completed, bCompleted);
		Results[int(Difficulty)].Score = Max(Results[int(Difficulty)].Score, Score);
	}
	Results[int(Difficulty)].SaveConfig();
	return;
}

function MissionResult GetResult(SwatGUIConfig.eDifficultyLevel Difficulty)
{
	return Results[int(Difficulty)];
	return;
}

function bool EverPlayed()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, int(4)))
	{
		if(Results[i].Played)
		{
			return true;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return false;
	return;
}

function PreDelete()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, int(4)))
	{
		Results[i].Completed = false;
		Results[i].Score = 0;
		Results[i].Played = false;
		Results[i].SaveConfig();
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}
