class SwatOfficer extends SwatAI implements ISwatOfficer, IControllableThroughViewport, ICanBePepperSprayed, IReactToCSGas, ICanUseC2Charge
	native
	config(SwatPawn)
	hidecategories(Karma);

cpptext
{
	virtual UBOOL IsOtherActorAThreat(AActor* otherActor);
	UOfficerCommanderAction* GetOfficerCommanderAction() { check(Commander); check(Commander->achievingAction); return Cast<UOfficerCommanderAction>(Commander->achievingAction); }

    // Provides some extra checks for actor-to-pawn collision
    // Overridden from APawn.h. If the other actor is also a SwatOfficer, they
    // should not collide.
    virtual bool WillCollide(const AActor * otherActor, const FVector & otherActorTestLocation) const
    {
        if (otherActor->IsA(ASwatOfficer::StaticClass()))
        {
            return false;
        }

        return Super::WillCollide(otherActor, otherActorTestLocation);
    }

}

const kMinNotifyStoppedMovingTime = 0.75;
const kMaxNotifyStoppedMovingTime = 1.25;

var private string OfficerLoadOutType;
var private OfficerLoadOut LoadOut;
var private Formation CurrentFormation;
var private SwatDoor DoorToBlowC2On;
var private config float MinTimeToFireFullAuto;
var private config float MaxTimeToFireFullAuto;
var private config Material ViewportOverlayMaterial;
var private float NextTimeCanReactToHarmlessShotByPlayer;
var private config float DeltaReactionTimeBetweenHarmlessShot;
var Timer NotifyStoppedMovingTimer;

event PreBeginPlay()
{
	super.PreBeginPlay();
	AddToSquads();
	InitLoadOut(OfficerLoadOutType);
	return;
}

event PostBeginPlay()
{
	super.PostBeginPlay();
	SwatAIRepository(Level.AIRepo).GetHive().NotifyOfficerConstructed(self);
	UpdateOfficerLOD();
	NotifyStoppedMovingTimer = Spawn(Class'Engine.Timer');
	assert(NotEqual_ObjectObject(NotifyStoppedMovingTimer, none));
	NotifyStoppedMovingTimer.__TimerDelegate__Delegate = NotifyStoppedMovingTimerCallback;
	return;
}

event Destroyed()
{
	Warn(Concat_StrStr(Concat_StrStr("Officer ", string(Name)), " was destroyed!"));
	SwatAIRepository(Level.AIRepo).GetHive().NotifyOfficerDestroyed(self);
	RemoveFromSquads();
	if(NotEqual_ObjectObject(NotifyStoppedMovingTimer, none))
	{
		NotifyStoppedMovingTimer.Destroy();
		NotifyStoppedMovingTimer = none;
	}
	super.Destroyed();
	return;
}

function EnteredZone(ZoneInfo Zone)
{
	super(Pawn).EnteredZone(Zone);
	if(IsConscious())
	{
		SetDesiredFlashlightState(Zone.bUseFlashlight);
	}
	return;
}

protected function AddToSquads()
{
	assert(false);
	return;
}

protected function RemoveFromSquads()
{
	assert(false);
	return;
}

function UpdateOfficerLOD()
{
	local int i;
	local SimpleEquipment se;

	i = int(18);
	J0x0A:

	if(LessEqual_IntInt(i, int(22)))
	{
		se = SimpleEquipment(LoadOut.GetItemAtPocket(byte(i)));
		AssertWithDescription(NotEqual_ObjectObject(se, none), Concat_StrStr(Concat_StrStr("Item at pocket ", string(GetEnum(Enum'Engine.HandheldEquipment.Pocket', i))), " is None or not SimpleEquipment"));
		if(EqualEqual_IntInt(int(Level.DetailMode), int(0)))
		{
			se.bHidden = true;
			se.CullDistance = 1.0000000;
			// [Explicit Continue]
			goto J0x136;
		}
		if(EqualEqual_IntInt(int(Level.DetailMode), int(1)))
		{
			se.bHidden = false;
			se.CullDistance = 875.0000000;
			// [Explicit Continue]
			goto J0x136;
		}
		se.bHidden = false;
		se.CullDistance = 0.0000000;
		J0x136:

		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x0A;
	}
	return;
}

protected function ConstructCharacterAI()
{
	local AI_Resource characterResource;

	characterResource = AI_Resource(CharacterAI);
	assert(NotEqual_ObjectObject(characterResource, none));
	characterResource.addAbility(Class'SwatAICommon.OfficerCommanderAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.OfficerSpeechManagerAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.StackedUpAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.RemoveWedgeAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.PlaceWedgeAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.PickLockAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.TryDoorAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.StackUpAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.MoveAndClearAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.FallInAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.ThrowGrenadeAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.UseBreachingChargeAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.UseBreachingShotgunAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.EngageForComplianceAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.AttackEnemyAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.RestrainAndReportAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.SecureEvidenceAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.DeployTaserAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.DeployLessLethalShotgunAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.DeployPepperBallAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.DeployPepperSprayAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.DisableTargetAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.CoverAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.GuardAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.WatchNonHostileTargetAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.MirrorDoorAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.MirrorCornerAction'.static.Allocate(self)., Construct_Void());
	super.ConstructCharacterAI();
	return;
}

protected function ConstructMovementAI()
{
	local AI_Resource movementResource;

	movementResource = AI_Resource(MovementAI);
	assert(NotEqual_ObjectObject(movementResource, none));
	movementResource.addAbility(Class'SwatAICommon.MoveInFormationAction'.static.Allocate(self)., Construct_Void());
	movementResource.addAbility(Class'SwatAICommon.MoveOfficerToEngageAction'.static.Allocate(self)., Construct_Void());
	super.ConstructMovementAI();
	return;
}

protected function ConstructWeaponAI()
{
	local AI_Resource weaponResource;

	weaponResource = AI_Resource(WeaponAI);
	assert(NotEqual_ObjectObject(weaponResource, none));
	weaponResource.addAbility(Class'SwatAICommon.UseOptiwandAction'.static.Allocate(self)., Construct_Void());
	weaponResource.addAbility(Class'SwatAICommon.UseGrenadeAction'.static.Allocate(self)., Construct_Void());
	weaponResource.addAbility(Class'SwatAICommon.OrderComplianceAction'.static.Allocate(self)., Construct_Void());
	weaponResource.addAbility(Class'SwatAICommon.ReloadAction'.static.Allocate(self)., Construct_Void());
	super.ConstructWeaponAI();
	return;
}

event Pawn GetCurrentAssignment()
{
	return GetOfficerCommanderAction().GetCurrentAssignment();
	return;
}

function bool IsAttackingPlayer()
{
	local Pawn CurrentAssignment;

	CurrentAssignment = GetCurrentAssignment();
	return AndAnd_BoolBool(NotEqual_ObjectObject(CurrentAssignment, none), CurrentAssignment.IsA('SwatPlayer'));
	return;
}

function NotifyHit(float Damage, Pawn HitInstigator)
{
	local SwatPlayer PlayerInstigator;
	local bool IsHitByPlayer;

	IsHitByPlayer = OrOr_BoolBool(HitInstigator.IsA('SwatPlayer'), HitInstigator.IsA('SniperPawn'));
	if(IsHitByPlayer)
	{
		PlayerInstigator = SwatPlayer(Level.GetLocalPlayerController().Pawn);
	}
	if(AndAnd_BoolBool(NotEqual_ObjectObject(PlayerInstigator, none), Not_PreBool(IsIncapacitated())))
	{
		if(Not_PreBool(Controller.bGodMode))
		{
			SwatAIRepository(Level.AIRepo).GetHive().NotifyOfficerShotByPlayer(self, Damage, PlayerInstigator);
		}
	}
	return;
}

function NotifyBecameIncapacitated(Pawn Incapacitator)
{
	local FiredWeapon CurrentWeapon;

	if(AndAnd_BoolBool(NotEqual_ObjectObject(Incapacitator, none), Incapacitator.IsA('SwatEnemy')))
	{
		SwatEnemy(Incapacitator).GetEnemyCommanderAction().NotifyKilledOfficer(self);
	}
	RemoveFromSquads();
	SwatAIRepository(Level.AIRepo).GetHive().NotifyOfficerDied(self);
	CurrentWeapon = FiredWeapon(GetActiveItem());
	if(AndAnd_BoolBool(NotEqual_ObjectObject(CurrentWeapon, none), CurrentWeapon.IsFlashlightOn()))
	{
		Log(Concat_StrStr(Concat_StrStr("Officer ", string(Name)), " became incapacitated; turning flashlight off after delay"));
		SetDesiredFlashlightState(false);
	}
	return;
}

function bool ShouldBecomeIncapacitated()
{
	return LessEqual_FloatFloat(float(Health), GetIncapacitatedDamageAmount());
	return;
}

event NotifyStartedMoving()
{
	super.NotifyStartedMoving();
	if(NotEqual_ObjectObject(NotifyStoppedMovingTimer, none))
	{
		NotifyStoppedMovingTimer.StopTimer();
	}
	SetUpperBodyAnimBehavior(1, 8);
	return;
}

event NotifyStoppedMoving()
{
	super.NotifyStoppedMoving();
	AnimSnapBaseToAim();
	if(NotEqual_ObjectObject(NotifyStoppedMovingTimer, none))
	{
		NotifyStoppedMovingTimer.StartTimer(RandRange(0.7500000, 1.2500000));
	}
	else
	{
		NotifyStoppedMovingTimerCallback();
	}
	return;
}

simulated function NotifyStoppedMovingTimerCallback()
{
	UnsetUpperBodyAnimBehavior(8);
	return;
}

function Actor GetViewportOwner()
{
	return self;
	return;
}

function OffsetViewportRotation(out Rotator ViewportRotation)
{
	return;
}

simulated function AdjustMouseAcceleration(out Vector MouseAccel)
{
	return;
}

function OnMouseAccelerated(out Vector MouseAccel)
{
	return;
}

function string GetViewportType()
{
	return string(Name);
	return;
}

function string GetViewportDescription()
{
	return "";
	return;
}

function string GetViewportName()
{
	return GetHumanReadableName();
	return;
}

simulated function bool CanIssueCommands()
{
	return true;
	return;
}

function OnBeginControlling()
{
	LockAim();
	return;
}

function OnEndControlling()
{
	UnlockAim();
	return;
}

function Vector GetViewportLocation()
{
	return GetViewPoint();
	return;
}

function Rotator GetViewportDirection()
{
	return Rotator(GetViewDirection());
	return;
}

function float GetViewportPitchClamp()
{
	return 55.0000000;
	return;
}

function float GetViewportYawClamp()
{
	return 0.0000000;
	return;
}

function SetRotationToViewport(Rotator inNewRotation)
{
	AimToRotation(inNewRotation);
	return;
}

function bool ShouldDrawViewport()
{
	return AndAnd_BoolBool(Not_PreBool(checkDead(self)), Not_PreBool(IsIncapacitated()));
	return;
}

function Material GetViewportOverlay()
{
	return ViewportOverlayMaterial;
	return;
}

function Rotator GetOriginalDirection()
{
	return Rotation;
	return;
}

function float GetViewportPitchSpeed()
{
	return 0.6000000;
	return;
}

function float GetViewportYawSpeed()
{
	return 0.6000000;
	return;
}

function bool ShouldDrawReticle()
{
	return true;
	return;
}

simulated function float GetFOV()
{
	return;
}

simulated function HandleFire()
{
	return;
}

simulated function HandleAltFire()
{
	return;
}

simulated function HandleReload()
{
	return;
}

function PlayTurnAwayAnimation()
{
	local name TurnAwayAnimation;

	TurnAwayAnimation = GetTurnAwayAnimation();
	if(NotEqual_NameName(TurnAwayAnimation, 'None'))
	{
		AnimPlaySpecial(TurnAwayAnimation, 0.1000000, GetUpperBodyBone());
	}
	return;
}

private function InitLoadOut(string LoadOutName)
{
	local DynamicLoadOutSpec LoadOutSpec;
	local CustomScenario CustomScen;

	LoadOut = Spawn(Class'SwatGame.OfficerLoadOut', self, string(Concat_StrStr("Default", LoadOutName)));
	assert(NotEqual_ObjectObject(LoadOut, none));
	if(Level.IsTraining)
	{
		LoadOutSpec = Spawn(Class'SwatGame.DynamicLoadOutSpec', self, string(Concat_StrStr("Default", LoadOutName)));
	}
	else
	{
		CustomScen = SwatRepo(Level.GetRepo()).GuiConfig.CurrentMission.CustomScenario;
		if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(CustomScen, none), self.IsA('OfficerRedOne')), NotEqual_NameName(CustomScen.RedOneLoadOut, 'Any')))
		{
			LoadOutSpec = Spawn(Class'SwatGame.DynamicLoadOutSpec', self, CustomScen.RedOneLoadOut);
		}
		else
		{
			if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(CustomScen, none), self.IsA('OfficerRedTwo')), NotEqual_NameName(CustomScen.RedTwoLoadOut, 'Any')))
			{
				LoadOutSpec = Spawn(Class'SwatGame.DynamicLoadOutSpec', self, CustomScen.RedTwoLoadOut);
			}
			else
			{
				if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(CustomScen, none), self.IsA('OfficerBlueOne')), NotEqual_NameName(CustomScen.BlueOneLoadOut, 'Any')))
				{
					LoadOutSpec = Spawn(Class'SwatGame.DynamicLoadOutSpec', self, CustomScen.BlueOneLoadOut);
				}
				else
				{
					if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(CustomScen, none), self.IsA('OfficerBlueTwo')), NotEqual_NameName(CustomScen.BlueTwoLoadOut, 'Any')))
					{
						LoadOutSpec = Spawn(Class'SwatGame.DynamicLoadOutSpec', self, CustomScen.BlueTwoLoadOut);
					}
					else
					{
						LoadOutSpec = Spawn(Class'SwatGame.DynamicLoadOutSpec', self, string(Concat_StrStr("Current", LoadOutName)));
					}
				}
			}
		}
	}
	assert(NotEqual_ObjectObject(LoadOutSpec, none));
	LoadOut.Initialize(LoadOutSpec);
	ReceiveLoadOut();
	return;
}

private function ReceiveLoadOut()
{
	assert(NotEqual_ObjectObject(LoadOut, none));
	Log(Concat_StrStr("------LoadOut.Owner=", string(LoadOut.Owner)));
	Skins[0] = LoadOut.GetPantsMaterial();
	Skins[1] = LoadOut.GetFaceMaterial();
	Skins[2] = LoadOut.GetNameMaterial();
	Skins[3] = LoadOut.GetVestMaterial();
	if(NotEqual_ObjectObject(LoadOut.GetPrimaryWeapon(), none))
	{
		LoadOut.GetPrimaryWeapon().Equip();
	}
	else
	{
		if(NotEqual_ObjectObject(LoadOut.GetBackupWeapon(), none))
		{
			LoadOut.GetBackupWeapon().Equip();
		}
		else
		{
			Warn("An AI Officer has no Weapon (no weapon was specified in his LoadOut).");
		}
	}
	ChangeAnimation();
	return;
}

simulated function DestroyEquipment()
{
	LoadOut.Destroy();
	return;
}

function AwarenessProxy GetAwareness()
{
	return SwatAIRepository(Level.AIRepo).GetHive().GetAwareness();
	return;
}

function DisableAwareness()
{
	SwatAIRepository(Level.AIRepo).GetHive().DisableAwareness();
	return;
}

function EnableAwareness()
{
	SwatAIRepository(Level.AIRepo).GetHive().EnableAwareness();
	return;
}

event bool IgnoresSeenPawnsOfType(Class<Pawn> SeenType)
{
	return OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(ClassIsChildOf(SeenType, Class'SwatGame.SwatOfficer'), ClassIsChildOf(SeenType, Class'SwatGame.SwatPlayer')), ClassIsChildOf(SeenType, Class'SwatGame.SwatTrainer')), ClassIsChildOf(SeenType, Class'SwatGame.SniperPawn'));
	return;
}

function Formation GetCurrentFormation()
{
	return CurrentFormation;
	return;
}

function SetCurrentFormation(Formation Formation)
{
	assert(NotEqual_ObjectObject(Formation, none));
	ClearFormation();
	CurrentFormation = Formation;
	CurrentFormation.AddRef();
	return;
}

function ClearFormation()
{
	if(NotEqual_ObjectObject(CurrentFormation, none))
	{
		CurrentFormation.Release();
		CurrentFormation = none;
	}
	return;
}

function bool ShouldPlayFullBodyHitAnimation()
{
	return false;
	return;
}

protected function bool CanPawnUseLowReady()
{
	local StaircaseAimPoint StaircaseAimPoint;

	StaircaseAimPoint = StaircaseAimPoint(AnimAimActor);
	return EqualEqual_ObjectObject(StaircaseAimPoint, none);
	return;
}

simulated function AnimationSetManager.EAnimationSet GetStandingInjuredAnimSet()
{
	return 15;
	return;
}

simulated function AnimationSetManager.EAnimationSet GetCrouchingInjuredAnimSet()
{
	return 16;
	return;
}

function ISwatAI.EUpperBodyAnimBehavior GetMovementUpperBodyAimBehavior()
{
	return 1;
	return;
}

function ThrownWeapon GetThrownWeapon(HandheldEquipment.EquipmentSlot Slot)
{
	return ThrownWeapon(GetItemAtSlot(Slot));
	return;
}

function HandheldEquipment GetItemAtSlot(HandheldEquipment.EquipmentSlot Slot)
{
	return LoadOut.GetItemAtSlot(Slot);
	return;
}

protected function float GetLengthOfTimeToFireFullAuto()
{
	return RandRange(MinTimeToFireFullAuto, MaxTimeToFireFullAuto);
	return;
}

function FiredWeapon GetPrimaryWeapon()
{
	return LoadOut.GetPrimaryWeapon();
	return;
}

function FiredWeapon GetBackupWeapon()
{
	return LoadOut.GetBackupWeapon();
	return;
}

function bool HasUsableWeapon()
{
	return OrOr_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(GetPrimaryWeapon(), none), Not_PreBool(GetPrimaryWeapon().IsEmpty())), AndAnd_BoolBool(NotEqual_ObjectObject(GetBackupWeapon(), none), Not_PreBool(GetBackupWeapon().IsEmpty())));
	return;
}

// Export USwatOfficer::execGetOfficerCommanderAction(FFrame&, void* const)
native function OfficerCommanderAction GetOfficerCommanderAction();

function OfficerSpeechManagerAction GetOfficerSpeechManagerAction()
{
	return OfficerSpeechManagerAction(GetSpeechManagerAction());
	return;
}

simulated function SetDeployedC2Charge(DeployedC2ChargeBase Charge)
{
	return;
}

simulated function DeployedC2ChargeBase GetDeployedC2Charge()
{
	if(NotEqual_ObjectObject(DoorToBlowC2On, none))
	{
		if(DoorToBlowC2On.PointIsToMyLeft(Location))
		{
			if(DoorToBlowC2On.IsChargePlacedOnLeft())
			{
				return DoorToBlowC2On.GetDeployedC2ChargeLeft();
			}
		}
		else
		{
			if(DoorToBlowC2On.IsChargePlacedOnRight())
			{
				return DoorToBlowC2On.GetDeployedC2ChargeRight();
			}
		}
	}
	return none;
	return;
}

latent function ReEquipFiredWeapon()
{
	local FiredWeapon PrimaryWeapon, BackupWeapon;

	if(IsConscious())
	{
		PrimaryWeapon = GetPrimaryWeapon();
		BackupWeapon = GetBackupWeapon();
		if(AndAnd_BoolBool(NotEqual_ObjectObject(PrimaryWeapon, none), Not_PreBool(PrimaryWeapon.IsEmpty())))
		{
			PrimaryWeapon.LatentEquip();
		}
		else
		{
			if(AndAnd_BoolBool(NotEqual_ObjectObject(BackupWeapon, none), Not_PreBool(BackupWeapon.IsEmpty())))
			{
				BackupWeapon.LatentEquip();
			}
		}
	}
	return;
}

function InstantReEquipFiredWeapon()
{
	local FiredWeapon PrimaryWeapon, BackupWeapon;

	if(IsConscious())
	{
		PrimaryWeapon = GetPrimaryWeapon();
		BackupWeapon = GetBackupWeapon();
		if(OrOr_BoolBool(OrOr_BoolBool(NotEqual_ObjectObject(GetActiveItem(), PrimaryWeapon), EqualEqual_ObjectObject(PrimaryWeapon, none)), PrimaryWeapon.IsEmpty()))
		{
			if(AndAnd_BoolBool(NotEqual_ObjectObject(PrimaryWeapon, none), Not_PreBool(PrimaryWeapon.IsEmpty())))
			{
				PrimaryWeapon.AIInstantEquip();
			}
			else
			{
				if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(GetActiveItem(), BackupWeapon), NotEqual_ObjectObject(BackupWeapon, none)), Not_PreBool(BackupWeapon.IsEmpty())))
				{
					BackupWeapon.AIInstantEquip();
				}
			}
		}
	}
	return;
}

function bool HasTaser()
{
	local HandheldEquipment Equipment;

	Equipment = GetItemAtSlot(2);
	if(NotEqual_ObjectObject(Equipment, none))
	{
		return Equipment.IsA('Taser');
	}
	return false;
	return;
}

function SetDoorToBlowC2On(Door TargetDoor)
{
	DoorToBlowC2On = SwatDoor(TargetDoor);
	return;
}

event PlayerBlockingPath()
{
	GetOfficerSpeechManagerAction().TriggerPlayerInTheWaySpeech();
	return;
}

simulated function name GetEffectEventForReportingToTOCWhenDead()
{
	AssertWithDescription(false, "Unexpected: reported a dead swat officer");
	return 'None';
	return;
}

simulated function name GetEffectEventForReportingToTOCWhenArrested()
{
	AssertWithDescription(false, "Unexpected: reported an arrested swat officer");
	return 'None';
	return;
}

simulated function name GetEffectEventForReportResponseFromTOCWhenIncapacitated()
{
	return 'RepliedOfficerDown';
	return;
}

simulated function name GetEffectEventForReportResponseFromTOCWhenNotIncapacitated()
{
	AssertWithDescription(false, "Unexpected: TOC responding to a non-incapacitated swat officer");
	return 'None';
	return;
}

private function TriggerHarmlessShotSpeech()
{
	if(Greater_FloatFloat(Level.TimeSeconds, NextTimeCanReactToHarmlessShotByPlayer))
	{
		NextTimeCanReactToHarmlessShotByPlayer = Add_FloatFloat(Level.TimeSeconds, DeltaReactionTimeBetweenHarmlessShot);
		GetOfficerSpeechManagerAction().TriggerReactedFirstShotSpeech();
	}
	return;
}

function ReactToCSGas(Actor GasContainer, float Duration, float SPPlayerProtectiveEquipmentDurationScaleFactor, float MPPlayerProtectiveEquipmentDurationScaleFactor)
{
	if(GasContainer.IsA('CSBallBase'))
	{
		TriggerHarmlessShotSpeech();
	}
	return;
}

function ReactToBeingPepperSprayed(Actor PepperSpray, float PlayerDuration, float AIDuration, float SPPlayerProtectiveEquipmentDurationScaleFactor, float MPPlayerProtectiveEquipmentDurationScaleFactor)
{
	TriggerHarmlessShotSpeech();
	return;
}

function DrawLineToAssignment(HUD DrawTarget)
{
	local Pawn Assignment;

	Assignment = GetOfficerCommanderAction().GetCurrentAssignment();
	if(NotEqual_ObjectObject(Assignment, none))
	{
		DrawTarget.Draw3DLine(Location, Assignment.Location, Class'Engine.Canvas'.static.MakeColor(byte(255), 0, 0));
	}
	return;
}

simulated function bool ReadyToTriggerEffectEvents()
{
	return HasEquippedFirstItemYet;
	return;
}

defaultproperties
{
	OfficerLoadOutType="OfficerLoadOut"
	bAlwaysTestPathReachability=true
	bAlwaysUseWalkAimErrorWhenMoving=true
}