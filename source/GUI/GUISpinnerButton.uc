class GUISpinnerButton extends GUIGFXButton
	native
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object,Menu,Object,Menu,Object);

var() config bool PlusButton "If true this uses a plus graphic, else it uses minus graphic";
var() config Material PlusImage "Image to use for a plus";
var() config Material MinusImage "Image to use for a minus";

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	if(PlusButton)
	{
		Graphic = PlusImage;
	}
	else
	{
		Graphic = MinusImage;
	}
	return;
}

defaultproperties
{
	PlusImage=Texture'gui_tex.menu_plus'
	MinusImage=Texture'gui_tex.menu_minus'
	Position=2
	StyleName="STY_RoundScaledButton"
	bRepeatClick=true
}