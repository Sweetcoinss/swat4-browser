class Pump1SG extends Shotgun
	config(SwatEquipment)
	hidecategories(Karma);

defaultproperties
{
	MagazineSize=8
	PlayerAmmoOption=/* Array type was not detected. */
	EnemyUsesAmmo=/* Array type was not detected. */
	MuzzleVelocity=20384.0000000
	MaxAimError=60.0000000
	SmallAimErrorRecoveryRate=2.0000000
	LargeAimErrorRecoveryRate=12.0000000
	AimErrorBreakingPoint=3.5000000
	LookAimErrorPenaltyFactor=0.0001250
	MaxLookAimErrorPenalty=10.0000000
	InjuredAimErrorPenalty=1.5000000
	MaxInjuredAimErrorPenalty=6.5000000
	EquippedAimErrorPenalty=9.0000000
	FiredAimErrorPenalty=1.0000000
	WalkToRunAimErrorPenalty=6.0000000
	StandToWalkAimErrorPenalty=2.0000000
	StandingAimError=1.5000000
	WalkingAimError=2.5000000
	RunningAimError=8.0000000
	CrouchingAimError=0.7500000
	RecoilBackDuration=0.0500000
	RecoilForeDuration=0.3500000
	RecoilMagnitude=1000.0000000
	Range=4000
	ThirdPersonModelClass=Class'SwatEquipmentModels.Pump1_ThirdPerson'
	Description="Pistol Grip Pump Shotgun"
	FriendlyName="Pistol Grip Pump Shotgun"
	ShouldHaveFirstPersonModel=false
}