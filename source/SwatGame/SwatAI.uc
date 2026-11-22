class SwatAI extends SwatRagdollPawn implements ISwatAI, IUseArchetype, IAwarenessOuter, ICanThrowWeapons, IEffectObserver, IAmReportableCharacter
	abstract
	native
	config(SwatPawn)
	hidecategories(Karma);

const kAIPathCostNotInCover = 10000.0;
const kAIPathCostInLowCover = 1000.0;
const kAIPathCostInCover = 0.0;
const kMinCanHitWeaponTraceToggleTime = 1.0;
const kMaxCanHitWeaponTraceToggleTime = 3.0;
const kPalmOffsetFromShoulder = 45.0;
const MaxAIWaitForEffectEventToFinish = 10.0;

struct native UpperBodyAnimBehaviorEntry
{
	var ISwatAI.EUpperBodyAnimBehavior behavior;
	var int clientId;
};

var VisionNotifier Vision;
var HearingNotifier Hearing;
var private bool bIsIncapacitated;
var private bool bIsCompliant;
var name EyeBoneName;
var const int EyeBoneIndex;
var private const Vector CurrentViewPoint;
var private const Rotator CurrentViewDirection;
var private const float LastViewUpdateTime;
var private name IdleCategory;
var private float LastIdleUpdateTime;
var private AIKnowledge AIKnowledge;
var private AICoverFinder AICoverFinder;
var private SwatDoor PendingDoor;
var bool bShowBlackboardDebugInfo;
var bool bShowTyrionCharacterDebugInfo;
var bool bShowTyrionMovementDebugInfo;
var bool bShowTyrionWeaponDebugInfo;
var bool bShowTyrionHeadDebugInfo;
var bool bShowMoraleHistoryDebugInfo;
var bool bShowAimingDebugInfo;
var bool bVisionDisabled;
var bool bVisionDisabledPermanently;
var bool bHearingDisabled;
var bool bHearingDisabledPermanently;
var private float PlayerBlockingPathStartTime;
var config float PlayerBlockingPathTime;
var private bool bAlwaysTestPathReachability;
var config float PathReachabilityRenderedRecentlyDelta;
var array<UpperBodyAnimBehaviorEntry> UpperBodyAnimBehaviorEntries;
var config array<name> FBStandingReactionAnimations;
var config array<name> FBStandingNoWeaponReactionAnimations;
var config array<name> FBCrouchingReactionAnimations;
var config array<name> FBCrouchingNoWeaponReactionAnimations;
var config array<name> FBCompliantReactionAnimations;
var config array<name> FBRestrainedReactionAnimations;
var config array<name> FBStandingAffectedAnimations;
var config array<name> FBStandingNoWeaponAffectedAnimations;
var config array<name> FBCrouchingAffectedAnimations;
var config array<name> FBCrouchingNoWeaponAffectedAnimations;
var config array<name> FBCompliantAffectedAnimations;
var config array<name> FBRestrainedAffectedAnimations;
var config array<name> FBStandingRecoveryAnimations;
var config array<name> FBStandingNoWeaponRecoveryAnimations;
var config array<name> FBCrouchingRecoveryAnimations;
var config array<name> FBCrouchingNoWeaponRecoveryAnimations;
var config array<name> FBCompliantRecoveryAnimations;
var config array<name> FBRestrainedRecoveryAnimations;
var config array<name> GasStandingReactionAnimations;
var config array<name> GasStandingNoWeaponReactionAnimations;
var config array<name> GasCrouchingReactionAnimations;
var config array<name> GasCrouchingNoWeaponReactionAnimations;
var config array<name> GasCompliantReactionAnimations;
var config array<name> GasRestrainedReactionAnimations;
var config array<name> GasStandingAffectedAnimations;
var config array<name> GasStandingNoWeaponAffectedAnimations;
var config array<name> GasCrouchingAffectedAnimations;
var config array<name> GasCrouchingNoWeaponAffectedAnimations;
var config array<name> GasCompliantAffectedAnimations;
var config array<name> GasRestrainedAffectedAnimations;
var config array<name> GasStandingRecoveryAnimations;
var config array<name> GasStandingNoWeaponRecoveryAnimations;
var config array<name> GasCrouchingRecoveryAnimations;
var config array<name> GasCrouchingNoWeaponRecoveryAnimations;
var config array<name> GasCompliantRecoveryAnimations;
var config array<name> GasRestrainedRecoveryAnimations;
var config array<name> TasedStandingReactionAnimations;
var config array<name> TasedCrouchingReactionAnimations;
var config array<name> TasedCompliantReactionAnimations;
var config array<name> TasedRestrainedReactionAnimations;
var config array<name> TasedStandingAffectedAnimations;
var config array<name> TasedCrouchingAffectedAnimations;
var config array<name> TasedCompliantAffectedAnimations;
var config array<name> TasedRestrainedAffectedAnimations;
var config array<name> TasedStandingRecoveryAnimations;
var config array<name> TasedCrouchingRecoveryAnimations;
var config array<name> TasedCompliantRecoveryAnimations;
var config array<name> TasedRestrainedRecoveryAnimations;
var config array<name> StungStandingReactionAnimations;
var config array<name> StungStandingNoWeaponReactionAnimations;
var config array<name> StungCrouchingReactionAnimations;
var config array<name> StungCrouchingNoWeaponReactionAnimations;
var config array<name> StungCompliantReactionAnimations;
var config array<name> StungRestrainedReactionAnimations;
var config array<name> StungStandingAffectedAnimations;
var config array<name> StungStandingNoWeaponAffectedAnimations;
var config array<name> StungCrouchingAffectedAnimations;
var config array<name> StungCrouchingNoWeaponAffectedAnimations;
var config array<name> StungCompliantAffectedAnimations;
var config array<name> StungRestrainedAffectedAnimations;
var config array<name> StungStandingRecoveryAnimations;
var config array<name> StungStandingNoWeaponRecoveryAnimations;
var config array<name> StungCrouchingRecoveryAnimations;
var config array<name> StungCrouchingNoWeaponRecoveryAnimations;
var config array<name> StungCompliantRecoveryAnimations;
var config array<name> StungRestrainedRecoveryAnimations;
var config array<name> StandingFlinchAnimations;
var config array<name> CrouchingFlinchAnimations;
var config array<name> CompliantFlinchAnimations;
var config array<name> RestrainedFlinchAnimations;
var config Vector UnderhandThrownProjectileInitialOffset;
var config Vector OverhandThrownProjectileInitialOffset;
var config int ThrownProjectilePitch;
var config name ThrowShortAnimation;
var config name ThrowLongAnimation;
var config name ThrowFromLeftAnimation;
var config name ThrowFromRightAnimation;
var config float ThrowAnimationTweenTime;
var config float MaxUnderhandThrowDistance;
var config float ZPositiveOffsetForOverhandThrow;
var config Vector ShoulderOffset;
var config float MinLastRenderedTimeDeltaForRelevency;
var config float MinTimeBetweenFireHG;
var config float MaxTimeBetweenFireHG;
var config float MinTimeBetweenFireSMGSingleShot;
var config float MaxTimeBetweenFireSMGSingleShot;
var config float MinTimeBetweenFireSMGBurst;
var config float MaxTimeBetweenFireSMGBurst;
var config float MinTimeBetweenFireSMGFullAuto;
var config float MaxTimeBetweenFireSMGFullAuto;
var config float MinTimeBetweenFireMGSingleShot;
var config float MaxTimeBetweenFireMGSingleShot;
var config float MinTimeBetweenFireMGFullBurst;
var config float MaxTimeBetweenFireMGFullBurst;
var config float MinTimeBetweenFireMGFullAuto;
var config float MaxTimeBetweenFireMGFullAuto;
var config float MinTimeBetweenFireShotgun;
var config float MaxTimeBetweenFireShotgun;
var private float EndTimeToStopFiringFullAuto;
var config array<name> TurnAwayAnimationHG;
var config array<name> TurnAwayAnimationSG;
var config array<name> TurnAwayAnimationMG;
var config array<name> TurnAwayAnimationSMG;
var config array<name> TurnAwayAnimationPB;
var private ArchetypeInstance ArchetypeInstance;
var private bool bUsesAwarenessForPathfindingCost;
var private bool bUsesCoverForPathfindingCost;
var array<Pawn> OtherPawnsToFavorCoveredPathFrom;
var private Actor CurrentWeaponTarget;
var private Vector CurrentWeaponTargetLocation;
var private float NextCanHitWeaponTraceToggleTime;
var private bool bCanHitUsesWeaponTrace;
var private Vector vGrenadeTargetLocation;
var private ISwatAI.AIThrowSide ThrowSide;
var private bool bHasBeenReportedToTOC;
var private name SpawnedFromName;
var private CommanderGoal Commander;
var private SpeechManagerGoal SpeechManager;
var private Vector LastVelocity;
var private SoundInstance LatentSound;
var private bool MoveMouthDuringEffect;
var array<StaircaseAimVolume> TouchingStaircaseAimVolumes;
var private bool bIsAimLocked;
var private bool bDebugPathLines;
var private name CurrentEffectEventName;
var private int CurrentSeed;
var private bool bEffectEventStillPlaying;

replication
{
	// Pos:0x000
	reliable if(EqualEqual_IntInt(int(Role), int(ROLE_Authority)))
		SpawnedFromName, bHasBeenReportedToTOC,
		bIsCompliant, bIsIncapacitated;
}

simulated event PreBeginPlay()
{
	logAI = Level.GetEngine().EnableDevTools;
	super(Pawn).PreBeginPlay();
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		FindAnchor(true);
	}
	return;
}

simulated event PostBeginPlay()
{
	super.PostBeginPlay();
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		SetupVisionBone();
		CreateTyrionResources();
		InitKnowledge();
		InitCoverFinder();
	}
	InitAimPoses();
	SetAimUrgency(false);
	AssertWithDescription(OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)), NotEqual_ObjectObject(Controller, none)), Concat_StrStr(Concat_StrStr("AI '", string(self)), "' has no controller after PostBeginPlay!"));
	return;
}

private simulated function InitAimPoses()
{
	SetLowReady(CanPawnUseLowReady());
	return;
}

simulated event Destroyed()
{
	super.Destroyed();
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		TermKnowledge();
		CleanupTyrion();
		CleanupSensing();
	}
	return;
}

function CharacterAICreated()
{
	CreateVisionNotifier();
	CreateHearingNotifier();
	return;
}

private function CleanupTyrion()
{
	CleanupPrivateTyrion();
	CharacterAI.cleanup();
	MovementAI.cleanup();
	WeaponAI.cleanup();
	CharacterAI.deleteSensors();
	MovementAI.deleteSensors();
	WeaponAI.deleteSensors();
	CharacterAI.deleteRemovedActions();
	MovementAI.deleteRemovedActions();
	WeaponAI.deleteRemovedActions();
	return;
}

private function CleanupPrivateTyrion()
{
	if(NotEqual_ObjectObject(Commander, none))
	{
		Commander.Release();
		Commander = none;
	}
	if(NotEqual_ObjectObject(SpeechManager, none))
	{
		SpeechManager.Release();
		SpeechManager = none;
	}
	return;
}

// Export USwatAI::execSetupVisionBone(FFrame&, void* const)
native function SetupVisionBone();

private function CreateTyrionResources()
{
	ConstructCharacterAI();
	ConstructMovementAI();
	ConstructWeaponAI();
	return;
}

protected function ConstructCharacterAI()
{
	local AI_Resource characterResource;

	characterResource = AI_Resource(CharacterAI);
	assert(NotEqual_ObjectObject(CharacterAI, none));
	characterResource.addAbility(Class'SwatAICommon.TakeCoverAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.MoveToAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.IncapacitatedAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.ReactToBeingShotAction'.static.Allocate(self)., Construct_Void());
	SetupCommanderGoal();
	SetupSpeechManagerGoal();
	SetupIdling();
	return;
}

private function SetupCommanderGoal()
{
	Commander = Class'SwatAICommon.CommanderGoal'.static.Allocate(self).;
	construct_AI_Resource(AI_Resource(CharacterAI));
	assert(NotEqual_ObjectObject(Commander, none));
	Commander.AddRef();
	Commander.postGoal(none);
	return;
}

private function SetupSpeechManagerGoal()
{
	SpeechManager = Class'SwatAICommon.SpeechManagerGoal'.static.Allocate(self).;
	construct_AI_Resource(AI_Resource(CharacterAI));
	assert(NotEqual_ObjectObject(SpeechManager, none));
	SpeechManager.AddRef();
	SpeechManager.postGoal(none);
	return;
}

protected function ConstructMovementAI()
{
	local AI_Resource movementResource;

	movementResource = AI_Resource(MovementAI);
	assert(NotEqual_ObjectObject(movementResource, none));
	movementResource.addAbility(Class'Tyrion.AI_DummyMovement'.static.Allocate(self)., Construct_Void());
	movementResource.addAbility(Class'SwatAICommon.MoveToDoorAction'.static.Allocate(self)., Construct_Void());
	movementResource.addAbility(Class'SwatAICommon.OpenDoorAction'.static.Allocate(self)., Construct_Void());
	movementResource.addAbility(Class'SwatAICommon.CloseDoorAction'.static.Allocate(self)., Construct_Void());
	movementResource.addAbility(Class'SwatAICommon.MoveToOpponentAction'.static.Allocate(self)., Construct_Void());
	movementResource.addAbility(Class'SwatAICommon.MoveToActorAction'.static.Allocate(self)., Construct_Void());
	movementResource.addAbility(Class'SwatAICommon.MoveToLocationAction'.static.Allocate(self)., Construct_Void());
	movementResource.addAbility(Class'SwatAICommon.RotateTowardActorAction'.static.Allocate(self)., Construct_Void());
	movementResource.addAbility(Class'SwatAICommon.RotateTowardPointAction'.static.Allocate(self)., Construct_Void());
	movementResource.addAbility(Class'SwatAICommon.RotateTowardRotationAction'.static.Allocate(self)., Construct_Void());
	return;
}

protected function ConstructWeaponAI()
{
	local AI_Resource weaponResource;

	weaponResource = AI_Resource(WeaponAI);
	assert(NotEqual_ObjectObject(weaponResource, none));
	weaponResource.addAbility(Class'Tyrion.AI_DummyWeapon'.static.Allocate(self)., Construct_Void());
	weaponResource.addAbility(Class'SwatAICommon.AimAroundAction'.static.Allocate(self)., Construct_Void());
	weaponResource.addAbility(Class'SwatAICommon.AimBetweenPointsAction'.static.Allocate(self)., Construct_Void());
	weaponResource.addAbility(Class'SwatAICommon.AttackTargetAction'.static.Allocate(self)., Construct_Void());
	weaponResource.addAbility(Class'SwatAICommon.AimAtTargetAction'.static.Allocate(self)., Construct_Void());
	weaponResource.addAbility(Class'SwatAICommon.AimAtPointAction'.static.Allocate(self)., Construct_Void());
	weaponResource.addAbility(Class'SwatAICommon.IdleAimAroundAction'.static.Allocate(self)., Construct_Void());
	return;
}

private function CleanupSensing()
{
	if(NotEqual_ObjectObject(Vision, none))
	{
		Vision.CleanupVisionNotifier();
		Vision.Release();
		Vision = none;
	}
	if(NotEqual_ObjectObject(Hearing, none))
	{
		Hearing.Release();
		Hearing = none;
	}
	return;
}

private function CreateVisionNotifier()
{
	Vision = Class'AICommon.VisionNotifier'.static.Allocate(self, self).;
	Construct_Void();
	assert(NotEqual_ObjectObject(Vision, none));
	Vision.AddRef();
	Vision.InitializeVisionNotifier(self);
	return;
}

private function CreateHearingNotifier()
{
	Hearing = Class'AICommon.HearingNotifier'.static.Allocate(self, self).;
	Construct_Void();
	assert(NotEqual_ObjectObject(Hearing, none));
	Hearing.AddRef();
	Hearing.InitializeHearingNotifier(self);
	return;
}

event EndCrouch(float HeightAdjust)
{
	super(Pawn).EndCrouch(HeightAdjust);
	GetCommanderAction().ResetIdling();
	return;
}

event StartCrouch(float HeightAdjust)
{
	super(Pawn).StartCrouch(HeightAdjust);
	GetCommanderAction().ResetIdling();
	return;
}

simulated function OnActiveItemEquipped()
{
	super(SwatPawn).OnActiveItemEquipped();
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		GetCommanderAction().ResetIdling();
	}
	return;
}

private function SetupIdling()
{
	local IdleGoal IdleGoal;

	IdleGoal = Class'SwatAICommon.IdleGoal'.static.Allocate(self).;
	construct_AI_Resource(AI_CharacterResource(CharacterAI));
	assert(NotEqual_ObjectObject(IdleGoal, none));
	IdleGoal.postGoal(none);
	AddIdleActions();
	return;
}

private function bool CanUseIdle(IdleDefinition Idle)
{
	if(EqualEqual_IntInt(int(Idle.IdleCharacterType), int(0)))
	{
		return ClassIsChildOf(Class, Class'SwatGame.SwatAICharacter');
	}
	else
	{
		if(EqualEqual_IntInt(int(Idle.IdleCharacterType), int(1)))
		{
			return OrOr_BoolBool(ClassIsChildOf(Class, Class'SwatGame.SwatEnemy'), ClassIsChildOf(Class, Class'SwatGame.SwatOfficer'));
		}
		else
		{
			if(EqualEqual_IntInt(int(Idle.IdleCharacterType), int(2)))
			{
				return ClassIsChildOf(Class, Class'SwatGame.SwatEnemy');
			}
			else
			{
				if(EqualEqual_IntInt(int(Idle.IdleCharacterType), int(3)))
				{
					return ClassIsChildOf(Class, Class'SwatGame.SwatOfficer');
				}
				else
				{
					if(EqualEqual_IntInt(int(Idle.IdleCharacterType), int(4)))
					{
						return ClassIsChildOf(Class, Class'SwatGame.SwatHostage');
					}
					else
					{
						assert(false);
						return false;
					}
				}
			}
		}
	}
	return;
}

private function AddIdleActions()
{
	local IdleActionsList IdleActionsList;
	local IdleDefinition DefinitionIter;
	local AnimatorIdleAction NewAnimatorIdleAction;
	local ProceduralIdleAction NewProceduralIdleAction;
	local string ProceduralIdleActionClassName;
	local Class<ProceduralIdleAction> ProceduralIdleActionClass;
	local int i;

	IdleActionsList = SwatAIRepository(Level.AIRepo).GetIdleActions();
	i = 0;
	J0x2A:

	if(Less_IntInt(i, IdleActionsList.AnimatorIdleDefinitions.Length))
	{
		DefinitionIter = IdleActionsList.AnimatorIdleDefinitions[i];
		AssertWithDescription(NotEqual_NameName(AnimatorIdleDefinition(DefinitionIter).AnimationName, 'None'), Concat_StrStr(Concat_StrStr("DefinitionIter: ", string(DefinitionIter)), " has no AnimationName ! "));
		if(CanUseIdle(DefinitionIter))
		{
			NewAnimatorIdleAction = Class'SwatAICommon.AnimatorIdleAction'.static.Allocate(self).;
			construct_IdleDefinition(DefinitionIter);
			assert(NotEqual_ObjectObject(NewAnimatorIdleAction, none));
			CharacterAI.addAbility(NewAnimatorIdleAction);
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x2A;
	}
	i = 0;
	J0x118:

	if(Less_IntInt(i, IdleActionsList.ProceduralIdleDefinitions.Length))
	{
		DefinitionIter = IdleActionsList.ProceduralIdleDefinitions[i];
		if(CanUseIdle(DefinitionIter))
		{
			ProceduralIdleActionClassName = Concat_StrStr("SwatAICommon.", ProceduralIdleDefinition(DefinitionIter).ProceduralClassName);
			ProceduralIdleActionClass = Class<ProceduralIdleAction>(DynamicLoadObject(ProceduralIdleActionClassName, Class'Core.Class'));
			AssertWithDescription(NotEqual_ObjectObject(ProceduralIdleActionClass, none), At_StrStr("Could not find procedural idle action class named: ", ProceduralIdleActionClassName));
			NewProceduralIdleAction = ProceduralIdleActionClass.static.Allocate(self).;
			construct_IdleDefinition(DefinitionIter);
			assert(NotEqual_ObjectObject(NewProceduralIdleAction, none));
			CharacterAI.addAbility(NewProceduralIdleAction);
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x118;
	}
	return;
}

function SetIdleCategory(name inIdleCategory)
{
	local bool bResetIdling;

	if(logTyrion)
	{
		Log(Concat_StrStr("SetIdleCategory changed to: ", string(inIdleCategory)));
	}
	if(NotEqual_NameName(IdleCategory, inIdleCategory))
	{
		bResetIdling = true;
	}
	IdleCategory = inIdleCategory;
	if(AndAnd_BoolBool(AndAnd_BoolBool(bResetIdling, NotEqual_ObjectObject(Commander, none)), NotEqual_ObjectObject(Commander.achievingAction, none)))
	{
		GetCommanderAction().ResetIdling();
	}
	return;
}

function name GetIdleCategory()
{
	return IdleCategory;
	return;
}

function RegisterVisionNotification(IVisionNotification Registrant)
{
	Vision.RegisterVisionNotification(Registrant);
	return;
}

function UnregisterVisionNotification(IVisionNotification Registrant)
{
	Vision.UnregisterVisionNotification(Registrant);
	return;
}

function bool isVisible(Pawn TestPawn)
{
	return Vision.isVisible(TestPawn);
	return;
}

// Export USwatAI::execGetViewDirection(FFrame&, void* const)
native function Vector GetViewDirection();

// Export USwatAI::execGetViewPoint(FFrame&, void* const)
native function Vector GetViewPoint();

// Export USwatAI::execIsRelevantToPlayerOrOfficers(FFrame&, void* const)
native function bool IsRelevantToPlayerOrOfficers();

function HandheldEquipment GetRestrainedHandcuffs()
{
	assert(false);
	return none;
	return;
}

function NotifyBecameCompliant()
{
	SetCollision(bCollideActors, false, false);
	dispatchMessage(Class'SwatGame.MessageAICharacterComplied'.static.Allocate(self)., construct_Name(Label));
	return;
}

function RegisterHearingNotification(IHearingNotification Registrant)
{
	Hearing.RegisterHearingNotification(Registrant);
	return;
}

function UnregisterHearingNotification(IHearingNotification Registrant)
{
	Hearing.UnregisterHearingNotification(Registrant);
	return;
}

event NotifyStartedMoving()
{
	return;
}

event NotifyStoppedMoving()
{
	return;
}

function bool IsIdleCurrent()
{
	return EqualEqual_FloatFloat(Level.TimeSeconds, LastIdleUpdateTime);
	return;
}

function ChooseIdle()
{
	local BaseIdleAction IdleAction;
	local array<BaseIdleAction> UsableIdleActions;
	local float TotalIdleWeight, RandomValue, SummedWeight;
	local int i;

	TotalIdleWeight = 0.0000000;
	i = 0;
	J0x12:

	if(Less_IntInt(i, CharacterAI.abilities.Length))
	{
		if(CharacterAI.abilities[i].IsA('BaseIdleAction'))
		{
			IdleAction = BaseIdleAction(CharacterAI.abilities[i]);
			IdleAction.SetPawn(self);
			IdleAction.SetCurrentIdle(false);
			if(IdleAction.CanUseIdleAction())
			{
				AddEqual_FloatFloat(TotalIdleWeight, IdleAction.GetIdleWeight());
				UsableIdleActions[UsableIdleActions.Length] = IdleAction;
			}
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x12;
	}
	RandomValue = Multiply_FloatFloat(FRand(), TotalIdleWeight);
	i = 0;
	J0xE7:

	if(Less_IntInt(i, UsableIdleActions.Length))
	{
		AddEqual_FloatFloat(SummedWeight, UsableIdleActions[i].GetIdleWeight());
		if(Less_FloatFloat(RandomValue, SummedWeight))
		{
			UsableIdleActions[i].SetCurrentIdle(true);
			// [Explicit Break]
			goto J0x145;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0xE7;
	}
	J0x145:

	LastIdleUpdateTime = Level.TimeSeconds;
	return;
}

event float GetExtraCostForPoint(NavigationPoint Point)
{
	return GetAwarenessCostForPoint(Point);
	return;
}

function EnableFavorLowThreatPath()
{
	bUsesAwarenessForPathfindingCost = true;
	return;
}

function DisableFavorLowThreatPath()
{
	bUsesAwarenessForPathfindingCost = false;
	return;
}

function float GetAwarenessCostForPoint(NavigationPoint Point)
{
	local AwarenessPoint ClosestAwarenessPoint;
	local AwarenessKnowledge KnowledgeOfPoint;
	local float cost;

	if(bUsesAwarenessForPathfindingCost)
	{
		ClosestAwarenessPoint = Point.GetClosestAwarenessPoint();
		if(NotEqual_ObjectObject(ClosestAwarenessPoint, none))
		{
			KnowledgeOfPoint = GetAwareness().GetKnowledge(ClosestAwarenessPoint);
			cost = Multiply_FloatFloat(KnowledgeOfPoint.threat, 10000.0000000);
		}
	}
	return cost;
	return;
}

function float GetCoverCostForPoint(NavigationPoint Point)
{
	local AICoverResult CoverResult;
	local float cost;

	if(AndAnd_BoolBool(bUsesCoverForPathfindingCost, EqualEqual_IntInt(int(Region.ZoneNumber), int(Point.Region.ZoneNumber))))
	{
		CoverResult = AICoverFinder.IsLocationInCover(OtherPawnsToFavorCoveredPathFrom, Point.Location);
		switch(CoverResult.coverLocationInfo)
		{
			case 0:
				cost = 10000.0000000;
				break;
			case 1:
				cost = 1000.0000000;
				break;
			case 2:
				cost = 0.0000000;
				break;
			default:
				break;
		}
	}
	else
	{
		return cost;
		return;
	}
}

event PlayerBlockingPath()
{
	return;
}

function EnableFavorCoveredPath(array<Pawn> otherPawnsToCoverFrom)
{
	bUsesCoverForPathfindingCost = true;
	OtherPawnsToFavorCoveredPathFrom = otherPawnsToCoverFrom;
	return;
}

function DisableFavorCoveredPath()
{
	bUsesCoverForPathfindingCost = false;
	return;
}

function SetPendingDoor(Door inPendingDoor)
{
	assert(NotEqual_ObjectObject(inPendingDoor, none));
	assert(inPendingDoor.IsA('SwatDoor'));
	PendingDoor = SwatDoor(inPendingDoor);
	return;
}

function ClearPendingDoor()
{
	PendingDoor = none;
	return;
}

function bool ShouldForceOpenLockedDoors()
{
	return false;
	return;
}

function InteractWithPendingDoor()
{
	if(AndAnd_BoolBool(NotEqual_ObjectObject(PendingDoor, none), PendingDoor.CanInteract()))
	{
		PendingDoor.Interact(self, ShouldForceOpenLockedDoors());
	}
	return;
}

function NotifyBlockingDoorClose(Door BlockedDoor)
{
	GetCommanderAction().NotifyBlockingDoorClose(BlockedDoor);
	return;
}

function NotifyBlockingDoorOpen(Door BlockedDoor)
{
	GetCommanderAction().NotifyBlockingDoorOpen(BlockedDoor);
	return;
}

function bool ShouldPlayFullBodyHitAnimation()
{
	return true;
	return;
}

function SwapInCompliantAnimSet()
{
	AnimSwapInSet(43);
	return;
}

function SwapInRestrainedAnimSet()
{
	AnimSwapInSet(44);
	return;
}

function name GetFBReactionAnimation()
{
	local int RandomIndex;

	if(IsArrested())
	{
		RandomIndex = Rand(FBRestrainedReactionAnimations.Length);
		return FBRestrainedReactionAnimations[RandomIndex];
	}
	else
	{
		if(IsCompliant())
		{
			RandomIndex = Rand(FBCompliantReactionAnimations.Length);
			return FBCompliantReactionAnimations[RandomIndex];
		}
		else
		{
			if(bIsCrouched)
			{
				if(NotEqual_ObjectObject(GetActiveItem(), none))
				{
					RandomIndex = Rand(FBCrouchingReactionAnimations.Length);
					return FBCrouchingReactionAnimations[RandomIndex];
				}
				else
				{
					RandomIndex = Rand(FBCrouchingNoWeaponReactionAnimations.Length);
					return FBCrouchingNoWeaponReactionAnimations[RandomIndex];
				}
			}
			else
			{
				if(NotEqual_ObjectObject(GetActiveItem(), none))
				{
					RandomIndex = Rand(FBStandingReactionAnimations.Length);
					return FBStandingReactionAnimations[RandomIndex];
				}
				else
				{
					RandomIndex = Rand(FBStandingNoWeaponReactionAnimations.Length);
					return FBStandingNoWeaponReactionAnimations[RandomIndex];
				}
			}
		}
	}
	return;
}

function name GetFBAffectedAnimation()
{
	local int RandomIndex;

	if(IsArrested())
	{
		RandomIndex = Rand(FBRestrainedAffectedAnimations.Length);
		return FBRestrainedAffectedAnimations[RandomIndex];
	}
	else
	{
		if(IsCompliant())
		{
			RandomIndex = Rand(FBCompliantAffectedAnimations.Length);
			return FBCompliantAffectedAnimations[RandomIndex];
		}
		else
		{
			if(bIsCrouched)
			{
				if(NotEqual_ObjectObject(GetActiveItem(), none))
				{
					RandomIndex = Rand(FBCrouchingAffectedAnimations.Length);
					return FBCrouchingAffectedAnimations[RandomIndex];
				}
				else
				{
					RandomIndex = Rand(FBCrouchingNoWeaponAffectedAnimations.Length);
					return FBCrouchingNoWeaponAffectedAnimations[RandomIndex];
				}
			}
			else
			{
				if(NotEqual_ObjectObject(GetActiveItem(), none))
				{
					RandomIndex = Rand(FBStandingAffectedAnimations.Length);
					return FBStandingAffectedAnimations[RandomIndex];
				}
				else
				{
					RandomIndex = Rand(FBStandingNoWeaponAffectedAnimations.Length);
					return FBStandingNoWeaponAffectedAnimations[RandomIndex];
				}
			}
		}
	}
	return;
}

function name GetFBRecoveryAnimation()
{
	local int RandomIndex;

	if(IsArrested())
	{
		RandomIndex = Rand(FBRestrainedRecoveryAnimations.Length);
		return FBRestrainedRecoveryAnimations[RandomIndex];
	}
	else
	{
		if(IsCompliant())
		{
			RandomIndex = Rand(FBCompliantRecoveryAnimations.Length);
			return FBCompliantRecoveryAnimations[RandomIndex];
		}
		else
		{
			if(bIsCrouched)
			{
				if(NotEqual_ObjectObject(GetActiveItem(), none))
				{
					RandomIndex = Rand(FBCrouchingRecoveryAnimations.Length);
					return FBCrouchingRecoveryAnimations[RandomIndex];
				}
				else
				{
					RandomIndex = Rand(FBCrouchingNoWeaponRecoveryAnimations.Length);
					return FBCrouchingNoWeaponRecoveryAnimations[RandomIndex];
				}
			}
			else
			{
				if(NotEqual_ObjectObject(GetActiveItem(), none))
				{
					RandomIndex = Rand(FBStandingRecoveryAnimations.Length);
					return FBStandingRecoveryAnimations[RandomIndex];
				}
				else
				{
					RandomIndex = Rand(FBStandingNoWeaponRecoveryAnimations.Length);
					return FBStandingNoWeaponRecoveryAnimations[RandomIndex];
				}
			}
		}
	}
	return;
}

function name GetGasReactionAnimation()
{
	local int RandomIndex;

	if(IsArrested())
	{
		RandomIndex = Rand(GasRestrainedReactionAnimations.Length);
		return GasRestrainedReactionAnimations[RandomIndex];
	}
	else
	{
		if(IsCompliant())
		{
			RandomIndex = Rand(GasCompliantReactionAnimations.Length);
			return GasCompliantReactionAnimations[RandomIndex];
		}
		else
		{
			if(bIsCrouched)
			{
				if(NotEqual_ObjectObject(GetActiveItem(), none))
				{
					RandomIndex = Rand(GasCrouchingReactionAnimations.Length);
					return GasCrouchingReactionAnimations[RandomIndex];
				}
				else
				{
					RandomIndex = Rand(GasCrouchingNoWeaponReactionAnimations.Length);
					return GasCrouchingNoWeaponReactionAnimations[RandomIndex];
				}
			}
			else
			{
				if(NotEqual_ObjectObject(GetActiveItem(), none))
				{
					RandomIndex = Rand(GasStandingReactionAnimations.Length);
					return GasStandingReactionAnimations[RandomIndex];
				}
				else
				{
					RandomIndex = Rand(GasStandingNoWeaponReactionAnimations.Length);
					return GasStandingNoWeaponReactionAnimations[RandomIndex];
				}
			}
		}
	}
	return;
}

function name GetGasAffectedAnimation()
{
	local int RandomIndex;

	if(IsArrested())
	{
		RandomIndex = Rand(GasRestrainedAffectedAnimations.Length);
		return GasRestrainedAffectedAnimations[RandomIndex];
	}
	else
	{
		if(IsCompliant())
		{
			RandomIndex = Rand(GasCompliantAffectedAnimations.Length);
			return GasCompliantAffectedAnimations[RandomIndex];
		}
		else
		{
			if(bIsCrouched)
			{
				if(NotEqual_ObjectObject(GetActiveItem(), none))
				{
					RandomIndex = Rand(GasCrouchingAffectedAnimations.Length);
					return GasCrouchingAffectedAnimations[RandomIndex];
				}
				else
				{
					RandomIndex = Rand(GasCrouchingNoWeaponAffectedAnimations.Length);
					return GasCrouchingNoWeaponAffectedAnimations[RandomIndex];
				}
			}
			else
			{
				if(NotEqual_ObjectObject(GetActiveItem(), none))
				{
					RandomIndex = Rand(GasStandingAffectedAnimations.Length);
					return GasStandingAffectedAnimations[RandomIndex];
				}
				else
				{
					RandomIndex = Rand(GasStandingNoWeaponAffectedAnimations.Length);
					return GasStandingNoWeaponAffectedAnimations[RandomIndex];
				}
			}
		}
	}
	return;
}

function name GetGasRecoveryAnimation()
{
	local int RandomIndex;

	if(IsArrested())
	{
		RandomIndex = Rand(GasRestrainedRecoveryAnimations.Length);
		return GasRestrainedRecoveryAnimations[RandomIndex];
	}
	else
	{
		if(IsCompliant())
		{
			RandomIndex = Rand(GasCompliantRecoveryAnimations.Length);
			return GasCompliantRecoveryAnimations[RandomIndex];
		}
		else
		{
			if(bIsCrouched)
			{
				if(NotEqual_ObjectObject(GetActiveItem(), none))
				{
					RandomIndex = Rand(GasCrouchingRecoveryAnimations.Length);
					return GasCrouchingRecoveryAnimations[RandomIndex];
				}
				else
				{
					RandomIndex = Rand(GasCrouchingNoWeaponRecoveryAnimations.Length);
					return GasCrouchingNoWeaponRecoveryAnimations[RandomIndex];
				}
			}
			else
			{
				if(NotEqual_ObjectObject(GetActiveItem(), none))
				{
					RandomIndex = Rand(GasStandingRecoveryAnimations.Length);
					return GasStandingRecoveryAnimations[RandomIndex];
				}
				else
				{
					RandomIndex = Rand(GasStandingNoWeaponRecoveryAnimations.Length);
					return GasStandingNoWeaponRecoveryAnimations[RandomIndex];
				}
			}
		}
	}
	return;
}

function name GetStungReactionAnimation()
{
	local int RandomIndex;

	if(IsArrested())
	{
		RandomIndex = Rand(StungRestrainedReactionAnimations.Length);
		return StungRestrainedReactionAnimations[RandomIndex];
	}
	else
	{
		if(IsCompliant())
		{
			RandomIndex = Rand(StungCompliantReactionAnimations.Length);
			return StungCompliantReactionAnimations[RandomIndex];
		}
		else
		{
			if(bIsCrouched)
			{
				if(NotEqual_ObjectObject(GetActiveItem(), none))
				{
					RandomIndex = Rand(StungCrouchingReactionAnimations.Length);
					return StungCrouchingReactionAnimations[RandomIndex];
				}
				else
				{
					RandomIndex = Rand(StungCrouchingNoWeaponReactionAnimations.Length);
					return StungCrouchingNoWeaponReactionAnimations[RandomIndex];
				}
			}
			else
			{
				if(NotEqual_ObjectObject(GetActiveItem(), none))
				{
					RandomIndex = Rand(StungStandingReactionAnimations.Length);
					return StungStandingReactionAnimations[RandomIndex];
				}
				else
				{
					RandomIndex = Rand(StungStandingNoWeaponReactionAnimations.Length);
					return StungStandingNoWeaponReactionAnimations[RandomIndex];
				}
			}
		}
	}
	return;
}

function name GetStungAffectedAnimation()
{
	local int RandomIndex;

	if(IsArrested())
	{
		RandomIndex = Rand(StungRestrainedAffectedAnimations.Length);
		return StungRestrainedAffectedAnimations[RandomIndex];
	}
	else
	{
		if(IsCompliant())
		{
			RandomIndex = Rand(StungCompliantAffectedAnimations.Length);
			return StungCompliantAffectedAnimations[RandomIndex];
		}
		else
		{
			if(bIsCrouched)
			{
				if(NotEqual_ObjectObject(GetActiveItem(), none))
				{
					RandomIndex = Rand(StungCrouchingAffectedAnimations.Length);
					return StungCrouchingAffectedAnimations[RandomIndex];
				}
				else
				{
					RandomIndex = Rand(StungCrouchingNoWeaponAffectedAnimations.Length);
					return StungCrouchingNoWeaponAffectedAnimations[RandomIndex];
				}
			}
			else
			{
				if(NotEqual_ObjectObject(GetActiveItem(), none))
				{
					RandomIndex = Rand(StungStandingAffectedAnimations.Length);
					return StungStandingAffectedAnimations[RandomIndex];
				}
				else
				{
					RandomIndex = Rand(StungStandingNoWeaponAffectedAnimations.Length);
					return StungStandingNoWeaponAffectedAnimations[RandomIndex];
				}
			}
		}
	}
	return;
}

function name GetStungRecoveryAnimation()
{
	local int RandomIndex;

	if(IsArrested())
	{
		RandomIndex = Rand(StungRestrainedRecoveryAnimations.Length);
		return StungRestrainedRecoveryAnimations[RandomIndex];
	}
	else
	{
		if(IsCompliant())
		{
			RandomIndex = Rand(StungCompliantRecoveryAnimations.Length);
			return StungCompliantRecoveryAnimations[RandomIndex];
		}
		else
		{
			if(bIsCrouched)
			{
				if(NotEqual_ObjectObject(GetActiveItem(), none))
				{
					RandomIndex = Rand(StungCrouchingRecoveryAnimations.Length);
					return StungCrouchingRecoveryAnimations[RandomIndex];
				}
				else
				{
					RandomIndex = Rand(StungCrouchingNoWeaponRecoveryAnimations.Length);
					return StungCrouchingNoWeaponRecoveryAnimations[RandomIndex];
				}
			}
			else
			{
				if(NotEqual_ObjectObject(GetActiveItem(), none))
				{
					RandomIndex = Rand(StungStandingRecoveryAnimations.Length);
					return StungStandingRecoveryAnimations[RandomIndex];
				}
				else
				{
					RandomIndex = Rand(StungStandingNoWeaponRecoveryAnimations.Length);
					return StungStandingNoWeaponRecoveryAnimations[RandomIndex];
				}
			}
		}
	}
	return;
}

function name GetTasedReactionAnimation()
{
	local int RandomIndex;

	if(IsArrested())
	{
		RandomIndex = Rand(TasedRestrainedReactionAnimations.Length);
		return TasedRestrainedReactionAnimations[RandomIndex];
	}
	else
	{
		if(IsCompliant())
		{
			RandomIndex = Rand(TasedCompliantReactionAnimations.Length);
			return TasedCompliantReactionAnimations[RandomIndex];
		}
		else
		{
			if(bIsCrouched)
			{
				RandomIndex = Rand(TasedCrouchingReactionAnimations.Length);
				return TasedCrouchingReactionAnimations[RandomIndex];
			}
			else
			{
				RandomIndex = Rand(TasedStandingReactionAnimations.Length);
				return TasedStandingReactionAnimations[RandomIndex];
			}
		}
	}
	return;
}

function name GetTasedAffectedAnimation()
{
	local int RandomIndex;

	if(IsArrested())
	{
		RandomIndex = Rand(TasedRestrainedAffectedAnimations.Length);
		return TasedRestrainedAffectedAnimations[RandomIndex];
	}
	else
	{
		if(IsCompliant())
		{
			RandomIndex = Rand(TasedCompliantAffectedAnimations.Length);
			return TasedCompliantAffectedAnimations[RandomIndex];
		}
		else
		{
			if(bIsCrouched)
			{
				RandomIndex = Rand(TasedCrouchingAffectedAnimations.Length);
				return TasedCrouchingAffectedAnimations[RandomIndex];
			}
			else
			{
				RandomIndex = Rand(TasedStandingAffectedAnimations.Length);
				return TasedStandingAffectedAnimations[RandomIndex];
			}
		}
	}
	return;
}

function name GetTasedRecoveryAnimation()
{
	local int RandomIndex;

	if(IsArrested())
	{
		RandomIndex = Rand(TasedRestrainedRecoveryAnimations.Length);
		return TasedRestrainedRecoveryAnimations[RandomIndex];
	}
	else
	{
		if(IsCompliant())
		{
			RandomIndex = Rand(TasedCompliantRecoveryAnimations.Length);
			return TasedCompliantRecoveryAnimations[RandomIndex];
		}
		else
		{
			if(bIsCrouched)
			{
				RandomIndex = Rand(TasedCrouchingRecoveryAnimations.Length);
				return TasedCrouchingRecoveryAnimations[RandomIndex];
			}
			else
			{
				RandomIndex = Rand(TasedStandingRecoveryAnimations.Length);
				return TasedStandingRecoveryAnimations[RandomIndex];
			}
		}
	}
	return;
}

function name GetTurnAwayAnimation()
{
	if(NotEqual_ObjectObject(GetActiveItem(), none))
	{
		if(GetActiveItem().IsA('MachineGun'))
		{
			return TurnAwayAnimationMG[Rand(TurnAwayAnimationMG.Length)];
		}
		else
		{
			if(GetActiveItem().IsA('SubMachineGun'))
			{
				return TurnAwayAnimationSMG[Rand(TurnAwayAnimationSMG.Length)];
			}
			else
			{
				if(GetActiveItem().IsA('Shotgun'))
				{
					return TurnAwayAnimationSG[Rand(TurnAwayAnimationSG.Length)];
				}
				else
				{
					if(GetActiveItem().IsA('CSBallLauncher'))
					{
						return TurnAwayAnimationPB[Rand(TurnAwayAnimationPB.Length)];
					}
					else
					{
						return TurnAwayAnimationHG[Rand(TurnAwayAnimationHG.Length)];
					}
				}
			}
		}
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetMovementAnimSet()
{
	if(AndAnd_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)), IsBeingArrestedNow()))
	{
		return GetRestrainedAnimSet();
	}
	else
	{
		return super(SwatPawn).GetMovementAnimSet();
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetCrouchingInjuredAnimSet()
{
	if(EqualEqual_ObjectObject(GetActiveItem(), none))
	{
		return 9;
	}
	else
	{
		return super(SwatPawn).GetCrouchingInjuredAnimSet();
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetFlashbangedAnimSet()
{
	if(Not_PreBool(ShouldUseCuffedAnims()))
	{
		return 115;
	}
	else
	{
		return 106;
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetGassedAnimSet()
{
	if(Not_PreBool(ShouldUseCuffedAnims()))
	{
		return 116;
	}
	else
	{
		return 108;
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetPepperSprayedAnimSet()
{
	if(Not_PreBool(ShouldUseCuffedAnims()))
	{
		return 117;
	}
	else
	{
		return 110;
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetStungAnimSet()
{
	if(Not_PreBool(ShouldUseCuffedAnims()))
	{
		return 118;
	}
	else
	{
		return 112;
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetTasedAnimSet()
{
	if(Not_PreBool(ShouldUseCuffedAnims()))
	{
		return 119;
	}
	else
	{
		return 114;
	}
	return;
}

function AimAtPoint(Vector Point)
{
	local bool bShouldSnapBaseToAim;

	if(Not_PreBool(bIsAimLocked))
	{
		if(AndAnd_BoolBool(OrOr_BoolBool(NotEqual_IntInt(int(AnimAimType), int(2)), NotEqual_VectorVector(AnimAimPoint, Point)), EqualEqual_IntInt(int(GetUpperBodyAnimBehavior()), int(0))))
		{
			bShouldSnapBaseToAim = true;
		}
		AnimSetAimPoint(Point);
		if(bShouldSnapBaseToAim)
		{
			AnimSnapBaseToAim();
		}
	}
	return;
}

function AimAtActor(Actor Target)
{
	local bool bShouldSnapBaseToAim;

	if(AndAnd_BoolBool(NotEqual_ObjectObject(Target, none), Not_PreBool(bIsAimLocked)))
	{
		if(AndAnd_BoolBool(OrOr_BoolBool(NotEqual_IntInt(int(AnimAimType), int(3)), NotEqual_ObjectObject(AnimAimActor, Target)), EqualEqual_IntInt(int(GetUpperBodyAnimBehavior()), int(0))))
		{
			bShouldSnapBaseToAim = true;
		}
		AnimSetAimActor(Target);
		if(bShouldSnapBaseToAim)
		{
			AnimSnapBaseToAim();
		}
	}
	return;
}

function AimToRotation(Rotator DesiredRotation)
{
	local bool bShouldSnapBaseToAim;

	if(Not_PreBool(bIsAimLocked))
	{
		if(AndAnd_BoolBool(OrOr_BoolBool(NotEqual_IntInt(int(AnimAimType), int(1)), NotEqual_RotatorRotator(AnimAimRotator, DesiredRotation)), EqualEqual_IntInt(int(GetUpperBodyAnimBehavior()), int(0))))
		{
			bShouldSnapBaseToAim = true;
		}
		AnimSetAimRotation(DesiredRotation);
		if(bShouldSnapBaseToAim)
		{
			AnimSnapBaseToAim();
		}
	}
	return;
}

function LockAim()
{
	bIsAimLocked = true;
	return;
}

function UnlockAim()
{
	bIsAimLocked = false;
	return;
}

function bool CanProcedurallyAnimateUpperBody()
{
	return HasUsableWeapon();
	return;
}

function DisableAim()
{
	AnimAimUnset();
	return;
}

function SetUpperBodyAnimBehavior(ISwatAI.EUpperBodyAnimBehavior behavior, optional UpperBodyAnimBehaviorClients.EUpperBodyAnimBehaviorClientId clientId)
{
	local ISwatAI.EUpperBodyAnimBehavior previousDominantBehavior, newDominantBehavior;

	if(Not_PreBool(bDeleteMe))
	{
		previousDominantBehavior = GetDominantUpperBodyAnimBehavior();
		SetUpperBodyAnimBehaviorForClient(behavior, clientId);
		newDominantBehavior = GetDominantUpperBodyAnimBehavior();
		SetUpperBodyAnimBehaviorPawnState(newDominantBehavior, previousDominantBehavior);
	}
	return;
}

function UnsetUpperBodyAnimBehavior(optional UpperBodyAnimBehaviorClients.EUpperBodyAnimBehaviorClientId clientId)
{
	local ISwatAI.EUpperBodyAnimBehavior previousDominantBehavior, newDominantBehavior;

	if(Not_PreBool(bDeleteMe))
	{
		previousDominantBehavior = GetDominantUpperBodyAnimBehavior();
		UnsetUpperBodyAnimBehaviorForClient(clientId);
		newDominantBehavior = GetDominantUpperBodyAnimBehavior();
		SetUpperBodyAnimBehaviorPawnState(newDominantBehavior, previousDominantBehavior);
	}
	return;
}

function ISwatAI.EUpperBodyAnimBehavior GetUpperBodyAnimBehavior()
{
	if(EqualEqual_BoolBool(AnimGetFlag(2), false))
	{
		return 0;
	}
	else
	{
		if(IsLowReady())
		{
			return 1;
		}
		else
		{
			return 2;
		}
	}
	return;
}

function ISwatAI.EUpperBodyAnimBehavior GetMovementUpperBodyAimBehavior()
{
	return 0;
	return;
}

private function SetUpperBodyAnimBehaviorPawnState(ISwatAI.EUpperBodyAnimBehavior newDominantBehavior, ISwatAI.EUpperBodyAnimBehavior previousDominantBehavior)
{
	local bool bCanProcedurallyAnimateUpperBody, bCanPawnUseLowReady, bWasUsingAim;

	bCanProcedurallyAnimateUpperBody = CanProcedurallyAnimateUpperBody();
	bCanPawnUseLowReady = CanPawnUseLowReady();
	if(Not_PreBool(bCanProcedurallyAnimateUpperBody))
	{
		newDominantBehavior = 0;
	}
	else
	{
		if(AndAnd_BoolBool(EqualEqual_IntInt(int(newDominantBehavior), int(1)), Not_PreBool(bCanPawnUseLowReady)))
		{
			newDominantBehavior = 2;
		}
	}
	bWasUsingAim = AnimGetFlag(2);
	switch(newDominantBehavior)
	{
		case 0:
			AnimSetFlag(2, false);
			if(NotEqual_IntInt(int(previousDominantBehavior), int(0)))
			{
				AnimSnapBaseToAim();
			}
			break;
		case 1:
			SetLowReady(true);
			AnimSetFlag(2, true);
			break;
		case 2:
			SetLowReady(false);
			AnimSetFlag(2, true);
			if(Not_PreBool(bWasUsingAim))
			{
				GetCommanderAction().ResetIdling();
			}
			break;
		default:
			break;
	}
	return;
}

private function SetUpperBodyAnimBehaviorForClient(ISwatAI.EUpperBodyAnimBehavior behavior, UpperBodyAnimBehaviorClients.EUpperBodyAnimBehaviorClientId clientId)
{
	local int i, numEntries;

	numEntries = UpperBodyAnimBehaviorEntries.Length;
	i = 0;
	J0x13:

	if(Less_IntInt(i, numEntries))
	{
		if(LessEqual_IntInt(UpperBodyAnimBehaviorEntries[i].clientId, int(clientId)))
		{
			// [Explicit Break]
			goto J0x4B;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x13;
	}
	J0x4B:

	if(AndAnd_BoolBool(Less_IntInt(i, numEntries), EqualEqual_IntInt(UpperBodyAnimBehaviorEntries[i].clientId, int(clientId))))
	{
		UpperBodyAnimBehaviorEntries[i].behavior = behavior;
	}
	else
	{
		UpperBodyAnimBehaviorEntries.Insert(i, 1);
		UpperBodyAnimBehaviorEntries[i].behavior = behavior;
		UpperBodyAnimBehaviorEntries[i].clientId = int(clientId);
	}
	return;
}

private function UnsetUpperBodyAnimBehaviorForClient(UpperBodyAnimBehaviorClients.EUpperBodyAnimBehaviorClientId clientId)
{
	local int i, numEntries;

	numEntries = UpperBodyAnimBehaviorEntries.Length;
	i = 0;
	J0x13:

	if(Less_IntInt(i, numEntries))
	{
		if(EqualEqual_IntInt(UpperBodyAnimBehaviorEntries[i].clientId, int(clientId)))
		{
			UpperBodyAnimBehaviorEntries.Remove(i, 1);
			return;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x13;
	}
	return;
}

private function ISwatAI.EUpperBodyAnimBehavior GetDominantUpperBodyAnimBehavior()
{
	if(Greater_IntInt(UpperBodyAnimBehaviorEntries.Length, 0))
	{
		return UpperBodyAnimBehaviorEntries[0].behavior;
	}
	else
	{
		return 0;
	}
	return;
}

function bool AnimIsWeaponAimSet()
{
	return AnimIsAimSet();
	return;
}

function Rotator GetAimOrientation()
{
	return AnimGetAimRotation();
	return;
}

function OnTouchedStaircaseAimVolume(StaircaseAimVolume StaircaseAimVolume)
{
	local int i;
	local AimAroundAction AimAroundAction;

	i = 0;
	J0x07:

	if(Less_IntInt(i, TouchingStaircaseAimVolumes.Length))
	{
		if(EqualEqual_ObjectObject(TouchingStaircaseAimVolumes[i], StaircaseAimVolume))
		{
			// [Explicit Break]
			goto J0x39;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	J0x39:

	if(EqualEqual_IntInt(i, TouchingStaircaseAimVolumes.Length))
	{
		TouchingStaircaseAimVolumes[TouchingStaircaseAimVolumes.Length] = StaircaseAimVolume;
		AimAroundAction = GetAimAroundAction();
		if(NotEqual_ObjectObject(AimAroundAction, none))
		{
			AimAroundAction.ForceReevaluation();
		}
	}
	return;
}

function OnUntouchedStaircaseAimVolume(StaircaseAimVolume StaircaseAimVolume)
{
	local int i;
	local AimAroundAction AimAroundAction;

	i = 0;
	J0x07:

	if(Less_IntInt(i, TouchingStaircaseAimVolumes.Length))
	{
		if(EqualEqual_ObjectObject(TouchingStaircaseAimVolumes[i], StaircaseAimVolume))
		{
			TouchingStaircaseAimVolumes.Remove(i, 1);
			AimAroundAction = GetAimAroundAction();
			if(NotEqual_ObjectObject(AimAroundAction, none))
			{
				AimAroundAction.ForceReevaluation();
			}
			// [Explicit Break]
			goto J0x6B;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	J0x6B:

	return;
}

function int GetNumTouchingStaircaseAimVolumes()
{
	return TouchingStaircaseAimVolumes.Length;
	return;
}

function StaircaseAimVolume GetTouchingStaircaseAimVolumeAtIndex(int Index)
{
	assert(AndAnd_BoolBool(GreaterEqual_IntInt(Index, 0), Less_IntInt(Index, TouchingStaircaseAimVolumes.Length)));
	return TouchingStaircaseAimVolumes[Index];
	return;
}

function AimAroundAction GetAimAroundAction()
{
	local AI_Resource resource;
	local AimAroundAction AimAroundAction;
	local int i;

	if(NotEqual_ObjectObject(WeaponAI, none))
	{
		resource = AI_Resource(WeaponAI);
		if(NotEqual_ObjectObject(resource, none))
		{
			i = 0;
			J0x2D:

			if(Less_IntInt(i, resource.runningActions.Length))
			{
				AimAroundAction = AimAroundAction(resource.runningActions[i]);
				if(NotEqual_ObjectObject(AimAroundAction, none))
				{
					return AimAroundAction;
				}
				AddAdd_Int(i);
				// [Loop Continue]
				goto J0x2D;
			}
		}
	}
	return none;
	return;
}

simulated function Rotator AdjustAim(Ammunition FiredAmmunition, Vector projStart, int aimerror)
{
	return AnimGetAimRotation();
	return;
}

simulated function Rotator GetAimRotation()
{
	local Vector TargetLocation;
	local HandheldEquipment ActiveItem;

	ActiveItem = GetActiveItem();
	if(NotEqual_ObjectObject(CurrentWeaponTarget, none))
	{
		TargetLocation = CurrentWeaponTarget.GetFireLocation(ActiveItem);
	}
	else
	{
		TargetLocation = CurrentWeaponTargetLocation;
	}
	if(AndAnd_BoolBool(NotEqual_ObjectObject(ActiveItem, none), ActiveItem.IsA('CSBallLauncher')))
	{
		return GetCSBallLauncherAimRotation(TargetLocation);
	}
	else
	{
		return Rotator(Subtract_VectorVector(TargetLocation, GetAimOrigin()));
	}
	return;
}

private simulated function Rotator GetCSBallLauncherAimRotation(Vector TargetLocation)
{
	local float Distance, Grav, ProjectileSpeed, Angle;
	local Vector AimOrigin, OriginalAim;
	local HandheldEquipment ActiveItem;
	local Rotator PaintballAimRotation;

	ActiveItem = GetActiveItem();
	assert(ActiveItem.IsA('CSBallLauncher'));
	AimOrigin = GetAimOrigin();
	Distance = VSize(Subtract_VectorVector(TargetLocation, AimOrigin));
	Grav = Multiply_FloatFloat(Subtract_PreFloat(PhysicsVolume.Gravity.Z), 0.5000000);
	ProjectileSpeed = FiredWeapon(ActiveItem).MuzzleVelocity;
	Angle = Divide_FloatFloat(Asin(Divide_FloatFloat(Multiply_FloatFloat(Distance, Grav), Multiply_FloatFloat(ProjectileSpeed, ProjectileSpeed))), 2.0000000);
	OriginalAim = Subtract_VectorVector(TargetLocation, AimOrigin);
	PaintballAimRotation = Rotator(OriginalAim);
	AddEqual_IntInt(PaintballAimRotation.Pitch, int(Multiply_FloatFloat(10430.3800000, Angle)));
	return PaintballAimRotation;
	return;
}

// Export USwatAI::execGetAimOrigin(FFrame&, void* const)
native simulated function Vector GetAimOrigin();

function SetAimUrgency(bool Fast)
{
	local SwatPawn.EAnimAimRotationUrgency Urgency;

	if(Fast)
	{
		Urgency = 1;
	}
	else
	{
		Urgency = 0;
	}
	AnimSetAnimAimRotationUrgency(Urgency);
	return;
}

// Export USwatAI::execCanHitTargetAt(FFrame&, void* const)
native event bool CanHitTargetAt(Actor Target, Vector AILocation);

// Export USwatAI::execCanHit(FFrame&, void* const)
native event bool CanHit(Actor Target);

function bool HasUsableWeapon()
{
	return false;
	return;
}

protected function Actor GetWeaponTarget()
{
	return CurrentWeaponTarget;
	return;
}

// Export USwatAI::execSetWeaponTarget(FFrame&, void* const)
native function SetWeaponTarget(Actor Target);

event SetWeaponTargetLocation(Vector TargetLocation)
{
	CurrentWeaponTarget = none;
	CurrentWeaponTargetLocation = TargetLocation;
	return;
}

function FiredWeapon.FireMode GetDefaultAIFireModeForWeapon(FiredWeapon Weapon)
{
	assert(NotEqual_ObjectObject(Weapon, none));
	if(Weapon.HasFireMode(1))
	{
		return 1;
	}
	else
	{
		if(Weapon.HasFireMode(2))
		{
			return 2;
		}
		else
		{
			assert(Weapon.HasFireMode(0));
			return 0;
		}
	}
	return;
}

function float GetTimeToWaitBetweenFiring(FiredWeapon Weapon)
{
	local FiredWeapon.FireMode CurrentFireMode;

	CurrentFireMode = Weapon.GetCurrentFireMode();
	if(Weapon.IsA('Handgun'))
	{
		return RandRange(MinTimeBetweenFireHG, MaxTimeBetweenFireHG);
	}
	else
	{
		if(Weapon.IsA('SubMachineGun'))
		{
			if(EqualEqual_IntInt(int(CurrentFireMode), int(0)))
			{
				return RandRange(MinTimeBetweenFireSMGSingleShot, MaxTimeBetweenFireSMGSingleShot);
			}
			else
			{
				if(EqualEqual_IntInt(int(CurrentFireMode), int(1)))
				{
					return RandRange(MinTimeBetweenFireSMGBurst, MaxTimeBetweenFireSMGBurst);
				}
				else
				{
					return RandRange(MinTimeBetweenFireSMGFullAuto, MaxTimeBetweenFireSMGFullAuto);
				}
			}
		}
		else
		{
			if(Weapon.IsA('MachineGun'))
			{
				if(EqualEqual_IntInt(int(CurrentFireMode), int(0)))
				{
					return RandRange(MinTimeBetweenFireMGSingleShot, MaxTimeBetweenFireMGSingleShot);
				}
				else
				{
					if(EqualEqual_IntInt(int(CurrentFireMode), int(1)))
					{
						return RandRange(MinTimeBetweenFireMGFullBurst, MaxTimeBetweenFireMGFullBurst);
					}
					else
					{
						return RandRange(MinTimeBetweenFireMGFullAuto, MaxTimeBetweenFireMGFullAuto);
					}
				}
			}
			else
			{
				return RandRange(MinTimeBetweenFireShotgun, MaxTimeBetweenFireShotgun);
			}
		}
	}
	return;
}

protected function float GetLengthOfTimeToFireFullAuto()
{
	assert(false);
	return 0.0000000;
	return;
}

private function SetLengthOfTimeToFireFullAuto()
{
	EndTimeToStopFiringFullAuto = Add_FloatFloat(Level.TimeSeconds, GetLengthOfTimeToFireFullAuto());
	assert(GreaterEqual_FloatFloat(EndTimeToStopFiringFullAuto, Level.TimeSeconds));
	return;
}

private function WeaponDischargedAt(Pawn TargetPawn)
{
	if(Class'Engine.Pawn'.static.checkConscious(TargetPawn))
	{
		NotifyWeaponDischarged();
		if(TargetPawn.IsA('SwatAI'))
		{
			SwatCharacterResource(TargetPawn.CharacterAI).ThreatenedSensorAction.UpdateThreatFrom(self);
		}
	}
	return;
}

protected function NotifyWeaponDischarged()
{
	return;
}

simulated function OnUsingBegan()
{
	local FiredWeapon CurrentWeapon;
	local Pawn CurrentPawnTarget;

	super(Pawn).OnUsingBegan();
	CurrentWeapon = FiredWeapon(GetActiveItem());
	if(NotEqual_ObjectObject(CurrentWeapon, none))
	{
		CurrentPawnTarget = Pawn(CurrentWeaponTarget);
		if(NotEqual_ObjectObject(CurrentPawnTarget, none))
		{
			WeaponDischargedAt(CurrentPawnTarget);
		}
	}
	return;
}

simulated function OnAutoFireStarted()
{
	bWantsToContinueAutoFiring = true;
	SetLengthOfTimeToFireFullAuto();
	return;
}

simulated function bool WantsToContinueAutoFiring()
{
	return AndAnd_BoolBool(AndAnd_BoolBool(bWantsToContinueAutoFiring, Less_FloatFloat(Level.TimeSeconds, EndTimeToStopFiringFullAuto)), CanHitCurrentTarget());
	return;
}

private simulated function bool CanHitCurrentTarget()
{
	if(NotEqual_ObjectObject(CurrentWeaponTarget, none))
	{
		return CanHit(CurrentWeaponTarget);
	}
	else
	{
		return true;
	}
	return;
}

simulated function Died(Controller Killer, Class<DamageType> DamageType, Vector HitLocation, Vector HitMomentum)
{
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(Name), " Died - IsIncapacitated: "), string(IsIncapacitated())), " ShouldBecomeIncapacitated: "), string(ShouldBecomeIncapacitated())));
	if(ShouldBecomeIncapacitated())
	{
		BecomeIncapacitated(, Killer.Pawn);
	}
	else
	{
		if(Not_PreBool(IsIncapacitated()))
		{
			GetSpeechManagerAction().TriggerDiedSpeech();
		}
		SetIncapacitated(false);
		GetCommanderAction().RemoveGoalsToDie();
		super.Died(Killer, DamageType, HitLocation, HitMomentum);
	}
	return;
}

protected simulated function TriggerPawnDied(Controller Killer)
{
	if(Not_PreBool(IsIncapacitated()))
	{
		if(NotEqual_ObjectObject(Killer, none))
		{
			SwatGameInfo(Level.Game).GameEvents.PawnDied.Triggered(self, Killer.Pawn, AndAnd_BoolBool(AndAnd_BoolBool(IsAThreat(), Not_PreBool(IsCompliant())), Not_PreBool(IsArrested())));
		}
		else
		{
			SwatGameInfo(Level.Game).GameEvents.PawnDied.Triggered(self, none, AndAnd_BoolBool(AndAnd_BoolBool(IsAThreat(), Not_PreBool(IsCompliant())), Not_PreBool(IsArrested())));
		}
	}
	return;
}

function BecomeIncapacitated(optional name IncapaciatedIdleCategoryOverride, optional Pawn Incapacitator)
{
	Health = Max(1, Health);
	if(Not_PreBool(IsIncapacitated()))
	{
		SetIncapacitated(true);
		Log(Concat_StrStr(Concat_StrStr(string(Name), " is now incapacitated - IncapaciatedIdleCategoryOverride is "), string(IncapaciatedIdleCategoryOverride)));
		Commander.BecomeIncapacitated(IncapaciatedIdleCategoryOverride);
		NotifyBecameIncapacitated(Incapacitator);
		SwatGameInfo(Level.Game).GameEvents.PawnIncapacitated.Triggered(self, Incapacitator, AndAnd_BoolBool(AndAnd_BoolBool(IsAThreat(), Not_PreBool(IsCompliant())), Not_PreBool(IsArrested())));
	}
	return;
}

function NotifyBecameIncapacitated(Pawn Incapacitator)
{
	return;
}

simulated function PostTakeDamage(int Damage, Pawn InstigatedBy, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType)
{
	NotifyHit(float(Damage), InstigatedBy);
	super(SwatPawn).PostTakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
	if(ShouldBecomeIncapacitated())
	{
		BecomeIncapacitated(, InstigatedBy);
	}
	return;
}

function NotifyHit(float Damage, Pawn HitInstigator)
{
	return;
}

function OnSkeletalRegionHit(Actor.ESkeletalRegion RegionHit, Vector HitLocation, Vector HitNormal, int Damage, Class<DamageType> DamageType, Actor Instigator)
{
	local Pawn Attacker;
	local bool bIsLessLethalHit;

	Attacker = Pawn(Instigator);
	if(NotEqual_ObjectObject(Attacker, none))
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(Attacker.GetActiveItem(), none), Attacker.GetActiveItem().IsA('LessLethalSG')))
		{
			bIsLessLethalHit = true;
		}
	}
	if(AndAnd_BoolBool(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)), Not_PreBool(bIsLessLethalHit)))
	{
		GetCommanderAction().OnSkeletalRegionHit(RegionHit, HitLocation, HitNormal, Damage, DamageType);
	}
	return;
}

function name GetFlinchAnimation()
{
	if(IsCompliant())
	{
		return CompliantFlinchAnimations[Rand(CompliantFlinchAnimations.Length)];
	}
	else
	{
		if(IsArrested())
		{
			return RestrainedFlinchAnimations[Rand(RestrainedFlinchAnimations.Length)];
		}
		else
		{
			if(bIsCrouched)
			{
				return CrouchingFlinchAnimations[Rand(CrouchingFlinchAnimations.Length)];
			}
			else
			{
				return StandingFlinchAnimations[Rand(StandingFlinchAnimations.Length)];
			}
		}
	}
	return;
}

// Export USwatAI::execGetCommanderAction(FFrame&, void* const)
native function CommanderAction GetCommanderAction();

function CharacterSpeechManagerAction GetSpeechManagerAction()
{
	assert(NotEqual_ObjectObject(SpeechManager, none));
	assert(NotEqual_ObjectObject(SpeechManager.achievingAction, none));
	assert(NotEqual_ObjectObject(CharacterSpeechManagerAction(SpeechManager.achievingAction), none));
	return CharacterSpeechManagerAction(SpeechManager.achievingAction);
	return;
}

function DrawVisionCone(HUD DrawTarget)
{
	DrawTarget.Draw3DCone(GetViewPoint(), GetViewDirection(), SightRadius, Divide_FloatFloat(Multiply_FloatFloat(Acos(PeripheralVision), 180.0000000), 3.1415930), Class'Engine.Canvas'.static.MakeColor(0, byte(255), 0), 8);
	return;
}

function DrawDebugAIMovement(HUD DrawTarget)
{
	local int i;
	local Vector LineOrigin;

	if(NotEqual_ObjectObject(Controller, none))
	{
		if(NotEqual_ObjectObject(Controller.MoveTarget, none))
		{
			DrawTarget.Draw3DLine(Location, Controller.MoveTarget.Location, Class'Engine.Canvas'.static.MakeColor(0, byte(255), 0));
			LineOrigin = Controller.MoveTarget.Location;
			if(EqualEqual_ObjectObject(Controller.MoveTarget, Controller.RouteCache[0]))
			{
				i = 1;
				J0xA8:

				if(Less_IntInt(i, 16))
				{
					if(NotEqual_ObjectObject(Controller.RouteCache[i], none))
					{
						DrawTarget.Draw3DLine(LineOrigin, Controller.RouteCache[i].Location, Class'Engine.Canvas'.static.MakeColor(byte(255), 0, byte(255)));
						LineOrigin = Controller.RouteCache[i].Location;
					}
					AddAdd_PreInt(i);
					// [Loop Continue]
					goto J0xA8;
				}
			}
		}
		else
		{
			if(Greater_FloatFloat(Controller.MoveTimer, 0.0000000))
			{
				DrawTarget.Draw3DLine(Location, Controller.Destination, Class'Engine.Canvas'.static.MakeColor(200, 200, byte(255)));
			}
		}
	}
	return;
}

event DebugTyrionInfo(AI_Resource resource)
{
	local int i;

	assert(NotEqual_ObjectObject(resource, none));
	AddDebugMessage(" ");
	if(Greater_IntInt(resource.goals.Length, 0))
	{
		AddDebugMessage(Concat_StrStr(string(resource.Name), " Goals"), Class'Engine.Canvas'.static.MakeColor(byte(255), byte(255), byte(255)));
		i = 0;
		J0x6B:

		if(Less_IntInt(i, resource.goals.Length))
		{
			AddDebugMessage(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("  ", AI_Goal(resource.goals[i]).goalName), " ("), string(AI_Goal(resource.goals[i]).Priority)), ")"));
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x6B;
		}
	}
	if(Greater_IntInt(resource.runningActions.Length, 0))
	{
		AddDebugMessage(Concat_StrStr(Concat_StrStr("Running ", string(resource.Name)), " Actions"), Class'Engine.Canvas'.static.MakeColor(byte(255), byte(255), byte(255)));
		i = 0;
		J0x152:

		if(Less_IntInt(i, resource.runningActions.Length))
		{
			AddDebugMessage(Concat_StrStr("  ", string(resource.runningActions[i].Name)));
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x152;
		}
	}
	if(Greater_IntInt(resource.idleActions.Length, 0))
	{
		AddDebugMessage(Concat_StrStr(Concat_StrStr("Idle ", string(resource.Name)), " Actions"), Class'Engine.Canvas'.static.MakeColor(byte(255), byte(255), byte(255)));
		i = 0;
		J0x202:

		if(Less_IntInt(i, resource.idleActions.Length))
		{
			AddDebugMessage(Concat_StrStr("  ", string(resource.idleActions[i].Name)));
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x202;
		}
	}
	return;
}

event ShowAimingDebugInfo()
{
	local int i;
	local Color Color;
	local string ClientIdString, BehaviorString;

	if(Class'Engine.Pawn'.static.checkConscious(self))
	{
		switch(AnimAimType)
		{
			case 1:
				AddDebugMessage(Concat_StrStr("Aiming to Rotation ", string(AnimAimRotator)), Class'Engine.Canvas'.static.MakeColor(byte(255), byte(255), 0));
				break;
			case 2:
				AddDebugMessage(Concat_StrStr("Aiming at Point ", string(AnimAimPoint)), Class'Engine.Canvas'.static.MakeColor(byte(255), byte(255), 0));
				break;
			case 3:
				AddDebugMessage(Concat_StrStr("Aiming at Actor ", string(AnimAimActor)), Class'Engine.Canvas'.static.MakeColor(byte(255), byte(255), 0));
				break;
			default:
				break;
		}
		AddDebugMessage(" ");
		AddDebugMessage("Upper Body Anim Behaviors", Class'Engine.Canvas'.static.MakeColor(byte(255), byte(255), byte(255)));
		AddDebugMessage("(most-to-least dominant):", Class'Engine.Canvas'.static.MakeColor(byte(255), byte(255), byte(255)));
		i = 0;
		J0x16E:

		if(Less_IntInt(i, UpperBodyAnimBehaviorEntries.Length))
		{
			if(EqualEqual_IntInt(i, 0))
			{
				Color = Class'Engine.Canvas'.static.MakeColor(0, byte(255), 0);
			}
			else
			{
				Color = Class'Engine.Canvas'.static.MakeColor(0, 192, 0);
			}
			ClientIdString = string(GetEnum(Enum'SwatAICommon.UpperBodyAnimBehaviorClients.EUpperBodyAnimBehaviorClientId', UpperBodyAnimBehaviorEntries[i].clientId));
			BehaviorString = string(GetEnum(Enum'SwatAICommon.ISwatAI.EUpperBodyAnimBehavior', int(UpperBodyAnimBehaviorEntries[i].behavior)));
			ClientIdString = Right(ClientIdString, Subtract_IntInt(Len(ClientIdString), Len("kUBABCI_")));
			BehaviorString = Right(BehaviorString, Subtract_IntInt(Len(BehaviorString), Len("kUBAB_")));
			AddDebugMessage(Concat_StrStr(Concat_StrStr(Concat_StrStr("   ", ClientIdString), " - "), BehaviorString), Color);
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x16E;
		}
	}
	return;
}

function EnableVision()
{
	if(Not_PreBool(bVisionDisabledPermanently))
	{
		bVisionDisabled = false;
	}
	return;
}

function DisableVision(bool bDisableVisionPermanently)
{
	bVisionDisabled = true;
	if(Not_PreBool(bVisionDisabledPermanently))
	{
		bVisionDisabledPermanently = bDisableVisionPermanently;
	}
	return;
}

function bool IsHearingEnabled()
{
	return Not_PreBool(bHearingDisabled);
	return;
}

function EnableHearing()
{
	if(Not_PreBool(bHearingDisabledPermanently))
	{
		bHearingDisabled = false;
	}
	return;
}

function DisableHearing(bool bDisableHearingPermanently)
{
	bHearingDisabled = true;
	if(Not_PreBool(bHearingDisabledPermanently))
	{
		bHearingDisabledPermanently = bDisableHearingPermanently;
	}
	return;
}

function ArchetypeInstance GetArchetypeInstance()
{
	return ArchetypeInstance;
	return;
}

function InitializeFromSpawner(Spawner Spawner)
{
	SpawnedFromName = Spawner.Name;
	return;
}

function Internal_InitializeFromArchetypeInstance(ArchetypeInstance inInstance)
{
	ArchetypeInstance = inInstance;
	InitializeFromArchetypeInstance();
	ChangeAnimation();
	return;
}

function InitializeFromArchetypeInstance()
{
	return;
}

simulated function DestroyEquipment()
{
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		ArchetypeInstance.DestroyEquipment();
	}
	return;
}

private function InitKnowledge()
{
	AIKnowledge = Class'SwatAICommon.AIKnowledge'.static.Allocate(self).;
	Construct_Void();
	assert(NotEqual_ObjectObject(AIKnowledge, none));
	AIKnowledge.Init(self, Vision);
	return;
}

private function TermKnowledge()
{
	AssertWithDescription(NotEqual_ObjectObject(AIKnowledge, none), "It appears an AI object has gotten its event Destroyed() without getting its event PostBeginPlay(). Look into why..");
	if(NotEqual_ObjectObject(AIKnowledge, none))
	{
		AIKnowledge.Term();
		AIKnowledge = none;
	}
	return;
}

function AIKnowledge GetKnowledge()
{
	return AIKnowledge;
	return;
}

function AwarenessProxy GetAwareness()
{
	return none;
	return;
}

function DisableAwareness()
{
	return;
}

function EnableAwareness()
{
	return;
}

function SetIsCompliant()
{
	bIsCompliant = true;
	return;
}

function SetIncapacitated(bool bInIsIncapacitated)
{
	bIsIncapacitated = bInIsIncapacitated;
	return;
}

// Export USwatAI::execIsOtherActorAThreat(FFrame&, void* const)
native function bool IsOtherActorAThreat(Actor otherActor);

function bool GetKnownLocationOfPawn(Pawn otherPawn, out Vector Location)
{
	local KnowledgeAboutPawn Knowledge;

	if(AIKnowledge.GetLastKnownKnowledgeAboutPawn(otherPawn, Knowledge))
	{
		Location = Knowledge.Location;
		return true;
	}
	return false;
	return;
}

// Export USwatAI::execCanMoveFreely(FFrame&, void* const)
native event bool CanMoveFreely();

function bool IsAggressive()
{
	return false;
	return;
}

function float GetInitialMorale()
{
	return -1.0000000;
	return;
}

function InitCoverFinder()
{
	AICoverFinder = Class'SwatAICommon.AICoverFinder'.static.Allocate(self).;
	construct_Pawn(self);
	return;
}

function AICoverFinder GetCoverFinder()
{
	return AICoverFinder;
	return;
}

function NavigationPoint FindRunToPoint(Vector PointToRunAwayFrom, float MinDistanceToRunAway)
{
	local int i;
	local array<AwarenessKnowledge> PotentiallyVisibleSet;
	local AwarenessKnowledge Knowledge;
	local NavigationPoint NavigationPoint;
	local float DistSq, Weight;
	local NavigationPoint BestRunToPoint;
	local float BestRunToPointWeight;

	PotentiallyVisibleSet = GetAwareness().GetPotentiallyVisibleKnowledge(self);
	i = 0;
	J0x1E:

	if(Less_IntInt(i, PotentiallyVisibleSet.Length))
	{
		Knowledge = PotentiallyVisibleSet[i];
		NavigationPoint = Knowledge.aboutAwarenessPoint.GetClosestNavigationPoint();
		if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(NavigationPoint, none), Not_PreBool(NavigationPoint.IsA('Door'))), NotEqual_ObjectObject(NavigationPoint, Anchor)))
		{
			DistSq = VDistSquared(Location, NavigationPoint.Location);
			if(GreaterEqual_FloatFloat(DistSq, MinDistanceToRunAway))
			{
				Weight = Subtract_FloatFloat(Knowledge.Confidence, Multiply_FloatFloat(Knowledge.threat, 2.0000000));
				if(OrOr_BoolBool(EqualEqual_ObjectObject(BestRunToPoint, none), Greater_FloatFloat(Weight, BestRunToPointWeight)))
				{
					BestRunToPoint = NavigationPoint;
					BestRunToPointWeight = Weight;
				}
			}
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x1E;
	}
	return BestRunToPoint;
	return;
}

private function UseGrenadeAction GetUseGrenadeBehavior()
{
	local UseGrenadeGoal CurrentUseGrenadeGoal;
	local UseGrenadeAction CurrentUseGrenadeAction;

	CurrentUseGrenadeGoal = UseGrenadeGoal(AI_Resource(WeaponAI).findGoalByName("UseGrenade"));
	assert(NotEqual_ObjectObject(CurrentUseGrenadeGoal, none));
	CurrentUseGrenadeAction = UseGrenadeAction(CurrentUseGrenadeGoal.achievingAction);
	assert(NotEqual_ObjectObject(CurrentUseGrenadeAction, none));
	return CurrentUseGrenadeAction;
	return;
}

function Vector GetThrowOriginOffset(bool bIsUnderhandThrow, Rotator Orientation)
{
	local Vector ThrowOriginOffset;

	if(bIsUnderhandThrow)
	{
		ThrowOriginOffset = GreaterGreater_VectorRotator(UnderhandThrownProjectileInitialOffset, Orientation);
	}
	else
	{
		ThrowOriginOffset = GreaterGreater_VectorRotator(OverhandThrownProjectileInitialOffset, Orientation);
	}
	return ThrowOriginOffset;
	return;
}

function Vector GetThrowOrigin(bool bIsUnderhandThrow, Rotator Orientation)
{
	return Add_VectorVector(Location, GetThrowOriginOffset(bIsUnderhandThrow, Orientation));
	return;
}

function float GetThrowAngle()
{
	return Multiply_FloatFloat(float(ThrownProjectilePitch), 0.0174533);
	return;
}

function GetThrownProjectileParams(out Vector outLocation, out Rotator outRotation)
{
	outLocation = GetActiveItem().GetThirdPersonModel().Location;
	outRotation.Yaw = Rotator(Subtract_VectorVector(vGrenadeTargetLocation, outLocation)).Yaw;
	outRotation.Pitch = int(Add_FloatFloat(float(WrapAngle0To2Pi(Rotator(Subtract_VectorVector(vGrenadeTargetLocation, outLocation)).Pitch)), Multiply_FloatFloat(float(ThrownProjectilePitch), 182.0444000)));
	return;
}

simulated function name GetPreThrowAnimation()
{
	return 'None';
	return;
}

simulated function name GetThrowAnimation(float ThrowSpeed)
{
	if(EqualEqual_IntInt(int(ThrowSide), int(0)))
	{
		if(IsUnderhandThrowTo(vGrenadeTargetLocation))
		{
			return ThrowShortAnimation;
		}
		else
		{
			return ThrowLongAnimation;
		}
	}
	else
	{
		if(EqualEqual_IntInt(int(ThrowSide), int(2)))
		{
			return ThrowFromRightAnimation;
		}
		else
		{
			assert(EqualEqual_IntInt(int(ThrowSide), int(1)));
			return ThrowFromLeftAnimation;
		}
	}
	return;
}

simulated function name GetPawnThrowRootBone()
{
	return 'None';
	return;
}

simulated function float GetPawnThrowTweenTime()
{
	return ThrowAnimationTweenTime;
	return;
}

function bool IsUnderhandThrow(Vector Origin, Vector TargetLocation)
{
	return AndAnd_BoolBool(Less_FloatFloat(VSize(Subtract_VectorVector(TargetLocation, Origin)), MaxUnderhandThrowDistance), Less_FloatFloat(Subtract_FloatFloat(TargetLocation.Z, Origin.Z), ZPositiveOffsetForOverhandThrow));
	return;
}

function bool IsUnderhandThrowTo(Vector TargetLocation)
{
	return IsUnderhandThrow(Location, TargetLocation);
	return;
}

function SetGrenadeTargetLocation(Vector vInGrenadeTargetLocation)
{
	vGrenadeTargetLocation = vInGrenadeTargetLocation;
	return;
}

function SetThrowSide(ISwatAI.AIThrowSide inThrowSide)
{
	ThrowSide = inThrowSide;
	return;
}

simulated function bool IsPlayerPawn()
{
	return false;
	return;
}

simulated function bool IsHumanControlled()
{
	return false;
	return;
}

simulated function bool HasBeenReportedToTOC()
{
	return bHasBeenReportedToTOC;
	return;
}

simulated function ToggleDebugPathLines()
{
	bDebugPathLines = Not_PreBool(bDebugPathLines);
	return;
}

latent function LatentAITriggerEffectEvent(name EffectEvent, optional Actor Other, optional Material TargetMaterial, optional Vector HitLocation, optional Rotator HitNormal, optional bool PlayOnOther, optional bool MoveMouth)
{
	local float MaxTime;

	if(logTyrion)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(Name), " triggering effect event "), string(EffectEvent)), " Tag is: "), string(Tag)), " Time is: "), string(Level.TimeSeconds)));
	}
	if(Not_PreBool(TriggerEffectEvent(EffectEvent,,,,,, true)))
	{
		return;
	}
	LatentSound = none;
	bEffectEventStillPlaying = true;
	AITriggerEffectEvent(EffectEvent, Other, TargetMaterial, HitLocation, HitNormal, PlayOnOther, Tag, MoveMouth, Rand(10000));
	MaxTime = Add_FloatFloat(Level.TimeSeconds, 10.0000000);
	J0xE7:

	if(AndAnd_BoolBool(bEffectEventStillPlaying, Greater_FloatFloat(MaxTime, Level.TimeSeconds)))
	{
		Sleep(0.0300000);
		// [Loop Continue]
		goto J0xE7;
	}
	return;
}

simulated function AITriggerEffectEvent(name EffectEvent, optional Actor Other, optional Material TargetMaterial, optional Vector HitLocation, optional Rotator HitNormal, optional bool PlayOnOther, optional name ReferenceTag, optional bool MoveMouth, optional int Seed)
{
	local Controller i, theLocalPlayerController;
	local SwatGamePlayerController Current;

	MoveMouthDuringEffect = MoveMouth;
	CurrentEffectEventName = EffectEvent;
	CurrentSeed = Seed;
	SetSeedForNextEffectEvent(CurrentSeed);
	TriggerEffectEvent(EffectEvent, Other, TargetMaterial, HitLocation, HitNormal, PlayOnOther, false, self, ReferenceTag);
	if(AndAnd_BoolBool(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)), NotEqual_IntInt(int(Level.NetMode), int(NM_Client))))
	{
		theLocalPlayerController = Level.GetLocalPlayerController();
		i = Level.ControllerList;
		J0xB7:

		if(NotEqual_ObjectObject(i, none))
		{
			Current = SwatGamePlayerController(i);
			if(AndAnd_BoolBool(NotEqual_ObjectObject(Current, none), NotEqual_ObjectObject(Current, theLocalPlayerController)))
			{
				Current.ClientAITriggerEffectEvent(self, UniqueID(), string(EffectEvent), Other, TargetMaterial, HitLocation, HitNormal, PlayOnOther, string(ReferenceTag), MoveMouth, CurrentSeed);
			}
			i = i.nextController;
			// [Loop Continue]
			goto J0xB7;
		}
	}
	return;
}

simulated function name GetPlayerTag()
{
	return Tag;
	return;
}

function ServerOnEffectStopped(string EffectName, int Seed)
{
	if(AndAnd_BoolBool(EqualEqual_NameName(string(EffectName), CurrentEffectEventName), EqualEqual_IntInt(Seed, CurrentSeed)))
	{
		bEffectEventStillPlaying = false;
	}
	RestartInterruptedActionSpeech(string(EffectName));
	return;
}

function RestartInterruptedActionSpeech(name PreviousEffectEvent)
{
	if(NotEqual_NameName(PreviousEffectEvent, 'ReactedTaser'))
	{
		RestartStunnedActionSpeech(AI_Resource(CharacterAI).findGoalByName("Tased"));
	}
	if(AndAnd_BoolBool(NotEqual_NameName(PreviousEffectEvent, 'ReactedSting'), NotEqual_NameName(PreviousEffectEvent, 'ReactedBeanBag')))
	{
		RestartStunnedActionSpeech(AI_Resource(CharacterAI).findGoalByName("Stung"));
	}
	if(NotEqual_NameName(PreviousEffectEvent, 'ReactedGas'))
	{
		RestartStunnedActionSpeech(AI_Resource(CharacterAI).findGoalByName("Gassed"));
	}
	if(NotEqual_NameName(PreviousEffectEvent, 'ReactedPepper'))
	{
		RestartStunnedActionSpeech(AI_Resource(CharacterAI).findGoalByName("PepperSprayed"));
	}
	if(NotEqual_NameName(PreviousEffectEvent, 'ReactedBang'))
	{
		RestartStunnedActionSpeech(AI_Resource(CharacterAI).findGoalByName("Flashbanged"));
	}
	if(NotEqual_NameName(PreviousEffectEvent, 'ReactedBreach'))
	{
		RestartStunnedActionSpeech(AI_Resource(CharacterAI).findGoalByName("StunnedByC2"));
	}
	return;
}

function RestartStunnedActionSpeech(AI_Goal Goal)
{
	if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(Goal, none), NotEqual_ObjectObject(Goal.achievingAction, none)), NotEqual_ObjectObject(StunnedAction(Goal.achievingAction), none)))
	{
		StunnedAction(Goal.achievingAction).TriggerStunnedSpeech();
	}
	return;
}

simulated function OnEffectInitialized(Actor inInitializedEffect)
{
	LatentSound = SoundInstance(inInitializedEffect);
	AssertWithDescription(NotEqual_ObjectObject(LatentSound, none), Concat_StrStr(Concat_StrStr("[tcohen] SwatAI::OnEffectInitialized() an effect was created, but it was not a sound.  ", "SwatAI only expects to get an OnEffectInitialized() call for a sound played "), "in response to a LatentAITriggerEffectEvent() call."));
	return;
}

simulated function OnEffectStarted(Actor inStartedEffect)
{
	if(MoveMouthDuringEffect)
	{
		StartMouthMovement();
	}
	return;
}

simulated function OnEffectStopped(Actor inStoppedEffect, bool Completed)
{
	local SoundInstance StoppedSoundInstance;

	StoppedSoundInstance = SoundInstance(inStoppedEffect);
	if(EqualEqual_ObjectObject(StoppedSoundInstance, LatentSound))
	{
		StopMouthMovement();
		if(NotEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer)))
		{
			SwatGamePlayerController(Level.GetLocalPlayerController()).ServerOnEffectStopped(self, UniqueID(), string(CurrentEffectEventName), CurrentSeed);
		}
	}
	return;
}

simulated function bool CanBeUsedNow()
{
	return AndAnd_BoolBool(Not_PreBool(bHasBeenReportedToTOC), OrOr_BoolBool(Not_PreBool(Class.static.checkConscious(self)), IsArrested()));
	return;
}

simulated function OnUsed(Pawn Other)
{
	assert(Not_PreBool(bHasBeenReportedToTOC));
	SwatGameInfo(Level.Game).GameEvents.ReportableReportedToTOC.Triggered(self, Other);
	return;
}

simulated function PostUsed()
{
	bHasBeenReportedToTOC = true;
	return;
}

simulated function string UniqueID()
{
	return string(SpawnedFromName);
	return;
}

final simulated function name GetEffectEventForReportingToTOC()
{
	if(IsDead())
	{
		return GetEffectEventForReportingToTOCWhenDead();
	}
	else
	{
		if(IsIncapacitated())
		{
			return GetEffectEventForReportingToTOCWhenIncapacitated();
		}
		else
		{
			if(IsArrested())
			{
				return GetEffectEventForReportingToTOCWhenArrested();
			}
			else
			{
				return 'None';
			}
		}
	}
	return;
}

final simulated function name GetEffectEventForReportResponseFromTOC()
{
	if(IsIncapacitated())
	{
		return GetEffectEventForReportResponseFromTOCWhenIncapacitated();
	}
	else
	{
		return GetEffectEventForReportResponseFromTOCWhenNotIncapacitated();
	}
	return;
}

simulated function name GetEffectEventForReportingToTOCWhenDead()
{
	return 'None';
	return;
}

simulated function name GetEffectEventForReportingToTOCWhenIncapacitated()
{
	return 'None';
	return;
}

simulated function name GetEffectEventForReportingToTOCWhenArrested()
{
	return 'None';
	return;
}

simulated function name GetEffectEventForReportResponseFromTOCWhenIncapacitated()
{
	return 'None';
	return;
}

simulated function name GetEffectEventForReportResponseFromTOCWhenNotIncapacitated()
{
	return 'None';
	return;
}

defaultproperties
{
	EyeBoneName="eye_R"
	PlayerBlockingPathStartTime=-1.0000000
	ShoulderOffset=(X=0.0000000,Y=15.0000000,Z=42.0000000)
	AnimFlags[2]=0
	AnimRotationUrgency=1
	AnimAimRotationUrgency=1
	PeripheralVision=0.5000000
	ControllerClassName="SwatGame.SwatAIController"
	Physics=1
	bRotateToDesired=false
	RotationRate=(Pitch=4096,Yaw=60000,Roll=3072)
}