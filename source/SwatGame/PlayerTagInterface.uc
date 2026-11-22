class PlayerTagInterface extends PlayerFocusInterface
	native
	config(PlayerInterface_PlayerTags)
	notplaceable
	hidecategories(Karma);

cpptext
{
    virtual UBOOL DoorRelatedContextMatches(UPlayerInterfaceDoorRelatedContext* DoorRelatedContext, ASwatDoor* Door) {return true; }
    virtual UBOOL ContextMatches(UPlayerInterfaceContext* inContext, AActor* Candidate);

}

var export editinline HUDPageBase CachedHUDPage;
var SwatPawn CachedPlayerTarget;
var SwatPawn PlayerTargetDuringUpdate;
var Timer TagTimeoutTimer;
var Timer HoverTimer;
var bool bShowEnemyTags;
var bool bShowFriendlyTags;
var config float FriendlyHoverDuration;
var config float EnemyHoverDuration;
var config float TagTimeoutDuration;
var config string FriendlyTagStyle;
var config string EnemyTagStyle;
var SwatGameReplicationInfo CachedRep;
var bool bLoadedFromRepo;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	TagTimeoutTimer = Spawn(Class'Engine.Timer');
	HoverTimer = Spawn(Class'Engine.Timer');
	TagTimeoutTimer.__TimerDelegate__Delegate = OnTagTimeoutTimer;
	HoverTimer.__TimerDelegate__Delegate = OnHoverTimer;
	return;
}

// Export UPlayerTagInterface::execRejectFocus(FFrame&, void* const)
native function bool RejectFocus(PlayerController Player, Actor CandidateActor, Vector CandidateLocation, Vector CandidateNormal, Material CandidateMaterial, Actor.ESkeletalRegion CandidateSkeletalRegion, float Distance, bool Transparent);

protected simulated function bool PreUpdateHook(SwatGamePlayerController Player, HUDPageBase HUDPage)
{
	if(AndAnd_BoolBool(EqualEqual_ObjectObject(CachedHUDPage, none), NotEqual_ObjectObject(HUDPage, none)))
	{
		HUDPage.PlayerTag.SetVisibility(false);
	}
	CachedHUDPage = HUDPage;
	if(Not_PreBool(bLoadedFromRepo))
	{
		CachedRep = SwatGameReplicationInfo(PlayerController(Owner).GameReplicationInfo);
		MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("Testing repo initialization! CachedRep: ", string(CachedRep)), ", ShowFriendlyTags: "), string(CachedRep.ShowTeammateNames)), ", EnemyTags: "), string(CachedRep.ShowEnemyNames)));
		if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(CachedRep, none), Greater_IntInt(CachedRep.ShowTeammateNames, 0)), Greater_IntInt(CachedRep.ShowEnemyNames, 0)))
		{
			bLoadedFromRepo = true;
			bShowFriendlyTags = EqualEqual_IntInt(CachedRep.ShowTeammateNames, 2);
			bShowEnemyTags = EqualEqual_IntInt(CachedRep.ShowEnemyNames, 2);
			MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr("Repo_Loaded! ShowFriendlyTags: ", string(bShowFriendlyTags)), ", EnemyTags: "), string(bShowEnemyTags)));
		}
	}
	return OrOr_BoolBool(bShowEnemyTags, bShowFriendlyTags);
	return;
}

protected simulated function ResetFocusHook(SwatGamePlayerController Player, HUDPageBase HUDPage)
{
	PlayerTargetDuringUpdate = none;
	return;
}

protected simulated event PostFocusAdded(PlayerInterfaceContext Context, Actor Target, Actor.ESkeletalRegion SkeletalRegionHit)
{
	local SwatPawn PawnTarget;

	PawnTarget = SwatPawn(Target);
	if(AndAnd_BoolBool(NotEqual_ObjectObject(PawnTarget, none), Not_PreBool(Class'Engine.Pawn'.static.checkDead(PawnTarget))))
	{
		PlayerTargetDuringUpdate = SwatPawn(Target);
	}
	return;
}

simulated function PostUpdate()
{
	local SwatPlayer LocalPlayer;
	local bool bIsSWAT, bIsOnSameTeam;

	LocalPlayer = SwatPlayer(SwatGamePlayerController(Owner).Pawn);
	if(NotEqual_ObjectObject(CachedPlayerTarget, PlayerTargetDuringUpdate))
	{
		if(EqualEqual_ObjectObject(PlayerTargetDuringUpdate, none))
		{
			HoverTimer.StopTimer();
			TagTimeoutTimer.StartTimer(TagTimeoutDuration, true);
		}
		else
		{
			bIsSWAT = EqualEqual_IntInt(PlayerTargetDuringUpdate.GetTeamNumber(), 0);
			bIsOnSameTeam = EqualEqual_IntInt(PlayerTargetDuringUpdate.GetTeamNumber(), LocalPlayer.GetTeamNumber());
			if(OrOr_BoolBool(AndAnd_BoolBool(bShowFriendlyTags, bIsOnSameTeam), AndAnd_BoolBool(bShowEnemyTags, Not_PreBool(bIsOnSameTeam))))
			{
				StartTag(bIsSWAT);
			}
		}
	}
	PlayerTargetDuringUpdate = none;
	return;
}

simulated function StartTag(bool bFriendly)
{
	local float HoverDuration;

	TagTimeoutTimer.StopTimer();
	CachedPlayerTarget = PlayerTargetDuringUpdate;
	if(bFriendly)
	{
		HoverDuration = FriendlyHoverDuration;
	}
	else
	{
		HoverDuration = EnemyHoverDuration;
	}
	HoverTimer.StartTimer(HoverDuration, false, false);
	if(bFriendly)
	{
		CachedHUDPage.PlayerTag.Style = CachedHUDPage.Controller.GetStyle(FriendlyTagStyle);
	}
	else
	{
		CachedHUDPage.PlayerTag.Style = CachedHUDPage.Controller.GetStyle(EnemyTagStyle);
	}
	CachedHUDPage.PlayerTag.SetCaption(CachedPlayerTarget.GetHumanReadableName());
	return;
}

simulated function OnHoverTimer()
{
	CachedHUDPage.PlayerTag.SetVisibility(true);
	CachedHUDPage.PlayerTag.bDrawStyle = true;
	return;
}

simulated function OnTagTimeoutTimer()
{
	CachedPlayerTarget = none;
	TagTimeoutTimer.StopTimer();
	CachedHUDPage.PlayerTag.SetCaption("");
	CachedHUDPage.PlayerTag.SetVisibility(false);
	return;
}

defaultproperties
{
	DoorRelatedContextClass=Class'SwatGame.PlayerTagInterfaceDoorRelatedContext'
	ContextClass=Class'SwatGame.PlayerTagInterfaceContext'
}