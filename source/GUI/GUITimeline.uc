class GUITimeline extends GUIMultiComponent
	native
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

cpptext
{
	void Draw(UCanvas* Canvas);

}

var() config Material BarMaterial "The material of the filled portion of the bar";
var() config Color BarColor "The Color of the filled portion of the bar";
var() config GUI.EMenuRenderStyle BarRenderStyle "How should we display this image";
var() config float BarHeight "Height of the bar";
var() config Material SelectedPlotMaterial "The material for the selected plot point";
var() config Color SelectedPlotColor "The Color of the filled portion of the bar";
var() config GUI.EMenuRenderStyle SelectedPlotRenderStyle "How should we display this image";
var() config float SelectedPlotHeight "Height of the selected plot";
var() config float SelectedPlotThickness "Thickness of the selected plot";
var() config Material UnSelectedPlotMaterial "The material for the un-selected plot points";
var() config Color UnSelectedPlotColor "The Color of the filled portion of the bar";
var() config GUI.EMenuRenderStyle UnSelectedPlotRenderStyle "How should we display this image";
var() config float UnSelectedPlotHeight "Height of the un-selected plot";
var() config float UnSelectedPlotThickness "Thickness of the un-selected plot";
var() config array<int> TimePlots;
var() config int SelectedPlot;

function AddTimePlot(int i)
{
	TimePlots[TimePlots.Length] = i;
	return;
}

function ClearPlot()
{
	TimePlots.Remove(0, TimePlots.Length);
	return;
}

function SelectPlot(int i)
{
	if(GreaterEqual_IntInt(i, TimePlots.Length))
	{
		SelectedPlot = Subtract_IntInt(TimePlots.Length, 1);
	}
	else
	{
		if(Less_IntInt(i, 0))
		{
			SelectedPlot = 0;
		}
		else
		{
			SelectedPlot = i;
		}
	}
	return;
}

defaultproperties
{
	BarMaterial=Texture'gui_tex.White'
	BarColor=(R=255,G=255,B=255,A=255)
	BarRenderStyle=5
	BarHeight=0.2000000
	SelectedPlotMaterial=Texture'gui_tex.White'
	SelectedPlotColor=(R=255,G=255,B=255,A=255)
	SelectedPlotRenderStyle=5
	SelectedPlotHeight=1.0000000
	SelectedPlotThickness=0.0200000
	UnSelectedPlotMaterial=Texture'gui_tex.White'
	UnSelectedPlotColor=(R=150,G=150,B=150,A=255)
	UnSelectedPlotRenderStyle=5
	UnSelectedPlotHeight=0.8000000
	UnSelectedPlotThickness=0.0100000
	StyleName="STY_ProgressBar"
}