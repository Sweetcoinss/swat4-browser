class RotateTowardActorAction extends SwatMovementAction
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Actor ActorToRotateToward;

state Running
{Begin:

	assert(achievingGoal.IsA('RotateTowardActorGoal'));
	RotateTowardActor(ActorToRotateToward);
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.RotateTowardActorGoal'
}