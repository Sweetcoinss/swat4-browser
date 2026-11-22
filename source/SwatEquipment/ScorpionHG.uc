class ScorpionHG extends Handgun
	config(SwatEquipment)
	hidecategories(Karma);

defaultproperties
{
	PlayerAmmoOption=/* Array type was not detected. */
	EnemyUsesAmmo=/* Array type was not detected. */
	MuzzleVelocity=16000.0000000
	MaxAimError=60.0000000
	SmallAimErrorRecoveryRate=25.0000000
	LargeAimErrorRecoveryRate=50.0000000
	AimErrorBreakingPoint=3.0000000
	LookAimErrorPenaltyFactor=0.0001250
	MaxLookAimErrorPenalty=10.0000000
	InjuredAimErrorPenalty=1.0000000
	MaxInjuredAimErrorPenalty=2.5000000
	EquippedAimErrorPenalty=5.7500000
	FiredAimErrorPenalty=0.7500000
	WalkToRunAimErrorPenalty=6.5000000
	StandToWalkAimErrorPenalty=1.7500000
	StandingAimError=0.3000000
	WalkingAimError=0.8000000
	RunningAimError=6.5000000
	CrouchingAimError=0.1500000
	RecoilBackDuration=0.0500000
	RecoilForeDuration=0.3500000
	RecoilMagnitude=1000.0000000
	FlashlightPosition_1stPerson=(X=1.0000000,Y=-1.5000000,Z=5.0000000)
	FlashlightPosition_3rdPerson=(X=0.0000000,Y=0.0000000,Z=2.5000000)
	FlashlightRotation_3rdPerson=(Pitch=0,Yaw=-16384,Roll=0)
	AvailableFireMode=/* Array type was not detected. */
	Range=4000
	ThirdPersonModelClass=Class'SwatEquipmentModels.Scorpion_ThirdPerson'
	Description="Skorpion Machine Pistol"
	FriendlyName="Skorpion Machine Pistol"
	ShouldHaveFirstPersonModel=false
}