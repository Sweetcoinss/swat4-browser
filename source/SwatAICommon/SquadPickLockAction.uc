class SquadPickLockAction extends SquadStackUpAction
	collapsecategories
	hidecategories(Object,InternalParameters);

state Running
{Begin:

	StackUpSquad(true);
	PickLock(true);
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.SquadPickLockGoal'
}