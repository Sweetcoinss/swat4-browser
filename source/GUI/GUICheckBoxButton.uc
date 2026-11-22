class GUICheckBoxButton extends GUIGFXButton
	native
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object,Menu,Object);

defaultproperties
{
	Graphic=Texture'gui_tex.menu_checkbox_on'
	Position=2
	bCheckBox=true
	bTabStop=true
}