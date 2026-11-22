class PlacedThrowPoint extends PathNode
	native
	config
	hidecategories(Karma,Lighting,LightColor,Karma,Force);

var ISwatAI.AIThrowSide ThrowSide "Determines the animation we use to throw through this door";

defaultproperties
{
	bPropagatesSound=false
	Texture=Texture'SWAT4editorTex.ThrowPoint'
	bDirectional=true
}