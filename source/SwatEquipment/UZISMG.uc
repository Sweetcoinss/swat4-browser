class UZISMG extends SubMachineGun
	config(SwatEquipment)
	hidecategories(Karma);

defaultproperties
{
	PlayerAmmoOption=/* Array type was not detected. */
	EnemyUsesAmmo=/* Array type was not detected. */
	MuzzleVelocity=19508.0000000
	MaxAimError=60.0000000
	SmallAimErrorRecoveryRate=4.0000000
	LargeAimErrorRecoveryRate=15.0000000
	AimErrorBreakingPoint=1.5000000
	LookAimErrorPenaltyFactor=0.0001250
	MaxLookAimErrorPenalty=8.0000000
	InjuredAimErrorPenalty=1.0000000
	MaxInjuredAimErrorPenalty=2.5000000
	EquippedAimErrorPenalty=5.7500000
	FiredAimErrorPenalty=5.0000000
	WalkToRunAimErrorPenalty=5.0000000
	StandToWalkAimErrorPenalty=2.0000000
	StandingAimError=0.3500000
	WalkingAimError=1.0000000
	RunningAimError=8.5000000
	CrouchingAimError=0.2500000
	RecoilBackDuration=0.0200000
	RecoilForeDuration=0.5000000
	RecoilMagnitude=200.0000000
	AutoFireRecoilMagnitudeIncrement=50.0000000
	AvailableFireMode=/* Array type was not detected. */
	BurstRateFactor=1.2500000
	Range=4000
	FirstPersonModelClass=Class'SwatEquipmentModels.Uzi_FirstPerson'
	ThirdPersonModelClass=Class'SwatEquipmentModels.UZI_ThirdPerson'
	Description="The Gal is a compact and reliable sub-machinegun that was developed in the early fifties in Israel.  It has a very high rate of fire and can be hard to control when fired in full auto mode.  This model is equipped with a suppressor making it a more stealthy choice.    Since the weapon is not normally used by SWAT it is not equipped with a tactical flashlight."
	FriendlyName="Gal Sub-machinegun"
	GUIImage=Texture'gui_tex.equip_Uzi'
	ZoomedFOV=60.0000000
}