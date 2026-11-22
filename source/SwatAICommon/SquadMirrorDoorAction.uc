class SquadMirrorDoorAction extends SquadStackUpAction
	collapsecategories
	hidecategories(Object,InternalParameters);

var private Pawn OfficerWithMirror;
var private MirrorDoorGoal CurrentMirrorDoorGoal;

function cleanup()
{
	super.cleanup();
	if(NotEqual_ObjectObject(CurrentMirrorDoorGoal, none))
	{
		CurrentMirrorDoorGoal.Release();
		CurrentMirrorDoorGoal = none;
	}
	return;
}

function Pawn GetFirstOfficerWithMirror()
{
	local int i;
	local Pawn Officer;

	i = 0;
	J0x07:

	if(Less_IntInt(i, OfficersInStackUpOrder.Length))
	{
		Officer = OfficersInStackUpOrder[i];
		if(AndAnd_BoolBool(Class'Engine.Pawn'.static.checkConscious(Officer), NotEqual_ObjectObject(ISwatOfficer(Officer).GetItemAtSlot(9), none)))
		{
			return Officer;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return none;
	return;
}

latent function MirrorDoor()
{
	OfficerWithMirror = GetFirstOfficerWithMirror();
	if(EqualEqual_ObjectObject(OfficerWithMirror, none))
	{
		instantSucceed();
	}
	else
	{
		if(NotEqual_ObjectObject(OfficerWithMirror, GetFirstOfficer()))
		{
			ISwatOfficer(OfficerWithMirror).GetOfficerSpeechManagerAction().TriggerGenericMoveUpSpeech();
			SwapStackUpPositions(OfficerWithMirror, GetFirstOfficer());
		}
		CurrentMirrorDoorGoal = Class'SwatAICommon.MirrorDoorGoal'.static.Allocate(self).;
		construct_AI_ResourceDoor(AI_CharacterResource(OfficerWithMirror.CharacterAI), TargetDoor);
		assert(NotEqual_ObjectObject(CurrentMirrorDoorGoal, none));
		CurrentMirrorDoorGoal.AddRef();
		CurrentMirrorDoorGoal.postGoal(self);
		waitForGoal(CurrentMirrorDoorGoal);
		CurrentMirrorDoorGoal.unPostGoal(self);
		CurrentMirrorDoorGoal.Release();
		CurrentMirrorDoorGoal = none;
	}
	return;
}

state Running
{Begin:

	StackUpSquad(true);
	MirrorDoor();
	StackUpOfficer(OfficerWithMirror, StackUpPoints[0]);
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.SquadMirrorDoorGoal'
}