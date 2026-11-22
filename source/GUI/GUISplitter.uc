class GUISplitter extends GUIPanel
	native
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object,Menu,Object);

cpptext
{
//	void UpdateComponent(UCanvas* Canvas);
		void PreDraw(UCanvas* Canvas);
		void Draw(UCanvas* Canvas);
#if IG_SHARED
		UBOOL MouseMove(FLOAT XDelta, FLOAT YDelta);
#else
		UBOOL MouseMove(INT XDelta, INT YDelta);
#endif
		UBOOL MousePressed(UBOOL IsRepeat);
        UBOOL MouseReleased();
		UBOOL MouseHover();
		void SplitterUpdatePositions();

}

enum EGUISplitterType
{
	SPLIT_Vertical,                 // 0
	SPLIT_Horizontal                // 1
};

var() config GUISplitter.EGUISplitterType SplitOrientation "Orientation for the splitter";
var() config float SplitPosition "0.0 - 1.0";
var() config bool bFixedSplitter "Can splitter be moved?";
var() config bool bDrawSplitter "Draw the actual splitter bar";
var() config float SplitAreaSize "size of splitter thing";
var() editinline config string DefaultPanels[2] "Names of the default panels";
var() config float MaxPercentage "How big can any 1 panel get";
var export editinline GUIComponent Panels[2];

function InitComponent(GUIComponent MyOwner)
{
	super(GUIMultiComponent).InitComponent(MyOwner);
	if(NotEqual_StrStr(DefaultPanels[0], ""))
	{
		Panels[0] = AddComponent(DefaultPanels[0]);
		if(NotEqual_StrStr(DefaultPanels[1], ""))
		{
			Panels[1] = AddComponent(DefaultPanels[1]);
		}
	}
	SplitterUpdatePositions();
	return;
}

// Export UGUISplitter::execSplitterUpdatePositions(FFrame&, void* const)
native function SplitterUpdatePositions();

defaultproperties
{
	SplitPosition=0.5000000
	bDrawSplitter=true
	SplitAreaSize=8.0000000
	StyleName="STY_SquareButton"
	bNeverFocus=true
}