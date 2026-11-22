class M4A1MG extends MachineGun
	config(SwatEquipment)
	hidecategories(Karma);

defaultproperties
{
	PlayerAmmoOption=/* Array type was not detected. */
	EnemyUsesAmmo=/* Array type was not detected. */
	MuzzleVelocity=44617.0000000
	ReloadAnimationRate=0.8000000
	MaxAimError=15.0000000
	SmallAimErrorRecoveryRate=2.5000000
	LargeAimErrorRecoveryRate=8.0000000
	AimErrorBreakingPoint=2.5000000
	LookAimErrorPenaltyFactor=0.0001250
	MaxLookAimErrorPenalty=12.0000000
	InjuredAimErrorPenalty=1.1500000
	MaxInjuredAimErrorPenalty=5.0000000
	EquippedAimErrorPenalty=8.5000000
	FiredAimErrorPenalty=1.2500000
	WalkToRunAimErrorPenalty=5.0000000
	StandToWalkAimErrorPenalty=3.5000000
	StandingAimError=0.2500000
	WalkingAimError=1.5000000
	RunningAimError=10.0000000
	CrouchingAimError=0.1500000
	RecoilBackDuration=0.0200000
	RecoilForeDuration=0.6000000
	RecoilMagnitude=235.0000000
	AutoFireRecoilMagnitudeIncrement=70.0000000
	HasAttachedFlashlight=true
	FlashlightPosition_1stPerson=(X=22.0000000,Y=1.0000000,Z=10.0000000)
	FlashlightPosition_3rdPerson=(X=2.5000000,Y=-32.0000000,Z=8.7000000)
	FlashlightRotation_3rdPerson=(Pitch=0,Yaw=-16384,Roll=0)
	AvailableFireMode=/* Array type was not detected. */
	BurstRateFactor=1.5000000
	Range=4000
	FirstPersonModelClass=Class'SwatEquipmentModels.M4A1_FirstPerson'
	ThirdPersonModelClass=Class'SwatEquipmentModels.M4A1_ThirdPerson'
	Description="The Colt M4A1 carbine is based on the tried and true design of the M16 assault rifle used by the United States Army.  The shorter carbine design makes it a more viable weapon than the M16 in close quarters situations.  Using .223 caliber rifle ammunition in both full metal jacket and jacketed hollow point configurations, the Colt carbine is the most powerful weapon available to SWAT officers.  It is equipped with a fire mode selector allowing semi-automatic as well as fully automatic firing."
	FriendlyName="Colt M4A1 Carbine"
	GUIImage=Texture'gui_tex.equip_m4a1'
	ZoomedFOV=40.0000000
	ZoomTime=0.7500000
}