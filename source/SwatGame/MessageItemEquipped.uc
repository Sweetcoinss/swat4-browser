class MessageItemEquipped extends Message
	editinlinenew;

var name Who;
var name What;

overloaded function Construct(name inWho, name inWhat)
{
	Who = inWho;
	What = inWhat;
	return;
}

static function string editorDisplay(name TriggeredBy, Message filter)
{
	return "A Pawn Equips a piece of Handheld Equipment";
	return;
}

defaultproperties
{
	specificTo=Class'SwatGame.SwatPawn'
}