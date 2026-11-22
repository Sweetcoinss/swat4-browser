class PlayerStart extends SmallNavigationPoint
	native
	config
	notplaceable
	hidecategories(Karma,Lighting,LightColor,Karma,Force);

var editconst bool bSinglePlayerStart;
var editconst bool bEnabled;
var editconst float LastSpawnCampTime;

defaultproperties
{
	bSinglePlayerStart=true
	bEnabled=true
	Texture=Texture'Engine_res.S_Player'
	bDirectional=true
}