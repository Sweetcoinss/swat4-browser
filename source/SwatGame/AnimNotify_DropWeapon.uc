class AnimNotify_DropWeapon extends AnimNotify_Scripted
	editinlinenew
	collapsecategories
	hidecategories(Object);

const MAX_MAGNITUDE = 300;

var Rotator DropDirection "Direction the weapon should fall (based on the the enemy's current rotation) when dropped";
var float magnitude "Magnitude of impulse to apply to the weapon in the DropDirection, in UnrealUnits/second";
var float RandomDropChance "Enter a value between 0.0 and 1.0 if you want a random drop chance";

event Notify(Actor Owner)
{
	local float ClampedMagnitude;

	assert(NotEqual_ObjectObject(Owner, none));
	if(AndAnd_BoolBool(Owner.IsA('SwatEnemy'), LessEqual_FloatFloat(FRand(), RandomDropChance)))
	{
		ClampedMagnitude = FClamp(magnitude, 0.0000000, 300.0000000);
		MPLog("AnimNotify_DropWeapon calling DropCurrentWeapon().");
		SwatEnemy(Owner).DropCurrentWeapon(Vector(DropDirection), ClampedMagnitude);
	}
	return;
}

defaultproperties
{
	magnitude=275.0000000
	RandomDropChance=1.0000000
}