class AI_CharacterGoal extends AI_Goal
	abstract
	native
	collapsecategories
	hidecategories(Object,InternalParameters);

static function Class<Tyrion_ResourceBase> getResourceClass()
{
	return Class'Tyrion.AI_CharacterResource';
	return;
}

static function Tyrion_ResourceBase findResource(Pawn P, optional Tyrion_GoalBase Goal)
{
	return P.CharacterAI;
	return;
}
