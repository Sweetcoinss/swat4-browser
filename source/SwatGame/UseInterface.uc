class UseInterface extends PlayerFocusInterface
	native
	config(PlayerInterface_Use)
	notplaceable
	hidecategories(Karma);

cpptext
{
    virtual UBOOL DoorRelatedContextMatches(UPlayerInterfaceDoorRelatedContext* DoorRelatedContext, ASwatDoor* Door);
    virtual UBOOL ContextMatches(UPlayerInterfaceContext* inContext, AActor* Candidate);

}

var string UseFeedbackText;
var string OtherFeedbackText;
var export editinline HUDPageBase CachedHUDPage;
var bool LookingThruGlass;

protected simulated function bool PreUpdateHook(SwatGamePlayerController Player, HUDPageBase HUDPage)
{
	return EqualEqual_ObjectObject(Player.ActiveViewport, none);
	return;
}

protected simulated function ResetFocusHook(SwatGamePlayerController Player, HUDPageBase HUDPage)
{
	UseFeedbackText = "";
	OtherFeedbackText = "";
	CachedHUDPage = HUDPage;
	LookingThruGlass = false;
	PostUpdate();
	return;
}

protected simulated event PostContextMatched(PlayerInterfaceContext Context, Actor Target)
{
	local string localUseFeedbackText, localOtherFeedbackText;

	if(UseInterfaceContext(Context).IsGlass)
	{
		LookingThruGlass = true;
	}
	localUseFeedbackText = UseInterfaceContext(Context).UseFeedbackText;
	localOtherFeedbackText = UseInterfaceContext(Context).OtherFeedbackText;
	if(NotEqual_StrStr(localUseFeedbackText, ""))
	{
		UseFeedbackText = localUseFeedbackText;
	}
	if(NotEqual_StrStr(localOtherFeedbackText, ""))
	{
		OtherFeedbackText = localOtherFeedbackText;
	}
	return;
}

protected simulated event PostDoorRelatedFocusAdded(PlayerInterfaceDoorRelatedContext inContext, Actor Target, Actor.ESkeletalRegion SkeletalRegionHit)
{
	local UseInterfaceDoorRelatedContext Context;

	Context = UseInterfaceDoorRelatedContext(inContext);
	UseFeedbackText = Context.UseFeedbackText;
	OtherFeedbackText = Context.OtherFeedbackText;
	return;
}

simulated function PostUpdate()
{
	local export editinline GUIFeedback Feedback;

	Feedback = CachedHUDPage.Feedback;
	Feedback.UseText = UseFeedbackText;
	Feedback.OtherText = OtherFeedbackText;
	return;
}

simulated function Interact()
{
	local ICanBeUsed Target;
	local SwatGamePlayerController PC;

	MPLog("---UseInterface::Interact().");
	if(Greater_IntInt(FociLength, 0))
	{
		Target = ICanBeUsed(Foci[0].Actor);
		MPLog(Concat_StrStr("...Target=", string(Target)));
		if(EqualEqual_ObjectObject(Target, none))
		{
			return;
		}
		PC = SwatGamePlayerController(Level.GetLocalPlayerController());
		if(Target.CanBeUsedNow())
		{
			MPLog(Concat_StrStr("...UniqueID=", Target.UniqueID()));
			PC.ServerRequestInteract(Target, Target.UniqueID());
		}
	}
	return;
}

defaultproperties
{
	DoorRelatedContextClass=Class'SwatGame.UseInterfaceDoorRelatedContext'
	ContextClass=Class'SwatGame.UseInterfaceContext'
}