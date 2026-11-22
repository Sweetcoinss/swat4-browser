class BadguyMP5SMG extends SubMachineGun
	config(SwatEquipment)
	hidecategories(Karma);

defaultproperties
{
	PlayerAmmoOption=/* Array type was not detected. */
	EnemyUsesAmmo=/* Array type was not detected. */
	MuzzleVelocity=20185.0000000
	MaxAimError=60.0000000
	AimErrorBreakingPoint=2.0000000
	LookAimErrorPenaltyFactor=0.0001250
	MaxLookAimErrorPenalty=9.0000000
	InjuredAimErrorPenalty=1.0000000
	MaxInjuredAimErrorPenalty=4.0000000
	EquippedAimErrorPenalty=6.5000000
	FiredAimErrorPenalty=0.7500000
	WalkToRunAimErrorPenalty=6.0000000
	StandToWalkAimErrorPenalty=2.2500000
	StandingAimError=0.4500000
	WalkingAimError=1.0500000
	RunningAimError=6.2500000
	CrouchingAimError=0.2500000
	RecoilBackDuration=0.0500000
	RecoilForeDuration=0.4000000
	RecoilMagnitude=200.0000000
	AutoFireRecoilMagnitudeIncrement=25.0000000
	AvailableFireMode=/* Array type was not detected. */
	Range=4000
	ThirdPersonModelClass=Class'SwatEquipmentModels.BadguyMP5_ThirdPerson'
	Description="Default description for MP5SMG"
	FriendlyName="9mm Sub-Machine Gun"
	UnequipAnimationRate=1.5000000
	UseAnimationRate=0.5000000
	ShouldHaveFirstPersonModel=false
}