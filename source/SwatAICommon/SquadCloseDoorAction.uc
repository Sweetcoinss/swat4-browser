class SquadCloseDoorAction extends OfficerSquadAction
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Door TargetDoor;
var private CloseDoorGoal CurrentCloseDoorGoal;
var private Pawn DoorCloser;

function cleanup()
{
	super(ActionBase).cleanup();
	if(NotEqual_ObjectObject(CurrentCloseDoorGoal, none))
	{
		CurrentCloseDoorGoal.Release();
		CurrentCloseDoorGoal = none;
	}
	return;
}

latent function CloseTheDoor()
{
	CurrentCloseDoorGoal = Class'SwatAICommon.CloseDoorGoal'.static.Allocate(self).;
	construct_AI_ResourceDoor(AI_Resource(DoorCloser.MovementAI), TargetDoor);
	assert(NotEqual_ObjectObject(CurrentCloseDoorGoal, none));
	CurrentCloseDoorGoal.AddRef();
	CurrentCloseDoorGoal.SetRotateTowardsPointsDuringMovement(true);
	CurrentCloseDoorGoal.SetCloseDoorFromLeft(ISwatDoor(TargetDoor).PointIsToMyLeft(CommandOrigin));
	CurrentCloseDoorGoal.postGoal(self);
	waitForGoal(CurrentCloseDoorGoal);
	CurrentCloseDoorGoal.unPostGoal(self);
	CurrentCloseDoorGoal.Release();
	CurrentCloseDoorGoal = none;
	return;
}

state Running
{Begin:

	DoorCloser = GetClosestOfficerTo(TargetDoor, false, true);
	assert(NotEqual_ObjectObject(DoorCloser, none));
	CloseTheDoor();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.SquadCloseDoorGoal'
}