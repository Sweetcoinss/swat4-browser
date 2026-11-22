class NetPlayer extends SwatPlayer implements IAmUsedByToolkit
	native
	config(SwatPawn)
	hidecategories(Karma);

const MAX_CLIPS = 10;

var private DynamicLoadOutSpec DynamicLoadOutSpec;
var Material ReplicatedSkins[6];
var Class<Actor> ReplicatedLoadOutSpec[25];
var private bool bThisPlayerIsTheVIP;
var private float QualifyTime;
var private Vector BeingCuffedTargetLocation;
var private Rotator BeingCuffedTargetRotation;
var private config float IdealCuffingDistanceBetweenPawns;
var private int TeamNumber;
var Mesh VIPMesh;
var private bool bLoadOutInitialized;
var private int LoadOutSpecCount;
var private int SkinsCount;
var private HandheldEquipment.Pocket CurrentWeaponPocket;
var private int CurrentAmmoCounts[10];
var private int CurrentClip;
var SwatGUIConfig.eVoiceType VoiceType;
var int SwatPlayerID;
var private config Material ViewportOverlayMaterial;

replication
{
	// Pos:0x000
	reliable if(EqualEqual_IntInt(int(Role), int(ROLE_Authority)))
		LoadOutSpecCount, ReplicatedLoadOutSpec,
		ReplicatedSkins, SkinsCount,
		SwatPlayerID, VoiceType,
		bThisPlayerIsTheVIP;

	// Pos:0x00D
	reliable if(EqualEqual_IntInt(int(Role), int(ROLE_Authority)))
		OnDoorUnlocked;

	// Pos:0x01A
	reliable if(EqualEqual_IntInt(int(Role), int(ROLE_Authority)))
		CurrentAmmoCounts, CurrentClip,
		CurrentWeaponPocket;
}

simulated function string UniqueID()
{
	return Concat_StrStr("SwatNetPlayer", string(SwatPlayerID));
	return;
}

function InitializeReplicatedCounts()
{
	local int i;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---NetPlayer::InitializeReplicatedCounts()."));
	}
	assert(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)));
	LoadOutSpecCount = 0;
	i = 0;
	J0x7B:

	if(Less_IntInt(i, int(25)))
	{
		if(NotEqual_ObjectObject(ReplicatedLoadOutSpec[i], none))
		{
			AddAdd_PreInt(LoadOutSpecCount);
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x7B;
	}
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr("...LoadOutSpecCount=", string(LoadOutSpecCount)));
	}
	SkinsCount = 0;
	i = 0;
	J0xFA:

	if(Less_IntInt(i, int(6)))
	{
		if(NotEqual_ObjectObject(ReplicatedSkins[i], none))
		{
			AddAdd_PreInt(SkinsCount);
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0xFA;
	}
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr("...SkinsCount=", string(SkinsCount)));
	}
	return;
}

// Export UNetPlayer::execAllVarsHaveReplicated(FFrame&, void* const)
native event bool AllVarsHaveReplicated();

simulated event PostNetBeginPlay()
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---NetPlayer::PostNetBeginPlay()."));
	}
	super.PostNetBeginPlay();
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		if(AllVarsHaveReplicated())
		{
			PostReplication();
			bLoadOutInitialized = true;
		}
	}
	else
	{
		bLoadOutInitialized = true;
	}
	if(IsTheVIP())
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog("...Yo! This guy is the VIP.");
		}
		SwitchToMesh(VIPMesh);
	}
	RefreshCameraEffects(self);
	return;
}

simulated event PostBeginPlay()
{
	super.PostBeginPlay();
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		VoiceType = SwatGamePlayerController(Controller).VoiceType;
	}
	return;
}

simulated event PostReplication()
{
	local OfficerLoadOut newLoadOut;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---NetPlayer::PostReplication()."));
	}
	bLoadOutInitialized = true;
	assert(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)));
	if(EqualEqual_IntInt(int(Role), int(ROLE_AutonomousProxy)))
	{
		InitializeHands();
	}
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog("...Spawning the loadout.");
	}
	if(EqualEqual_IntInt(GetTeamNumber(), 0))
	{
		if(IsTheVIP())
		{
			newLoadOut = Spawn(Class'SwatGame.OfficerLoadOut', self, 'VIPLoadOut');
		}
		else
		{
			newLoadOut = Spawn(Class'SwatGame.OfficerLoadOut', self, 'EmptyMultiplayerOfficerLoadOut');
		}
	}
	else
	{
		newLoadOut = Spawn(Class'SwatGame.OfficerLoadOut', self, 'EmptyMultiplayerSuspectLoadOut');
	}
	assert(NotEqual_ObjectObject(newLoadOut, none));
	GetLoadoutSpec();
	CopyReplicatedSpecToDynamicSpec();
	newLoadOut.Initialize(DynamicLoadOutSpec);
	ReceiveLoadOut(newLoadOut);
	if(NotEqual_IntInt(int(GetDesiredItemPocket()), int(24)))
	{
		CheckDesiredItemAndEquipIfNeeded();
	}
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(string(self), " has name: "), GetHumanReadableName()));
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetStandingWalkAnimSet()
{
	local LoadOut theLoadOut;

	theLoadOut = GetLoadOut();
	if(AndAnd_BoolBool(NotEqual_ObjectObject(theLoadOut, none), theLoadOut.HasHeavyArmor()))
	{
		return 6;
	}
	else
	{
		return 5;
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetStandingRunAnimSet()
{
	local LoadOut theLoadOut;

	theLoadOut = GetLoadOut();
	if(AndAnd_BoolBool(NotEqual_ObjectObject(theLoadOut, none), theLoadOut.HasHeavyArmor()))
	{
		return 2;
	}
	else
	{
		return 1;
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetCrouchingAnimSet()
{
	local LoadOut theLoadOut;

	theLoadOut = GetLoadOut();
	if(AndAnd_BoolBool(NotEqual_ObjectObject(theLoadOut, none), theLoadOut.HasHeavyArmor()))
	{
		return 10;
	}
	else
	{
		return 9;
	}
	return;
}

function MoveIntoBeingCuffedPosition(Pawn Arrester)
{
	local float directionX, directionY;

	assert(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)));
	directionX = Cos(Multiply_FloatFloat(float(Arrester.Rotation.Yaw), 0.0000959));
	directionY = Sin(Multiply_FloatFloat(float(Arrester.Rotation.Yaw), 0.0000959));
	BeingCuffedTargetLocation = Arrester.Location;
	AddEqual_FloatFloat(BeingCuffedTargetLocation.X, Multiply_FloatFloat(directionX, IdealCuffingDistanceBetweenPawns));
	AddEqual_FloatFloat(BeingCuffedTargetLocation.Y, Multiply_FloatFloat(directionY, IdealCuffingDistanceBetweenPawns));
	BeingCuffedTargetLocation.Z = Location.Z;
	BeingCuffedTargetRotation = Arrester.Rotation;
	GotoState('MovingIntoBeingCuffedPosition');
	return;
}

function StopMovingIntoBeingCuffedPosition()
{
	assert(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)));
	GotoState('None');
	return;
}

simulated function OnArrestBegan(Pawn Arrester)
{
	local HandheldEquipment IAmCuffedEquipment;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(string(self), "---NetPlayer::OnArrestBegan(). Arrester="), string(Arrester)));
	}
	assert(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)));
	super(SwatPawn).OnArrestBegan(Arrester);
	LastArrester = SwatPlayer(Arrester);
	InterruptState('BeingCuffed');
	if(NotEqual_ObjectObject(Controller, none))
	{
		Controller.InterruptState('BeingCuffed');
	}
	if(NotEqual_ObjectObject(Controller, none))
	{
		Controller.GotoState('BeingCuffed');
	}
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		MoveIntoBeingCuffedPosition(Arrester);
		IAmCuffedEquipment = HandheldEquipment(GetLoadOut().GetItemAtPocket(15));
		AssertWithDescription(NotEqual_ObjectObject(IAmCuffedEquipment, none), "[mcj] I'm being arrested but have no IAmCuffed equipment.");
		SetDesiredItemPocket(15);
		CheckDesiredItemAndEquipIfNeeded();
	}
	return;
}

simulated function OnArrestedSwatPawn(Pawn Arrester)
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(string(self), "---NetPlayer::OnArrestedSwatPawn(). Arrester="), string(Arrester)));
	}
	super(SwatPawn).OnArrestedSwatPawn(Arrester);
	ChangeAnimation();
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		StopMovingIntoBeingCuffedPosition();
		SwatGamePlayerController(Controller).OnArrested();
	}
	return;
}

simulated function OnArrestInterrupted(Pawn Arrester)
{
	super(SwatPawn).OnArrestInterrupted(Arrester);
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(string(self), "---NetPlayer::OnArrestInterrupted(). Arrester="), string(Arrester)));
	}
	if(NotEqual_ObjectObject(Controller, none))
	{
		Controller.GotoState('PlayerWalking');
	}
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		if(NotEqual_ObjectObject(Controller, Level.GetLocalPlayerController()))
		{
			PlayerController(Controller).ClientGotoState('PlayerWalking', 'Begin');
		}
		StopMovingIntoBeingCuffedPosition();
		DoDefaultEquip();
	}
	return;
}

simulated function bool CanBeUsedByToolkitNow()
{
	return AndAnd_BoolBool(IsArrested(), IsTheVIP());
	return;
}

simulated function OnUsingByToolkitBegan(Pawn Unarrester)
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(string(self), "---NetPlayer::OnUsingByToolkitBegan(). Unarrester="), string(Unarrester)));
	}
	Controller.GotoState('BeingUncuffed');
	PlayerController(Controller).ClientGotoState('BeingUncuffed', 'Begin');
	SwatGameInfo(Level.Game).GameEvents.PawnUnarrestBegan.Triggered(Unarrester, self);
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		MoveIntoBeingCuffedPosition(Unarrester);
	}
	return;
}

simulated function OnUsedByToolkit(Pawn Unarrester)
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(string(self), "---NetPlayer::OnUsedByToolkit(). Unarrester="), string(Unarrester)));
	}
	OnUnarrestedSwatPawn(Unarrester);
	SwatGamePlayerController(Controller).OnUnarrested();
	SwatGameInfo(Level.Game).GameEvents.PawnUnarrested.Triggered(Unarrester, self);
	Controller.GotoState('PlayerWalking');
	PlayerController(Controller).ClientGotoState('PlayerWalking', 'Begin');
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		StopMovingIntoBeingCuffedPosition();
		DoDefaultEquip();
	}
	return;
}

simulated function OnUsingByToolkitInterrupted(Pawn Unarrester)
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(string(self), "---NetPlayer::OnUsingByToolkitInterrupted(). Unarrester="), string(Unarrester)));
	}
	Controller.GotoState('PlayerWalking');
	PlayerController(Controller).ClientGotoState('PlayerWalking', 'Begin');
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		StopMovingIntoBeingCuffedPosition();
	}
	return;
}

simulated function float GetQualifyTimeForToolkit()
{
	return QualifyTime;
	return;
}

simulated function SetPlayerSkins(OfficerLoadOut inLoadOut)
{
	super.SetPlayerSkins(inLoadOut);
	ReplicatedSkins[0] = Skins[0];
	ReplicatedSkins[1] = Skins[1];
	ReplicatedSkins[2] = Skins[2];
	ReplicatedSkins[3] = Skins[3];
	return;
}

simulated function PrintLoadOutSpecToMPLog()
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr("DynamicLoadOutSpec of ", string(self)), " contains:"));
		GetLoadoutSpec().PrintLoadOutSpecToMPLog();
	}
	return;
}

simulated function SetPocketItemClass(HandheldEquipment.Pocket Pocket, Class<Actor> Item)
{
	GetLoadoutSpec().LoadOutSpec[int(Pocket)] = Item;
	ReplicatedLoadOutSpec[int(Pocket)] = Item;
	return;
}

simulated function SetPocketItemClassName(HandheldEquipment.Pocket Pocket, string ItemClassName)
{
	local Class<Actor> ItemClass;

	if(NotEqual_StrStr(ItemClassName, ""))
	{
		ItemClass = Class<Actor>(DynamicLoadObject(ItemClassName, Class'Core.Class'));
	}
	SetPocketItemClass(Pocket, ItemClass);
	return;
}

simulated function Class GetPocketItem(HandheldEquipment.Pocket Pocket)
{
	if(Level.GetEngine().EnableDevTools)
	{
		if(EqualEqual_ObjectObject(GetLoadoutSpec().LoadOutSpec[int(Pocket)], none))
		{
			MPLog(Concat_StrStr(Concat_StrStr(string(self), " in NetPlayer::GetPocketItem(). Item was 'None' in pocket="), string(Pocket)));
		}
	}
	return GetLoadoutSpec().LoadOutSpec[int(Pocket)];
	return;
}

simulated function string GetHumanReadableName()
{
	return super.GetHumanReadableName();
	return;
}

simulated function int GetTeamNumber()
{
	return TeamNumber;
	return;
}

simulated function NetTeam GetNetTeam()
{
	local SwatGameReplicationInfo SGRI;

	SGRI = SwatGameReplicationInfo(Level.GetGameReplicationInfo());
	return NetTeam(SGRI.Teams[GetTeamNumber()]);
	return;
}

function SetIsVIP()
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---NetPlayer::SetIsVIP()."));
	}
	bThisPlayerIsTheVIP = true;
	Label = 'VIP';
	return;
}

simulated function bool IsTheVIP()
{
	return bThisPlayerIsTheVIP;
	return;
}

simulated function OnDoorUnlocked(SwatDoor TheDoor)
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(string(self), "---NetPlayer::OnDoorUnlocked(). TheDoor="), string(TheDoor)));
	}
	assert(NotEqual_ObjectObject(TheDoor, none));
	TheDoor.OnUnlocked();
	return;
}

simulated function DynamicLoadOutSpec GetLoadoutSpec()
{
	if(EqualEqual_ObjectObject(DynamicLoadOutSpec, none))
	{
		if(IsTheVIP())
		{
			DynamicLoadOutSpec = Spawn(Class'SwatGame.DynamicLoadOutSpec', none, 'DefaultVIPLoadOut');
		}
		else
		{
			DynamicLoadOutSpec = Spawn(Class'SwatGame.DynamicLoadOutSpec', none, 'DefaultMultiplayerLoadOut');
		}
		assert(NotEqual_ObjectObject(DynamicLoadOutSpec, none));
	}
	return DynamicLoadOutSpec;
	return;
}

private simulated function CopyReplicatedSpecToDynamicSpec()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, int(25)))
	{
		DynamicLoadOutSpec.LoadOutSpec[i] = ReplicatedLoadOutSpec[i];
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	i = 0;
	J0x46:

	if(Less_IntInt(i, int(6)))
	{
		DynamicLoadOutSpec.MaterialSpec[i] = ReplicatedSkins[i];
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x46;
	}
	return;
}

simulated function TakeDamageEffectsHook(int Damage, Pawn EventInstigator, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType)
{
	super(Actor).TakeDamageEffectsHook(Damage, EventInstigator, HitLocation, Momentum, DamageType);
	if(OrOr_BoolBool(LessEqual_IntInt(Damage, 0), EqualEqual_NameName(DamageType.Name, 'LessLethalSG')))
	{
		return;
	}
	if(Greater_IntInt(Health, 0))
	{
		if(IsIntenseInjury())
		{
			TriggerEffectEvent('ReactedInjuryIntense');
		}
		else
		{
			TriggerEffectEvent('ReactedInjuryNormal');
		}
	}
	return;
}

simulated function OnEquippingFinished()
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---NetPlayer::OnEquippingFinished()."));
	}
	super.OnEquippingFinished();
	UpdateAmmoInfo();
	return;
}

simulated function OnUsingFinished()
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---NetPlayer::OnUsingFinished()."));
	}
	super.OnUsingFinished();
	UpdateAmmoInfo();
	return;
}

simulated function OnReloadingFinished()
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---NetPlayer::OnReloadingFinished()."));
	}
	super.OnReloadingFinished();
	UpdateAmmoInfo();
	return;
}

simulated function UpdateAmmoInfo()
{
	local FiredWeapon Weapon;
	local int i;
	local string TheLog;

	if(AndAnd_BoolBool(NotEqual_IntInt(int(Level.NetMode), int(NM_ListenServer)), NotEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer))))
	{
		return;
	}
	Weapon = FiredWeapon(GetActiveItem());
	if(EqualEqual_ObjectObject(Weapon, none))
	{
		return;
	}
	CurrentWeaponPocket = Weapon.GetPocket();
	CurrentClip = Weapon.Ammo.GetCurrentClip();
	if(Level.GetEngine().EnableDevTools)
	{
		TheLog = Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "::UpdateAmmoInfo() ... CurrentWeaponPocket = "), string(CurrentWeaponPocket)), ", CurrentClip = "), string(CurrentClip)), ", CurrentAmmoCounts = ");
	}
	i = 0;
	J0x124:

	if(Less_IntInt(i, 10))
	{
		CurrentAmmoCounts[i] = Weapon.Ammo.GetClip(i);
		if(Level.GetEngine().EnableDevTools)
		{
			TheLog = Concat_StrStr(Concat_StrStr(TheLog, string(CurrentAmmoCounts[i])), " ");
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x124;
	}
	if(Level.GetEngine().EnableDevTools)
	{
		Log(TheLog);
	}
	return;
}

simulated event OnAmmoInfoChanged()
{
	local FiredWeapon Weapon;
	local int i;

	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		return;
	}
	Weapon = FiredWeapon(GetActiveItem());
	if(EqualEqual_ObjectObject(Weapon, none))
	{
		return;
	}
	if(NotEqual_IntInt(int(CurrentWeaponPocket), int(Weapon.GetPocket())))
	{
		return;
	}
	Weapon.Ammo.SetCurrentClip(CurrentClip);
	i = 0;
	J0x7C:

	if(Less_IntInt(i, 10))
	{
		Weapon.Ammo.SetClip(i, CurrentAmmoCounts[i]);
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x7C;
	}
	Weapon.Ammo.UpdateHUD();
	return;
}

simulated function Material GetViewportOverlay()
{
	return ViewportOverlayMaterial;
	return;
}

simulated function Rotator GetViewportDirection()
{
	return GetAimRotation();
	return;
}

state MovingIntoBeingCuffedPosition
{
	private function UpdateBeingCuffedRotation()
	{
		FaceRotation(BeingCuffedTargetRotation);
		ClientFaceRotation(BeingCuffedTargetRotation);
		return;
	}

	private latent function UpdateBeingCuffedLocation()
	{
		local bool HasReachedTargetLocation;
		local float LastUpdateTime, DeltaTime;
		local Vector TargetLocationDelta, MovementDelta;

		LastUpdateTime = Level.TimeSeconds;
		J0x14:

		if(Not_PreBool(HasReachedTargetLocation))
		{
			Sleep(0.0000000);
			DeltaTime = Subtract_FloatFloat(Level.TimeSeconds, LastUpdateTime);
			LastUpdateTime = Level.TimeSeconds;
			TargetLocationDelta = Subtract_VectorVector(BeingCuffedTargetLocation, Location);
			MovementDelta = Multiply_VectorFloat(Multiply_VectorFloat(Normal(TargetLocationDelta), GroundSpeed), DeltaTime);
			if(GreaterEqual_FloatFloat(VSizeSquared2D(MovementDelta), VSizeSquared2D(TargetLocationDelta)))
			{
				MovementDelta = TargetLocationDelta;
				HasReachedTargetLocation = true;
			}
			Move(MovementDelta);
			// [Loop Continue]
			goto J0x14;
		}
		return;
	}
Begin:

	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		UpdateBeingCuffedRotation();
		UpdateBeingCuffedLocation();
	}
	stop;
}

defaultproperties
{
	QualifyTime=5.0000000
	IdealCuffingDistanceBetweenPawns=50.0000000
	TeamNumber=-1
	VIPMesh=SkeletalMesh'SWATMaleAnimation.MaleSuit2'
	ViewportOverlayMaterial=Texture'HUD.officerviewport'
}