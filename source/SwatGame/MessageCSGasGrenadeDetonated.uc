class MessageCSGasGrenadeDetonated extends Message
	editinlinenew;

static function string editorDisplay(name TriggeredBy, Message filter)
{
	return "A CSGas Grenade Detonates.";
	return;
}

defaultproperties
{
	specificTo=Class'Engine.SwatGrenadeProjectile'
}