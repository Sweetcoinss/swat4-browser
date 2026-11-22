class MP5SMG extends SubMachineGun
	config(SwatEquipment)
	hidecategories(Karma);

defaultproperties
{
	PlayerAmmoOption=/* Array type was not detected. */
	EnemyUsesAmmo=/* Array type was not detected. */
	MuzzleVelocity=20185.0000000
	MaxAimError=60.0000000
	SmallAimErrorRecoveryRate=2.7500000
	LargeAimErrorRecoveryRate=15.0000000
	AimErrorBreakingPoint=2.0000000
	LookAimErrorPenaltyFactor=0.0001250
	MaxLookAimErrorPenalty=9.0000000
	InjuredAimErrorPenalty=1.0000000
	MaxInjuredAimErrorPenalty=4.0000000
	EquippedAimErrorPenalty=6.5000000
	FiredAimErrorPenalty=0.7500000
	WalkToRunAimErrorPenalty=6.0000000
	StandToWalkAimErrorPenalty=2.2500000
	StandingAimError=0.4500000
	WalkingAimError=1.0500000
	RunningAimError=8.2500000
	CrouchingAimError=0.2500000
	RecoilBackDuration=0.0500000
	RecoilForeDuration=0.4000000
	RecoilMagnitude=200.0000000
	AutoFireRecoilMagnitudeIncrement=25.0000000
	HasAttachedFlashlight=true
	FlashlightPosition_1stPerson=(X=14.0000000,Y=-4.0000000,Z=11.0000000)
	FlashlightPosition_3rdPerson=(X=0.0000000,Y=-30.0000000,Z=5.4000000)
	FlashlightRotation_3rdPerson=(Pitch=0,Yaw=-16384,Roll=0)
	AvailableFireMode=/* Array type was not detected. */
	BurstRateFactor=1.3300000
	Range=4000
	FirstPersonModelClass=Class'SwatEquipmentModels.MP5_FirstPerson'
	ThirdPersonModelClass=Class'SwatEquipmentModels.MP5_ThirdPerson'
	Description="This 9mm sub-machine gun is designed by a world renowned german manufacturer.  It is preferred by many para-military groups throughout the world for urban tactical engagements.  Firing either full metal jacket or jacketed hollow point 9mm ammunition it is versatile, but lacks the stopping power of an assault rifle.  Its key advantage is its compact design, which allows superior maneuverability in indoor situations.  It is equipped with a fire mode selector allowing semi-automatic and three round burst firing modes."
	FriendlyName="9mm SMG"
	GUIImage=Texture'gui_tex.equip_mp5'
	ZoomedFOV=50.0000000
	ZoomTime=0.7500000
	UnequipAnimationRate=1.5000000
}