class ClearPoint extends BaseDoorPoint
	native
	config
	hidecategories(Karma,Lighting,LightColor,Karma,Force);

var private Texture ClearPointIcons[4];
var array<ClearRoutePoint> ClearRoutePoints;
var array<Vector> ClearPathLocations;
var private Color ClearPathColors[4];

defaultproperties
{
	ClearPathColors[0]=(R=255,G=255,B=255,A=255)
	ClearPathColors[1]=(R=0,G=0,B=0,A=255)
	ClearPathColors[2]=(R=200,G=200,B=255,A=255)
	ClearPathColors[3]=(R=255,G=96,B=0,A=255)
}