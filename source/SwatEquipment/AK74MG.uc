class AK74MG extends MachineGun
	config(SwatEquipment)
	hidecategories(Karma);

defaultproperties
{
	PlayerAmmoOption=/* Array type was not detected. */
	EnemyUsesAmmo=/* Array type was not detected. */
	MuzzleVelocity=37093.0000000
	MaxAimError=60.0000000
	SmallAimErrorRecoveryRate=2.5000000
	LargeAimErrorRecoveryRate=8.0000000
	AimErrorBreakingPoint=2.5000000
	LookAimErrorPenaltyFactor=0.0001250
	MaxLookAimErrorPenalty=10.0000000
	InjuredAimErrorPenalty=1.5000000
	MaxInjuredAimErrorPenalty=6.0000000
	EquippedAimErrorPenalty=7.5000000
	FiredAimErrorPenalty=2.0000000
	WalkToRunAimErrorPenalty=4.5000000
	StandToWalkAimErrorPenalty=3.0000000
	StandingAimError=0.3500000
	WalkingAimError=1.5000000
	RunningAimError=7.7500000
	CrouchingAimError=0.1000000
	RecoilBackDuration=0.0500000
	RecoilForeDuration=0.3500000
	RecoilMagnitude=1000.0000000
	FlashlightPosition_1stPerson=(X=22.0000000,Y=1.0000000,Z=10.0000000)
	FlashlightPosition_3rdPerson=(X=0.0000000,Y=-20.0000000,Z=5.0000000)
	FlashlightRotation_3rdPerson=(Pitch=0,Yaw=-16384,Roll=0)
	AvailableFireMode=/* Array type was not detected. */
	Range=4000
	ThirdPersonModelClass=Class'SwatEquipmentModels.AK74_ThirdPerson'
	Description="Default description for M4A1MG"
	FriendlyName="AK74"
	ShouldHaveFirstPersonModel=false
}