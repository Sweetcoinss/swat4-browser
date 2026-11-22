class AttackEnemyGoal extends SwatCharacterGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) private Pawn Enemy;

overloaded function Construct(AI_Resource R, Pawn inEnemy)
{
	construct_AI_ResourceInt(R, Priority);
	assert(NotEqual_ObjectObject(inEnemy, none));
	Enemy = inEnemy;
	return;
}

defaultproperties
{
	Priority=85
	goalName="AttackEnemy"
}