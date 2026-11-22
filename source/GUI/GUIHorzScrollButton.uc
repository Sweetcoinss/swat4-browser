class GUIHorzScrollButton extends GUIGFXButton
	native
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object,Menu,Object,Menu,Object);

var() config bool LeftButton "If true, this button will use a left arrow material for its graphic, else a right arrow";
var() config Material LeftImage "Image to use for a left arrow";
var() config Material RightImage "Image to use for a right arrow";

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	if(LeftButton)
	{
		Graphic = LeftImage;
	}
	else
	{
		Graphic = RightImage;
	}
	return;
}

defaultproperties
{
	LeftImage=Texture'gui_tex.menu_scroll_left'
	RightImage=Texture'gui_tex.menu_scroll_right'
	Position=2
	StyleName="STY_RoundScaledButton"
}