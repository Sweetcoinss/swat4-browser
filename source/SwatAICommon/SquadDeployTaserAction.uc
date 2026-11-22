class SquadDeployTaserAction extends OfficerSquadAction
	collapsecategories
	hidecategories(Object,InternalParameters);

var private DeployTaserGoal CurrentDeployTaserGoal;
var(Parameters) Pawn TargetPawn;

function cleanup()
{
	super(ActionBase).cleanup();
	if(NotEqual_ObjectObject(CurrentDeployTaserGoal, none))
	{
		CurrentDeployTaserGoal.Release();
		CurrentDeployTaserGoal = none;
	}
	return;
}

latent function DeployTaserOnTarget()
{
	local Pawn Officer;

	Officer = GetClosestOfficerWithEquipment(TargetPawn.Location, 2, 'Taser');
	CurrentDeployTaserGoal = Class'SwatAICommon.DeployTaserGoal'.static.Allocate(self).;
	construct_AI_ResourcePawn(AI_Resource(Officer.CharacterAI), TargetPawn);
	assert(NotEqual_ObjectObject(CurrentDeployTaserGoal, none));
	CurrentDeployTaserGoal.AddRef();
	CurrentDeployTaserGoal.postGoal(self);
	waitForGoal(CurrentDeployTaserGoal);
	CurrentDeployTaserGoal.unPostGoal(self);
	CurrentDeployTaserGoal.Release();
	CurrentDeployTaserGoal = none;
	return;
}

state Running
{Begin:

	DeployTaserOnTarget();
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.SquadDeployTaserGoal'
}