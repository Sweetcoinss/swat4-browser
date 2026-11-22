class USP40HG extends Handgun
	config(SwatEquipment)
	hidecategories(Karma);

defaultproperties
{
	PlayerAmmoOption=/* Array type was not detected. */
	EnemyUsesAmmo=/* Array type was not detected. */
	MuzzleVelocity=18170.0000000
	MaxAimError=60.0000000
	SmallAimErrorRecoveryRate=1.0000000
	LargeAimErrorRecoveryRate=10.0000000
	AimErrorBreakingPoint=1.0000000
	LookAimErrorPenaltyFactor=0.0001250
	MaxLookAimErrorPenalty=10.0000000
	InjuredAimErrorPenalty=0.5000000
	MaxInjuredAimErrorPenalty=1.0000000
	EquippedAimErrorPenalty=5.0000000
	FiredAimErrorPenalty=0.5000000
	WalkToRunAimErrorPenalty=5.0000000
	StandToWalkAimErrorPenalty=2.0000000
	StandingAimError=0.2500000
	WalkingAimError=1.8000000
	RunningAimError=6.5000000
	CrouchingAimError=0.1500000
	RecoilBackDuration=0.0500000
	RecoilForeDuration=0.3500000
	RecoilMagnitude=1000.0000000
	FlashlightPosition_1stPerson=(X=1.0000000,Y=-1.5000000,Z=5.0000000)
	FlashlightPosition_3rdPerson=(X=0.0000000,Y=0.0000000,Z=2.5000000)
	FlashlightRotation_3rdPerson=(Pitch=0,Yaw=-16384,Roll=0)
	Range=4000
	ThirdPersonModelClass=Class'SwatEquipmentModels.USP40_ThirdPerson'
	Description="SLP40 Handgun"
	FriendlyName="SLP 40"
	ShouldHaveFirstPersonModel=false
}