class MessageUnexpectedCommandGiven extends Message
	editinlinenew;

var name ExpectedCommand;
var name ExpectedCommandTeam;
var name ExpectedCommandTargetDoor;
var name ExpectedCommandSource;
var name GivenCommand;
var name GivenCommandTeam;
var name GivenCommandTargetDoor;
var name GivenCommandSource;

overloaded function Construct(name inExpectedCommand, name inExpectedCommandTeam, name inExpectedCommandTargetDoor, name inExpectedCommandSource, name inGivenCommand, name inGivenCommandTeam, name inGivenCommandTargetDoor, name inGivenCommandSource)
{
	ExpectedCommand = inExpectedCommand;
	ExpectedCommandTeam = inExpectedCommandTeam;
	ExpectedCommandTargetDoor = inExpectedCommandTargetDoor;
	ExpectedCommandSource = inExpectedCommandSource;
	GivenCommand = inGivenCommand;
	GivenCommandTeam = inGivenCommandTeam;
	GivenCommandTargetDoor = inGivenCommandTargetDoor;
	GivenCommandSource = inGivenCommandSource;
	return;
}

static function string editorDisplay(name TriggeredBy, Message filter)
{
	return "The Player gives an unexpected command with the CommandInterface";
	return;
}

defaultproperties
{
	specificTo=Class'SwatGame.CommandInterface'
}