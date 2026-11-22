class SquadRemoveWedgeAction extends SquadStackUpAction
	collapsecategories
	hidecategories(Object,InternalParameters);

var private RemoveWedgeGoal CurrentRemoveWedgeGoal;

function cleanup()
{
	super.cleanup();
	if(NotEqual_ObjectObject(CurrentRemoveWedgeGoal, none))
	{
		CurrentRemoveWedgeGoal.Release();
		CurrentRemoveWedgeGoal = none;
	}
	return;
}

latent function RemoveWedge(Pawn Officer)
{
	CurrentRemoveWedgeGoal = Class'SwatAICommon.RemoveWedgeGoal'.static.Allocate(self).;
	construct_AI_ResourceDoor(AI_Resource(Officer.CharacterAI), TargetDoor);
	assert(NotEqual_ObjectObject(CurrentRemoveWedgeGoal, none));
	CurrentRemoveWedgeGoal.AddRef();
	CurrentRemoveWedgeGoal.postGoal(self);
	waitForGoal(CurrentRemoveWedgeGoal);
	CurrentRemoveWedgeGoal.unPostGoal(self);
	CurrentRemoveWedgeGoal.Release();
	CurrentRemoveWedgeGoal = none;
	return;
}

state Running
{Begin:

	StackUpSquad(true);
	RemoveWedge(GetFirstOfficer());
	StackUpOfficer(GetFirstOfficer(), StackUpPoints[0]);
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.SquadRemoveWedgeGoal'
}