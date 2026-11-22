class SweepWeaponIdleAction extends ProceduralIdleAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

var private AimAroundGoal CurrentAimAroundGoal;

function cleanup()
{
	super(BaseIdleAction).cleanup();
	if(NotEqual_ObjectObject(CurrentAimAroundGoal, none))
	{
		CurrentAimAroundGoal.Release();
		CurrentAimAroundGoal = none;
	}
	return;
}

latent function SweepWeapon()
{
	CurrentAimAroundGoal = Class'SwatAICommon.AimAroundGoal'.static.Allocate(self).;
	construct_AI_ResourceInt(weaponResource());
	assert(NotEqual_ObjectObject(CurrentAimAroundGoal, none));
	CurrentAimAroundGoal.AddRef();
	CurrentAimAroundGoal.SetAimInnerFovDegrees(60.0000000);
	CurrentAimAroundGoal.SetAimOuterFovDegrees(120.0000000);
	CurrentAimAroundGoal.SetDoOnce(true);
	CurrentAimAroundGoal.postGoal(self);
	waitForGoal(CurrentAimAroundGoal);
	CurrentAimAroundGoal.unPostGoal(self);
	CurrentAimAroundGoal.Release();
	CurrentAimAroundGoal = none;
	return;
}

state Running
{Begin:

	SweepWeapon();
	succeed();
	stop;
}
