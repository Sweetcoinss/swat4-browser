class GUIImage extends GUIComponent
	native
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object);

cpptext
{
		void Draw(UCanvas* Canvas);

}

var() config Material Image "The Material to Render";
var() config Color ImageColor "What color should we set";
var() config GUI.eImgStyle ImageStyle "How should the image be displayed";
var() config GUI.EMenuRenderStyle ImageRenderStyle "How should we display this image";
var() config GUI.eImgAlign ImageAlign "If ISTY_Justified, how should image be aligned";
var() config int x1;
var() config int y1;
var() config int x2;
var() config int y2 "If set, it will pull a subimage from inside the image";

function InitComponent(GUIComponent Owner)
{
	super.InitComponent(Owner);
	return;
}

defaultproperties
{
	ImageColor=(R=255,G=255,B=255,A=255)
	ImageStyle=2
	ImageRenderStyle=5
	x1=-1
	y1=-1
	x2=-1
	y2=-1
	bAcceptsInput=false
	RenderWeight=0.1000000
}