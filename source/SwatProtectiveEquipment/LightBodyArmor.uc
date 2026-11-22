class LightBodyArmor extends BodyArmor
	config
	hidecategories(Karma);

defaultproperties
{
	ProtectedRegion=2
	MomentumToPenetrate=240.0000000
	PenetratedDamageFactor=(Min=1.7500000,Max=3.8000000)
	BlockedDamageFactor=(Min=1.0000000,Max=1.5000000)
	Description="The basic and common kevlar body armor worn during normal operations it provides some protection from bullet penetrations."
	FriendlyName="Light Armor"
	GUIImage=Texture'gui_tex.equip_lightarmor'
	DrawType=0
}