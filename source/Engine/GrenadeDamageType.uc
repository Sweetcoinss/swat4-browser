class GrenadeDamageType extends DamageType implements DamageType
	config(SwatEquipment);

var config localized string FriendlyName;

static function string GetFriendlyName()
{
	return default.FriendlyName;
	return;
}

defaultproperties
{
	FriendlyName="Grenade Explosion"
}