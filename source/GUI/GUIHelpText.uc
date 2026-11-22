class GUIHelpText extends GUILabel
	native
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object,Menu,Object);

cpptext
{
		void PreDraw(UCanvas* Canvas);
	void UpdateComponent(UCanvas* Canvas);

}

var() config float XOverlapPercent "The percentage of the ActiveControl to overlap by this label";
var() config float YOverlapPercent "The percentage of the ActiveControl to overlap by this label";
var() config float XBorderPercent "The percentage of border around the text (typically in the range 1.0 - 1.5)";
var() config float YBorderPercent "The percentage of border around the text (typically in the range 1.0 - 1.5)";
var() config float MaxWidth "The maximum width of the label, if exceded, will word wrap";

function InitComponent(GUIComponent Owner)
{
	super(GUITextComponent).InitComponent(Owner);
	return;
}

defaultproperties
{
	XOverlapPercent=0.2000000
	YOverlapPercent=0.2000000
	XBorderPercent=1.1000000
	YBorderPercent=1.2000000
	MaxWidth=160.0000000
	TextAlign=1
}