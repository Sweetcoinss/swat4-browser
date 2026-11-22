class MessageMissionObjectiveFailed extends Message
	editinlinenew;

var name Objective;

overloaded function Construct(name inObjective)
{
	Objective = inObjective;
	return;
}

static function string editorDisplay(name TriggeredBy, Message filter)
{
	return "A Mission Objective is Failed.";
	return;
}

defaultproperties
{
	specificTo=Class'SwatGame.SwatGameInfo'
}