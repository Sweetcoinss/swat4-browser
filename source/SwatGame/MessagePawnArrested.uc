class MessagePawnArrested extends Message
	editinlinenew;

var name Arrester;
var name Arrestee;

overloaded function Construct(name inArrester, name inArrestee)
{
	Arrester = inArrester;
	Arrestee = inArrestee;
	return;
}

static function string editorDisplay(name TriggeredBy, Message filter)
{
	return "A Pawn is Arrested";
	return;
}

defaultproperties
{
	specificTo=Class'SwatGame.SwatPawn'
}