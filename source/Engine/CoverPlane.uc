class CoverPlane extends Volume
	native
	config
	notplaceable
	hidecategories(Karma,Events,Force,Karma,LightColor,Lighting,Sound,Object);

var const bool CanBillBoard "If true, this cover plane can swivel on its vertical center point to face the most appropriate direction";

defaultproperties
{
	bStatic=false
	bHidden=false
	bNoDelete=false
}