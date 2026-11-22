class Light extends Actor
	native
	config
	placeable
	hidecategories(Karma,Karma,Force,Collision,Object,Sound);

var(Corona) float MinCoronaSize;
var(Corona) float MaxCoronaSize;
var(Corona) float CoronaRotation;
var(Corona) float CoronaRotationOffset;
var(Corona) bool UseOwnFinalBlend;

defaultproperties
{
	MaxCoronaSize=250.0000000
	LightType=1
	LightBrightness=128.0000000
	LightRadius=14.0000000
	LightSaturation=255
	LightPeriod=32
	LightCone=128
	bOnlyAffectCurrentZone=true
	bStatic=true
	bHidden=true
	bNoDelete=true
	Texture=Texture'Engine_res.S_Light'
	bMovable=false
	CollisionRadius=24.0000000
	CollisionHeight=24.0000000
}