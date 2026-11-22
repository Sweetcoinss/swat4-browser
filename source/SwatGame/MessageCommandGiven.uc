class MessageCommandGiven extends Message
	editinlinenew;

var name Command;
var name Team;
var name Door;

overloaded function Construct(name inCommand, name InTeam, name inDoor)
{
	Command = inCommand;
	Team = InTeam;
	Door = inDoor;
	return;
}

static function string editorDisplay(name TriggeredBy, Message filter)
{
	return "The Player gives a command with the CommandInterface";
	return;
}

defaultproperties
{
	specificTo=Class'SwatGame.CommandInterface'
}