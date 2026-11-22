class DecorationList extends Keypoint
	native
	config
	placeable
	hidecategories(Karma);

struct DecorationType
{
	var() StaticMesh StaticMesh;
	var() Range Count;
	var() Range DrawScale;
	var() int bAlign;
	var() int bRandomPitch;
	var() int bRandomYaw;
	var() int bRandomRoll;
};

var(List) array<DecorationType> Decorations;

defaultproperties
{
	Texture=Texture'Engine_res.S_DecorationList'
}