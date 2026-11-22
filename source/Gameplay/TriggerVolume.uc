class TriggerVolume extends PhysicsVolume
	config
	hidecategories(Karma,Events,Force,Karma,LightColor,Lighting,Sound,Object);

var() array< Class<Pawn> > TriggerOnlyByClass "If not empty, this TriggerVolume will only trigger if the class of Pawn entering or leaving the Volume is in this list.";
var() array<name> TriggerOnlyByLabel "If not empty, this TriggerVolume will only trigger if the label of the Pawn entering or leaving the Volume is in this list.";
var() bool TriggerOnlyOnce "If true, then MessageTriggerVolumeEnter and MessageTriggerVolumeExit will only be sent once (each).";
var bool Disabled;
var bool AlreadyTriggeredEntered;
var bool AlreadyTriggeredLeaving;

event PawnEnteredVolume(Pawn Other)
{
	if(Disabled)
	{
		return;
	}
	if(AndAnd_BoolBool(TriggerOnlyOnce, AlreadyTriggeredEntered))
	{
		return;
	}
	if(MeetsRestrictions(Other))
	{
		dispatchMessage(Class'Gameplay.MessageTriggerVolumeEnter'.static.Allocate(self)., construct_NameName(Label, Other.Label));
		AlreadyTriggeredEntered = true;
	}
	return;
}

event PawnLeavingVolume(Pawn Other)
{
	if(Disabled)
	{
		return;
	}
	if(AndAnd_BoolBool(TriggerOnlyOnce, AlreadyTriggeredLeaving))
	{
		return;
	}
	if(MeetsRestrictions(Other))
	{
		dispatchMessage(Class'Gameplay.MessageTriggerVolumeExit'.static.Allocate(self)., construct_NameName(Label, Other.Label));
		AlreadyTriggeredLeaving = true;
	}
	return;
}

function bool MeetsRestrictions(Pawn Other)
{
	local int i;
	local bool Trigger;

	if(AndAnd_BoolBool(EqualEqual_IntInt(TriggerOnlyByClass.Length, 0), EqualEqual_IntInt(TriggerOnlyByLabel.Length, 0)))
	{
		return true;
	}
	if(Greater_IntInt(TriggerOnlyByClass.Length, 0))
	{
		Trigger = false;
		i = 0;
		J0x37:

		if(Less_IntInt(i, TriggerOnlyByClass.Length))
		{
			if(EqualEqual_ObjectObject(TriggerOnlyByClass[i], Other.Class))
			{
				Trigger = true;
				// [Explicit Break]
				goto J0x7A;
			}
			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0x37;
		}
		J0x7A:

		if(Not_PreBool(Trigger))
		{
			return false;
		}
	}
	if(Greater_IntInt(TriggerOnlyByLabel.Length, 0))
	{
		Trigger = false;
		i = 0;
		J0xA2:

		if(Less_IntInt(i, TriggerOnlyByLabel.Length))
		{
			if(EqualEqual_NameName(TriggerOnlyByLabel[i], Other.Label))
			{
				Trigger = true;
				// [Explicit Break]
				goto J0xE5;
			}
			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0xA2;
		}
		J0xE5:

		if(Not_PreBool(Trigger))
		{
			return false;
		}
	}
	return true;
	return;
}

function ResetForMPQuickRestart()
{
	Disabled = false;
	AlreadyTriggeredEntered = false;
	AlreadyTriggeredLeaving = false;
	return;
}
