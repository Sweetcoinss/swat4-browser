class MessageStingGrenadeDetonated extends Message
	editinlinenew;

static function string editorDisplay(name TriggeredBy, Message filter)
{
	return "A Sting Grenade Detonates.";
	return;
}

defaultproperties
{
	specificTo=Class'Engine.SwatGrenadeProjectile'
}