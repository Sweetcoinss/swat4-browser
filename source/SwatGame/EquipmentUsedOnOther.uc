class EquipmentUsedOnOther extends QualifiedUseEquipment implements IAmUsedOnOther
	abstract
	config(SwatEquipment)
	hidecategories(Karma);

var Actor Other;

simulated function OnPlayerUse()
{
	local Actor DefaultFireFocusActor;
	local SwatGamePlayerController LPC;

	LPC = SwatGamePlayerController(Level.GetLocalPlayerController());
	if(NotEqual_ObjectObject(LPC, none))
	{
		DefaultFireFocusActor = LPC.GetFocusInterface(1).GetDefaultFocusActor();
	}
	if(EqualEqual_ObjectObject(DefaultFireFocusActor, none))
	{
		return;
	}
	LPC.OtherForQualifyingUse = DefaultFireFocusActor;
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		if(Not_PreBool(CanUseOnOtherNow(DefaultFireFocusActor)))
		{
			return;
		}
		BeginQualifying(DefaultFireFocusActor);
	}
	else
	{
		SwatPlayer(Owner).ServerRequestQualify(DefaultFireFocusActor);
	}
	return;
}

simulated function bool CanUseOnOtherNow(Actor Other)
{
	return true;
	return;
}

simulated function BeginQualifying(Actor DefaultFireFocusActor)
{
	local SwatGamePlayerController ControllerOfOwner;

	MPLog(Concat_StrStr(string(self), "---EquipmentUsedOnOther::BeginQualifying()."));
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		ControllerOfOwner = SwatGamePlayerController(Pawn(Owner).Controller);
		if(NotEqual_ObjectObject(ControllerOfOwner, none))
		{
			ControllerOfOwner.GotoState('QualifyingForUse');
		}
	}
	UseOn(DefaultFireFocusActor);
	return;
}

simulated function UseOn(Actor inOther)
{
	Other = inOther;
	AssertOtherIsValid();
	Use();
	return;
}

latent simulated function LatentUseOn(Actor inOther)
{
	Other = inOther;
	AssertOtherIsValid();
	LatentUse();
	return;
}

simulated function Actor GetOther()
{
	return Other;
	return;
}

protected simulated function AssertOtherIsValid()
{
	assert(false);
	return;
}
