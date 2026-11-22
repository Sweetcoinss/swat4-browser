class SquadDisableTargetAction extends OfficerSquadAction
	collapsecategories
	hidecategories(Object,InternalParameters);

var private DisableTargetGoal CurrentDisableTargetGoal;
var(Parameters) Actor Target;

function Vector GetDisableFromPoint()
{
	local IDeployedC2Charge DeployedC2Charge;
	local ISwatDoor SwatDoor;
	local Vector DisablePoint;
	local Rotator DummyRotation;

	DeployedC2Charge = IDeployedC2Charge(Target);
	if(NotEqual_ObjectObject(DeployedC2Charge, none))
	{
		SwatDoor = DeployedC2Charge.GetDoorDeployedOn();
		if(NotEqual_ObjectObject(SwatDoor, none))
		{
			SwatDoor.GetOpenPositions(CommandGiver, false, DisablePoint, DummyRotation);
			return DisablePoint;
		}
	}
	return Target.Location;
	return;
}

latent function DisableTarget()
{
	local Pawn Officer;
	local bool bUseDisableTargetMoveThreshold;

	Officer = GetClosestOfficerWithEquipment(Target.Location, 8);
	bUseDisableTargetMoveThreshold = EqualEqual_ObjectObject(IDeployedC2Charge(Target), none);
	CurrentDisableTargetGoal = Class'SwatAICommon.DisableTargetGoal'.static.Allocate(self).;
	construct_AI_ResourceActorVectorBool(AI_Resource(Officer.CharacterAI), Target, GetDisableFromPoint(), bUseDisableTargetMoveThreshold);
	assert(NotEqual_ObjectObject(CurrentDisableTargetGoal, none));
	CurrentDisableTargetGoal.AddRef();
	CurrentDisableTargetGoal.postGoal(self);
	waitForGoal(CurrentDisableTargetGoal);
	CurrentDisableTargetGoal.unPostGoal(self);
	CurrentDisableTargetGoal.Release();
	CurrentDisableTargetGoal = none;
	return;
}

state Running
{Begin:

	DisableTarget();
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.SquadDisableTargetGoal'
}