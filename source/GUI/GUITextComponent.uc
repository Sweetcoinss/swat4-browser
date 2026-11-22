class GUITextComponent extends GUIComponent
	abstract
	native
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object);

cpptext
{
		void Draw(UCanvas* Canvas);

}

var() config localized string Caption "The text to display";
var() config GUI.eTextAlign TextAlign "How is the text aligned in it's bounding box";
var() config bool bMultiLine "Will cut content to display on multiple lines when too long";
var() config bool bDontCenterVertically "If true, the text will be flushed to the top; when false, it will be centered vertically in the label";

function InitComponent(GUIComponent Owner)
{
	super.InitComponent(Owner);
	return;
}

event SetCaption(string NewCaption)
{
	Caption = NewCaption;
	SetDirty();
	return;
}

function string GetCaption()
{
	return Caption;
	return;
}

defaultproperties
{
	RenderWeight=0.8000000
}