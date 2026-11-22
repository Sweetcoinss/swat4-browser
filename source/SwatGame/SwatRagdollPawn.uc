class SwatRagdollPawn extends SwatPawn
	native
	config(SwatPawn)
	hidecategories(Karma);

cpptext
{
    virtual UBOOL Tick( FLOAT DeltaTime, ELevelTick TickType );
	virtual void PostNetReceive();

}

const kRagdollCollisionRadius = 72;
const kDeadPawnTearOffDelaySeconds = 5.0;

enum ETwitchType
{
	ETWITCH_Torque,                 // 0
	ETWITCH_LinearVelocity,         // 1
	ETWITCH_Force,                  // 2
	ETWITCH_Impulse                 // 3
};

struct native TwitchingBoneInfo
{
	var config name BoneName;
	var config Range ForceMagnitude;
	var Vector ForceVector;
	var config name TargetBoneName;
	var config Vector TargetForceNormal;
	var SwatRagdollPawn.ETwitchType TwitchType;
};

struct native BoneDampingSetting
{
	var name BoneName;
	var float Damping;
};

var private bool bHasRagdolledLocally;
var private bool bHasRagdolledOnServer;
var private bool bShouldCheckHasRagdolledOnServer;
var private Vector LocationAtRagdollStartOnServer;
var private Timer DeadPawnTearOffTimer;
var private bool bClientsShouldCallPlayDying;
var private bool bIsDisabledRagdoll;
var private config bool bRagdollDeathUsesImpactMomentum;
var private config bool bRagdollDeathPushesAwayFromDoor;
var private config float RagdollPushAwayFromDoorVelocityMagnitude;
var private config float RagdollSimulationTimeout;
var private Timer LimbTwitchTimer;
var private config float LimbTwitchTime;
var private Timer LimbIdleTimer;
var private config float LimbIdleTime;
var private bool bLimbsAreIdle;
var private bool bRagdollingOnReplication;
var private float FirstRagdollRenderTime;
var config array<TwitchingBoneInfo> TwitchInfos;
var private config float RenderTimeout;
var private config float InitialRagdollRenderTimeout;
var config array<BoneDampingSetting> BoneLinearDamping;
var config array<BoneDampingSetting> BoneAngularDamping;

replication
{
	// Pos:0x000
	reliable if(EqualEqual_IntInt(int(Role), int(ROLE_Authority)))
		LocationAtRagdollStartOnServer, bClientsShouldCallPlayDying,
		bHasRagdolledOnServer;
}

simulated event PostNetBeginPlay()
{
	super.PostNetBeginPlay();
	if(AndAnd_BoolBool(bHasRagdolledOnServer, Not_PreBool(bHasRagdolledLocally)))
	{
		bRagdollingOnReplication = true;
		BecomeRagdoll();
	}
	else
	{
		bShouldCheckHasRagdolledOnServer = true;
	}
	return;
}

simulated function OnMeshChanged()
{
	super.OnMeshChanged();
	if(EqualEqual_IntInt(int(Physics), int(16)))
	{
		SetPhysics(0);
		BecomeRagdoll();
	}
	return;
}

simulated function float GetRagdollSimulationTimeout()
{
	return RagdollSimulationTimeout;
	return;
}

// Export USwatRagdollPawn::execStartTwitchingLimbs(FFrame&, void* const)
native function StartTwitchingLimbs();

// Export USwatRagdollPawn::execStopTwitchingLimbs(FFrame&, void* const)
native function StopTwitchingLimbs();

simulated function StartTwitching()
{
	if(IsIncapacitated())
	{
		if(EqualEqual_ObjectObject(LimbTwitchTimer, none))
		{
			LimbTwitchTimer = Class'Engine.Timer'.static.Allocate(self).;
			Construct_Void();
			LimbTwitchTimer.__TimerDelegate__Delegate = StartIdling;
		}
		bLimbsAreIdle = false;
		StartTwitchingLimbs();
		LimbTwitchTimer.StartTimer(LimbTwitchTime, false);
	}
	return;
}

simulated function StartIdling()
{
	if(IsIncapacitated())
	{
		if(EqualEqual_ObjectObject(LimbIdleTimer, none))
		{
			LimbIdleTimer = Class'Engine.Timer'.static.Allocate(self).;
			Construct_Void();
			LimbIdleTimer.__TimerDelegate__Delegate = StartTwitching;
		}
		bLimbsAreIdle = true;
		StopTwitchingLimbs();
		LimbIdleTimer.StartTimer(LimbIdleTime, false);
	}
	return;
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	return;
}

simulated event Destroyed()
{
	if(NotEqual_ObjectObject(LimbIdleTimer, none))
	{
		LimbIdleTimer.Destroy();
		LimbIdleTimer = none;
	}
	if(NotEqual_ObjectObject(LimbTwitchTimer, none))
	{
		LimbTwitchTimer.Destroy();
		LimbTwitchTimer = none;
	}
	if(NotEqual_ObjectObject(DeadPawnTearOffTimer, none))
	{
		DeadPawnTearOffTimer.Destroy();
		DeadPawnTearOffTimer = none;
	}
	super.Destroyed();
	return;
}

function Died(Controller Killer, Class<DamageType> DamageType, Vector HitLocation, Vector HitMomentum)
{
	MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "---SwatRagdollPawn::Died(). HitLocation="), string(HitLocation)), ", HitMomentum="), string(HitMomentum)), ", DamageType "), string(DamageType)));
	super.Died(Killer, DamageType, HitLocation, HitMomentum);
	if(OrOr_BoolBool(bDeleteMe, Level.bLevelChange))
	{
		return;
	}
	BroadcastStopAllSounds();
	BroadcastEffectEvent('Died', Killer, none, HitLocation,,,,, GetPlayerTag());
	return;
}

simulated function Tick(float DeltaTime)
{
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer)))
	{
		return;
	}
	if(bTearOff)
	{
		if(Not_PreBool(bPlayedDeath))
		{
			PlayDying(DeathHitDamageType, DeathHitLocation, DeathHitMomentum, KillerLocation);
		}
		return;
	}
	return;
}

simulated function ChunkUp(Rotator HitRotation, Class<DamageType> TheDamageType)
{
	return;
}

simulated function Vector GetBestVelocityToApplyToPushRagdollAwayFromDoors()
{
	local Vector PushAwayDirection, CumulativePushAwayDirection;
	local SwatDoor NearbyDoor;

	foreach TouchingActors(Class'SwatGame.SwatDoor', NearbyDoor)
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(NearbyDoor, none), Not_PreBool(NearbyDoor.IsClosed())))
		{
			PushAwayDirection = NearbyDoor.GetPushAwayDirection(self);
			AddEqual_VectorVector(CumulativePushAwayDirection, PushAwayDirection);
		}
	}
	if(Greater_FloatFloat(VSizeSquared(CumulativePushAwayDirection), float(0)))
	{
		CumulativePushAwayDirection = Multiply_VectorFloat(Normal(CumulativePushAwayDirection), RagdollPushAwayFromDoorVelocityMagnitude);
	}
	return CumulativePushAwayDirection;
	return;
}

simulated function PushAwayFromDoors()
{
	local Vector PushAwayVelocity;

	PushAwayVelocity = GetBestVelocityToApplyToPushRagdollAwayFromDoors();
	if(Greater_FloatFloat(VSizeSquared(PushAwayVelocity), float(0)))
	{
		HavokSetLinearVelocityAll(PushAwayVelocity);
	}
	return;
}

protected simulated function ApplyDeathHitMomentumToRagdoll()
{
	local name TakeHitBone;
	local Actor.ESkeletalRegion HitRegion;
	local Vector TraceStart, TraceEnd, DummyTraceLoc, DummyTraceNormal, HitDir;

	local SwatRagdollPawn DummyTraceActor;
	local Material DummyTraceMaterial;
	local Vector ScaledMomentum;
	local bool bLogDebugInfo;

	bLogDebugInfo = OrOr_BoolBool(Level.AnalyzeBallistics, Level.GetEngine().EnableDevTools);
	if(bLogDebugInfo)
	{
		if(NotEqual_ObjectObject(DeathHitDamageType, none))
		{
			Log(Concat_StrStr("DeathHitDamageType = ", DeathHitDamageType.static.GetFriendlyName()));
		}
		else
		{
			Log("DeathHitDamageType = None");
		}
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("  DeathHitMomentum = ", string(DeathHitMomentum)), " Normalized = "), string(Normal(DeathHitMomentum))));
		Log(Concat_StrStr("  DeathHitLocation = ", string(DeathHitLocation)));
		Log(Concat_StrStr("    KillerLocation = ", string(KillerLocation)));
	}
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		HitDir = Normal(DeathHitMomentum);
		TraceStart = Subtract_VectorVector(DeathHitLocation, Multiply_FloatVector(float(200), HitDir));
		TraceEnd = Add_VectorVector(DeathHitLocation, Multiply_FloatVector(float(200), HitDir));
		foreach TraceActors(Class'SwatGame.SwatRagdollPawn', DummyTraceActor, DummyTraceLoc, DummyTraceNormal, DummyTraceMaterial, TraceEnd, TraceStart,, true, HitRegion)
		{
			if(EqualEqual_ObjectObject(DummyTraceActor, self))
			{
				if(NotEqual_IntInt(int(HitRegion), int(0)))
				{
					TakeHitBone = GetLastTracedBone();
					if(bLogDebugInfo)
					{
						Log(Concat_StrStr(" BecomeRagdoll: HIT PAWN   = ", string(DummyTraceActor)));
						Log(Concat_StrStr(Concat_StrStr(" HIT REGION = ", string(GetEnum(Enum'Engine.Actor.ESkeletalRegion', int(HitRegion)))), " was hit."));
						if(NotEqual_NameName(TakeHitBone, 'None'))
						{
							Log(Concat_StrStr(Concat_StrStr("  HIT BONE  = ", string(TakeHitBone)), " (from re-calculated trace)"));
						}
						else
						{
							Log("  HIT BONE  = UNKNOWN (from re-calculated trace)");
						}
					}
				}
				break;
			}
		}
	}
	else
	{
		TakeHitBone = GetLastTracedBone();
		if(bLogDebugInfo)
		{
			if(NotEqual_NameName(TakeHitBone, 'None'))
			{
				Log(Concat_StrStr(Concat_StrStr("   TakeHitBone = ", string(TakeHitBone)), " (from cached trace)"));
			}
		}
	}
	if(EqualEqual_NameName(TakeHitBone, 'None'))
	{
		TakeHitBone = 'Bip01_Spine2';
		if(bLogDebugInfo)
		{
			Log("   Applying hit impulse to Bip01_Spine2 because hit bone is unknown");
		}
	}
	if(bLogDebugInfo)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("   Applying hit impulse dir = ", string(Normal(DeathHitMomentum))), ", base magnitude = "), string(VSize(DeathHitMomentum))), ", multiplier = "), string(DeathHitDamageType.static.GetRagdollDeathImpactMomentumMultiplier())), " to bone = "), string(TakeHitBone)));
		Log(Concat_StrStr("...DeathHitMomentum before scaling=", string(DeathHitMomentum)));
		Log(Concat_StrStr("...multiplier=", string(DeathHitDamageType.static.GetRagdollDeathImpactMomentumMultiplier())));
		ScaledMomentum = Multiply_VectorFloat(DeathHitMomentum, DeathHitDamageType.static.GetRagdollDeathImpactMomentumMultiplier());
		Log(Concat_StrStr("...DeathHitMomentum after scaling=", string(ScaledMomentum)));
	}
	HavokImpartCOMImpulse(ScaledMomentum, TakeHitBone);
	return;
}

simulated event BecomeRagdoll()
{
	local int i;

	if(Not_PreBool(bHasRagdolledLocally))
	{
		bHasRagdolledLocally = true;
		bReplicateMovement = false;
		bUseCompressedPosition = false;
		bBlockPlayers = false;
		if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)))
		{
			Role = ROLE_DumbProxy;
			if(AndAnd_BoolBool(bRagdollingOnReplication, OrOr_BoolBool(OrOr_BoolBool(NotEqual_FloatFloat(LocationAtRagdollStartOnServer.X, 0.0000000), NotEqual_FloatFloat(LocationAtRagdollStartOnServer.Y, 0.0000000)), NotEqual_FloatFloat(LocationAtRagdollStartOnServer.Z, 0.0000000))))
			{
				SetLocation(LocationAtRagdollStartOnServer);
			}
		}
		else
		{
			RemoteRole = ROLE_DumbProxy;
			bHasRagdolledOnServer = true;
			LocationAtRagdollStartOnServer = Location;
		}
		bAlwaysRelevant = true;
	}
	if(EqualEqual_IntInt(int(Physics), int(16)))
	{
		return;
	}
	NotifyReadyToRagdoll();
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer)))
	{
		StopAnimating(false);
		bPhysicsAnimUpdate = false;
		bReplicateAnimations = false;
		if(NotEqual_ObjectObject(GetHands(), none))
		{
			GetHands().StopAnimating();
		}
		bHavokCharacterCollisions = false;
		SetPhysics(16);
		i = 0;
		J0x13D:

		if(Less_IntInt(i, BoneLinearDamping.Length))
		{
			HavokSetLinearDamping(BoneLinearDamping[i].Damping, BoneLinearDamping[i].BoneName);
			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0x13D;
		}
		i = 0;
		J0x184:

		if(Less_IntInt(i, BoneAngularDamping.Length))
		{
			HavokSetAngularDamping(BoneAngularDamping[i].Damping, BoneAngularDamping[i].BoneName);
			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0x184;
		}
		if(AndAnd_BoolBool(bRagdollDeathUsesImpactMomentum, Not_PreBool(IsIncapacitated())))
		{
			ApplyDeathHitMomentumToRagdoll();
		}
		if(bRagdollDeathPushesAwayFromDoor)
		{
			PushAwayFromDoors();
		}
		if(IsIncapacitated())
		{
			StartTwitching();
		}
	}
	else
	{
		SetPhysics(0);
		SetCollision(false, false, false);
	}
	SetCollisionSize(72.0000000, CollisionHeight);
	return;
}

simulated function NotifyReadyToRagdoll()
{
	return;
}

simulated function PlayDying(Class<DamageType> DamageType, Vector HitLoc, Vector HitMomentum, Vector inKillerLocation)
{
	local SwatGamePlayerController LocalPlayerController;
	local HandheldEquipment theActiveItem;
	local HandheldEquipmentModel theThirdPersonModel;

	if(Level.IsCOOPServer)
	{
		if(AndAnd_BoolBool(IsA('SwatAI'), IsArrested()))
		{
			theActiveItem = GetActiveItem();
			if(NotEqual_ObjectObject(theActiveItem, none))
			{
				theThirdPersonModel = theActiveItem.GetThirdPersonModel();
				if(NotEqual_ObjectObject(theThirdPersonModel, none))
				{
					theThirdPersonModel.bTearOff = true;
				}
			}
		}
	}
	bPlayedDeath = true;
	DeathHitLocation = HitLoc;
	DeathHitDamageType = DamageType;
	DeathHitMomentum = HitMomentum;
	KillerLocation = inKillerLocation;
	bClientsShouldCallPlayDying = true;
	LocalPlayerController = SwatGamePlayerController(Level.GetLocalPlayerController());
	if(AndAnd_BoolBool(NotEqual_ObjectObject(LocalPlayerController, none), EqualEqual_ObjectObject(LocalPlayerController.ViewTarget, self)))
	{
		if(NotEqual_FloatFloat(KillerLocation.Z, -10000.0000000))
		{
			LocalPlayerController.SetKillerLocation(inKillerLocation);
		}
		LocalPlayerController.StartDeathCam();
	}
	MPLog("...calling InterruptState().");
	InterruptState('Dying');
	if(NotEqual_ObjectObject(Controller, none))
	{
		Controller.InterruptState('Dying');
	}
	else
	{
		if(NotEqual_ObjectObject(CachedPlayerControllerForOptiwand, none))
		{
			CachedPlayerControllerForOptiwand.InterruptState('Dying');
		}
	}
	GotoState('Dying');
	ResetNonlethalEffects();
	BecomeRagdoll();
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		if(EqualEqual_ObjectObject(DeadPawnTearOffTimer, none))
		{
			DeadPawnTearOffTimer = Class'Engine.Timer'.static.Allocate(self).;
			Construct_Void();
			DeadPawnTearOffTimer.__TimerDelegate__Delegate = TearOffPawn;
			DeadPawnTearOffTimer.StartTimer(5.0000000, false);
		}
	}
	return;
}

function TearOffPawn()
{
	bTearOff = true;
	return;
}

simulated event DisableRagdoll(optional bool bKeepHavokPhysics)
{
	if(EqualEqual_IntInt(int(Physics), int(16)))
	{
		if(Not_PreBool(bKeepHavokPhysics))
		{
			if(NotEqual_ObjectObject(LimbIdleTimer, none))
			{
				LimbIdleTimer.Destroy();
				LimbIdleTimer = none;
			}
			if(NotEqual_ObjectObject(LimbTwitchTimer, none))
			{
				LimbTwitchTimer.Destroy();
				LimbTwitchTimer = none;
			}
			SetPhysics(0);
		}
		HavokActivate(false);
		bIsDisabledRagdoll = true;
	}
	return;
}

simulated state Dying
{
	simulated function BeginState()
	{
		MPLog(Concat_StrStr(string(self), " entering state 'Dying'."));
		super.BeginState();
		return;
	}

	simulated function EndState()
	{
		MPLog(Concat_StrStr(string(self), " leaving state 'Dying'."));
		return;
	}

	simulated function Timer()
	{
		if(Not_PreBool(IsIncapacitated()))
		{
			DisableRagdoll();
		}
		else
		{
			SetTimer(RagdollSimulationTimeout, false);
		}
		return;
	}

	simulated function PostTakeDamage(int Damage, Pawn InstigatedBy, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType)
	{
		if(EqualEqual_IntInt(int(Physics), int(16)))
		{
		}
		return;
	}

	event FellOutOfWorld(Actor.eKillZType KillType)
	{
		if(EqualEqual_IntInt(int(KillType), int(1)))
		{
			return;
		}
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[ckline]: !!!! WARNING !!!!! Pawn ", string(self)), " in state SwatRagdollPawn.Dying and Physics="), string(GetEnum(Enum'Engine.Actor.EPhysics', int(Physics)))), " fell out of the world and had Super::FellOutOfWorld() called on it! Contact a programmer -- This shouldn't happen, and it might screw up objectives, leadership scores, etc. "));
		super.FellOutOfWorld(KillType);
		return;
	}
Begin:

	MPLog(Concat_StrStr(string(self), " Begin: of state 'Dying'."));
	bInvulnerableBody = false;
	SetTimer(RagdollSimulationTimeout, false);
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		if(AndAnd_BoolBool(IsA('NetPlayer'), Not_PreBool(NetPlayer(self).IsTheVIP())))
		{
			NetPlayer(self).GetNetTeam().AddNetPlayerToDestroy(NetPlayer(self));
		}
	}
	stop;
}

defaultproperties
{
	bRagdollDeathUsesImpactMomentum=true
	bRagdollDeathPushesAwayFromDoor=true
	RagdollPushAwayFromDoorVelocityMagnitude=85.0000000
	RagdollSimulationTimeout=10.0000000
	HavokDataClass=Class'SwatGame.SwatOfficerRagdollParams'
}