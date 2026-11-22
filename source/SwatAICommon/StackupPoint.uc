class StackupPoint extends BaseDoorPoint
	native
	config
	hidecategories(Karma,Lighting,LightColor,Karma,Force);

var private Pawn OfficerClaimer;
var private Texture StackupPointIcons[4];
var bool CanThrowFromPoint;
var ISwatAI.AIThrowSide ThrowSide;
var private int AlternatePriority;
var array<Vector> StackupPathToDoor;
var private Actor BlockedOpenLeft;
var private Actor BlockedOpenRight;

function bool IsClaimedByOfficer()
{
	return NotEqual_ObjectObject(OfficerClaimer, none);
	return;
}

function SetClaimedByOfficer(Pawn Officer)
{
	OfficerClaimer = Officer;
	return;
}

function ClearClaims()
{
	OfficerClaimer = none;
	return;
}
