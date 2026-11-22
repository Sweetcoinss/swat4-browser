class RoundBasedWeapon extends FiredWeapon
	config(SwatEquipment)
	hidecategories(Karma);

var config int MagazineSize;

simulated function EquippedHook()
{
	super.EquippedHook();
	Ammo.UpdateHUD();
	return;
}
