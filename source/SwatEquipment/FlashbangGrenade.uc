class FlashbangGrenade extends ThrownWeapon
	config(SwatEquipment)
	hidecategories(Karma);

defaultproperties
{
	ProjectileClass=Class'SwatEquipment.FlashbangGrenadeProjectile'
	FirstPersonModelClass=Class'SwatEquipmentModels.FlashbangGrenade_FirstPerson'
	ThirdPersonModelClass=Class'SwatEquipmentModels.FlashbangGrenade_ThirdPerson'
	Description="The flashbang is a diversionary device that stuns and disorients people with an explosive report and a brillant flash.  People that are affected by the device can be temporarily blinded and deafened by the blast.  During this time SWAT has a significant tactical advantage over the affected persons.||Flashbangs are designed so that they will not fragment on detonation, but can still cause serious injury if detonation occurs in close proximity to a person.  Caution is advised."
	FriendlyName="Flashbang"
	GUIImage=Texture'gui_tex.equip_flashbang'
	Slot=3
	EquipAnimationRate=1.5000000
	UnequipAnimationRate=1.5000000
}