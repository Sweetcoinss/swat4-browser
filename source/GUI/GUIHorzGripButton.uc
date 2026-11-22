class GUIHorzGripButton extends GUIGFXButton
	native
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object,Menu,Object);

var() config Material GripButtonImage "Image to use for a grip button";

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	Graphic = GripButtonImage;
	return;
}

defaultproperties
{
	GripButtonImage=Texture'gui_tex.White'
	Position=4
}