class SwatHostage extends SwatAICharacter implements ISwatHostage, ICanBeSpawned
	native
	config(SwatPawn)
	hidecategories(Karma);

cpptext
{
    // Will return NULL if this actor has no cover plane, or should not be
    // used as cover. A valid poly's coordinates will be relative to the origin.
    virtual const FPoly * GetCoverPlanePoly() const;
    // If TRUE, the CoverPlane should be rotated about the Z axis as-needed
    virtual UBOOL CanCoverPlaneBillboard() const;
    // Returns TRUE if the cover plane cannot move
    virtual UBOOL IsCoverPlaneStatic() const;

	virtual UBOOL IsOtherActorAThreat(AActor* otherActor);

}

var private HostageSpawner SpawnedFrom;
var private ISwatHostage.HostageState CurrentState;
var private bool bSpawnedAsIncapacitated;

simulated function AnimationSetManager.EAnimationSet GetStandingWalkAnimSet()
{
	return 17;
	return;
}

simulated function AnimationSetManager.EAnimationSet GetStandingRunAnimSet()
{
	return 18;
	return;
}

simulated function AnimationSetManager.EAnimationSet GetCrouchingAnimSet()
{
	return 9;
	return;
}

protected function ConstructCharacterAI()
{
	local AI_Resource characterResource;

	characterResource = AI_Resource(CharacterAI);
	assert(NotEqual_ObjectObject(characterResource, none));
	characterResource.addAbility(Class'SwatAICommon.ComplianceAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.HostageCommanderAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.HostageSpeechManagerAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.FleeAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.HostageReactionToOfficersAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.CowerAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.RestrainedAction'.static.Allocate(self)., Construct_Void());
	super.ConstructCharacterAI();
	return;
}

event bool IgnoresSeenPawnsOfType(Class<Pawn> SeenType)
{
	return OrOr_BoolBool(OrOr_BoolBool(ClassIsChildOf(SeenType, Class'SwatGame.SwatHostage'), ClassIsChildOf(SeenType, Class'SwatGame.SwatTrainer')), ClassIsChildOf(SeenType, Class'SwatGame.SniperPawn'));
	return;
}

function InitializeFromSpawner(Spawner Spawner)
{
	local HostageSpawner HostageSpawner;

	super(SwatAI).InitializeFromSpawner(Spawner);
	if(EqualEqual_ObjectObject(Spawner, none))
	{
		return;
	}
	HostageSpawner = HostageSpawner(Spawner);
	assert(NotEqual_ObjectObject(HostageSpawner, none));
	SetIdleCategory(HostageSpawner.IdleCategoryOverride);
	SpawnedFrom = HostageSpawner;
	bSpawnedAsIncapacitated = HostageSpawner.SpawnIncapacitated;
	if(Not_PreBool(bSpawnedAsIncapacitated))
	{
		InitializePatrolling(HostageSpawner.HostagePatrol);
	}
	else
	{
		Health = Add_IntInt(Rand(int(IncapacitatedHealthAmount)), 1);
		BecomeIncapacitated(HostageSpawner.IdleCategoryOverride);
	}
	return;
}

function Spawner GetSpawner()
{
	return SpawnedFrom;
	return;
}

function bool WasHostageSpawnedIncapacitated()
{
	return bSpawnedAsIncapacitated;
	return;
}

function HostageCommanderAction GetHostageCommanderAction()
{
	return HostageCommanderAction(GetCommanderAction());
	return;
}

function HostageSpeechManagerAction GetHostageSpeechManagerAction()
{
	return HostageSpeechManagerAction(GetSpeechManagerAction());
	return;
}

function name SpawnedFromGroup()
{
	return GetSpawner().SpawnedFromGroup();
	return;
}

function ISwatHostage.HostageState GetCurrentState()
{
	return CurrentState;
	return;
}

function SetCurrentState(ISwatHostage.HostageState NewState)
{
	CurrentState = NewState;
	if(NotEqual_IntInt(int(CurrentState), int(0)))
	{
		SetIdleCategory('None');
	}
	return;
}

simulated function name GetEffectEventForReportingToTOCWhenDead()
{
	return 'ReportedHostageKilled';
	return;
}

simulated function name GetEffectEventForReportingToTOCWhenIncapacitated()
{
	return 'ReportedInjCivilianSecured';
	return;
}

simulated function name GetEffectEventForReportingToTOCWhenArrested()
{
	return 'ReportedCivilianSecured';
	return;
}

simulated function name GetEffectEventForReportResponseFromTOCWhenIncapacitated()
{
	return 'RepliedInjHostageReported';
	return;
}

simulated function name GetEffectEventForReportResponseFromTOCWhenNotIncapacitated()
{
	return 'RepliedHostageReported';
	return;
}

simulated function string GetHumanReadableName()
{
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		return "Hostage";
	}
	return super(Pawn).GetHumanReadableName();
	return;
}

defaultproperties
{
	RestrainedHandcuffsClassName="SwatEquipment.IAmCuffed"
	IncapacitatedHealthAmount=20.0000000
	PlayerBlockingPathTime=3.0000000
	PathReachabilityRenderedRecentlyDelta=5.0000000
	FBStandingReactionAnimations[0]="sReactionFB"
	FBStandingNoWeaponReactionAnimations[0]="sReactionFBnoWeapon"
	FBCrouchingReactionAnimations[0]="cReactionFB"
	FBCrouchingNoWeaponReactionAnimations[0]="cReactionFBNoWeapon"
	FBCompliantReactionAnimations[0]="complyReactionFB"
	FBRestrainedReactionAnimations[0]="cuffedReactionFB"
	FBStandingAffectedAnimations[0]="sLoopFB1"
	FBStandingAffectedAnimations[1]="sLoopFB2"
	FBStandingNoWeaponAffectedAnimations[0]="sLoopFB1noWeapon"
	FBStandingNoWeaponAffectedAnimations[1]="sLoopFB2noWeapon"
	FBCrouchingAffectedAnimations[0]="cLoopFB1"
	FBCrouchingAffectedAnimations[1]="cLoopFB2"
	FBCrouchingNoWeaponAffectedAnimations[0]="cLoopFB1NoWeapon"
	FBCrouchingNoWeaponAffectedAnimations[1]="cLoopFB2NoWeapon"
	FBCompliantAffectedAnimations[0]="complyLoopFB"
	FBRestrainedAffectedAnimations[0]="cuffedLoopFB"
	FBStandingRecoveryAnimations[0]="sRecoveryFB"
	FBStandingNoWeaponRecoveryAnimations[0]="sRecoveryFBnoWeapon"
	FBCrouchingRecoveryAnimations[0]="cRecoveryFB"
	FBCrouchingNoWeaponRecoveryAnimations[0]="cRecoveryFBNoWeapon"
	FBCompliantRecoveryAnimations[0]="complyRecoveryFB"
	FBRestrainedRecoveryAnimations[0]="cuffedRecoveryFB"
	GasStandingReactionAnimations[0]="sReactionGas"
	GasStandingNoWeaponReactionAnimations[0]="sReactionGasNoWeapon"
	GasCrouchingReactionAnimations[0]="cReactionGas"
	GasCrouchingNoWeaponReactionAnimations[0]="cReactionGasNoWeapon"
	GasCompliantReactionAnimations[0]="complyReactionGas"
	GasRestrainedReactionAnimations[0]="cuffedReactionGas"
	GasStandingAffectedAnimations[0]="sLoopGas1"
	GasStandingAffectedAnimations[1]="sLoopGas2"
	GasStandingNoWeaponAffectedAnimations[0]="sLoopGas1NoWeapon"
	GasStandingNoWeaponAffectedAnimations[1]="sLoopGas2NoWeapon"
	GasCrouchingAffectedAnimations[0]="cLoopGas1"
	GasCrouchingAffectedAnimations[1]="cLoopGas2"
	GasCrouchingNoWeaponAffectedAnimations[0]="cLoopGas1NoWeapon"
	GasCrouchingNoWeaponAffectedAnimations[1]="cLoopGas2NoWeapon"
	GasCompliantAffectedAnimations[0]="complyLoopGas1"
	GasRestrainedAffectedAnimations[0]="cuffedLoopGas"
	GasStandingRecoveryAnimations[0]="sRecoveryGas"
	GasStandingNoWeaponRecoveryAnimations[0]="sRecoveryGasNoWeapon"
	GasCrouchingRecoveryAnimations[0]="cRecoveryGas"
	GasCrouchingNoWeaponRecoveryAnimations[0]="cRecoveryGasNoWeapon"
	GasCompliantRecoveryAnimations[0]="complyRecoveryGas"
	GasRestrainedRecoveryAnimations[0]="cuffedRecoveryGas"
	TasedStandingReactionAnimations[0]="sTaserReaction"
	TasedCrouchingReactionAnimations[0]="cTaserReaction"
	TasedCompliantReactionAnimations[0]="complyReactionTaser"
	TasedRestrainedReactionAnimations[0]="cuffedReactionTaser"
	TasedStandingAffectedAnimations[0]="sTaserLoop"
	TasedCrouchingAffectedAnimations[0]="cTaserLoop"
	TasedCompliantAffectedAnimations[0]="complyLoopTaser"
	TasedRestrainedAffectedAnimations[0]="cuffedLoopTaser"
	TasedStandingRecoveryAnimations[0]="sTaserRecovery"
	TasedCrouchingRecoveryAnimations[0]="cTaserRecovery"
	TasedCompliantRecoveryAnimations[0]="complyRecoveryTaser"
	TasedRestrainedRecoveryAnimations[0]="cuffedRecoveryTaser"
	StungStandingReactionAnimations[0]="sReactionFB"
	StungStandingNoWeaponReactionAnimations[0]="sReactionFBnoWeapon"
	StungCrouchingReactionAnimations[0]="cReactionFB"
	StungCrouchingNoWeaponReactionAnimations[0]="cReactionFBNoWeapon"
	StungCompliantReactionAnimations[0]="complyReactionFB"
	StungRestrainedReactionAnimations[0]="cuffedReactionFB"
	StungStandingAffectedAnimations[0]="sLoopStunned"
	StungStandingNoWeaponAffectedAnimations[0]="sLoopStunned"
	StungCrouchingAffectedAnimations[0]="cLoopStunned"
	StungCrouchingNoWeaponAffectedAnimations[0]="cLoopStunned"
	StungCompliantAffectedAnimations[0]="ComplyLoopStunned"
	StungRestrainedAffectedAnimations[0]="cuffedLoopFB"
	StungStandingRecoveryAnimations[0]="sRecoveryFB"
	StungStandingNoWeaponRecoveryAnimations[0]="sRecoveryFBnoWeapon"
	StungCrouchingRecoveryAnimations[0]="cRecoveryFB"
	StungCrouchingNoWeaponRecoveryAnimations[0]="cRecoveryFBNoWeapon"
	StungCompliantRecoveryAnimations[0]="complyRecoveryFB"
	StungRestrainedRecoveryAnimations[0]="cuffedRecoveryFB"
	StandingFlinchAnimations[0]="sFlinch"
	StandingFlinchAnimations[1]="sFlinch2"
	StandingFlinchAnimations[2]="sFlinch3"
	StandingFlinchAnimations[3]="sFlinch4"
	StandingFlinchAnimations[4]="sFlinch5"
	CrouchingFlinchAnimations[0]="cFlinch"
	CrouchingFlinchAnimations[1]="cFlinch2"
	CrouchingFlinchAnimations[2]="cFlinch3"
	CrouchingFlinchAnimations[3]="cFlinch4"
	CrouchingFlinchAnimations[4]="cFlinch5"
	CompliantFlinchAnimations[0]="complyFlinch"
	CompliantFlinchAnimations[1]="ComplyFlinch2"
	CompliantFlinchAnimations[2]="ComplyFlinch3"
	CompliantFlinchAnimations[3]="ComplyFlinch4"
	CompliantFlinchAnimations[4]="ComplyFlinch5"
	RestrainedFlinchAnimations[0]="cuffedFlinch"
	RestrainedFlinchAnimations[1]="CuffedFlinch2"
	RestrainedFlinchAnimations[2]="CuffedFlinch3"
	RestrainedFlinchAnimations[3]="CuffedFlinch4"
	RestrainedFlinchAnimations[4]="CuffedFlinch5"
	UnderhandThrownProjectileInitialOffset=(X=36.0000000,Y=24.0000000,Z=-10.0000000)
	OverhandThrownProjectileInitialOffset=(X=47.0000000,Y=15.0000000,Z=49.0000000)
	ThrownProjectilePitch=15
	ThrowShortAnimation="sThrowShort"
	ThrowLongAnimation="sThrowLong"
	ThrowFromLeftAnimation="sGrenadeThrowLeft"
	ThrowFromRightAnimation="sGrenadeThrowRight"
	ThrowAnimationTweenTime=0.1000000
	MaxUnderhandThrowDistance=1024.0000000
	ZPositiveOffsetForOverhandThrow=96.0000000
	MinLastRenderedTimeDeltaForRelevency=5.0000000
	MinTimeBetweenFireHG=0.1000000
	MaxTimeBetweenFireHG=0.2000000
	MinTimeBetweenFireSMGSingleShot=0.1000000
	MaxTimeBetweenFireSMGSingleShot=0.2000000
	MinTimeBetweenFireSMGBurst=0.2000000
	MaxTimeBetweenFireSMGBurst=0.4000000
	MinTimeBetweenFireSMGFullAuto=0.5000000
	MaxTimeBetweenFireSMGFullAuto=0.7000000
	MinTimeBetweenFireMGSingleShot=0.1000000
	MaxTimeBetweenFireMGSingleShot=0.2000000
	MinTimeBetweenFireMGFullBurst=0.2000000
	MaxTimeBetweenFireMGFullBurst=0.4000000
	MinTimeBetweenFireMGFullAuto=0.5000000
	MaxTimeBetweenFireMGFullAuto=0.7000000
	MinTimeBetweenFireShotgun=0.3000000
	MaxTimeBetweenFireShotgun=0.6000000
	TurnAwayAnimationHG[0]="TurnAwayRight_HG"
	TurnAwayAnimationHG[1]="TurnAwayRightAlt1_HG"
	TurnAwayAnimationSG[0]="TurnAwayRight_SG"
	TurnAwayAnimationSG[1]="TurnAwayRightAlt1_SG"
	TurnAwayAnimationMG[0]="TurnAwayRight_M4"
	TurnAwayAnimationMG[1]="TurnAwayRightAlt1_M4"
	TurnAwayAnimationSMG[0]="TurnAwayRight_SMG"
	TurnAwayAnimationSMG[1]="TurnAwayRightAlt1_SMG"
	TurnAwayAnimationPB[0]="TurnAwayRight_PB"
	LimbTwitchTime=3.0000000
	LimbIdleTime=8.0000000
	TwitchInfos[0]=(BoneName="Bip01_Head",ForceMagnitude=(Min=-3000.0000000,Max=3000.0000000),ForceVector=(X=0.0000000,Y=0.0000000,Z=0.0000000),TargetBoneName="Bip01_Spine",TargetForceNormal=(X=0.0000000,Y=0.0000000,Z=0.0000000),TwitchType=0)
	TwitchInfos[1]=(BoneName="Bip01_Spine2",ForceMagnitude=(Min=-120.0000000,Max=1200.0000000),ForceVector=(X=0.0000000,Y=0.0000000,Z=0.0000000),TargetBoneName="Bip01_Spine",TargetForceNormal=(X=0.0000000,Y=0.0000000,Z=0.0000000),TwitchType=2)
	RenderTimeout=1.5000000
	InitialRagdollRenderTimeout=3.0000000
	AnimBoneBase="bip01"
	AnimBoneSpineLow="Bip01_Spine1"
	AnimBoneRightShoulder="Bip01_R_UpperArm"
	AnimBoneHead="Bip01_Head"
	AnimBoneJaw="Bone03jaw"
	NormalAimLocationBone="Bip01_Spine2"
	LeanAimLocationBone="Bip01_Head"
	NormalFireLocationBone="Bip01_Spine2"
	LeanFireLocationBone="Bip01_Head"
	AnimSocketGripRhand="GripRHand"
	AnimSocketGripBack="GripBack"
	AnimSocketGripHolster="GripHolster"
	AnimSocketGripBelt1="GripBelt1"
	AnimSocketGripBelt2="GripBelt2"
	AnimSocketHolster="Holster"
	AnimSocketPouch="Pouch"
	AnimSocketHeadGear="HeadGear"
	MaleAnimGroups[0]="SWATMaleAnimation.SWATaimPoses"
	MaleAnimGroups[1]="SWATMaleAnimation.SWAThostage"
	MaleAnimGroups[2]="SWATMaleAnimation.SWATmovement"
	MaleAnimGroups[3]="SWATMaleAnimation.SWATinjuries"
	MaleAnimGroups[4]="SWATMaleAnimation.SWATfidgets"
	MaleAnimGroups[5]="SWATMaleAnimation.SWATaction"
	FemaleAnimGroups[0]="FemaleAnimation.FEMALEaimPoses"
	FemaleAnimGroups[1]="FemaleAnimation.FEMALEhostage"
	FemaleAnimGroups[2]="FemaleAnimation.FEMALEmovement"
	FemaleAnimGroups[3]="FemaleAnimation.FEMALEinjuries"
	FemaleAnimGroups[4]="FemaleAnimation.FEMALEfidgets"
	FemaleAnimGroups[5]="FemaleAnimation.FEMALEaction"
	PercentageHealthForIntenseInjury=0.5000000
	MaxComplianceIssueDistance=2000.0000000
	QualifyTimeForArrest=3.0000000
	RelevancyPropogationDistance=800.0000000
	RelevancyLOSDistance=160.0000000
	GroundSpeed=150.0000000
	BaseEyeHeight=48.0000000
	CrouchEyeHeight=35.0000000
	CrouchHeight=52.0000000
	Bob=0.0020000
}