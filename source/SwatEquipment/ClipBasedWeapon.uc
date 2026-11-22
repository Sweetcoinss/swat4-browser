class ClipBasedWeapon extends FiredWeapon
	config(SwatEquipment)
	hidecategories(Karma);

simulated function EquippedHook()
{
	super.EquippedHook();
	Ammo.UpdateHUD();
	return;
}
