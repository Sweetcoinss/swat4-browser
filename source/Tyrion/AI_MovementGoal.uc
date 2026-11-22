class AI_MovementGoal extends AI_Goal
	abstract
	collapsecategories
	hidecategories(Object,InternalParameters);

static function Class<Tyrion_ResourceBase> getResourceClass()
{
	return Class'Tyrion.AI_MovementResource';
	return;
}

static function Tyrion_ResourceBase findResource(Pawn P, optional Tyrion_GoalBase Goal)
{
	return P.MovementAI;
	return;
}

function AI_CharacterResource characterResource()
{
	return AI_CharacterResource(AI_MovementResource(resource).m_pawn.CharacterAI);
	return;
}
