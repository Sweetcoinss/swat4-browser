class UMP45SMG extends SubMachineGun
	config(SwatEquipment)
	hidecategories(Karma);

defaultproperties
{
	PlayerAmmoOption=/* Array type was not detected. */
	EnemyUsesAmmo=/* Array type was not detected. */
	MuzzleVelocity=12693.0000000
	MaxAimError=60.0000000
	SmallAimErrorRecoveryRate=2.7500000
	LargeAimErrorRecoveryRate=13.0000000
	AimErrorBreakingPoint=2.0000000
	LookAimErrorPenaltyFactor=0.0001250
	MaxLookAimErrorPenalty=9.0000000
	InjuredAimErrorPenalty=1.0000000
	MaxInjuredAimErrorPenalty=3.0000000
	EquippedAimErrorPenalty=6.0000000
	FiredAimErrorPenalty=1.1000000
	WalkToRunAimErrorPenalty=6.0000000
	StandToWalkAimErrorPenalty=2.2500000
	StandingAimError=0.5500000
	WalkingAimError=1.1500000
	RunningAimError=8.7500000
	CrouchingAimError=0.3500000
	RecoilBackDuration=0.0400000
	RecoilForeDuration=0.6000000
	RecoilMagnitude=220.0000000
	AutoFireRecoilMagnitudeIncrement=45.0000000
	HasAttachedFlashlight=true
	FlashlightPosition_1stPerson=(X=14.0000000,Y=-4.0000000,Z=11.0000000)
	FlashlightPosition_3rdPerson=(X=0.0000000,Y=-30.5000000,Z=4.0000000)
	FlashlightRotation_3rdPerson=(Pitch=0,Yaw=-16384,Roll=0)
	AvailableFireMode=/* Array type was not detected. */
	BurstRateFactor=0.5500000
	Range=4000
	FirstPersonModelClass=Class'SwatEquipmentModels.UMP45_FirstPerson'
	ThirdPersonModelClass=Class'SwatEquipmentModels.UMP45_ThirdPerson'
	Description="The .45 caliber submachinegun is comparable to the 9mm SMG in almost every way.  Built largely of glass-fiber reinforced polymers, this lightweight sub-machine gun provides the same reliability as the 9mm model, but with the added punch of the larger .45 caliber round.  The heavy bullet provides superior penetration of armored targets with FMJ rounds compared to its 9mm brethren, despite having a lower muzzle velocity and slower cyclical rate of fire.  This model is equipped with a fire mode selector allowing semi-automatic and fully automatic firing modes."
	FriendlyName=".45 SMG"
	GUIImage=Texture'gui_tex.equip_Ump'
	ZoomedFOV=45.0000000
	UnequipAnimationRate=1.5000000
}