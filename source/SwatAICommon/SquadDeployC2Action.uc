class SquadDeployC2Action extends SquadStackUpAction
	collapsecategories
	hidecategories(Object,InternalParameters);

var private UseBreachingChargeGoal CurrentUseBreachingChargeGoal;

function cleanup()
{
	super.cleanup();
	if(NotEqual_ObjectObject(CurrentUseBreachingChargeGoal, none))
	{
		CurrentUseBreachingChargeGoal.Release();
		CurrentUseBreachingChargeGoal = none;
	}
	return;
}

latent function DeployC2()
{
	local Pawn Officer;
	local NavigationPoint SafeLocation;

	Officer = GetC2BreachingOfficer();
	assert(NotEqual_ObjectObject(Officer, none));
	MoveUpC2Breacher(Officer);
	SafeLocation = StackUpPoints[0];
	assert(NotEqual_ObjectObject(SafeLocation, none));
	CurrentUseBreachingChargeGoal = Class'SwatAICommon.UseBreachingChargeGoal'.static.Allocate(self).;
	construct_AI_ResourceDoorNavigationPoint(AI_Resource(Officer.CharacterAI), TargetDoor, SafeLocation);
	assert(NotEqual_ObjectObject(CurrentUseBreachingChargeGoal, none));
	CurrentUseBreachingChargeGoal.AddRef();
	CurrentUseBreachingChargeGoal.postGoal(self);
	waitForGoal(CurrentUseBreachingChargeGoal);
	CurrentUseBreachingChargeGoal.unPostGoal(self);
	CurrentUseBreachingChargeGoal.Release();
	CurrentUseBreachingChargeGoal = none;
	return;
}

state Running
{Begin:

	StackUpSquad(true);
	DeployC2();
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.SquadDeployC2Goal'
}