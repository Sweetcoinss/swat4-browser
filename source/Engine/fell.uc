class fell extends DamageCategory
	abstract
	config(SwatEquipment)
	notplaceable
	hidecategories(Karma,Advanced,Collision,Events,Force,LightColor,Lighting,Movement,Object,Sound,Display);

defaultproperties
{
	DeathString="%o left a small crater"
	FemaleSuicide="%o left a small crater"
	MaleSuicide="%o left a small crater"
	bNoSpecificLocation=true
	GibModifier=2.0000000
}