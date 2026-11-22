class FireInterface extends PlayerFocusInterface
	native
	config(PlayerInterface_Fire)
	notplaceable
	hidecategories(Karma);

cpptext
{
    virtual UBOOL DoorRelatedContextMatches(UPlayerInterfaceDoorRelatedContext* DoorRelatedContext, ASwatDoor* Door);
    virtual UBOOL ContextMatches(UPlayerInterfaceContext* inContext, AActor* Candidate);

}

var SwatDoor LastDoorFocus;

protected simulated function bool PreUpdateHook(SwatGamePlayerController Player, HUDPageBase HUDPage)
{
	local HandheldEquipment ActiveItem;
	local SwatPlayer PlayerPawn;

	PlayerPawn = SwatPlayer(Player.Pawn);
	ActiveItem = PlayerPawn.GetActiveItem();
	if(OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(NotEqual_ObjectObject(Player.ActiveViewport, none), EqualEqual_ObjectObject(ActiveItem, none)), Not_PreBool(ActiveItem.IsIdle())), PlayerPawn.CanBeArrestedNow()), PlayerPawn.IsArrested()))
	{
		if(EqualEqual_ObjectObject(Player, Level.GetLocalPlayerController()))
		{
			Player.GetHUDPage().Reticle.CenterPreviewImage = none;
		}
		return false;
	}
	else
	{
		return true;
	}
	return;
}

protected simulated function ResetFocusHook(SwatGamePlayerController Player, HUDPageBase HUDPage)
{
	if(EqualEqual_ObjectObject(Player, Level.GetLocalPlayerController()))
	{
		Player.GetHUDPage().Reticle.CenterPreviewImage = none;
	}
	HUDPage.Feedback.FireText = "";
	Player.EquipmentSlotForQualify = 0;
	return;
}

// Export UFireInterface::execRejectFocus(FFrame&, void* const)
native function bool RejectFocus(PlayerController Player, Actor CandidateActor, Vector CandidateLocation, Vector CandidateNormal, Material CandidateMaterial, Actor.ESkeletalRegion CandidateSkeletalRegion, float Distance, bool Transparent);

protected simulated event PostFocusAdded(PlayerInterfaceContext inContext, Actor Target, Actor.ESkeletalRegion SkeletalRegionHit)
{
	local FireInterfaceContext Context;
	local SwatGamePlayerController Player;
	local export editinline HUDPageBase HUD;

	Context = FireInterfaceContext(inContext);
	Player = SwatGamePlayerController(Level.GetLocalPlayerController());
	HUD = Player.GetHUDPage();
	HUD.Feedback.FireText = Context.FireFeedbackText;
	HUD.Reticle.CenterPreviewImage = Context.ReticleImage;
	UpdateReticlePreviewAlpha(Player, HUD, Target, SkeletalRegionHit);
	Player.EquipmentSlotForQualify = Context.EquipmentSlotForQualify;
	return;
}

protected simulated event PostDoorRelatedFocusAdded(PlayerInterfaceDoorRelatedContext inContext, Actor Target, Actor.ESkeletalRegion SkeletalRegionHit)
{
	local FireInterfaceDoorRelatedContext Context;
	local SwatGamePlayerController Player;
	local export editinline HUDPageBase HUD;

	Context = FireInterfaceDoorRelatedContext(inContext);
	Player = SwatGamePlayerController(Level.GetLocalPlayerController());
	HUD = Player.GetHUDPage();
	HUD.Feedback.FireText = Context.FireFeedbackText;
	HUD.Reticle.CenterPreviewImage = Context.ReticleImage;
	UpdateReticlePreviewAlpha(Player, HUD, Target, SkeletalRegionHit);
	Player.EquipmentSlotForQualify = Context.EquipmentSlotForQualify;
	switch(Context.SideEffect)
	{
		case 'None':
			break;
		default:
			AssertWithDescription(false, Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] The FireInterfaceDoorRelatedContext named ", string(Context.Name)), " specifies the SideEffect '"), string(Context.SideEffect)), "', but that SideEffect is not recognized."));
			break;
			break;
	}
	return;
}

function UpdateReticlePreviewAlpha(SwatGamePlayerController Player, HUDPageBase HUD, Actor Target, Actor.ESkeletalRegion SkeletalRegion)
{
	local SwatDoor Door;
	local Vector BoxCenter, CameraToBoxCenter;
	local float DirectPct, DirectAlpha, Alpha;

	Door = SwatDoor(Target);
	if(EqualEqual_ObjectObject(Door, none))
	{
		HUD.Reticle.CenterPreviewAlpha = byte(255);
		return;
	}
	BoxCenter = Door.GetSkeletalRegionCenter(SkeletalRegion);
	CameraToBoxCenter = Normal(Subtract_VectorVector(BoxCenter, Player.FocusTraceOrigin));
	DirectPct = Dot_VectorVector(CameraToBoxCenter, Normal(Player.FocusTraceVector));
	DirectAlpha = Multiply_FloatFloat(Subtract_FloatFloat(1.0000000, DirectPct), 10000.0000000);
	Alpha = Subtract_FloatFloat(255.0000000, DirectAlpha);
	HUD.Reticle.CenterPreviewAlpha = byte(Alpha);
	return;
}

defaultproperties
{
	DoorRelatedContextClass=Class'SwatGame.FireInterfaceDoorRelatedContext'
	ContextClass=Class'SwatGame.FireInterfaceContext'
}