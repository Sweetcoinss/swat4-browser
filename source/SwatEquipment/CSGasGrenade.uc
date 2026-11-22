class CSGasGrenade extends ThrownWeapon
	config(SwatEquipment)
	hidecategories(Karma);

defaultproperties
{
	ProjectileClass=Class'SwatEquipment.CSGasGrenadeProjectile'
	FirstPersonModelClass=Class'SwatEquipmentModels.CSgasGrenade_FirstPerson'
	ThirdPersonModelClass=Class'SwatEquipmentModels.CSgasGrenade_ThirdPerson'
	Description="This grenade emits Chlorobenzylidene malonitrile, or CS.  CS is a chemical agent which causes tearing in the eyes and irritation of the mucus membranes.  Commonly known as Tear gas, this agent causes people to lose visual acuity and have difficulty breathing.  While under the influence of tear gas, suspects are at a significant disadvantage when encountering officers."
	FriendlyName="CS Gas"
	GUIImage=Texture'gui_tex.equip_csgas'
	Slot=4
	EquipAnimationRate=1.5000000
	UnequipAnimationRate=1.5000000
}