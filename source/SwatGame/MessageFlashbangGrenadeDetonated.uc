class MessageFlashbangGrenadeDetonated extends Message
	editinlinenew;

static function string editorDisplay(name TriggeredBy, Message filter)
{
	return "A Flashbang Grenade Detonates.";
	return;
}

defaultproperties
{
	specificTo=Class'Engine.SwatGrenadeProjectile'
}