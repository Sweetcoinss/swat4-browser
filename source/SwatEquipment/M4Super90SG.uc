class M4Super90SG extends Shotgun
	config(SwatEquipment)
	hidecategories(Karma);

defaultproperties
{
	MagazineSize=5
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
	MaxInjuredAimErrorPenalty=7.0000000
	EquippedAimErrorPenalty=9.0000000
	FiredAimErrorPenalty=0.7000000
	WalkToRunAimErrorPenalty=8.0000000
	StandToWalkAimErrorPenalty=4.0000000
	StandingAimError=2.7500000
	WalkingAimError=3.5000000
	RunningAimError=11.0000000
	CrouchingAimError=2.2500000
	RecoilBackDuration=0.0500000
	RecoilForeDuration=0.4500000
	RecoilMagnitude=1200.0000000
	HasAttachedFlashlight=true
	FlashlightPosition_1stPerson=(X=14.0000000,Y=-4.0000000,Z=7.0000000)
	FlashlightPosition_3rdPerson=(X=0.0000000,Y=-34.6000000,Z=2.7000000)
	FlashlightRotation_3rdPerson=(Pitch=0,Yaw=-16384,Roll=0)
	OverrideArmDamageModifier=1.0000000
	Range=4000
	FirstPersonModelClass=Class'SwatEquipmentModels.M4Super90_FirstPerson'
	ThirdPersonModelClass=Class'SwatEquipmentModels.M4super90_ThirdPerson'
	Description="The Benelli M4 Super90 tactical shotgun is a highly reliable 12 gauge shotgun that has proven itself time and again in the field.  This model features an auto loader allowing for semi-automatic firing of its five round magazine.  This powerful weapon is capable of dealing extreme damage quickly and in a reliable spread.  It only has two drawbacks.  The first is that its bulk can make it difficult to handle in close quarters situations.  The second is its small magazine size."
	FriendlyName="M4 Super90"
	GUIImage=Texture'gui_tex.equip_m4super90'
	ZoomedFOV=52.0000000
	UseAnimationRate=1.5000000
}