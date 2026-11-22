class DamageRadiusDamageType extends DamageCategory implements DamageType
	config(SwatEquipment)
	hidecategories(Karma,Advanced,Collision,Events,Force,LightColor,Lighting,Movement,Object,Sound,Display);

var config localized string FriendlyName;

static function string GetFriendlyName()
{
	return default.FriendlyName;
	return;
}

defaultproperties
{
	FriendlyName="nearby explosion"
}