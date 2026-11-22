class SwatAICharacter extends SwatAI implements ISwatAICharacter, IReactToFlashbangGrenade, IReactToCSGas, IReactToStingGrenade, IReactToC2Detonation, ICanBeTased, ICanBePepperSprayed, IReactToThrownGrenades
	abstract
	native
	config(SwatPawn)
	hidecategories(Karma);

const kMinAwarenessUpdateTime = 0.333;
const kMaxAwarenessUpdateTime = 0.666;

var Mesh OfficerMesh;
var private float InitialMorale;
var private name VoiceType;
var private name CharacterType;
var private float LastTimeFlashBanged;
var private float FlashBangedDuration;
var private float LastTimeGassed;
var private float GassedDuration;
var private float LastTimePepperSprayed;
var private float PepperSprayedDuration;
var private float LastTimeTased;
var private float TasedDuration;
var private float LastTimeStung;
var private float StungDuration;
var private float LastTimeStunnedByC2;
var private float StunnedByC2Duration;
var private bool bCanBeArrested;
var config string RestrainedHandcuffsClassName;
var private HandheldEquipment RestrainedHandcuffs;
var config float IncapacitatedHealthAmount;
var private bool bIsAggressive;
var private AwarenessProxy Awareness;
var private float AwarenessCounter;
var private bool bAwarenessDisabled;
var private Material ReplicatedSkins[4];
var private Mesh ReplicatedMesh;
var private bool bReplicatedIsFemale;
var private Class<Equipment> ReplicatedEquipment1Class;
var private Class<Equipment> ReplicatedEquipment2Class;
var private Class<Equipment> ReplicatedEquipment3Class;
var private Class<Equipment> ReplicatedEquipment4Class;
var array<Equipment> NetEquipment;
var ISwatAICharacter.AIEquipment DesiredAIEquipment;
var private bool ReplicatedShouldUsePatrolAnims;

replication
{
	// Pos:0x000
	reliable if(EqualEqual_IntInt(int(Role), int(ROLE_Authority)))
		CharacterType, DesiredAIEquipment,
		ReplicatedEquipment1Class, ReplicatedEquipment2Class,
		ReplicatedEquipment3Class, ReplicatedEquipment4Class,
		ReplicatedMesh, ReplicatedShouldUsePatrolAnims,
		ReplicatedSkins, VoiceType,
		bCanBeArrested, bReplicatedIsFemale;
}

simulated event PreBeginPlay()
{
	super.PreBeginPlay();
	SpawnRestrainedHandcuffs();
	return;
}

simulated event PostBeginPlay()
{
	super.PostBeginPlay();
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		CreateAwareness();
	}
	return;
}

simulated event ReplicatedMeshInfoOnChanged()
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(string(self), "---SwatAICharacter::ReplicatedMeshInfoOnChanged(), About to call SwitchToMesh on client, bReplicatedIsFemale is "), string(bReplicatedIsFemale)));
	}
	SwitchToMesh(ReplicatedMesh);
	return;
}

simulated event ReplicatedSkinsOnChanged(int SkinIndex)
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "---SwatAICharacter::ReplicatedSkinsOnChanged( "), string(SkinIndex)), " ), Skins[SkinIndex] = "), string(Skins[SkinIndex])), ", ReplicatedSkins[SkinIndex] = "), string(ReplicatedSkins[SkinIndex])));
	}
	Skins[SkinIndex] = ReplicatedSkins[SkinIndex];
	return;
}

simulated event ReplicatedEquipmentClassOnChanged(Class<Equipment> EquipmentClass)
{
	local Equipment theEquipment;

	theEquipment = Spawn(EquipmentClass, self);
	if(NotEqual_ObjectObject(theEquipment, none))
	{
		theEquipment.OnGivenToOwner();
		NetEquipment[NetEquipment.Length] = theEquipment;
	}
	return;
}

simulated event OnDesiredAIEquipmentChanged()
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(string(self), "---SwatAICharacter::OnDesiredAIEquipmentChanged(). NewValue="), string(DesiredAIEquipment)));
	}
	return;
}

function SetDesiredAIEquipment(ISwatAICharacter.AIEquipment NewValue)
{
	assert(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)));
	DesiredAIEquipment = NewValue;
	return;
}

simulated event Destroyed()
{
	super.Destroyed();
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		TermAwareness();
	}
	return;
}

simulated function DestroyEquipment()
{
	local int i;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SwatAICharacter::DestroyEquipment()."));
	}
	i = 0;
	J0x57:

	if(Less_IntInt(i, NetEquipment.Length))
	{
		if(NotEqual_ObjectObject(NetEquipment[i], none))
		{
			NetEquipment[i].Destroy();
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x57;
	}
	NetEquipment.Remove(0, NetEquipment.Length);
	if(NotEqual_ObjectObject(RestrainedHandcuffs, none))
	{
		RestrainedHandcuffs.Destroy();
	}
	super.DestroyEquipment();
	return;
}

protected function ConstructCharacterAI()
{
	local AI_Resource characterResource;

	characterResource = AI_Resource(CharacterAI);
	assert(NotEqual_ObjectObject(CharacterAI, none));
	if(ShouldReactToNonLethals())
	{
		characterResource.addAbility(Class'SwatAICommon.PepperSprayedAction'.static.Allocate(self)., Construct_Void());
		characterResource.addAbility(Class'SwatAICommon.GassedAction'.static.Allocate(self)., Construct_Void());
		characterResource.addAbility(Class'SwatAICommon.FlashbangedAction'.static.Allocate(self)., Construct_Void());
		characterResource.addAbility(Class'SwatAICommon.TasedAction'.static.Allocate(self)., Construct_Void());
		characterResource.addAbility(Class'SwatAICommon.StunnedByC2Action'.static.Allocate(self)., Construct_Void());
		characterResource.addAbility(Class'SwatAICommon.InitialReactionAction'.static.Allocate(self)., Construct_Void());
		characterResource.addAbility(Class'SwatAICommon.StungAction'.static.Allocate(self)., Construct_Void());
		characterResource.addAbility(Class'SwatAICommon.AvoidLocationAction'.static.Allocate(self)., Construct_Void());
	}
	super.ConstructCharacterAI();
	return;
}

protected function bool ShouldReactToNonLethals()
{
	return true;
	return;
}

private simulated function SpawnRestrainedHandcuffs()
{
	local Class<HandheldEquipment> RestrainedHandcuffsClass;

	RestrainedHandcuffsClass = Class<HandheldEquipment>(DynamicLoadObject(RestrainedHandcuffsClassName, Class'Core.Class'));
	assert(NotEqual_ObjectObject(RestrainedHandcuffsClass, none));
	RestrainedHandcuffs = Spawn(RestrainedHandcuffsClass, self);
	assert(NotEqual_ObjectObject(RestrainedHandcuffs, none));
	RestrainedHandcuffs.OnGivenToOwner();
	return;
}

simulated function HandheldEquipment GetRestrainedHandcuffs()
{
	return RestrainedHandcuffs;
	return;
}

simulated function AnimationSetManager.EAnimationSet GetStandingInjuredAnimSet()
{
	return 33;
	return;
}

simulated function AnimationSetManager.EAnimationSet GetStandingInjuredUpStairsAnimSet()
{
	return 34;
	return;
}

simulated function AnimationSetManager.EAnimationSet GetStandingInjuredDownStairsAnimSet()
{
	return 35;
	return;
}

simulated function AnimationSetManager.EAnimationSet GetCrouchingInjuredAnimSet()
{
	return 36;
	return;
}

protected simulated function SetAdditionalAnimSets()
{
	local PatrolGoal CurrentPatrolGoal;

	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
		{
			ReplicatedShouldUsePatrolAnims = false;
		}
		CurrentPatrolGoal = PatrolGoal(AI_Resource(CharacterAI).findGoalByName("Patrol"));
		if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(CurrentPatrolGoal, none), CurrentPatrolGoal.beingAchieved()), CurrentPatrolGoal.achievingAction.IsRunning()))
		{
			SetPatrolAnimMovementSet();
			if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
			{
				ReplicatedShouldUsePatrolAnims = true;
			}
		}
	}
	else
	{
		if(ReplicatedShouldUsePatrolAnims)
		{
			SetPatrolAnimMovementSet();
		}
	}
	return;
}

function SetPatrolAnimMovementSet()
{
	if(AndAnd_BoolBool(NotEqual_ObjectObject(GetActiveItem(), none), GetActiveItem().IsA('Handgun')))
	{
		AnimSwapInSet(39);
	}
	else
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(GetActiveItem(), none), GetActiveItem().IsA('MachineGun')))
		{
			AnimSwapInSet(41);
		}
		else
		{
			if(AndAnd_BoolBool(NotEqual_ObjectObject(GetActiveItem(), none), GetActiveItem().IsA('SubMachineGun')))
			{
				AnimSwapInSet(40);
			}
			else
			{
				if(AndAnd_BoolBool(NotEqual_ObjectObject(GetActiveItem(), none), GetActiveItem().IsA('Shotgun')))
				{
					AnimSwapInSet(42);
				}
				else
				{
					AnimSwapInSet(17);
				}
			}
		}
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetEquipmentAimSet()
{
	if(IsCompliant())
	{
		return 104;
	}
	else
	{
		return super(SwatPawn).GetEquipmentAimSet();
	}
	return;
}

function bool CanProcedurallyAnimateUpperBody()
{
	local HandheldEquipment Equipment;

	Equipment = GetActiveItem();
	if(AndAnd_BoolBool(NotEqual_ObjectObject(Equipment, none), Equipment.IsA('IAmCuffed')))
	{
		return true;
	}
	else
	{
		if(IsCompliant())
		{
			return true;
		}
		else
		{
			return super.CanProcedurallyAnimateUpperBody();
		}
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetAffectedByTacticalAidAnimSet()
{
	if(IsCompliant())
	{
		return 0;
	}
	else
	{
		return super(SwatPawn).GetAffectedByTacticalAidAnimSet();
	}
	return;
}

event NotifyStartedMoving()
{
	super.NotifyStartedMoving();
	if(IsCompliant())
	{
		SetUpperBodyAnimBehavior(0, 21);
	}
	return;
}

event NotifyStoppedMoving()
{
	super.NotifyStoppedMoving();
	UnsetUpperBodyAnimBehavior(21);
	return;
}

protected function InitializePatrolling(PatrolList Patrol)
{
	if(NotEqual_ObjectObject(Patrol, none))
	{
		CharacterAI.addAbility(Class'SwatAICommon.PatrolAction'.static.Allocate(self)., Construct_Void());
		Commander.SetPatrol(Patrol);
	}
	return;
}

function InitializeFromArchetypeInstance()
{
	local CharacterArchetypeInstance Instance;

	super.InitializeFromArchetypeInstance();
	Instance = CharacterArchetypeInstance(ArchetypeInstance);
	assert(NotEqual_ObjectObject(Instance, none));
	bIsAggressive = Instance.IsAggressive;
	InitialMorale = Instance.Morale;
	SetVoiceType(Instance);
	SwitchToMesh(Instance.Mesh);
	ReplicatedMesh = Instance.Mesh;
	if(EqualEqual_ObjectObject(Mesh, OfficerMesh))
	{
		Skins[0] = Instance.PantsMaterial;
		Skins[1] = Instance.FaceMaterial;
		Skins[2] = Instance.NameMaterial;
		Skins[3] = Instance.VestMaterial;
		ReplicatedSkins[0] = Skins[0];
		ReplicatedSkins[1] = Skins[1];
		ReplicatedSkins[2] = Skins[2];
		ReplicatedSkins[3] = Skins[3];
	}
	else
	{
		Skins[0] = Instance.FleshMaterial;
		Skins[1] = Instance.ClothesMaterial;
		ReplicatedSkins[0] = Skins[0];
		ReplicatedSkins[1] = Skins[1];
	}
	ReplicatedEquipment1Class = Instance.SelectedEquipment1Class;
	ReplicatedEquipment2Class = Instance.SelectedEquipment2Class;
	ReplicatedEquipment3Class = Instance.SelectedEquipment3Class;
	ReplicatedEquipment4Class = Instance.SelectedEquipment4Class;
	bReplicatedIsFemale = IsFemale();
	MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "---SwatAICharacter::InitializeFromArchetypeInstance(), bReplicatedIsFemale was set to "), string(bReplicatedIsFemale)), " on the server"));
	DropToGround();
	return;
}

private function SetVoiceType(CharacterArchetypeInstance Instance)
{
	local SwatAIRepository SwatAIRepo;

	assert(NotEqual_ObjectObject(Instance, none));
	SwatAIRepo = SwatAIRepository(Level.AIRepo);
	assert(NotEqual_ObjectObject(SwatAIRepo, none));
	CharacterType = Instance.CharacterType;
	assert(NotEqual_NameName(CharacterType, 'None'));
	if(NotEqual_NameName(Instance.VoiceTypeOverride, 'None'))
	{
		AssertWithDescription(SwatAIRepo.VerifyVoiceTypeExists(Instance.VoiceTypeOverride), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("SwatAICharacter::SetVoiceType - VoiceTypeOverride (", string(Instance.VoiceTypeOverride)), ") specified in archetype instance "), string(Instance.Name)), " not found!  Check your spelling in the Archetype .ini file!"));
		VoiceType = Instance.VoiceTypeOverride;
	}
	else
	{
		AssertWithDescription(SwatAIRepo.VerifyCharacterTypeExists(Instance.CharacterType), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("SwatAICharacter::SetVoiceType - CharacterType (", string(Instance.CharacterType)), ") specified in archetype instance "), string(Instance.Name)), " not found!  Check your spelling in the Archetype .ini file!"));
		VoiceType = SwatAIRepo.GetVoiceTypeForCharacterType(Instance.CharacterType);
	}
	assert(NotEqual_NameName(VoiceType, 'None'));
	Log(Concat_StrStr(Concat_StrStr(string(Name), " VoiceType is: "), string(VoiceType)));
	Tag = VoiceType;
	return;
}

function name GetVoiceType()
{
	return VoiceType;
	return;
}

function float GetInitialMorale()
{
	return InitialMorale;
	return;
}

function bool IsAggressive()
{
	return bIsAggressive;
	return;
}

simulated function bool IsFemale()
{
	local SwatAIRepository SwatAIRepo;

	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		return bReplicatedIsFemale;
	}
	else
	{
		SwatAIRepo = SwatAIRepository(Level.AIRepo);
		assert(NotEqual_ObjectObject(SwatAIRepo, none));
		return AndAnd_BoolBool(NotEqual_NameName(CharacterType, 'None'), SwatAIRepo.IsAFemaleCharacterType(CharacterType));
	}
	return;
}

function DropToGround()
{
	SetPhysics(2);
	return;
}

simulated function array<string> GetAnimPackageGroups()
{
	if(Level.GetEngine().EnableDevTools)
	{
		Log(Concat_StrStr(string(self), "---SwatAICharacter::GetAnimPackageGroups()."));
	}
	AssertWithDescription(EqualEqual_IntInt(FemaleAnimGroups.Length, MaleAnimGroups.Length), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("SwatAICharacter::GetAnimPackageGroups - MaleAnimGroups length (", string(MaleAnimGroups.Length)), ") does not match FemaleAnimGroups length ("), string(FemaleAnimGroups.Length)), ")"));
	if(Level.GetEngine().EnableDevTools)
	{
		Log(Concat_StrStr("...FemaleAnimGroups.Length=", string(FemaleAnimGroups.Length)));
		Log(Concat_StrStr("...MaleAnimGroups.Length  =", string(MaleAnimGroups.Length)));
	}
	if(IsFemale())
	{
		return FemaleAnimGroups;
	}
	else
	{
		return MaleAnimGroups;
	}
	return;
}

simulated function Died(Controller Killer, Class<DamageType> DamageType, Vector HitLocation, Vector HitMomentum)
{
	super.Died(Killer, DamageType, HitLocation, HitMomentum);
	SwatAIRepository(Level.AIRepo).GetHive().NotifyAIDied(self);
	return;
}

function float GetIncapacitatedDamageAmount()
{
	return IncapacitatedHealthAmount;
	return;
}

function ReactToFlashbangGrenade(SwatGrenadeProjectile Grenade, Pawn Instigator, float Damage, float DamageRadius, Range KarmaImpulse, float KarmaImpulseRadius, float StunRadius, float PlayerStunDuration, float AIStunDuration, float MoraleModifier)
{
	local Vector direction, GrenadeLocation;
	local float Distance, magnitude;

	if(HasProtection('IProtectFromFlashbang'))
	{
		return;
	}
	if(IsConscious())
	{
		if(NotEqual_ObjectObject(Grenade, none))
		{
			GrenadeLocation = Grenade.Location;
			direction = Subtract_VectorVector(Location, Grenade.Location);
			Distance = VSize(direction);
			if(EqualEqual_ObjectObject(Instigator, none))
			{
				Instigator = Pawn(Grenade.Owner);
			}
		}
		else
		{
			GrenadeLocation = Location;
			Distance = 0.0000000;
			if(NotEqual_ObjectObject(Instigator, none))
			{
				direction = Subtract_VectorVector(Location, Instigator.Location);
			}
			else
			{
				direction = Location;
			}
		}
		if(LessEqual_FloatFloat(Distance, DamageRadius))
		{
			TakeDamage(int(Damage), Instigator, GrenadeLocation, vect(0.0000000, 0.0000000, 0.0000000), Class'Engine.GrenadeDamageType');
		}
		if(Not_PreBool(IsConscious()))
		{
			if(LessEqual_FloatFloat(Distance, KarmaImpulseRadius))
			{
				magnitude = Lerp(Divide_FloatFloat(Distance, KarmaImpulseRadius), KarmaImpulse.Max, KarmaImpulse.Min);
			}
		}
		if(LessEqual_FloatFloat(Distance, StunRadius))
		{
			assert(Greater_FloatFloat(AIStunDuration, 0.0000000));
			LastTimeFlashBanged = Level.TimeSeconds;
			FlashBangedDuration = AIStunDuration;
			GetCommanderAction().NotifyFlashbanged(GrenadeLocation, AIStunDuration);
		}
	}
	return;
}

function ReactToCSGas(Actor GasContainer, float Duration, float SPPlayerProtectiveEquipmentDurationScaleFactor, float MPPlayerProtectiveEquipmentDurationScaleFactor)
{
	if(HasProtection('IProtectFromCSGas'))
	{
		return;
	}
	if(IsConscious())
	{
		LastTimeGassed = Level.TimeSeconds;
		GassedDuration = Duration;
		GetCommanderAction().NotifyGassed(GasContainer.Location, Duration);
	}
	return;
}

function ReactToStingGrenade(SwatGrenadeProjectile Grenade, Pawn Instigator, float Damage, float DamageRadius, Range KarmaImpulse, float KarmaImpulseRadius, float StingRadius, float PlayerStingDuration, float HeavilyArmoredPlayerStingDuration, float AIStingDuration, float MoraleModifier)
{
	local Vector direction, GrenadeLocation;
	local float Distance, magnitude;

	if(HasProtection('IProtectFromSting'))
	{
		return;
	}
	if(IsConscious())
	{
		if(NotEqual_ObjectObject(Grenade, none))
		{
			GrenadeLocation = Grenade.Location;
			direction = Subtract_VectorVector(Location, Grenade.Location);
			Distance = VSize(direction);
			if(EqualEqual_ObjectObject(Instigator, none))
			{
				Instigator = Pawn(Grenade.Owner);
			}
		}
		else
		{
			GrenadeLocation = Location;
			Distance = 0.0000000;
			if(NotEqual_ObjectObject(Instigator, none))
			{
				direction = Subtract_VectorVector(Location, Instigator.Location);
			}
			else
			{
				direction = Location;
			}
		}
		if(AndAnd_BoolBool(NotEqual_ObjectObject(Grenade, none), LessEqual_FloatFloat(Distance, DamageRadius)))
		{
			TakeDamage(int(Damage), Instigator, GrenadeLocation, vect(0.0000000, 0.0000000, 0.0000000), Class'Engine.GrenadeDamageType');
		}
		if(Not_PreBool(IsConscious()))
		{
			if(LessEqual_FloatFloat(Distance, KarmaImpulseRadius))
			{
				magnitude = Lerp(Divide_FloatFloat(Distance, KarmaImpulseRadius), KarmaImpulse.Max, KarmaImpulse.Min);
			}
		}
		if(LessEqual_FloatFloat(Distance, StingRadius))
		{
			LastTimeStung = Level.TimeSeconds;
			StungDuration = AIStingDuration;
			GetCommanderAction().NotifyStung(Grenade, GrenadeLocation, StungDuration);
		}
	}
	return;
}

function ReactToBeingPepperSprayed(Actor PepperSpray, float PlayerDuration, float AIDuration, float SPPlayerProtectiveEquipmentDurationScaleFactor, float MPPlayerProtectiveEquipmentDurationScaleFactor)
{
	if(HasProtection('IProtectFromPepperSpray'))
	{
		return;
	}
	if(IsConscious())
	{
		LastTimePepperSprayed = Level.TimeSeconds;
		PepperSprayedDuration = AIDuration;
		GetCommanderAction().NotifyPepperSprayed(PepperSpray.Location, AIDuration);
	}
	return;
}

function ReactToBeingTased(Actor Taser, float PlayerDuration, float AIDuration)
{
	if(IsConscious())
	{
		LastTimeTased = Level.TimeSeconds;
		TasedDuration = AIDuration;
		GetCommanderAction().NotifyTased(Taser.Location, AIDuration);
	}
	return;
}

simulated function bool IsVulnerableToTaser()
{
	return true;
	return;
}

function ReactToC2Detonation(Actor C2Charge, float StunRadius, float AIStunDuration)
{
	if(IsConscious())
	{
		LastTimeStunnedByC2 = Level.TimeSeconds;
		StunnedByC2Duration = AIStunDuration;
		GetCommanderAction().NotifyStunnedByC2Detonation(C2Charge.Location, AIStunDuration);
	}
	return;
}

// Export USwatAICharacter::execIsFlashbanged(FFrame&, void* const)
native simulated function bool IsFlashbanged();

// Export USwatAICharacter::execIsGassed(FFrame&, void* const)
native simulated function bool IsGassed();

// Export USwatAICharacter::execIsPepperSprayed(FFrame&, void* const)
native simulated function bool IsPepperSprayed();

// Export USwatAICharacter::execIsStung(FFrame&, void* const)
native simulated function bool IsStung();

// Export USwatAICharacter::execIsTased(FFrame&, void* const)
native simulated function bool IsTased();

// Export USwatAICharacter::execIsStunnedByC2(FFrame&, void* const)
native simulated function bool IsStunnedByC2();

// Export USwatAICharacter::execIsStunned(FFrame&, void* const)
native simulated function bool IsStunned();

simulated function SetCanBeArrested()
{
	bCanBeArrested = true;
	return;
}

simulated function bool CanBeArrestedNow()
{
	return AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(bCanBeArrested, Not_PreBool(IsArrested())), Not_PreBool(IsBeingArrestedNow())), Class.static.checkConscious(self));
	return;
}

function OnArrestBegan(Pawn Arrester)
{
	super(SwatPawn).OnArrestBegan(Arrester);
	GetCommanderAction().NotifyBeginArrest(Arrester);
	return;
}

function OnArrestInterrupted(Pawn Arrester)
{
	super(SwatPawn).OnArrestInterrupted(Arrester);
	if(IsConscious())
	{
		GetCommanderAction().NotifyArrestInterrupted();
	}
	return;
}

simulated function OnArrestedSwatPawn(Pawn Arrester)
{
	local HandheldEquipment thePendingItem;
	local HandheldEquipmentModel theThirdPersonModel;

	MPLog(Concat_StrStr(Concat_StrStr(string(self), "---SwatAICharacter::OnArrestedSwatPawn(). Arrester="), string(Arrester)));
	super(SwatPawn).OnArrestedSwatPawn(Arrester);
	if(Level.IsCOOPServer)
	{
		thePendingItem = GetPendingItem();
		if(NotEqual_ObjectObject(thePendingItem, none))
		{
			theThirdPersonModel = thePendingItem.GetThirdPersonModel();
			if(NotEqual_ObjectObject(theThirdPersonModel, none))
			{
				theThirdPersonModel.RemoteRole = ROLE_DumbProxy;
			}
		}
	}
	bCanBeArrested = false;
	ChangeAnimation();
	AnimSetRotationUrgency(0);
	AnimSetAnimAimRotationUrgency(0);
	return;
}

simulated function NotifyGrenadeThrown(SwatGrenadeProjectile ThrownGrenade)
{
	GetCommanderAction().NotifyGrenadeThrown(ThrownGrenade);
	return;
}

private function CreateAwareness()
{
	Awareness = Class'SwatAIAwareness.AwarenessFactory'.static.CreateAwarenessForPawn(self);
	return;
}

private function TermAwareness()
{
	Awareness.Term();
	Awareness = none;
	return;
}

function AwarenessProxy GetAwareness()
{
	return Awareness;
	return;
}

function DisableAwareness()
{
	bAwarenessDisabled = true;
	return;
}

function EnableAwareness()
{
	bAwarenessDisabled = false;
	return;
}

// Export USwatAICharacter::execForceUpdateAwareness(FFrame&, void* const)
native function ForceUpdateAwareness();

simulated event FellOutOfWorld(Actor.eKillZType KillType)
{
	local SwatGameInfo Game;
	local SwatGamePlayerController SGPC;

	Game = SwatGameInfo(Level.Game);
	if(EqualEqual_ObjectObject(Game, none))
	{
		return;
	}
	if(Not_PreBool(IsArrested()))
	{
		Game.GameEvents.PawnArrested.Triggered(self, none);
	}
	if(Not_PreBool(HasBeenReportedToTOC()))
	{
		Game.GameEvents.ReportableReportedToTOC.Triggered(self, none);
	}
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		SGPC = SwatGamePlayerController(Level.GetLocalPlayerController());
		if(NotEqual_ObjectObject(SGPC, none))
		{
			SGPC.ServerRequestInteract(self, self.UniqueID());
		}
	}
	super(Pawn).FellOutOfWorld(KillType);
	return;
}

defaultproperties
{
	OfficerMesh=SkeletalMesh'SWATMaleAnimation.SwatOfficer'
	bReplicateAnimations=true
	bNoRepMesh=false
}