class BadguyUMP45SMG extends SubMachineGun
	config(SwatEquipment)
	hidecategories(Karma);

defaultproperties
{
	PlayerAmmoOption=/* Array type was not detected. */
	EnemyUsesAmmo=/* Array type was not detected. */
	MuzzleVelocity=13123.0000000
	MaxAimError=60.0000000
	SmallAimErrorRecoveryRate=2.7500000
	LargeAimErrorRecoveryRate=15.0000000
	AimErrorBreakingPoint=2.0000000
	LookAimErrorPenaltyFactor=0.0001250
	MaxLookAimErrorPenalty=9.0000000
	InjuredAimErrorPenalty=1.0000000
	MaxInjuredAimErrorPenalty=3.0000000
	EquippedAimErrorPenalty=6.0000000
	FiredAimErrorPenalty=1.0000000
	WalkToRunAimErrorPenalty=6.0000000
	StandToWalkAimErrorPenalty=2.2500000
	StandingAimError=0.5000000
	WalkingAimError=0.9500000
	RunningAimError=6.7500000
	CrouchingAimError=0.2500000
	RecoilBackDuration=0.0400000
	RecoilForeDuration=0.6000000
	RecoilMagnitude=220.0000000
	AutoFireRecoilMagnitudeIncrement=40.0000000
	AvailableFireMode=/* Array type was not detected. */
	BurstRateFactor=0.7250000
	Range=4000
	ThirdPersonModelClass=Class'SwatEquipmentModels.BadGuyUMP_ThirdPerson'
	Description="The 45 caliber submachinegun is comparable to the 9mm SMG in almost every way.  Built largely of glass-fiber reinforced polymers, this lightweight sub-machine gun provides the same reliability as the 9mm model, but with the added punch of the larger .45 caliber round.  The heavy bullet provides superior penetration of armored targets with FMJ rounds compared to its 9mm brethren, despite having a lower muzzle velocity and slower cyclical rate of fire.  This model is equipped with a fire mode selector allowing semi-automatic and fully automatic firing modes."
	FriendlyName=".45 SMG"
	GUIImage=Texture'gui_tex.equip_Ump'
	ZoomedFOV=45.0000000
	UnequipAnimationRate=1.5000000
	ShouldHaveFirstPersonModel=false
}