class Command_MP extends Command
	config(PlayerInterface_Command_MP)
	perobjectconfig;

var config bool IsTaunt;
var config bool TargetIsSelf;
var config float ArrowLifetime;

defaultproperties
{
	ArrowLifetime=8.0000000
}