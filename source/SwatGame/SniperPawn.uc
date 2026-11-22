class SniperPawn extends SwatPawn implements IControllableThroughViewport
	config(SwatPawn)
	hidecategories(Karma);

var private int YawClampAngle "How many degrees this sniper is allowed to rotate on Yaw.";
var private int PitchClampAngle "How many degrees this sniper is allowed to rotate on Pitch.";
var string SniperName "Set this to either \"Sierra 1\" or \"Sierra 2\" based on which sniper team this pawn represents.";
var private config Material SniperOverlay;
var private config Class<FiredWeapon> SniperRifleClass;
var private FiredWeapon SniperRifle;
var private float CurrentFOV;
var config array<float> FOVLevels;
var config array<float> NoiseAmplitudeByFOVLevel;
var private int FOVIndex;
var private Rotator RotationOffset;
var private config float ReloadSoundTime;
var private Timer ReloadSoundTimer;
var private config float ReloadTime;
var private Timer ReloadTimer;
var private bool bReloading;
var private Rotator InitialRotation;
var private PerlinNoise PerlinNoiseYaw;
var private PerlinNoise PerlinNoisePitch;
var private float LastDeltaTime;
var private const config float kSniperBaseFrequency;
var private const config float kSniperMovementAddedFrequency;
var private const config float kSniperBaseAmplitude;
var private const config float kSniperMovementAmplitude;
var private const config float kSniperMovementZeroedSpeed;
var private const config float kSniperHorizontalNoiseDamping;
var private float ScaledMovementAmplitude;
var private float AddedMovementFrequency;

function PostBeginPlay()
{
	super.PostBeginPlay();
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		Destroy();
		return;
	}
	SniperRifle = Spawn(SniperRifleClass, self);
	SniperRifle.OnGivenToOwner();
	SniperRifle.Equip();
	InitialRotation = Rotation;
	PerlinNoiseYaw = Class'Engine.PerlinNoise'.static.Allocate(self).;
	Construct_Void();
	PerlinNoisePitch = Class'Engine.PerlinNoise'.static.Allocate(self).;
	Construct_Void();
	return;
}

function OnReloadSoundTimer()
{
	SniperRifle.TriggerEffectEvent('Reloaded');
	ReloadSoundTimer.Destroy();
	ReloadSoundTimer = none;
	if(EqualEqual_ObjectObject(ReloadTimer, none))
	{
		ReloadTimer = Spawn(Class'Engine.Timer');
		ReloadTimer.__TimerDelegate__Delegate = OnReloadTimer;
	}
	ReloadTimer.StartTimer(ReloadTime);
	return;
}

function OnReloadTimer()
{
	bReloading = false;
	ReloadTimer.Destroy();
	ReloadTimer = none;
	return;
}

function Actor GetViewportOwner()
{
	return self;
	return;
}

function string GetViewportType()
{
	return string(Name);
	return;
}

function string GetViewportName()
{
	return SniperName;
	return;
}

simulated function OnMouseAccelerated(out Vector MouseAccel)
{
	ScaledMovementAmplitude = kSniperMovementAmplitude;
	AddedMovementFrequency = kSniperMovementAddedFrequency;
	return;
}

function AdjustMouseAcceleration(out Vector MouseAccel)
{
	AddEqual_FloatFloat(MouseAccel.X, Multiply_FloatFloat(Multiply_FloatFloat(PerlinNoiseYaw.Noise1(Multiply_FloatFloat(Level.TimeSeconds, Add_FloatFloat(kSniperBaseFrequency, AddedMovementFrequency))), GetScaledNoiseAmplitude()), kSniperHorizontalNoiseDamping));
	AddEqual_FloatFloat(MouseAccel.Y, Multiply_FloatFloat(PerlinNoisePitch.Noise1(Multiply_FloatFloat(Level.TimeSeconds, Add_FloatFloat(kSniperBaseFrequency, AddedMovementFrequency))), GetScaledNoiseAmplitude()));
	ScaledMovementAmplitude = FMax(Subtract_FloatFloat(ScaledMovementAmplitude, Multiply_FloatFloat(LastDeltaTime, kSniperMovementZeroedSpeed)), 0.0000000);
	AddedMovementFrequency = FMax(Subtract_FloatFloat(AddedMovementFrequency, Multiply_FloatFloat(LastDeltaTime, kSniperMovementZeroedSpeed)), 0.0000000);
	return;
}

function float GetScaledNoiseAmplitude()
{
	return Multiply_FloatFloat(Multiply_FloatFloat(Add_FloatFloat(NoiseAmplitudeByFOVLevel[FOVIndex], ScaledMovementAmplitude), float(1024)), LastDeltaTime);
	return;
}

function OffsetViewportRotation(out Rotator ViewportRotation)
{
	return;
	return;
}

function string GetViewportDescription()
{
	return Concat_StrStr("x", string(Add_IntInt(FOVIndex, 1)));
	return;
}

simulated function bool CanIssueCommands()
{
	return false;
	return;
}

function Vector GetViewportLocation()
{
	return Location;
	return;
}

function Rotator GetViewportDirection()
{
	return Rotation;
	return;
}

function SetRotationToViewport(Rotator inNewRotation)
{
	SetRotation(inNewRotation);
	return;
}

function float GetViewportPitchClamp()
{
	return float(PitchClampAngle);
	return;
}

function float GetViewportYawClamp()
{
	return float(YawClampAngle);
	return;
}

function Material GetViewportOverlay()
{
	return SniperOverlay;
	return;
}

function bool ShouldDrawViewport()
{
	return Not_PreBool(bDeleteMe);
	return;
}

function bool ShouldDrawReticle()
{
	return false;
	return;
}

function float GetFOV()
{
	CurrentFOV = Lerp(0.3000000, CurrentFOV, FOVLevels[FOVIndex]);
	return CurrentFOV;
	return;
}

function HandleReload()
{
	if(SniperRifle.CanReload())
	{
		SniperRifle.ReloadedHook();
	}
	return;
}

function HandleFire()
{
	if(AndAnd_BoolBool(Not_PreBool(SniperRifle.NeedsReload()), Not_PreBool(bReloading)))
	{
		SniperRifle.TriggerEffectEvent('Fired');
		SniperRifle.Use();
		if(EqualEqual_ObjectObject(ReloadSoundTimer, none))
		{
			ReloadSoundTimer = Spawn(Class'Engine.Timer');
			ReloadSoundTimer.__TimerDelegate__Delegate = OnReloadSoundTimer;
		}
		ReloadSoundTimer.StartTimer(ReloadSoundTime);
		bReloading = true;
	}
	else
	{
		if(Not_PreBool(bReloading))
		{
			SniperRifle.TriggerEffectEvent('EmptyFired');
		}
	}
	return;
}

function HandleAltFire()
{
	FOVIndex = int(Percent_FloatFloat(float(Add_IntInt(FOVIndex, 1)), float(FOVLevels.Length)));
	SniperRifle.TriggerEffectEvent('ZoomModeChanged');
	return;
}

function Rotator GetOriginalDirection()
{
	return InitialRotation;
	return;
}

function float GetViewportPitchSpeed()
{
	return 0.5000000;
	return;
}

function float GetViewportYawSpeed()
{
	return 0.5000000;
	return;
}

function OnBeginControlling()
{
	PerlinNoiseYaw.Reinitialize();
	PerlinNoisePitch.Reinitialize();
	SetRotation(InitialRotation);
	return;
}

function OnEndControlling()
{
	return;
}

function Tick(float DeltaTime)
{
	LastDeltaTime = DeltaTime;
	return;
}

defaultproperties
{
	YawClampAngle=45
	PitchClampAngle=45
	SniperName="Sierra 1"
	SniperOverlay=Shader'HUD.SniperScopeShader'
	SniperRifleClass=Class'SwatEquipment.SniperRifle'
	FOVLevels[0]=90.0000000
	FOVLevels[1]=70.0000000
	FOVLevels[2]=45.0000000
	FOVLevels[3]=25.0000000
	NoiseAmplitudeByFOVLevel[0]=2.5000000
	NoiseAmplitudeByFOVLevel[1]=3.0000000
	NoiseAmplitudeByFOVLevel[2]=3.3000000
	NoiseAmplitudeByFOVLevel[3]=3.7000000
	ReloadSoundTime=1.0000000
	ReloadTime=1.0000000
	kSniperBaseFrequency=0.7500000
	kSniperBaseAmplitude=2.5000000
	kSniperMovementAmplitude=15.0000000
	kSniperMovementZeroedSpeed=2.0000000
	kSniperHorizontalNoiseDamping=0.3000000
	AnimBoneBase="bip01"
	AnimBoneSpineLow="Bip01_Spine1"
	AnimBoneRightShoulder="Bip01_R_UpperArm"
	AnimBoneHead="Bone01Eye"
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
	CrouchHeight=45.0000000
	Bob=0.0020000
	bPhysicsAnimUpdate=false
	bCollisionAvoidanceEnabled=false
	bActorShadows=false
	bHidden=true
	bStasis=false
	bCollideActors=false
	bCollideWorld=false
	bBlockActors=false
	bBlockPlayers=false
	bRotateToDesired=false
}