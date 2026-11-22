class Reaction_AlertAIs extends Reaction
	editinlinenew
	collapsecategories
	hidecategories(Object);

var(Reaction) array<name> SpawnerGroups "Specify one or multiple SpawnerGroups whose members that you want to alert";

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

private function bool ShouldAlertAI(Pawn AI)
{
	return AndAnd_BoolBool(AI.IsA('SwatEnemy'), OrOr_BoolBool(EqualEqual_IntInt(SpawnerGroups.Length, 0), IsOnSpawnerGroupsList(ISwatEnemy(AI).SpawnedFromGroup())));
	return;
}

private function AlertAI(Pawn AI)
{
	assert(AI.IsA('SwatEnemy'));
	ISwatEnemy(AI).BecomeAware();
	return;
}

protected function execute(Actor Owner, Actor Other)
{
	local Pawn PawnIter;

	PawnIter = Owner.Level.PawnList;
	J0x1D:

	if(NotEqual_ObjectObject(PawnIter, none))
	{
		if(ShouldAlertAI(PawnIter))
		{
			AlertAI(PawnIter);
		}
		PawnIter = PawnIter.nextPawn;
		// [Loop Continue]
		goto J0x1D;
	}
	return;
}
