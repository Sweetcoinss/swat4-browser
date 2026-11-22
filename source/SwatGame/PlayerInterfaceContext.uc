class PlayerInterfaceContext extends Object
	abstract
	native
	config
	perobjectconfig;

var config float Range;
var config name Type;
var config array<name> Except;
var config array<name> ExceptActiveItem;
var config bool HasSpecialConditions;
var config name HasA;
var config name DoesntHaveA;
var config bool CaresAboutTransparent;
var config bool IsTransparent;
var config name ActiveItem;
var config bool BlockTrace;
var config bool BlockTraceIfOpaque;
var config bool AddFocus;
var config bool BreakIfMatch;

defaultproperties
{
	Range=10000.0000000
	BreakIfMatch=true
}