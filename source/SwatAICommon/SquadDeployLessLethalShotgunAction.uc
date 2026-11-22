class SquadDeployLessLethalShotgunAction extends OfficerSquadAction
	collapsecategories
	hidecategories(Object,InternalParameters);

var private DeployLessLethalShotgunGoal CurrentDeployLessLethalShotgunGoal;
var(Parameters) Pawn TargetPawn;

function cleanup()
{
	super(ActionBase).cleanup();
	if(NotEqual_ObjectObject(CurrentDeployLessLethalShotgunGoal, none))
	{
		CurrentDeployLessLethalShotgunGoal.Release();
		CurrentDeployLessLethalShotgunGoal = none;
	}
	return;
}

latent function DeployLessLethalShotgunOnTarget()
{
	local Pawn Officer;

	Officer = GetClosestOfficerWithEquipment(TargetPawn.Location, 1, 'LessLethalSG');
	CurrentDeployLessLethalShotgunGoal = Class'SwatAICommon.DeployLessLethalShotgunGoal'.static.Allocate(self).;
	construct_AI_ResourcePawn(AI_Resource(Officer.CharacterAI), TargetPawn);
	assert(NotEqual_ObjectObject(CurrentDeployLessLethalShotgunGoal, none));
	CurrentDeployLessLethalShotgunGoal.AddRef();
	CurrentDeployLessLethalShotgunGoal.postGoal(self);
	waitForGoal(CurrentDeployLessLethalShotgunGoal);
	CurrentDeployLessLethalShotgunGoal.unPostGoal(self);
	CurrentDeployLessLethalShotgunGoal.Release();
	CurrentDeployLessLethalShotgunGoal = none;
	return;
}

state Running
{Begin:

	DeployLessLethalShotgunOnTarget();
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.SquadDeployLessLethalShotgunGoal'
}