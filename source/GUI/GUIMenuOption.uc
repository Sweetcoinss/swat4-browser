class GUIMenuOption extends GUIMultiComponent
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

var() config string ComponentClassName "Name of the component to spawn";
var() config localized string Caption "Caption for the label";
var() config string LabelStyle "Name of the GUIStyle for the label";
var() config bool bHeightFromComponent "Get the Height of this component from the Component";
var() config float CaptionWidth "How big should the Caption be";
var() config float ComponentWidth "How big should the Component be (-1 = 1-CaptionWidth)";
var() config bool bFlipped "Draw the Component to the left of the caption";
var() config GUI.eTextAlign LabelJustification "How do we justify the label";
var() config GUI.eTextAlign ComponentJustification "How do we justify the label";
var() config bool bSquare "Use the Height for the Width";
var() config bool bVerticalLayout "Layout controls vertically";
var export editinline GUILabel MyLabel;
var export editinline GUIComponent MyComponent;

function OnConstruct(GUIController MyController)
{
	super.OnConstruct(MyController);
	MyLabel = GUILabel(AddComponent("GUI.GUILabel", Concat_StrStr(string(self.Name), "_Label")));
	MyComponent = AddComponent(ComponentClassName, Concat_StrStr(Concat_StrStr(string(self.Name), "_"), ComponentClassName));
	return;
}

function InitComponent(GUIComponent MyOwner)
{
	MyLabel.StyleName = LabelStyle;
	super.InitComponent(MyOwner);
	if(EqualEqual_ObjectObject(MyLabel, none))
	{
		Log(At_StrStr(At_StrStr("Failed to create ", string(self)), " due to problems creating GUILabel"));
		return;
	}
	if(bFlipped)
	{
		if(EqualEqual_IntInt(int(LabelJustification), int(0)))
		{
			LabelJustification = 2;
		}
		else
		{
			if(EqualEqual_IntInt(int(LabelJustification), int(2)))
			{
				LabelJustification = 0;
			}
		}
		if(EqualEqual_IntInt(int(ComponentJustification), int(0)))
		{
			ComponentJustification = 2;
		}
		else
		{
			if(EqualEqual_IntInt(int(ComponentJustification), int(2)))
			{
				ComponentJustification = 0;
			}
		}
	}
	MyLabel.SetCaption(Caption);
	MyLabel.TextAlign = LabelJustification;
	if(EqualEqual_ObjectObject(MyComponent, none))
	{
		Log(At_StrStr("Could not create requested menu component", ComponentClassName));
		return;
	}
	if(AndAnd_BoolBool(bHeightFromComponent, Not_PreBool(bVerticalLayout)))
	{
		WinHeight = MyComponent.WinHeight;
	}
	MyComponent.__OnChange__Delegate = InternalOnChange;
	MyComponent.bTabStop = true;
	MyComponent.TabOrder = 1;
	return;
}

function InternalOnChange(GUIComponent Sender)
{
	OnChange(self);
	return;
}

defaultproperties
{
	bHeightFromComponent=true
	CaptionWidth=0.5000000
	ComponentWidth=-1.0000000
	ComponentJustification=2
	WinTop=0.3476560
	WinLeft=0.4960940
	WinWidth=0.5000000
	WinHeight=0.0600000
}