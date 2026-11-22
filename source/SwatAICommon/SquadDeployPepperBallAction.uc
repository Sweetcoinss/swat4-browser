class SquadDeployPepperBallAction extends OfficerSquadAction
	collapsecategories
	hidecategories(Object,InternalParameters);

var private DeployPepperBallGoal CurrentDeployPepperBallGoal;
var(Parameters) Pawn TargetPawn;

function cleanup()
{
	super(ActionBase).cleanup();
	if(NotEqual_ObjectObject(CurrentDeployPepperBallGoal, none))
	{
		CurrentDeployPepperBallGoal.Release();
		CurrentDeployPepperBallGoal = none;
	}
	return;
}

latent function DeployPepperBallOnTarget()
{
	local Pawn Officer;

	Officer = GetClosestOfficerWithEquipment(TargetPawn.Location, 1, 'CSBallLauncher');
	CurrentDeployPepperBallGoal = Class'SwatAICommon.DeployPepperBallGoal'.static.Allocate(self).;
	construct_AI_ResourcePawn(AI_Resource(Officer.CharacterAI), TargetPawn);
	assert(NotEqual_ObjectObject(CurrentDeployPepperBallGoal, none));
	CurrentDeployPepperBallGoal.AddRef();
	CurrentDeployPepperBallGoal.postGoal(self);
	waitForGoal(CurrentDeployPepperBallGoal);
	CurrentDeployPepperBallGoal.unPostGoal(self);
	CurrentDeployPepperBallGoal.Release();
	CurrentDeployPepperBallGoal = none;
	return;
}

state Running
{Begin:

	DeployPepperBallOnTarget();
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.SquadDeployPepperBallGoal'
}