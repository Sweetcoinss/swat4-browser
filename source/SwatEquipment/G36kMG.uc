class G36kMG extends MachineGun
	config(SwatEquipment)
	hidecategories(Karma);

defaultproperties
{
	PlayerAmmoOption=/* Array type was not detected. */
	EnemyUsesAmmo=/* Array type was not detected. */
	MuzzleVelocity=42893.0000000
	MaxAimError=60.0000000
	SmallAimErrorRecoveryRate=1.7500000
	LargeAimErrorRecoveryRate=9.0000000
	AimErrorBreakingPoint=3.0000000
	LookAimErrorPenaltyFactor=0.0001250
	MaxLookAimErrorPenalty=13.0000000
	InjuredAimErrorPenalty=1.5000000
	MaxInjuredAimErrorPenalty=5.5000000
	EquippedAimErrorPenalty=8.5000000
	FiredAimErrorPenalty=2.0000000
	WalkToRunAimErrorPenalty=5.0000000
	StandToWalkAimErrorPenalty=3.0000000
	StandingAimError=0.2000000
	WalkingAimError=1.8500000
	RunningAimError=10.0000000
	CrouchingAimError=0.1000000
	RecoilBackDuration=0.0200000
	RecoilForeDuration=0.5000000
	RecoilMagnitude=240.0000000
	AutoFireRecoilMagnitudeIncrement=65.0000000
	HasAttachedFlashlight=true
	FlashlightPosition_1stPerson=(X=14.0000000,Y=-4.0000000,Z=11.0000000)
	FlashlightPosition_3rdPerson=(X=2.2000000,Y=-31.0000000,Z=8.9000000)
	FlashlightRotation_3rdPerson=(Pitch=0,Yaw=-16384,Roll=0)
	AvailableFireMode=/* Array type was not detected. */
	BurstShotCount=2
	BurstRateFactor=1.2500000
	Range=4000
	FirstPersonModelClass=Class'SwatEquipmentModels.G36K_FirstPerson'
	ThirdPersonModelClass=Class'SwatEquipmentModels.G36k_ThirdPerson'
	Description="The GB36s Assault Rifle is a lightweight full sized assault rifle originally developed in the 1990s for the German Bundeswehr.  It is now world renowned as an incredibly reliable all-around assault rifle.  Firing a mid-sized 5.56mm (.223) rifle round, this weapon is equipped with a firemode selector with a 2-round burst as well as fully automatic firing."
	FriendlyName="GB36s Assault Rifle"
	GUIImage=Texture'gui_tex.equip_G36K'
	ZoomedFOV=35.0000000
	ZoomTime=0.7500000
}