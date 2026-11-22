class Cuffs extends EquipmentUsedOnOther implements ITacticalAid
	config(SwatEquipment)
	hidecategories(Karma);

var float LastInterruptTime;

simulated function bool CanUseOnOtherNow(Actor Other)
{
	local SwatPawn Pawn;

	Pawn = SwatPawn(Other);
	if(EqualEqual_ObjectObject(Pawn, none))
	{
		return false;
	}
	if(Pawn.IsBeingArrestedNow())
	{
		return false;
	}
	return true;
	return;
}

protected latent simulated function OnUsingBegan()
{
	MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "---Cuffs::OnUsingBegan(). Other="), string(Other)), ", Owner="), string(Owner)));
	super(QualifiedUseEquipment).OnUsingBegan();
	if(NotEqual_FloatFloat(LastInterruptTime, Level.TimeSeconds))
	{
		ICanBeArrested(Other).OnArrestBegan(Pawn(Owner));
	}
	if(NotEqual_ObjectObject(Pawn(Owner).GetHands(), none))
	{
		Pawn(Owner).GetHands().SetNextIdleTweenTime(0.2000000);
	}
	return;
}

simulated function UsedHook()
{
	local SwatGamePlayerController SGPC;

	MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "---Cuffs::UsedHook(). Other="), string(Other)), ", Owner="), string(Owner)));
	assert(NotEqual_ObjectObject(Pawn(Other), none));
	ICanBeArrested(Other).OnArrested(Pawn(Owner));
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		SwatGameInfo(Level.Game).GameEvents.PawnArrested.Triggered(Pawn(Other), Pawn(Owner));
	}
	SGPC = SwatGamePlayerController(Pawn(Other).Controller);
	if(NotEqual_ObjectObject(SGPC, none))
	{
		SGPC.PostArrested();
	}
	return;
}

simulated function UpdateAvailability()
{
	if(UnavailableAfterUsed)
	{
		SetAvailable(false);
	}
	return;
}

simulated function OnInterrupted()
{
	MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "---Cuffs::OnInterrupted. Other="), string(Other)), ", Owner="), string(Owner)));
	ICanBeArrested(Other).OnArrestInterrupted(Pawn(Owner));
	LastInterruptTime = Level.TimeSeconds;
	return;
}

simulated function bool ShouldUseAlternate()
{
	return AndAnd_BoolBool(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)), Not_PreBool(Level.IsPlayingCOOP));
	return;
}

simulated function float GetQualifyDuration()
{
	return ICanBeArrested(Other).GetQualifyTimeForArrest();
	return;
}

protected simulated function AssertOtherIsValid()
{
	AssertWithDescription(Other.IsA('ICanBeArrested'), Concat_StrStr(Concat_StrStr("[tcohen] Cuffs were called to AssertOtherIsValid(), but Other is a ", string(Other.Class.Name)), ", which is not an ICanBeArrested."));
	return;
}

simulated function OnForgotten()
{
	SetAvailable(true);
	return;
}

defaultproperties
{
	Slot=11
	UnavailableAfterUsed=true
}