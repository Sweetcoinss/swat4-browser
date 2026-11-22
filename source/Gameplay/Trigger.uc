class Trigger extends Actor
	abstract
	config
	notplaceable
	hidecategories(Karma,Events,Force,Karma,Lighting,LightColor,Movement,Sound);

var string debugLogString;
var array<name> triggeredByFilter;

function bool CanTrigger(Actor TestActor)
{
	local int Index;

	if(EqualEqual_IntInt(triggeredByFilter.Length, 0))
	{
		return true;
	}
	Index = 0;
	J0x15:

	if(Less_IntInt(Index, triggeredByFilter.Length))
	{
		if(EqualEqual_NameName(triggeredByFilter[Index], TestActor.Label))
		{
			return true;
		}
		AddAdd_PreInt(Index);
		// [Loop Continue]
		goto J0x15;
	}
	return false;
	return;
}

function dispatchMessage(Message msg)
{
	Log(Concat_StrStr(string(self), ".dispatchMessage: Use the 'dispatchTrigger' function to send messages from trigger classes."));
	return;
}

function bool dispatchTrigger(Actor Instigator, MessageTrigger msg)
{
	local Pawn P;
	local PlayerController C;

	if(NotEqual_StrStr(debugLogString, ""))
	{
		P = Pawn(Instigator);
		if(NotEqual_ObjectObject(P, none))
		{
			C = PlayerController(P.Controller);
			if(NotEqual_ObjectObject(C, none))
			{
				C.ClientMessage(Concat_StrStr(Concat_StrStr(Concat_StrStr("TRIGGER ", string(Label)), ": "), debugLogString));
			}
		}
	}
	dispatchMessage(msg);
	return true;
	return;
}

defaultproperties
{
	bHidden=true
	Texture=Texture'Engine_res.S_Trigger'
	bCollideActors=true
}