class PythonRevolverHG extends Handgun
	config(SwatEquipment)
	hidecategories(Karma);

defaultproperties
{
	PlayerAmmoOption=/* Array type was not detected. */
	EnemyUsesAmmo=/* Array type was not detected. */
	MuzzleVelocity=22308.0000000
	MaxAimError=60.0000000
	SmallAimErrorRecoveryRate=0.7500000
	LargeAimErrorRecoveryRate=9.0000000
	AimErrorBreakingPoint=1.7500000
	LookAimErrorPenaltyFactor=0.0001250
	MaxLookAimErrorPenalty=10.0000000
	InjuredAimErrorPenalty=0.7500000
	MaxInjuredAimErrorPenalty=1.2500000
	EquippedAimErrorPenalty=6.0000000
	FiredAimErrorPenalty=3.0000000
	WalkToRunAimErrorPenalty=6.0000000
	StandToWalkAimErrorPenalty=2.2500000
	StandingAimError=0.6000000
	WalkingAimError=1.0500000
	RunningAimError=7.7500000
	CrouchingAimError=0.2500000
	RecoilBackDuration=0.0100000
	RecoilForeDuration=1.0000000
	RecoilMagnitude=500.0000000
	OverrideArmDamageModifier=1.4100000
	Range=4000
	FirstPersonModelClass=Class'SwatEquipmentModels.PythonRevolver_FirstPerson'
	ThirdPersonModelClass=Class'SwatEquipmentModels.PythonRevolver_ThirdPerson'
	Description="The Colt Python is among the most famous of Colt revolvers and was introduced in 1955.  It is chambered for the powerful .357 Magnum ammunition making it one of the most powerful hand guns on the market.  Its power is offset by its slow rate of fire and arduous reload.  In addition, it is not equipped with a tactical flashlight."
	FriendlyName="Colt Python"
	GUIImage=Texture'gui_tex.equip_Python'
	ZoomedFOV=70.0000000
}