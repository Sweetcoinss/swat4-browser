class AI_SquadGoal extends AI_Goal
	abstract
	collapsecategories
	hidecategories(Object,InternalParameters);

static function Class<Tyrion_ResourceBase> getResourceClass()
{
	return Class'Tyrion.AI_SquadResource';
	return;
}

static function Tyrion_ResourceBase findResource(Pawn P, optional Tyrion_GoalBase Goal)
{
	assert(false);
	return none;
	return;
}
