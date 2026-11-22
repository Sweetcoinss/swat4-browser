class NovaPumpSG extends Shotgun
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
	AimErrorBreakingPoint=4.0000000
	LookAimErrorPenaltyFactor=0.0001250
	MaxLookAimErrorPenalty=13.0000000
	InjuredAimErrorPenalty=1.5000000
	MaxInjuredAimErrorPenalty=6.0000000
	EquippedAimErrorPenalty=9.0000000
	FiredAimErrorPenalty=0.7000000
	WalkToRunAimErrorPenalty=8.0000000
	StandToWalkAimErrorPenalty=4.0000000
	StandingAimError=2.7500000
	WalkingAimError=3.5000000
	RunningAimError=10.5000000
	CrouchingAimError=2.0000000
	RecoilBackDuration=0.0500000
	RecoilForeDuration=0.3500000
	RecoilMagnitude=1200.0000000
	HasAttachedFlashlight=true
	FlashlightPosition_1stPerson=(X=14.0000000,Y=-4.0000000,Z=11.0000000)
	FlashlightPosition_3rdPerson=(X=0.0000000,Y=-39.4000000,Z=1.1500000)
	FlashlightRotation_3rdPerson=(Pitch=0,Yaw=-16384,Roll=0)
	OverrideArmDamageModifier=1.0000000
	Range=4000
	FirstPersonModelClass=Class'SwatEquipmentModels.NovaPump_FirstPerson'
	ThirdPersonModelClass=Class'SwatEquipmentModels.NovaPump_ThirdPerson'
	Description="A relatively new design from Benelli, the Nova pump is the top of the line in pump action shotguns.   While firing a bit slower than the semi-automatic M4 Super 90, the attached magazine extender allows the Nova pump to hold up to 8 shells at one time."
	FriendlyName="Nova Pump"
	GUIImage=Texture'gui_tex.equip_novapump'
	ZoomedFOV=55.0000000
	UseAnimationRate=1.1500000
}