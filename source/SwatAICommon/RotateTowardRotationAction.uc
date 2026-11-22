class RotateTowardRotationAction extends SwatMovementAction
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Rotator DesiredRotation;

state Running
{Begin:

	assert(achievingGoal.IsA('RotateTowardRotationGoal'));
	RotateTowardRotation(DesiredRotation);
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.RotateTowardRotationGoal'
}