class Crushed extends DamageCategory
	abstract
	config(SwatEquipment)
	notplaceable
	hidecategories(Karma,Advanced,Collision,Events,Force,LightColor,Lighting,Movement,Object,Sound,Display);

defaultproperties
{
	DeathString="%o was crushed by %k."
	FemaleSuicide="%o was crushed."
	MaleSuicide="%o was crushed."
	bAlwaysGibs=true
}