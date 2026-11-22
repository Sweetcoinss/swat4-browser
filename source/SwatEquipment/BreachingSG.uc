class BreachingSG extends BreachingShotgun
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
	AimErrorBreakingPoint=3.5000000
	LookAimErrorPenaltyFactor=0.0001250
	MaxLookAimErrorPenalty=13.0000000
	InjuredAimErrorPenalty=1.0000000
	MaxInjuredAimErrorPenalty=2.0000000
	EquippedAimErrorPenalty=8.0000000
	FiredAimErrorPenalty=1.0000000
	WalkToRunAimErrorPenalty=6.0000000
	StandToWalkAimErrorPenalty=2.0000000
	StandingAimError=1.0000000
	WalkingAimError=2.2500000
	RunningAimError=7.5000000
	CrouchingAimError=0.5000000
	RecoilBackDuration=0.0500000
	RecoilForeDuration=0.1500000
	RecoilMagnitude=1200.0000000
	Range=82
	FirstPersonModelClass=Class'SwatEquipmentModels.BreachingShotgun_FirstPerson'
	ThirdPersonModelClass=Class'SwatEquipmentModels.BreachingShotgun_ThirdPerson'
	Description="The breaching shotgun is a specially modified, pump action shotgun designed to breach locked doors.  The weapon fires frangible breaching ammo that is designed to quickly break into very small pieces upon impact.  This behavior reduces penetration and increases damage upon impact with hard surfaces.  These factors make it ideal for breaking locks on doors without penetrating the door and harming someone on the other side.  The toothed extender on barrel allows officers to jam the weapon into the door and ensures the correct distance from the lock for the breaching ammo to be most effective.  Its compact design permits officers to carry the weapon on their back, allowing it to be carried in addition to the primary weapon."
	FriendlyName="Shotgun"
	GUIImage=Texture'gui_tex.equip_breachingshotgun'
	Slot=7
}