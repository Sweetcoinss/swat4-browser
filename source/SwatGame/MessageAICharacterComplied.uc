class MessageAICharacterComplied extends Message
	editinlinenew;

var name AI;

overloaded function Construct(name inAI)
{
	AI = inAI;
	return;
}

static function string editorDisplay(name TriggeredBy, Message filter)
{
	return "An AICharacter (Enemy or Hostage) Complies.";
	return;
}

defaultproperties
{
	specificTo=Class'SwatGame.SwatAICharacter'
}