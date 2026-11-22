class LowReadyInterface extends PlayerFocusInterface
	native
	config(PlayerInterface_LowReady)
	notplaceable
	hidecategories(Karma);

cpptext
{
    virtual UBOOL DoorRelatedContextMatches(UPlayerInterfaceDoorRelatedContext* DoorRelatedContext, ASwatDoor* Door);
    virtual UBOOL ContextMatches(UPlayerInterfaceContext* inContext, AActor* Candidate);

}

var config float LowReadyRefractoryPeriod;
var private float LastTimeLowReadyRefractoryBegan;
var bool ShouldLowReady;
var name LowReadyReason;

protected simulated function ResetFocusHook(SwatGamePlayerController Player, HUDPageBase HUDPage)
{
	ShouldLowReady = false;
	LowReadyReason = 'None';
	return;
}

protected simulated event PostContextMatched(PlayerInterfaceContext inContext, Actor Target)
{
	local LowReadyInterfaceContext Context;

	Context = LowReadyInterfaceContext(inContext);
	LowReadyReason = Context.Reason;
	return;
}

protected simulated event PostDoorRelatedContextMatched(PlayerInterfaceDoorRelatedContext inContext, Actor Target)
{
	local LowReadyInterfaceDoorRelatedContext Context;

	Context = LowReadyInterfaceDoorRelatedContext(inContext);
	LowReadyReason = Context.Reason;
	return;
}

protected simulated event PostFocusAdded(PlayerInterfaceContext inContext, Actor Target, Actor.ESkeletalRegion SkeletalRegionHit)
{
	local LowReadyInterfaceContext Context;
	local HandheldEquipment ActiveItem;

	Context = LowReadyInterfaceContext(inContext);
	if(AndAnd_BoolBool(Target.IsA('SwatOfficer'), InLowReadyRefractoryPeriod()))
	{
		return;
	}
	ActiveItem = SwatPlayer(Level.GetLocalPlayerController().Pawn).GetActiveItem();
	if(Context.ShouldLowReady)
	{
		ShouldLowReady = true;
	}
	return;
}

protected simulated event PostDoorRelatedFocusAdded(PlayerInterfaceDoorRelatedContext inContext, Actor Target, Actor.ESkeletalRegion SkeletalRegionHit)
{
	local LowReadyInterfaceDoorRelatedContext Context;

	Context = LowReadyInterfaceDoorRelatedContext(inContext);
	if(Context.ShouldLowReady)
	{
		ShouldLowReady = true;
	}
	return;
}

simulated function PostUpdate()
{
	local SwatGamePlayerController Player;
	local SwatPlayer PlayerPawn;
	local HandheldEquipment ActiveItem;
	local export editinline HUDPageBase HUD;

	Player = SwatGamePlayerController(Level.GetLocalPlayerController());
	PlayerPawn = SwatPlayer(Player.Pawn);
	ActiveItem = PlayerPawn.GetActiveItem();
	HUD = Player.GetHUDPage();
	if(OrOr_BoolBool(OrOr_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(Player.ActiveViewport, none), NotEqual_IntInt(int(Player.bControlViewport), 0)), AndAnd_BoolBool(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)), PlayerPawn.CanBeArrestedNow())), AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(HUD.Reticle.CenterPreviewImage, none), NotEqual_ObjectObject(ActiveItem, none)), NotEqual_IntInt(int(Player.EquipmentSlotForQualify), int(ActiveItem.GetSlot())))))
	{
		ShouldLowReady = true;
	}
	if(Not_PreBool(ShouldLowReady))
	{
		LowReadyReason = 'None';
	}
	PlayerPawn.SetLowReady(ShouldLowReady, LowReadyReason);
	return;
}

simulated function bool InLowReadyRefractoryPeriod()
{
	return AndAnd_BoolBool(Greater_FloatFloat(LastTimeLowReadyRefractoryBegan, float(0)), Less_FloatFloat(Level.TimeSeconds, Add_FloatFloat(LastTimeLowReadyRefractoryBegan, LowReadyRefractoryPeriod)));
	return;
}

simulated function BeginLowReadyRefractoryPeriod()
{
	LastTimeLowReadyRefractoryBegan = Level.TimeSeconds;
	return;
}

defaultproperties
{
	DoorRelatedContextClass=Class'SwatGame.LowReadyInterfaceDoorRelatedContext'
	ContextClass=Class'SwatGame.LowReadyInterfaceContext'
}