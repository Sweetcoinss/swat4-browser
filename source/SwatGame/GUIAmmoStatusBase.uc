class GUIAmmoStatusBase extends GUIMultiComponent
	abstract
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object);

function SetWeaponStatus(Ammunition Ammo)
{
	return;
}

defaultproperties
{
	bPersistent=true
}