class AK47MG extends MachineGun
	config(SwatEquipment)
	hidecategories(Karma);

defaultproperties
{
	PlayerAmmoOption=/* Array type was not detected. */
	EnemyUsesAmmo=/* Array type was not detected. */
	MuzzleVelocity=36186.0000000
	MaxAimError=60.0000000
	SmallAimErrorRecoveryRate=1.5000000
	LargeAimErrorRecoveryRate=6.0000000
	AimErrorBreakingPoint=2.7500000
	LookAimErrorPenaltyFactor=0.0001250
	MaxLookAimErrorPenalty=14.0000000
	InjuredAimErrorPenalty=2.0000000
	MaxInjuredAimErrorPenalty=6.7500000
	EquippedAimErrorPenalty=8.5000000
	FiredAimErrorPenalty=1.3500000
	WalkToRunAimErrorPenalty=5.0000000
	StandToWalkAimErrorPenalty=3.5000000
	StandingAimError=0.4000000
	WalkingAimError=2.0000000
	RunningAimError=10.5000000
	CrouchingAimError=0.3000000
	RecoilBackDuration=0.0150000
	RecoilForeDuration=0.7000000
	RecoilMagnitude=250.0000000
	AutoFireRecoilMagnitudeIncrement=70.0000000
	AvailableFireMode=/* Array type was not detected. */
	Range=4000
	FirstPersonModelClass=Class'SwatEquipmentModels.AK47_FirstPerson'
	ThirdPersonModelClass=Class'SwatEquipmentModels.AK47_ThirdPerson'
	Description="The AK-47 was developed in the Soviet Union in 1947 and became standard issue in the Soviet army in 1951.  It has remained in service in many third world armies as well as terrorist organizations around the world due to its dependability and the ease at which it can be maintained.  It has a slower rate of fire and lower muzzle velocity than the Colt M4A1, but uses a higher caliber bullet which makes it comparable to its American counterpart at short ranges.  Since the weapon is not normally used by SWAT it is not equipped with a tactical flashlight."
	FriendlyName="AK-47 Machinegun"
	GUIImage=Texture'gui_tex.equip_AK47'
	ZoomedFOV=50.0000000
	ZoomTime=1.0000000
}