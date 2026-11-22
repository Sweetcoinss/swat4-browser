class SquadPlaceWedgeAction extends SquadStackUpAction
	collapsecategories
	hidecategories(Object,InternalParameters);

var private PlaceWedgeGoal CurrentPlaceWedgeGoal;
var private Pawn OfficerWithWedge;
var private StackupPoint OfficerWithWedgeStackupPoint;

function cleanup()
{
	super.cleanup();
	if(NotEqual_ObjectObject(CurrentPlaceWedgeGoal, none))
	{
		CurrentPlaceWedgeGoal.Release();
		CurrentPlaceWedgeGoal = none;
	}
	return;
}

function int GetFirstOfficerWithWedgeIndex()
{
	local int i;
	local Pawn Officer;

	i = 0;
	J0x07:

	if(Less_IntInt(i, OfficersInStackUpOrder.Length))
	{
		Officer = OfficersInStackUpOrder[i];
		if(AndAnd_BoolBool(Class'Engine.Pawn'.static.checkConscious(Officer), NotEqual_ObjectObject(ISwatOfficer(Officer).GetItemAtSlot(10), none)))
		{
			return i;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return -1;
	return;
}

latent function PlaceWedge()
{
	local int OfficerWithWedgeIndex;

	OfficerWithWedgeIndex = GetFirstOfficerWithWedgeIndex();
	if(EqualEqual_IntInt(OfficerWithWedgeIndex, -1))
	{
		instantSucceed();
	}
	else
	{
		OfficerWithWedge = OfficersInStackUpOrder[OfficerWithWedgeIndex];
		OfficerWithWedgeStackupPoint = StackUpPoints[OfficerWithWedgeIndex];
		CurrentPlaceWedgeGoal = Class'SwatAICommon.PlaceWedgeGoal'.static.Allocate(self).;
		construct_AI_ResourceDoor(AI_Resource(OfficerWithWedge.CharacterAI), TargetDoor);
		assert(NotEqual_ObjectObject(CurrentPlaceWedgeGoal, none));
		CurrentPlaceWedgeGoal.AddRef();
		CurrentPlaceWedgeGoal.postGoal(self);
		waitForGoal(CurrentPlaceWedgeGoal);
		CurrentPlaceWedgeGoal.unPostGoal(self);
		CurrentPlaceWedgeGoal.Release();
		CurrentPlaceWedgeGoal = none;
	}
	return;
}

state Running
{Begin:

	StackUpSquad(true);
	PlaceWedge();
	StackUpOfficer(OfficerWithWedge, OfficerWithWedgeStackupPoint);
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.SquadPlaceWedgeGoal'
}