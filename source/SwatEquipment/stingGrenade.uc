class stingGrenade extends ThrownWeapon
	config(SwatEquipment)
	hidecategories(Karma);

defaultproperties
{
	ProjectileClass=Class'SwatEquipment.StingGrenadeProjectile'
	FirstPersonModelClass=Class'SwatEquipmentModels.StingGrenade_FirstPerson'
	ThirdPersonModelClass=Class'SwatEquipmentModels.StingGrenade_ThirdPerson'
	Description="The sting grenade, or Stinger, is filled with many small rubber balls.  Upon detonation these balls are ejected from the grenade, bombarding targets with blunt force projectiles.  The rubber balls will not penetrate the skin but can cause dizzyness, disorientation, and severe pain from the impact of the projectiles.  While considered less lethal, the sting grenade can cause severe injury if it detonates in very close proximity to someone."
	FriendlyName="Stinger"
	GUIImage=Texture'gui_tex.equip_stinggrenade'
	Slot=5
	EquipAnimationRate=1.5000000
	UnequipAnimationRate=1.5000000
}