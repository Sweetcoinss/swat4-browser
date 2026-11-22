class CommandInterfaceDoorRelatedContext extends PlayerInterfaceDoorRelatedContext
	abstract
	native
	config
	perobjectconfig;

var config bool CaresAboutPlayerOnExternalSide;
var config bool PlayerIsOnExternalSide;
var config bool CaresAboutCanIssueCommandsFromMySide;
var config bool CanIssueCommandsFromMySide;
var config CommandInterface.ECommand DefaultCommand;
var config int DefaultCommandPriority;
var config array<CommandInterface.ECommand> Command;

defaultproperties
{
	BreakIfMatch=false
}