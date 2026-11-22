class Suicided extends DamageCategory
	abstract
	config(SwatEquipment)
	notplaceable
	hidecategories(Karma,Advanced,Collision,Events,Force,LightColor,Lighting,Movement,Object,Sound,Display);

defaultproperties
{
	DeathString="%o had an aneurysm."
	FemaleSuicide="%o had an aneurysm."
	MaleSuicide="%o had an aneurysm."
	bArmorStops=false
	bNoSpecificLocation=true
}