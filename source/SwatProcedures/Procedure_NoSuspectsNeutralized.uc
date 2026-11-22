class Procedure_NoSuspectsNeutralized extends Procedure implements IInterested_GameEvent_PawnDied
	config(Leadership);

var config int Bonus;
var bool AnyoneNeutralized;

function PostInitHook()
{
	super.PostInitHook();
	GetGame().GameEvents.PawnDied.Register(self);
	return;
}

function OnPawnDied(Pawn Pawn, Actor Killer, bool WasAThreat)
{
	if(Not_PreBool(Pawn.IsA('SwatEnemy')))
	{
		return;
	}
	if(GetGame().DebugLeadership)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), " is setting AnyoneNeutralized=true because PawnDied, Pawn="), string(Pawn.Name)), ", Killer="), string(Killer)), "."));
	}
	AnyoneNeutralized = true;
	return;
}

function int GetCurrentValue()
{
	if(Not_PreBool(AnyoneNeutralized))
	{
		if(GetGame().DebugLeadershipStatus)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), " is returning CurrentValue = Bonus = "), string(Bonus)), " because !AnyoneNeutralized."));
		}
		return Bonus;
	}
	else
	{
		if(GetGame().DebugLeadershipStatus)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), " is returning CurrentValue = 0"), " because AnyoneNeutralized="), string(AnyoneNeutralized)));
		}
		return 0;
	}
	return;
}
