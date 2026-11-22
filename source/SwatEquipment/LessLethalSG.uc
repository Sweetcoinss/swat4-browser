class LessLethalSG extends Shotgun
	config(SwatEquipment)
	hidecategories(Karma);

var config float Damage;
var config float DamageRadius;
var config Range KarmaImpulse;
var config float KarmaImpulseRadius;
var config float StingRadius;
var config float PlayerStingDuration;
var config float HeavilyArmoredPlayerStingDuration;
var config float AIStingDuration;
var config float MoraleModifier;

simulated function DealDamage(Actor Victim, int Damage, Pawn Instigator, Vector HitLocation, Vector MomentumVector, Class<DamageType> DamageType)
{
	if(Victim.IsA('Pawn'))
	{
		IReactToStingGrenade(Victim).ReactToStingGrenade(none, Pawn(Owner), 0.0000000, DamageRadius, KarmaImpulse, KarmaImpulseRadius, StingRadius, PlayerStingDuration, HeavilyArmoredPlayerStingDuration, AIStingDuration, MoraleModifier);
		MPLog(Concat_StrStr("Called ReactToStingGrenade on: ", string(Victim)));
	}
	else
	{
		if(Not_PreBool(Victim.IsA('ExplodingStaticMesh')))
		{
			super(FiredWeapon).DealDamage(Victim, Damage, Instigator, HitLocation, MomentumVector, DamageType);
		}
	}
	return;
}

simulated function bool ShouldSpawnBloodForVictim(Pawn PawnVictim, int Damage)
{
	return false;
	return;
}

defaultproperties
{
	Damage=5.0000000
	DamageRadius=20.0000000
	KarmaImpulse=(Min=50.0000000,Max=200.0000000)
	KarmaImpulseRadius=800.0000000
	StingRadius=800.0000000
	PlayerStingDuration=12.0000000
	HeavilyArmoredPlayerStingDuration=6.0000000
	AIStingDuration=6.0000000
	MoraleModifier=0.4000000
	MagazineSize=8
	PlayerAmmoOption=/* Array type was not detected. */
	EnemyUsesAmmo=/* Array type was not detected. */
	MuzzleVelocity=20384.0000000
	bCanShootThroughGlass=false
	MaxAimError=60.0000000
	SmallAimErrorRecoveryRate=2.0000000
	LargeAimErrorRecoveryRate=12.0000000
	AimErrorBreakingPoint=3.0000000
	LookAimErrorPenaltyFactor=0.0001250
	MaxLookAimErrorPenalty=13.0000000
	InjuredAimErrorPenalty=1.0000000
	MaxInjuredAimErrorPenalty=6.0000000
	EquippedAimErrorPenalty=9.0000000
	FiredAimErrorPenalty=1.0000000
	WalkToRunAimErrorPenalty=6.0000000
	StandToWalkAimErrorPenalty=2.0000000
	StandingAimError=1.2500000
	WalkingAimError=2.0000000
	RunningAimError=9.0000000
	CrouchingAimError=1.0000000
	RecoilBackDuration=0.0500000
	RecoilForeDuration=0.3500000
	RecoilMagnitude=1200.0000000
	HasAttachedFlashlight=true
	FlashlightPosition_1stPerson=(X=14.0000000,Y=-4.0000000,Z=11.0000000)
	FlashlightPosition_3rdPerson=(X=0.0000000,Y=-39.4000000,Z=1.1500000)
	FlashlightRotation_3rdPerson=(Pitch=0,Yaw=-16384,Roll=0)
	Range=1536
	FirstPersonModelClass=Class'SwatEquipmentModels.NonLethalShotgun_FirstPerson'
	ThirdPersonModelClass=Class'SwatEquipmentModels.NonLethalShotgun_ThirdPerson'
	Description="The less lethal shotgun is a Benelli Nova, pump-action shotgun which is always loaded with less than lethal beanbag rounds.  It is most often used on an uncooperative suspect or civilian.  The specially designated less lethal shotgun is necessary to eliminate errors that can occur from individually loading lethal or less than lethal munitions into the same weapon.  To remind the operators that this particular weapon is only to be loaded with less than lethal ammunition, it has been painted green.||The beanbag ammunition provides a powerful blunt force impact on the target.  This causes extreme pain and disorientation."
	FriendlyName="Less Lethal Shotgun"
	GUIImage=Texture'gui_tex.equip_lesslethal'
	ZoomedFOV=55.0000000
}