class ColtM1911HG extends Handgun
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
	LookAimErrorPenaltyFactor=0.0001250
	MaxLookAimErrorPenalty=7.0000000
	InjuredAimErrorPenalty=0.5000000
	MaxInjuredAimErrorPenalty=1.0000000
	EquippedAimErrorPenalty=5.0000000
	FiredAimErrorPenalty=0.7500000
	WalkToRunAimErrorPenalty=5.0000000
	StandToWalkAimErrorPenalty=2.0000000
	StandingAimError=0.7500000
	WalkingAimError=0.9500000
	RunningAimError=8.5000000
	CrouchingAimError=0.5000000
	RecoilBackDuration=0.0200000
	RecoilForeDuration=0.4500000
	RecoilMagnitude=400.0000000
	HasAttachedFlashlight=true
	FlashlightPosition_1stPerson=(X=1.0000000,Y=-1.5000000,Z=5.0000000)
	FlashlightPosition_3rdPerson=(X=0.0000000,Y=-11.8000000,Z=1.9000000)
	FlashlightRotation_3rdPerson=(Pitch=0,Yaw=-16384,Roll=0)
	Range=4000
	FirstPersonModelClass=Class'SwatEquipmentModels.ColtM1911_FirstPerson'
	ThirdPersonModelClass=Class'SwatEquipmentModels.ColtM1911_ThirdPerson'
	Description="The Colt M1911 Handgun has been a mainstay in law enforcement for decades.  This .45 caliber weapon packs a powerful punch and is the most common backup weapon for SWAT officers.  This semi-automatic weapon has an 8 round magazine and can fire both full metal jacket and jacketed hollow point ammunition."
	FriendlyName="M1911 Handgun"
	GUIImage=Texture'gui_tex.equip_1911'
	ZoomedFOV=60.0000000
	UnequipAnimationRate=1.5000000
}