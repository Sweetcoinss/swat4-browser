class PlayerInterfaceDoorRelatedContext extends Object
	abstract
	native
	config
	perobjectconfig;

var config float Range;
var config PlayerFocusInterface.DoorPart DoorPart;
var config name ActiveItem;
var config array<name> ExceptActiveItem;
var config Actor.ESkeletalRegion SkeletalRegion;
var config bool CaresAboutOpen;
var config bool IsOpen;
var config bool CaresAboutLocked;
var config bool IsLocked;
var config bool CaresAboutPlayerBelief;
var config bool PlayerBelievesLocked;
var config bool CaresAboutWedged;
var config bool IsWedged;
var config bool CaresAboutBroken;
var config bool IsBroken;
var config bool CaresAboutMissionExit;
var config bool IsMissionExit;
var config bool CaresAboutTransparent;
var config bool IsTransparent;
var config name HasA;
var config name DoesntHaveA;
var config bool AddFocus;
var config bool BlockTrace;
var config bool BlockTraceIfOpaque;
var config bool BreakIfMatch;

defaultproperties
{
	Range=10000.0000000
	BreakIfMatch=true
}