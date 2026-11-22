class MirrorPoint extends Actor implements IMirrorPoint
	native
	config(SwatGame)
	placeable
	hidecategories(Karma);

enum EMirroringSide
{
	MirrorToLeft,                   // 0
	MirrorToRight                   // 1
};

var MirrorPoint.EMirroringSide MirrorDirection;
var private const bool bIsMirroringFromPointValid;
var private const Vector MirroringFromPoint;
var private const Vector MirroringToPoint;
var private const Rotator MirroringRotation;
var config float OffsetFromMirrorPoint;
var config float OffsetFromCornerDirection;

function Vector GetMirroringFromPoint()
{
	return MirroringFromPoint;
	return;
}

function Vector GetMirroringToPoint()
{
	return MirroringToPoint;
	return;
}

function Rotator GetMirroringDirection()
{
	return Rotation;
	return;
}

defaultproperties
{
	OffsetFromMirrorPoint=32.0000000
	OffsetFromCornerDirection=16.0000000
	DrawType=8
	StaticMesh=StaticMesh'Doors_sm.MirrorPoint'
	bHidden=true
	bAcceptsProjectors=false
	bCollideActors=true
	bDirectional=true
}