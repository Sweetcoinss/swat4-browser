class BadguyG36kMG extends MachineGun
	config(SwatEquipment)
	hidecategories(Karma);

defaultproperties
{
	PlayerAmmoOption=/* Array type was not detected. */
	EnemyUsesAmmo=/* Array type was not detected. */
	MuzzleVelocity=42893.0000000
	MaxAimError=60.0000000
	SmallAimErrorRecoveryRate=3.0000000
	LargeAimErrorRecoveryRate=7.0000000
	AimErrorBreakingPoint=2.5000000
	LookAimErrorPenaltyFactor=0.0001250
	MaxLookAimErrorPenalty=12.5000000
	InjuredAimErrorPenalty=1.0000000
	MaxInjuredAimErrorPenalty=5.5000000
	EquippedAimErrorPenalty=8.0000000
	FiredAimErrorPenalty=2.0000000
	WalkToRunAimErrorPenalty=5.0000000
	StandToWalkAimErrorPenalty=3.0000000
	StandingAimError=0.2000000
	WalkingAimError=1.6000000
	RunningAimError=8.0000000
	CrouchingAimError=0.1000000
	RecoilBackDuration=0.0200000
	RecoilForeDuration=0.5000000
	RecoilMagnitude=240.0000000
	AutoFireRecoilMagnitudeIncrement=60.0000000
	AvailableFireMode=/* Array type was not detected. */
	BurstShotCount=2
	BurstRateFactor=1.2500000
	Range=4000
	FirstPersonModelClass=Class'SwatEquipmentModels.G36K_FirstPerson'
	ThirdPersonModelClass=Class'SwatEquipmentModels.BadguyG36k_ThirdPerson'
	Description="The GB36s Assault Rifle is a lightweight full sized assault rifle originally developed in the 1990s for the German Bundeswehr.  It is now world renowned as an incredibly reliable all-around assault rifle.  Firing a mid-sized 5.56mm rifle round, this weapon is equipped with a firemode selector with a 2-round burst as well as fully automatic firing."
	FriendlyName="GB36s Assault Rifle"
	GUIImage=Texture'gui_tex.equip_G36K'
	ZoomedFOV=35.0000000
	ZoomTime=0.7500000
	ShouldHaveFirstPersonModel=false
}