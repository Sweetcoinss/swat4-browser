class CommandInterfaceContext extends PlayerInterfaceContext
	abstract
	native
	config
	perobjectconfig;

var config bool CaresAboutIsActive;
var config bool isActive;
var config CommandInterface.ECommand DefaultCommand;
var config int DefaultCommandPriority;
var config bool CaresAboutCanBeArrestedNow;
var config bool CanBeArrestedNow;
var config bool CaresAboutCanBeUsedNow;
var config bool CanBeUsedNow;
var config array<CommandInterface.ECommand> Command;

defaultproperties
{
	BreakIfMatch=false
}