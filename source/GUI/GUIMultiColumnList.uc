class GUIMultiColumnList extends GUIMultiComponent
	native
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

cpptext
{
	void PreDraw(UCanvas* Canvas);
	void UpdateComponent(UCanvas* Canvas);

}

var export editinline GUIList MCList;
var export editinline GUIButton MCButton;
var() config float ColumnWidth "Relative size of this column within parent";
var() config float HeaderHeight "Pixel height of the header button for this column (at 1024x768)";
var() config bool bIgnoreHeader "This list should never be active for sorting";
var() editconst int IndexID "What index number this is in MCLB array";

function OnConstruct(GUIController MyController)
{
	super.OnConstruct(MyController);
	MCList = GUIList(AddComponent("GUI.GUIList", Concat_StrStr(string(self.Name), "_List")));
	MCButton = GUIButton(AddComponent("GUI.GUIGFXButton", Concat_StrStr(string(self.Name), "_Button")));
	return;
}

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	MCButton.bNeverFocus = true;
	MCButton.SetFocusInstead(MCList);
	return;
}

defaultproperties
{
	ColumnWidth=1.0000000
	HeaderHeight=20.0000000
}