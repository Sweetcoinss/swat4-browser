class SwatEnemy extends SwatAICharacter implements ISwatEnemy, ICanBeSpawned
	native
	config(SwatPawn)
	hidecategories(Karma);

var private ISwatEnemy.EnemySkill Skill;
var private bool bIsInvestigator;
var private ISwatEnemy.EnemyState CurrentState;
var private bool bThreat;
var private bool bIsSprinting;
var config float LowSkillAdditionalBaseAimError;
var config float MediumSkillAdditionalBaseAimError;
var config float HighSkillAdditionalBaseAimError;
var config float LowSkillMinTimeToFireFullAuto;
var config float LowSkillMaxTimeToFireFullAuto;
var config float MediumSkillMinTimeToFireFullAuto;
var config float MediumSkillMaxTimeToFireFullAuto;
var config float HighSkillMinTimeToFireFullAuto;
var config float HighSkillMaxTimeToFireFullAuto;
var config float MinDistanceToAffectMoraleOfOtherEnemiesUponDeath;
var config array<name> ThrowWeaponDownAnimationsHG;
var config array<name> ThrowWeaponDownAnimationsMG;
var config array<name> ThrowWeaponDownAnimationsSMG;
var config array<name> ThrowWeaponDownAnimationsSG;
var config float LowSkillFullBodyHitChance;
var config float MediumSkillFullBodyHitChance;
var config float HighSkillFullBodyHitChance;
var private FiredWeapon PrimaryWeapon;
var private FiredWeapon BackupWeapon;
var private EnemySpawner SpawnedFrom;
var Class<FiredWeapon> ReplicatedPrimaryWeaponClass;
var Class<Ammunition> ReplicatedPrimaryWeaponAmmoClass;
var Class<FiredWeapon> ReplicatedBackupWeaponClass;
var Class<Ammunition> ReplicatedBackupWeaponAmmoClass;
var string DroppedPrimaryWeaponModelUniqueID;
var string DroppedBackupWeaponModelUniqueID;

replication
{
	// Pos:0x000
	reliable if(EqualEqual_IntInt(int(Role), int(ROLE_Authority)))
		ReplicatedBackupWeaponAmmoClass, ReplicatedBackupWeaponClass,
		ReplicatedPrimaryWeaponAmmoClass, ReplicatedPrimaryWeaponClass;
}

simulated function bool IsPrimaryWeapon(HandheldEquipment theItem)
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(string(self), "---SwatEnemy::IsPrimaryWeapon(). theItem="), string(theItem)));
		MPLog(Concat_StrStr("...PrimaryWeapon=", string(PrimaryWeapon)));
	}
	return EqualEqual_ObjectObject(theItem, PrimaryWeapon);
	return;
}

simulated event ReplicatedPrimaryWeaponClassInfoOnChanged()
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SwatEnemy::ReplicatedPrimaryWeaponClassInfoOnChanged()."));
	}
	if(NotEqual_ObjectObject(PrimaryWeapon, none))
	{
		MPLog("...destroying previous");
		PrimaryWeapon.Destroy();
	}
	if(NotEqual_ObjectObject(ReplicatedPrimaryWeaponClass, none))
	{
		PrimaryWeapon = Spawn(ReplicatedPrimaryWeaponClass, self);
		if(NotEqual_ObjectObject(PrimaryWeapon, none))
		{
			PrimaryWeapon.AmmoClass = ReplicatedPrimaryWeaponAmmoClass;
			PrimaryWeapon.OnGivenToOwner();
		}
		if(NotEqual_ObjectObject(PrimaryWeapon, none))
		{
			PrimaryWeapon.Equip();
		}
	}
	return;
}

simulated event ReplicatedBackupWeaponClassInfoOnChanged()
{
	MPLog(Concat_StrStr(string(self), "---SwatEnemy::ReplicatedBackupWeaponClassInfoOnChanged()."));
	if(NotEqual_ObjectObject(BackupWeapon, none))
	{
		MPLog("...destroying previous");
		BackupWeapon.Destroy();
	}
	if(NotEqual_ObjectObject(ReplicatedBackupWeaponClass, none))
	{
		MPLog("...spawning");
		BackupWeapon = Spawn(ReplicatedBackupWeaponClass, self);
		if(NotEqual_ObjectObject(BackupWeapon, none))
		{
			MPLog("...calling OnGivenToOwner()");
			BackupWeapon.AmmoClass = ReplicatedBackupWeaponAmmoClass;
			BackupWeapon.OnGivenToOwner();
		}
		if(AndAnd_BoolBool(EqualEqual_IntInt(int(DesiredAIEquipment), int(2)), NotEqual_ObjectObject(BackupWeapon, none)))
		{
			MPLog("...caling Equip()");
			BackupWeapon.Equip();
		}
	}
	return;
}

simulated event OnDesiredAIEquipmentChanged()
{
	MPLog(Concat_StrStr(Concat_StrStr(string(self), "---SwatEnemy::OnDesiredAIEquipmentChanged(). NewValue="), string(DesiredAIEquipment)));
	if(EqualEqual_IntInt(int(DesiredAIEquipment), int(2)))
	{
		if(NotEqual_ObjectObject(BackupWeapon, none))
		{
			BackupWeapon.Equip();
		}
	}
	return;
}

simulated event Destroyed()
{
	super.Destroyed();
	return;
}

simulated function DestroyEquipment()
{
	MPLog(Concat_StrStr(string(self), "---SwatEnemy::DestroyEquipment()."));
	if(NotEqual_ObjectObject(PrimaryWeapon, none))
	{
		MPLog("...destroying primary weapon");
		PrimaryWeapon.Destroy();
	}
	if(NotEqual_ObjectObject(BackupWeapon, none))
	{
		MPLog("...destroying backup weapon");
		BackupWeapon.Destroy();
	}
	super.DestroyEquipment();
	return;
}

event bool IgnoresSeenPawnsOfType(Class<Pawn> SeenType)
{
	return OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(ClassIsChildOf(SeenType, Class'SwatGame.SwatEnemy'), ClassIsChildOf(SeenType, Class'SwatGame.SwatHostage')), ClassIsChildOf(SeenType, Class'SwatGame.SwatTrainer')), ClassIsChildOf(SeenType, Class'SwatGame.SniperPawn'));
	return;
}

function InitializeFromSpawner(Spawner Spawner)
{
	local EnemySpawner EnemySpawner;

	super(SwatAI).InitializeFromSpawner(Spawner);
	if(EqualEqual_ObjectObject(Spawner, none))
	{
		return;
	}
	EnemySpawner = EnemySpawner(Spawner);
	assert(NotEqual_ObjectObject(EnemySpawner, none));
	SetIdleCategory(EnemySpawner.IdleCategoryOverride);
	SpawnedFrom = EnemySpawner;
	InitializePatrolling(EnemySpawner.EnemyPatrol);
	InitializeInvestigationFromSpawner(EnemySpawner);
	return;
}

function InitializeFromArchetypeInstance()
{
	local EnemyArchetypeInstance Instance;

	super.InitializeFromArchetypeInstance();
	Instance = EnemyArchetypeInstance(ArchetypeInstance);
	assert(NotEqual_ObjectObject(Instance, none));
	InitializeWeapons(Instance);
	Skill = Instance.Skill;
	bIsInvestigator = Instance.InvestigatorOverride;
	return;
}

private function InitializeWeapons(EnemyArchetypeInstance Instance)
{
	PrimaryWeapon = Instance.PrimaryWeapon;
	BackupWeapon = Instance.BackupWeapon;
	ReplicatedPrimaryWeaponClass = Instance.SelectedPrimaryWeaponClass;
	ReplicatedPrimaryWeaponAmmoClass = Instance.SelectedPrimaryWeaponAmmoClass;
	ReplicatedBackupWeaponClass = Instance.SelectedBackupWeaponClass;
	ReplicatedBackupWeaponAmmoClass = Instance.SelectedBackupWeaponAmmoClass;
	if(NotEqual_ObjectObject(PrimaryWeapon, none))
	{
		PrimaryWeapon.Equip();
	}
	return;
}

private function InitializeInvestigationFromSpawner(EnemySpawner InEnemySpawner)
{
	assert(NotEqual_ObjectObject(InEnemySpawner, none));
	if(Not_PreBool(bIsInvestigator))
	{
		bIsInvestigator = InEnemySpawner.SpawnAnInvestigator;
	}
	return;
}

protected function ConstructCharacterAI()
{
	local AI_Resource characterResource;

	characterResource = AI_Resource(CharacterAI);
	assert(NotEqual_ObjectObject(characterResource, none));
	characterResource.addAbility(Class'SwatAICommon.EnemyCommanderAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.EnemySpeechManagerAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.BarricadeAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.InvestigateAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.RestrainedAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.TakeCoverAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.EnemyComplianceAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.EnemyCowerAction'.static.Allocate(self)., Construct_Void());
	ConstructCharacterAIHook(characterResource);
	super.ConstructCharacterAI();
	return;
}

protected function ConstructCharacterAIHook(AI_Resource characterResource)
{
	characterResource.addAbility(Class'SwatAICommon.AttackOfficerAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.TakeCoverAndAttackAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.FleeAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.ThreatenHostageAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.ConverseWithHostagesAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.RegroupAction'.static.Allocate(self)., Construct_Void());
	return;
}

protected function ConstructMovementAI()
{
	local AI_Resource movementResource;

	movementResource = AI_Resource(MovementAI);
	assert(NotEqual_ObjectObject(movementResource, none));
	super(SwatAI).ConstructMovementAI();
	movementResource.addAbility(Class'SwatAICommon.MoveToAttackOfficerAction'.static.Allocate(self)., Construct_Void());
	return;
}

protected function ConstructWeaponAI()
{
	local AI_Resource weaponResource;

	weaponResource = AI_Resource(WeaponAI);
	assert(NotEqual_ObjectObject(weaponResource, none));
	weaponResource.addAbility(Class'SwatAICommon.ReloadAction'.static.Allocate(self)., Construct_Void());
	super(SwatAI).ConstructWeaponAI();
	return;
}

function bool ShouldPlayFullBodyHitAnimation()
{
	local float Chance;

	switch(Skill)
	{
		case 2:
			Chance = HighSkillFullBodyHitChance;
			break;
		case 1:
			Chance = MediumSkillFullBodyHitChance;
			break;
		case 0:
			Chance = LowSkillFullBodyHitChance;
			break;
		default:
			break;
	}
	return Less_FloatFloat(FRand(), Chance);
	return;
}

simulated function AnimationSetManager.EAnimationSet GetStandingWalkAnimSet()
{
	local HandheldEquipment CurrentActiveItem;

	CurrentActiveItem = GetActiveItem();
	if(NotEqual_ObjectObject(CurrentActiveItem, none))
	{
		if(CurrentActiveItem.IsA('SubMachineGun'))
		{
			return 21;
		}
		else
		{
			if(CurrentActiveItem.IsA('MachineGun'))
			{
				return 22;
			}
			else
			{
				if(CurrentActiveItem.IsA('Shotgun'))
				{
					return 23;
				}
				else
				{
					return 20;
				}
			}
		}
	}
	else
	{
		return 38;
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetCrouchingAnimSet()
{
	return 9;
	return;
}

simulated function AnimationSetManager.EAnimationSet GetStandingRunAnimSet()
{
	if(bIsSprinting)
	{
		return GetSprintAnimSet();
	}
	else
	{
		return GetRunAnimSet();
	}
	return;
}

private simulated function AnimationSetManager.EAnimationSet GetRunAnimSet()
{
	local HandheldEquipment CurrentActiveItem;

	CurrentActiveItem = GetActiveItem();
	if(NotEqual_ObjectObject(CurrentActiveItem, none))
	{
		if(CurrentActiveItem.IsA('SubMachineGun'))
		{
			return 25;
		}
		else
		{
			if(CurrentActiveItem.IsA('MachineGun'))
			{
				return 26;
			}
			else
			{
				if(CurrentActiveItem.IsA('Shotgun'))
				{
					return 27;
				}
				else
				{
					return 24;
				}
			}
		}
	}
	else
	{
		return 28;
	}
	return;
}

private simulated function AnimationSetManager.EAnimationSet GetSprintAnimSet()
{
	local HandheldEquipment CurrentActiveItem;

	CurrentActiveItem = GetActiveItem();
	if(NotEqual_ObjectObject(CurrentActiveItem, none))
	{
		if(CurrentActiveItem.IsA('SubMachineGun'))
		{
			return 30;
		}
		else
		{
			if(CurrentActiveItem.IsA('MachineGun'))
			{
				return 31;
			}
			else
			{
				if(CurrentActiveItem.IsA('Shotgun'))
				{
					return 32;
				}
				else
				{
					return 29;
				}
			}
		}
	}
	else
	{
		return 28;
	}
	return;
}

function StartSprinting()
{
	bIsSprinting = true;
	return;
}

function StopSprinting()
{
	bIsSprinting = false;
	return;
}

simulated function AnimationSetManager.EAnimationSet GetMachineGunAimPoseSet()
{
	assert(NotEqual_NameName(CharacterType, 'None'));
	if(EqualEqual_NameName(CharacterType, 'EnemyMaleGang'))
	{
		return 102;
	}
	else
	{
		return 55;
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetUMPAimPoseSet()
{
	return GetSubMachineGunAimPoseSet();
	return;
}

simulated function AnimationSetManager.EAnimationSet GetUMPLowReadyAimPoseSet()
{
	return GetSubMachineGunLowReadyAimPoseSet();
	return;
}

simulated function NotifyReadyToRagdoll()
{
	MPLog(Concat_StrStr(string(self), "---SwatEnemy::NotifyReadyToRagdoll()."));
	super(SwatRagdollPawn).NotifyReadyToRagdoll();
	DropAllWeapons();
	return;
}

simulated function Died(Controller Killer, Class<DamageType> DamageType, Vector HitLocation, Vector HitMomentum)
{
	super.Died(Killer, DamageType, HitLocation, HitMomentum);
	if(NotEqual_ObjectObject(Killer, none))
	{
		NotifyNearbyEnemiesOfDeath(Killer.Pawn);
	}
	return;
}

simulated function NotifyNearbyEnemiesOfDeath(Pawn Killer)
{
	local Pawn Iter;

	Iter = Level.PawnList;
	J0x14:

	if(NotEqual_ObjectObject(Iter, none))
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(Iter, self), Iter.IsA('SwatEnemy')))
		{
			if(AndAnd_BoolBool(Less_FloatFloat(VSize2D(Subtract_VectorVector(Iter.Location, Location)), MinDistanceToAffectMoraleOfOtherEnemiesUponDeath), LineOfSightTo(Iter)))
			{
				SwatEnemy(Iter).GetEnemyCommanderAction().NotifyNearbyEnemyKilled(self, Killer);
			}
		}
		Iter = Iter.nextPawn;
		// [Loop Continue]
		goto J0x14;
	}
	return;
}

function bool IsAnInvestigator()
{
	return bIsInvestigator;
	return;
}

function ISwatEnemy.EnemyState GetCurrentState()
{
	return CurrentState;
	return;
}

function BecomeAware()
{
	SetCurrentState(2);
	return;
}

function SetCurrentState(ISwatEnemy.EnemyState NewState)
{
	CurrentState = NewState;
	if(NotEqual_IntInt(int(CurrentState), int(0)))
	{
		SetIdleCategory('None');
	}
	return;
}

function ISwatEnemy.EnemySkill GetEnemySkill()
{
	return Skill;
	return;
}

simulated function FiredWeapon GetPrimaryWeapon()
{
	return PrimaryWeapon;
	return;
}

simulated function FiredWeapon GetBackupWeapon()
{
	return BackupWeapon;
	return;
}

function bool HasUsableWeapon()
{
	return OrOr_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(GetPrimaryWeapon(), none), Not_PreBool(GetPrimaryWeapon().IsEmpty())), AndAnd_BoolBool(NotEqual_ObjectObject(GetBackupWeapon(), none), Not_PreBool(GetBackupWeapon().IsEmpty())));
	return;
}

function name SpawnedFromGroup()
{
	return GetSpawner().SpawnedFromGroup();
	return;
}

function EnemyCommanderAction GetEnemyCommanderAction()
{
	return EnemyCommanderAction(GetCommanderAction());
	return;
}

function EnemySpeechManagerAction GetEnemySpeechManagerAction()
{
	return EnemySpeechManagerAction(GetSpeechManagerAction());
	return;
}

final simulated function DropAllWeapons(optional Vector WeaponSpaceDropDirection, optional float DropImpulseMagnitude)
{
	local HandheldEquipment PrimaryWeapon, BackupWeapon;
	local HandheldEquipmentModel BackupWeaponModel;

	MPLog(Concat_StrStr(string(self), "---SwatEnemy::DropAllWeapons()."));
	if(Level.IsCOOPServer)
	{
		NotifyClientsToDropAllWeapons();
	}
	PrimaryWeapon = GetPrimaryWeapon();
	if(AndAnd_BoolBool(NotEqual_ObjectObject(PrimaryWeapon, none), PrimaryWeapon.IsA('FiredWeapon')))
	{
		DropWeapon(PrimaryWeapon, Multiply_VectorFloat(WeaponSpaceDropDirection, DropImpulseMagnitude));
	}
	BackupWeapon = GetBackupWeapon();
	if(AndAnd_BoolBool(NotEqual_ObjectObject(BackupWeapon, none), BackupWeapon.IsA('FiredWeapon')))
	{
		MPLog("...1");
		BackupWeaponModel = BackupWeapon.GetThirdPersonModel();
		if(Not_PreBool(BackupWeaponModel.bHidden))
		{
			MPLog("...2");
			DropWeapon(BackupWeapon, Multiply_VectorFloat(WeaponSpaceDropDirection, DropImpulseMagnitude));
		}
		else
		{
			if(Not_PreBool(BackupWeapon.IsIdle()))
			{
				MPLog("...3");
				BackupWeapon.AIInterrupt();
			}
		}
	}
	return;
}

function NotifyClientsToDropAllWeapons()
{
	local Controller i, theLocalPlayerController;
	local SwatGamePlayerController Current;

	assert(OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_ListenServer)), EqualEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer))));
	MPLog(Concat_StrStr(string(self), "$---SwatEnemy::NotifyClientsToDropAllWeapons()."));
	theLocalPlayerController = Level.GetLocalPlayerController();
	i = Level.ControllerList;
	J0x99:

	if(NotEqual_ObjectObject(i, none))
	{
		Current = SwatGamePlayerController(i);
		if(AndAnd_BoolBool(NotEqual_ObjectObject(Current, none), NotEqual_ObjectObject(Current, theLocalPlayerController)))
		{
			Current.ClientAIDroppedAllWeapons(self);
		}
		i = i.nextController;
		// [Loop Continue]
		goto J0x99;
	}
	return;
}

final simulated function DropCurrentWeapon(optional Vector WeaponSpaceDropDirection, optional float DropImpulseMagnitude)
{
	local HandheldEquipment CurrentItem;

	MPLog(Concat_StrStr(string(self), "---SwatEnemy::DropCurrentWeapon()."));
	CurrentItem = GetActiveItem();
	if(AndAnd_BoolBool(NotEqual_ObjectObject(CurrentItem, none), CurrentItem.IsA('FiredWeapon')))
	{
		MPLog("...1");
		DropWeapon(CurrentItem, Multiply_VectorFloat(WeaponSpaceDropDirection, DropImpulseMagnitude));
	}
	return;
}

// Export USwatEnemy::execActorIsInSameOrAdjacentZoneAsMe(FFrame&, void* const)
native event bool ActorIsInSameOrAdjacentZoneAsMe(Actor theOtherActor);

final simulated function DropWeapon(HandheldEquipment Weapon, Vector WeaponSpaceImpulse)
{
	local Rotator RotationBeforeDrop;
	local Vector LocationBeforeDrop;
	local HandheldEquipmentModel WeaponModel;
	local bool PhysicsError, WasPrimary;

	MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "---SwatEnemy::DropWeapon(). Weapon="), string(Weapon)), ", WeaponSpaceImpulse="), string(WeaponSpaceImpulse)));
	assert(NotEqual_ObjectObject(Weapon, none));
	if(AndAnd_BoolBool(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)), EqualEqual_ObjectObject(Weapon, GetActiveItem())))
	{
		GetEnemyCommanderAction().NotifyWeaponDropped();
	}
	DisableAim();
	WeaponModel = Weapon.GetThirdPersonModel();
	assert(NotEqual_ObjectObject(WeaponModel, none));
	WeaponModel.UniqueID();
	MPLog(Concat_StrStr("...WeaponModel.UniqueID()=", WeaponModel.UniqueID()));
	RotationBeforeDrop = WeaponModel.Rotation;
	LocationBeforeDrop = WeaponModel.Location;
	Weapon.AIInterrupt();
	if(EqualEqual_ObjectObject(Weapon, GetActiveItem()))
	{
		Weapon.HACK_QuickUnequipForAIDropWeapon();
		SetActiveItem(none);
	}
	else
	{
		DetachFromBone(Weapon);
	}
	if(EqualEqual_ObjectObject(Weapon, GetPrimaryWeapon()))
	{
		DestroyDroppedWeapon(true);
		WasPrimary = true;
		PrimaryWeapon = none;
		ReplicatedPrimaryWeaponClass = none;
		ReplicatedPrimaryWeaponAmmoClass = none;
		if(OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_ListenServer)), EqualEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer))))
		{
			DroppedPrimaryWeaponModelUniqueID = WeaponModel.UniqueID();
		}
	}
	else
	{
		AssertWithDescription(EqualEqual_ObjectObject(Weapon, GetBackupWeapon()), Concat_StrStr(Concat_StrStr("SwatEnemy::DropWeapon - Weapon (", string(Weapon)), ") is not the backup weapon.  Crombie's sanity check failed!"));
		DestroyDroppedWeapon(false);
		BackupWeapon = none;
		ReplicatedBackupWeaponClass = none;
		ReplicatedBackupWeaponAmmoClass = none;
		if(OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_ListenServer)), EqualEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer))))
		{
			DroppedBackupWeaponModelUniqueID = WeaponModel.UniqueID();
		}
	}
	WeaponModel.bBlockNonZeroExtentTraces = true;
	WeaponModel.bBlockZeroExtentTraces = true;
	WeaponModel.bProjTarget = true;
	WeaponModel.SetCollision(true, false, false);
	WeaponModel.SetLocation(LocationBeforeDrop);
	WeaponModel.SetRotation(RotationBeforeDrop);
	if(Not_PreBool(ActorIsInSameOrAdjacentZoneAsMe(WeaponModel)))
	{
		MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "...was dropping "), string(WeaponModel)), ", but it was in a different zone from me. Dropping from my location..."));
		WeaponModel.HavokSetBlocking(false);
		WeaponModel.SetLocation(Location);
		WeaponModel.SetPhysics(2);
	}
	PhysicsError = false;
	if(EqualEqual_ObjectObject(WeaponModel.HavokDataClass, none))
	{
		AssertWithDescription(false, Concat_StrStr(Concat_StrStr("SwatEnemy::DropWeapon - HavokDataClass for WeaponModel ", string(WeaponModel.Name)), " is NULL."));
		PhysicsError = true;
	}
	if(Not_PreBool(PhysicsError))
	{
		if(EqualEqual_ObjectObject(WeaponModel.StaticMesh, none))
		{
			AssertWithDescription(NotEqual_ObjectObject(WeaponModel.DroppedStaticMesh, none), Concat_StrStr(Concat_StrStr("WeaponModel ", string(WeaponModel.Name)), " does not have a Dropped static mesh set for it.  It must!  Bug Shawn!!!"));
			Log(Concat_StrStr("setting static mesh to: ", string(WeaponModel.DroppedStaticMesh)));
			WeaponModel.SetStaticMesh(WeaponModel.DroppedStaticMesh);
			WeaponModel.SetDrawType(8);
		}
		WeaponModel.HavokSetBlocking(true);
		WeaponModel.SetPhysics(15);
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(Name), " dropping WeaponModel "), string(WeaponModel.Name)), " at location "), string(WeaponModel.Location)), " with weapon-space Impulse dir="), string(Normal(WeaponSpaceImpulse))), " mag="), string(VSize(WeaponSpaceImpulse))), " (WeaponModel.bHidden="), string(WeaponModel.bHidden)), ", Weapon that owns model is "), string(Weapon.Name)), ")"));
		WeaponModel.HavokImpartCOMImpulse(GreaterGreater_VectorRotator(WeaponSpaceImpulse, Rotation));
	}
	WeaponModel.bUseCylinderCollision = true;
	WeaponModel.OnDropped(WasPrimary);
	if(Level.IsCOOPServer)
	{
		WeaponModel.NotifyClientsAIDroppedWeapon(GreaterGreater_VectorRotator(WeaponSpaceImpulse, Rotation));
	}
	ChangeAnimation();
	return;
}

simulated function DestroyDroppedWeapon(bool bPrimary)
{
	local string UniqueIdentifier;
	local HandheldEquipmentModel Target;

	MPLog(Concat_StrStr(string(self), "---SwatEnemy::DestroyDroppedWeapon()."));
	MPLog(Concat_StrStr("...bPrimary=", string(bPrimary)));
	if(bPrimary)
	{
		UniqueIdentifier = Concat_StrStr(UniqueID(), "Pocket_PrimaryWeapon");
	}
	else
	{
		UniqueIdentifier = Concat_StrStr(UniqueID(), "Pocket_SecondaryWeapon");
	}
	foreach DynamicActors(Class'Engine.HandheldEquipmentModel', Target)
	{
		if(AndAnd_BoolBool(Target.IsDropped(), EqualEqual_StrStr(Target.UniqueID(), UniqueIdentifier)))
		{
			MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr("...destroying target=", string(Target)), ", with UniqueID="), UniqueIdentifier));
			Target.Destroy();
		}
	}
	return;
}

private simulated function name GetThrowWeaponDownAnimation()
{
	if(GetActiveItem().IsA('Handgun'))
	{
		return ThrowWeaponDownAnimationsHG[Rand(ThrowWeaponDownAnimationsHG.Length)];
	}
	else
	{
		if(GetActiveItem().IsA('MachineGun'))
		{
			return ThrowWeaponDownAnimationsMG[Rand(ThrowWeaponDownAnimationsMG.Length)];
		}
		else
		{
			if(GetActiveItem().IsA('SubMachineGun'))
			{
				return ThrowWeaponDownAnimationsSMG[Rand(ThrowWeaponDownAnimationsSMG.Length)];
			}
			else
			{
				assert(GetActiveItem().IsA('Shotgun'));
				return ThrowWeaponDownAnimationsSG[Rand(ThrowWeaponDownAnimationsSG.Length)];
			}
		}
	}
	return;
}

final latent simulated function ThrowWeaponDown()
{
	if(NotEqual_ObjectObject(GetActiveItem(), none))
	{
		AnimPlaySpecial(GetThrowWeaponDownAnimation(), 0.1000000);
		AnimFinishSpecial();
	}
	return;
}

function BecomeAThreat()
{
	if(Not_PreBool(bThreat))
	{
		Log(Concat_StrStr(string(Name), " became a threat!"));
		bThreat = true;
		SwatAIRepository(Level.AIRepo).GetHive().NotifyEnemyBecameThreat(self);
	}
	return;
}

protected function InitializeDoorKnowledge(Door inDoor, PawnDoorKnowledge DoorKnowledge)
{
	assert(NotEqual_ObjectObject(inDoor, none));
	assert(inDoor.IsA('SwatDoor'));
	assert(NotEqual_ObjectObject(DoorKnowledge, none));
	DoorKnowledge.SetBelievesDoorLocked(SwatDoor(inDoor).WasDoorInitiallyLocked());
	return;
}

function bool ShouldForceOpenLockedDoors()
{
	return true;
	return;
}

function bool IsNeutralized()
{
	return OrOr_BoolBool(Not_PreBool(IsConscious()), IsArrested());
	return;
}

function Spawner GetSpawner()
{
	return SpawnedFrom;
	return;
}

// Export USwatEnemy::execGetAdditionalBaseAimError(FFrame&, void* const)
native event float GetAdditionalBaseAimError();

protected function float GetLengthOfTimeToFireFullAuto()
{
	switch(Skill)
	{
		case 2:
			return RandRange(HighSkillMinTimeToFireFullAuto, HighSkillMaxTimeToFireFullAuto);
		case 1:
			return RandRange(MediumSkillMinTimeToFireFullAuto, MediumSkillMaxTimeToFireFullAuto);
		case 0:
			return RandRange(LowSkillMinTimeToFireFullAuto, LowSkillMaxTimeToFireFullAuto);
		default:
			return;
			break;
	}
}

protected function NotifyWeaponDischarged()
{
	if(Not_PreBool(IsAThreat()))
	{
		BecomeAThreat();
	}
	return;
}

simulated function name GetEffectEventForReportingToTOCWhenDead()
{
	return 'ReportedDeadSuspect';
	return;
}

simulated function name GetEffectEventForReportingToTOCWhenIncapacitated()
{
	return 'ReportedInjSuspectSecured';
	return;
}

simulated function name GetEffectEventForReportingToTOCWhenArrested()
{
	return 'ReportedSuspectSecured';
	return;
}

simulated function name GetEffectEventForReportResponseFromTOCWhenIncapacitated()
{
	return 'RepliedInjSuspectReported';
	return;
}

simulated function name GetEffectEventForReportResponseFromTOCWhenNotIncapacitated()
{
	return 'RepliedSuspectReported';
	return;
}

simulated function string GetHumanReadableName()
{
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		return "Suspect";
	}
	return super(Pawn).GetHumanReadableName();
	return;
}

function OnUsingBegan()
{
	super(SwatAI).OnUsingBegan();
	if(GetActiveItem().IsA('FiredWeapon'))
	{
		SwatGameInfo(Level.Game).GameEvents.EnemyFiredWeapon.Triggered(self, GetWeaponTarget());
	}
	return;
}

simulated event FellOutOfWorld(Actor.eKillZType KillType)
{
	if(OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_ListenServer)), EqualEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer))))
	{
		if(NotEqual_StrStr(DroppedPrimaryWeaponModelUniqueID, ""))
		{
			NotifyClientsToDestroyDroppedWeapon(DroppedPrimaryWeaponModelUniqueID);
		}
		if(NotEqual_StrStr(DroppedBackupWeaponModelUniqueID, ""))
		{
			NotifyClientsToDestroyDroppedWeapon(DroppedBackupWeaponModelUniqueID);
		}
	}
	super.FellOutOfWorld(KillType);
	return;
}

function NotifyClientsToDestroyDroppedWeapon(string theUniqueID)
{
	local Controller i, theLocalPlayerController;
	local PlayerController Current;

	assert(OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_ListenServer)), EqualEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer))));
	MPLog(Concat_StrStr(Concat_StrStr(string(self), "$---SwatEnemy::NotifyClientsToDestroyDroppedWeapon(). UniqueID="), theUniqueID));
	theLocalPlayerController = Level.GetLocalPlayerController();
	i = Level.ControllerList;
	J0xB0:

	if(NotEqual_ObjectObject(i, none))
	{
		Current = PlayerController(i);
		if(AndAnd_BoolBool(NotEqual_ObjectObject(Current, none), NotEqual_ObjectObject(Current, theLocalPlayerController)))
		{
			Current.ClientWeaponFellOutOfWorld(theUniqueID);
		}
		i = i.nextController;
		// [Loop Continue]
		goto J0xB0;
	}
	return;
}

simulated function bool ReadyToTriggerEffectEvents()
{
	return OrOr_BoolBool(HasEquippedFirstItemYet, EqualEqual_ObjectObject(GetPrimaryWeapon(), none));
	return;
}

defaultproperties
{
	AnimRotationUrgency=2
	Mesh=SkeletalMesh'SWATMaleAnimation.MaleGang1'
	Texture=Texture'SwatGearTex.Placeholder'
}