class Note extends Actor
	native
	config
	placeable
	hidecategories(Karma);

var string Text;

defaultproperties
{
	bStatic=true
	bHidden=true
	bNoDelete=true
	Texture=Texture'Engine_res.S_Note'
	bMovable=false
}