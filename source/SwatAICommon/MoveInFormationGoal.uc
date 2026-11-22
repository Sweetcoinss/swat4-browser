class MoveInFormationGoal extends MoveToActorGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) float InnerMoveToThreshold;
var(Parameters) float OuterMoveToThreshold;
var(Parameters) float InnerWalkThreshold;
var(Parameters) float OuterWalkThreshold;

function SetMoveToThresholds(float InitialMoveToThreshold, float inInnerMoveToThreshold, float inOuterMoveToThreshold)
{
	assert(GreaterEqual_FloatFloat(InitialMoveToThreshold, 0.0000000));
	assert(GreaterEqual_FloatFloat(inInnerMoveToThreshold, 0.0000000));
	assert(GreaterEqual_FloatFloat(inOuterMoveToThreshold, 0.0000000));
	MoveToThreshold = InitialMoveToThreshold;
	InnerMoveToThreshold = inInnerMoveToThreshold;
	OuterMoveToThreshold = inOuterMoveToThreshold;
	return;
}

function SetWalkThresholds(float InitialWalkThreshold, float inInnerWalkThreshold, float inOuterWalkThreshold)
{
	assert(GreaterEqual_FloatFloat(InitialWalkThreshold, 0.0000000));
	assert(GreaterEqual_FloatFloat(inInnerWalkThreshold, 0.0000000));
	assert(GreaterEqual_FloatFloat(inOuterWalkThreshold, 0.0000000));
	WalkThreshold = InitialWalkThreshold;
	InnerWalkThreshold = inInnerWalkThreshold;
	OuterWalkThreshold = inOuterWalkThreshold;
	return;
}

defaultproperties
{
	InnerMoveToThreshold=125.0000000
	OuterMoveToThreshold=75.0000000
	InnerWalkThreshold=150.0000000
	OuterWalkThreshold=100.0000000
	MoveToThreshold=75.0000000
	WalkThreshold=100.0000000
	goalName="MoveInFormation"
}