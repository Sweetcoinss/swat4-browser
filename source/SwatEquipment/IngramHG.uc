class IngramHG extends Handgun
	config(SwatEquipment)
	hidecategories(Karma);

defaultproperties
{
	PlayerAmmoOption=/* Array type was not detected. */
	EnemyUsesAmmo=/* Array type was not detected. */
	MuzzleVelocity=14123.0000000
	MaxAimError=60.0000000
	SmallAimErrorRecoveryRate=1.5000000
	LargeAimErrorRecoveryRate=12.0000000
	AimErrorBreakingPoint=1.2500000
	LookAimErrorPenaltyFactor=0.0001250
	MaxLookAimErrorPenalty=10.0000000
	InjuredAimErrorPenalty=1.0000000
	MaxInjuredAimErrorPenalty=3.5000000
	EquippedAimErrorPenalty=5.7500000
	FiredAimErrorPenalty=2.5000000
	WalkToRunAimErrorPenalty=6.0000000
	StandToWalkAimErrorPenalty=2.0000000
	StandingAimError=0.5000000
	WalkingAimError=1.2500000
	RunningAimError=6.5000000
	CrouchingAimError=0.3000000
	RecoilBackDuration=0.0500000
	RecoilForeDuration=0.3500000
	RecoilMagnitude=1000.0000000
	FlashlightPosition_1stPerson=(X=1.0000000,Y=-1.5000000,Z=5.0000000)
	FlashlightPosition_3rdPerson=(X=0.0000000,Y=0.0000000,Z=2.5000000)
	FlashlightRotation_3rdPerson=(Pitch=0,Yaw=-16384,Roll=0)
	AvailableFireMode=/* Array type was not detected. */
	Range=4000
	ThirdPersonModelClass=Class'SwatEquipmentModels.Ingram_ThirdPerson'
	Description="Ingram Handgun"
	FriendlyName="MAC-10 Machine Pistol"
	ShouldHaveFirstPersonModel=false
}