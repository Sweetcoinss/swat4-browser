class MessageTargetInanimateDisabled extends Message
	editinlinenew;

var name Objective;
var name Disabler;
var int RemainingTargetInanimates;

overloaded function Construct(name inObjective, name inDisabler, int inRemainingTargetInanimates)
{
	Objective = inObjective;
	Disabler = inDisabler;
	RemainingTargetInanimates = inRemainingTargetInanimates;
	return;
}

static function string editorDisplay(name TriggeredBy, Message filter)
{
	return "A Target Inanimate is Disabled.";
	return;
}

defaultproperties
{
	specificTo=Class'SwatGame.SwatGameInfo'
}