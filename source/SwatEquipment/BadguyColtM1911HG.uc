class BadguyColtM1911HG extends Handgun
	config(SwatEquipment)
	hidecategories(Karma);

defaultproperties
{
	PlayerAmmoOption=/* Array type was not detected. */
	EnemyUsesAmmo=/* Array type was not detected. */
	MuzzleVelocity=12770.0000000
	MaxAimError=60.0000000
	SmallAimErrorRecoveryRate=1.0000000
	LargeAimErrorRecoveryRate=10.0000000
	AimErrorBreakingPoint=1.0000000
	InjuredAimErrorPenalty=0.5000000
	MaxInjuredAimErrorPenalty=1.0000000
	EquippedAimErrorPenalty=5.0000000
	FiredAimErrorPenalty=0.5000000
	WalkToRunAimErrorPenalty=5.0000000
	StandToWalkAimErrorPenalty=2.0000000
	StandingAimError=0.6500000
	WalkingAimError=1.0000000
	RunningAimError=7.0000000
	CrouchingAimError=0.3500000
	RecoilBackDuration=0.0200000
	RecoilForeDuration=0.4500000
	RecoilMagnitude=400.0000000
	Range=4000
	ThirdPersonModelClass=Class'SwatEquipmentModels.BadguyColtM1911_ThirdPerson'
	Description="Colt M1911 Handgun"
	FriendlyName="Colt M1911"
	UnequipAnimationRate=1.5000000
	UseAnimationRate=0.9000000
	ShouldHaveFirstPersonModel=false
}