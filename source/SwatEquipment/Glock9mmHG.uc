class Glock9mmHG extends Handgun
	config(SwatEquipment)
	hidecategories(Karma);

defaultproperties
{
	PlayerAmmoOption=/* Array type was not detected. */
	EnemyUsesAmmo=/* Array type was not detected. */
	MuzzleVelocity=18170.0000000
	MaxAimError=60.0000000
	SmallAimErrorRecoveryRate=1.5000000
	LargeAimErrorRecoveryRate=17.0000000
	AimErrorBreakingPoint=1.5000000
	LookAimErrorPenaltyFactor=0.0001250
	MaxLookAimErrorPenalty=7.0000000
	InjuredAimErrorPenalty=0.5000000
	MaxInjuredAimErrorPenalty=1.0000000
	EquippedAimErrorPenalty=5.0000000
	FiredAimErrorPenalty=0.4000000
	WalkToRunAimErrorPenalty=5.0000000
	StandToWalkAimErrorPenalty=1.7500000
	StandingAimError=0.5500000
	WalkingAimError=0.8500000
	RunningAimError=7.7500000
	CrouchingAimError=0.3500000
	RecoilBackDuration=0.0300000
	RecoilForeDuration=0.3500000
	RecoilMagnitude=200.0000000
	HasAttachedFlashlight=true
	FlashlightPosition_1stPerson=(X=1.0000000,Y=-1.5000000,Z=5.0000000)
	FlashlightPosition_3rdPerson=(X=0.0000000,Y=-11.8000000,Z=1.9000000)
	FlashlightRotation_3rdPerson=(Pitch=0,Yaw=-16384,Roll=0)
	Range=4000
	FirstPersonModelClass=Class'SwatEquipmentModels.NineMMpistol_FirstPerson'
	ThirdPersonModelClass=Class'SwatEquipmentModels.NineMMpistol_ThirdPerson'
	Description="This Austrian designed handgun is largely made of high tech polymer plastics.  This construction results in a weapon that is incredibly easy to handle and manipulate.  While less powerful than the Colt 1911, it boasts a 17 round magazine.  Its ease of use, accuracy, and \"safe action\" trigger has made it a popular choice for law enforcement agencies."
	FriendlyName="9mm Handgun"
	GUIImage=Texture'gui_tex.Equip_9mmPistol'
	ZoomedFOV=60.0000000
}