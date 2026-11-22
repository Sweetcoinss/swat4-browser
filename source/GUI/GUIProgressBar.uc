class GUIProgressBar extends GUIComponent
	native
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object);

cpptext
{
	void Draw(UCanvas* Canvas);

}

var() config Material BarMaterial "The material of the filled portion of the bar";
var() config Color BarColor "The Color of the filled portion of the bar";
var() config GUI.EMenuRenderStyle BarRenderStyle "How should we display this image";
var() config float Value "The current percent filled value (clamped 0-1)";
var() config GUI.eProgressDirection BarDirection "The direction to fill the bar";

defaultproperties
{
	BarMaterial=Texture'gui_tex.White'
	BarColor=(R=255,G=255,B=255,A=255)
	BarRenderStyle=5
	Value=1.0000000
	StyleName="STY_ProgressBar"
}