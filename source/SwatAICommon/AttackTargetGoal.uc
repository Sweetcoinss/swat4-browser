class AttackTargetGoal extends SwatWeaponGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Actor Target;
var(Parameters) Pawn TargetPawn;
var(Parameters) float ChanceToSucceedAfterFiring;
var(Parameters) bool bHavePerfectAim;
var(Parameters) bool bOrderedToAttackTarget;

overloaded function Construct(AI_Resource R)
{
	assert(false);
	return;
}

overloaded function Construct(AI_Resource R, Actor inTarget)
{
	construct_AI_ResourceInt(R, Priority);
	assert(NotEqual_ObjectObject(inTarget, none));
	Target = inTarget;
	TargetPawn = Pawn(Target);
	return;
}

overloaded function Construct(AI_Resource R, int PRI, Actor inTarget)
{
	construct_AI_ResourceInt(R, PRI);
	assert(NotEqual_ObjectObject(inTarget, none));
	Target = inTarget;
	TargetPawn = Pawn(Target);
	return;
}

function SetChanceToSucceedAfterFiring(float inChanceToSucceedAfterFiring)
{
	assert(GreaterEqual_FloatFloat(inChanceToSucceedAfterFiring, 0.0000000));
	assert(LessEqual_FloatFloat(inChanceToSucceedAfterFiring, 1.0000000));
	ChanceToSucceedAfterFiring = inChanceToSucceedAfterFiring;
	return;
}

function SetHavePerfectAim(bool inHavePerfectAim)
{
	bHavePerfectAim = inHavePerfectAim;
	return;
}

function SetOrderedToAttackTarget(bool inOrderedToAttackTarget)
{
	bOrderedToAttackTarget = inOrderedToAttackTarget;
	return;
}

defaultproperties
{
	Priority=80
	goalName="AttackTarget"
}