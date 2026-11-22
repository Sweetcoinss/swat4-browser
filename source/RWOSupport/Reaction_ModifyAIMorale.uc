class Reaction_ModifyAIMorale extends Reaction
	editinlinenew
	collapsecategories
	hidecategories(Object);

enum MoraleModAIType
{
	HostageAndEnemy,                // 0
	EnemyOnly,                      // 1
	HostageOnly                     // 2
};

var(Reaction) Range MoraleModicationAmount "This range will be used to add or subtract from the AI's current morale";
var(Reaction) array<name> SpawnerGroups "Specify one or multiple SpawnerGroups whose members you want to modify their morale";
var(Reaction) Reaction_ModifyAIMorale.MoraleModAIType ModificationAIType "The type of AI we will be modifying the morale of";

private function bool IsOnSpawnerGroupsList(name TestSpawnerGroup)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, SpawnerGroups.Length))
	{
		if(EqualEqual_NameName(SpawnerGroups[i], TestSpawnerGroup))
		{
			return true;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return false;
	return;
}

private function bool ShouldModifyMorale(Pawn AI)
{
	if(Greater_IntInt(SpawnerGroups.Length, 0))
	{
		if(AI.IsA('SwatEnemy'))
		{
			if(Not_PreBool(IsOnSpawnerGroupsList(ISwatEnemy(AI).SpawnedFromGroup())))
			{
				return false;
			}
		}
		else
		{
			if(AI.IsA('SwatHostage'))
			{
				if(Not_PreBool(IsOnSpawnerGroupsList(ISwatHostage(AI).SpawnedFromGroup())))
				{
					return false;
				}
			}
		}
	}
	switch(ModificationAIType)
	{
		case 0:
			return OrOr_BoolBool(AI.IsA('SwatEnemy'), AI.IsA('SwatHostage'));
		case 1:
			return AI.IsA('SwatEnemy');
		case 2:
			return AI.IsA('SwatHostage');
		default:
			return;
			break;
	}
}

private function ModifyMoraleOf(Pawn AI)
{
	local float RandomMoraleChange;

	RandomMoraleChange = RandRange(MoraleModicationAmount.Min, MoraleModicationAmount.Max);
	ISwatAI(AI).GetCommanderAction().ChangeMorale(RandomMoraleChange, At_StrStr(At_StrStr(At_StrStr("Morale changed by Reaction_ModifyAIMorale", string(Name)), "at time"), string(AI.Level.TimeSeconds)));
	return;
}

protected function execute(Actor Owner, Actor Other)
{
	local Pawn PawnIter;

	PawnIter = Owner.Level.PawnList;
	J0x1D:

	if(NotEqual_ObjectObject(PawnIter, none))
	{
		if(ShouldModifyMorale(PawnIter))
		{
			ModifyMoraleOf(PawnIter);
		}
		PawnIter = PawnIter.nextPawn;
		// [Loop Continue]
		goto J0x1D;
	}
	return;
}
