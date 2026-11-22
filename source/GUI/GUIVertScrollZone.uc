class GUIVertScrollZone extends GUIComponent
	native
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object);

cpptext
{
		void Draw(UCanvas* Canvas);

}

//var delegate<OnScrollZoneClick> __OnScrollZoneClick__Delegate;

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	return;
}

event Click()
{
	local float Perc;

	super.Click();
	if(Not_PreBool(IsInBounds()))
	{
		return;
	}
	Perc = Divide_FloatFloat(Subtract_FloatFloat(Controller.MouseY, ActualTop()), ActualHeight());
	OnScrollZoneClick(Perc);
	return;
}

delegate OnScrollZoneClick(float Delta)
{
	return;
}

defaultproperties
{
	StyleName="STY_ScrollZone"
	bCaptureMouse=true
	bDrawStyle=true
	bNeverFocus=true
	bRepeatClick=true
	RenderWeight=0.2500000
}