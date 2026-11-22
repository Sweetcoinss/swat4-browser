class RotateTowardPointAction extends SwatMovementAction
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Vector PointToRotateToward;

state Running
{Begin:

	assert(achievingGoal.IsA('RotateTowardPointGoal'));
	RotateTowardPoint(PointToRotateToward);
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.RotateTowardPointGoal'
}