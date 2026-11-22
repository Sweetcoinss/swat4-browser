class ReachSpec extends Object
	native;

struct native DoorBlockedInfo
{
	var Door BlockedBy;
	var bool bBlockedWhenOpenRight;
};

var int Distance;
var const NavigationPoint Start;
var const NavigationPoint End;
var int CollisionRadius;
var int CollisionHeight;
var int reachFlags;
var int MaxLandingVelocity;
var byte bPruned;
var const bool bForced;
var array<DoorBlockedInfo> DoorBlockedList;
