class CSBallLauncher extends RoundBasedWeapon
	config(SwatEquipment)
	hidecategories(Karma);

var config Class<CSBallBase> CSBallClass;

simulated function PostBeginPlay()
{
	super(HandheldEquipment).PostBeginPlay();
	AssertWithDescription(NotEqual_ObjectObject(CSBallClass, none), "[tcohen] The CSBallLauncher's CSBallClass resolves to None.  Please set it in SwatEquipment.ini, [SwatEquipment.CSBallLauncher].");
	return;
}

simulated function BallisticFire(Vector StartTrace, Vector EndTrace)
{
	local Vector ShotVector;
	local CSBallBase Ball;
	local Vector BallStart;

	ShotVector = Normal(Subtract_VectorVector(EndTrace, StartTrace));
	BallStart = Add_VectorVector(StartTrace, Multiply_VectorFloat(ShotVector, 20.0000000));
	Ball = Spawn(CSBallClass, self,, BallStart,, true);
	assert(NotEqual_ObjectObject(Ball, none));
	Ball.Velocity = Multiply_VectorFloat(ShotVector, MuzzleVelocity);
	return;
}

defaultproperties
{
	CSBallClass=Class'SwatDesignerClasses.CSBall'
	MagazineSize=200
	PlayerAmmoOption=/* Array type was not detected. */
	EnemyUsesAmmo=/* Array type was not detected. */
	MuzzleVelocity=4000.0000000
	bCanShootThroughGlass=false
	bAimAtHead=true
	MaxAimError=60.0000000
	SmallAimErrorRecoveryRate=1.5000000
	LargeAimErrorRecoveryRate=10.0000000
	AimErrorBreakingPoint=3.5000000
	LookAimErrorPenaltyFactor=0.0001250
	MaxLookAimErrorPenalty=10.0000000
	InjuredAimErrorPenalty=0.5000000
	MaxInjuredAimErrorPenalty=2.5000000
	EquippedAimErrorPenalty=7.0000000
	FiredAimErrorPenalty=0.5000000
	WalkToRunAimErrorPenalty=5.0000000
	StandToWalkAimErrorPenalty=2.2500000
	StandingAimError=1.0000000
	WalkingAimError=2.5000000
	RunningAimError=10.5000000
	CrouchingAimError=0.5000000
	RecoilBackDuration=0.0250000
	RecoilForeDuration=0.0350000
	RecoilMagnitude=100.0000000
	HasAttachedFlashlight=true
	FlashlightPosition_1stPerson=(X=22.0000000,Y=1.0000000,Z=10.0000000)
	FlashlightPosition_3rdPerson=(X=2.5000000,Y=-31.5000000,Z=6.6000000)
	FlashlightRotation_3rdPerson=(Pitch=0,Yaw=-16384,Roll=0)
	AvailableFireMode=/* Array type was not detected. */
	RagdollDeathImpactMomentumMultiplier=0.0000000
	Range=4000
	FirstPersonModelClass=Class'SwatEquipmentModels.Paintball_FirstPerson'
	ThirdPersonModelClass=Class'SwatEquipmentModels.Paintball_ThirdPerson'
	Description="The Pepper-ball gun is based on technology originally designed for recreational paintball.  Compressed Carbon Dioxide ejects the ammunition at relatively high velocities.  The Pepper-ball gun allows officers to quickly deploy OC at specific targets, in more easily controlled quantities, and at significantly longer ranges than a grenade or standard pepper spray.  With the large ammunition hopper this weapon never needs to be reloaded under normal operating conditions."
	FriendlyName="Pepper-ball"
	GUIImage=Texture'gui_tex.equip_pepperballgun'
	ZoomedFOV=60.0000000
	UseAnimationRate=2.0000000
}