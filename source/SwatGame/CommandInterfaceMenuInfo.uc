class CommandInterfaceMenuInfo extends Object
	abstract
	config
	perobjectconfig;

var config CommandInterface.ECommand AnchorCommand;
var config bool CascadeUp;
var config localized string Text;
var config name OverrideDefaultCommand;
var Command OverrideDefaultCommandObject;

function bool IsAvailable(LevelInfo Level)
{
	return true;
	return;
}
