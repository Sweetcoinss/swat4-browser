class SquadDeployPepperSprayAction extends OfficerSquadAction
	collapsecategories
	hidecategories(Object,InternalParameters);

var private DeployPepperSprayGoal CurrentDeployPepperSprayGoal;
var(Parameters) Pawn TargetPawn;

function cleanup()
{
	super(ActionBase).cleanup();
	if(NotEqual_ObjectObject(CurrentDeployPepperSprayGoal, none))
	{
		CurrentDeployPepperSprayGoal.Release();
		CurrentDeployPepperSprayGoal = none;
	}
	return;
}

latent function DeployPepperSprayOnTarget()
{
	local Pawn Officer;

	Officer = GetClosestOfficerWithEquipment(TargetPawn.Location, 6);
	CurrentDeployPepperSprayGoal = Class'SwatAICommon.DeployPepperSprayGoal'.static.Allocate(self).;
	construct_AI_ResourcePawn(AI_Resource(Officer.CharacterAI), TargetPawn);
	assert(NotEqual_ObjectObject(CurrentDeployPepperSprayGoal, none));
	CurrentDeployPepperSprayGoal.AddRef();
	CurrentDeployPepperSprayGoal.postGoal(self);
	waitForGoal(CurrentDeployPepperSprayGoal);
	CurrentDeployPepperSprayGoal.unPostGoal(self);
	CurrentDeployPepperSprayGoal.Release();
	CurrentDeployPepperSprayGoal = none;
	return;
}

state Running
{Begin:

	DeployPepperSprayOnTarget();
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.SquadDeployPepperSprayGoal'
}