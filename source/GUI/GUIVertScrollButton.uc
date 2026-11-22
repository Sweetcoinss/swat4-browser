class GUIVertScrollButton extends GUIGFXButton
	native
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object,Menu,Object,Menu,Object);

var() config bool UpButton "If true, the graphic used is an up arrow (else a down arrow)";
var() config Material UpImage "Image to use for a up arrow";
var() config Material DownImage "Image to use for a down arrow";

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	if(UpButton)
	{
		Graphic = UpImage;
	}
	else
	{
		Graphic = DownImage;
	}
	return;
}

defaultproperties
{
	UpImage=Texture'gui_tex.menu_scroll_up'
	DownImage=Texture'gui_tex.menu_scroll_down'
	Position=2
	StyleName="STY_RoundScaledButton"
}