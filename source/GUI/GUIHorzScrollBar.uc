class GUIHorzScrollBar extends GUIScrollBarBase
	native
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object);

cpptext
{
		void PreDraw(UCanvas* Canvas);
	void UpdateComponent(UCanvas* Canvas);

}

var export editinline GUIHorzScrollZone MyScrollZone;
var export editinline GUIHorzScrollButton MyLeftButton;
var export editinline GUIHorzScrollButton MyRightButton;
var export editinline GUIHorzGripButton MyGripButton;
var float GripLeft;
var float GripWidth;

function OnConstruct(GUIController MyController)
{
	super(GUIMultiComponent).OnConstruct(MyController);
	MyScrollZone = GUIHorzScrollZone(AddComponent("GUI.GUIHorzScrollZone", Concat_StrStr(string(self.Name), "_SZone")));
	MyLeftButton = GUIHorzScrollButton(AddComponent("GUI.GUIHorzScrollButton", Concat_StrStr(string(self.Name), "_Left")));
	MyRightButton = GUIHorzScrollButton(AddComponent("GUI.GUIHorzScrollButton", Concat_StrStr(string(self.Name), "_Right")));
	MyGripButton = GUIHorzGripButton(AddComponent("GUI.GUIHorzGripButton", Concat_StrStr(string(self.Name), "_Grip")));
	return;
}

function InitComponent(GUIComponent MyOwner)
{
	super(GUIMultiComponent).InitComponent(MyOwner);
	MyLeftButton.LeftButton = true;
	MyRightButton.LeftButton = false;
	MyScrollZone.__OnScrollZoneClick__Delegate = ZoneClick;
	MyLeftButton.__OnClick__Delegate = LeftTickClick;
	MyRightButton.__OnClick__Delegate = RightTickClick;
	MyGripButton.__OnCapturedMouseMove__Delegate = GripMouseMove;
	Refocus(MyList);
	return;
}

function UpdateGripPosition(float NewPos)
{
	MyList.MakeVisible(NewPos);
	GripLeft = NewPos;
	SetDirty();
	return;
}

function bool GripMouseMove(float deltaX, float deltaY)
{
	local float NewPerc, NewLeft;

	if(EqualEqual_FloatFloat(deltaX, float(0)))
	{
		return true;
	}
	MultiplyEqual_FloatFloat(deltaX, float(-1));
	NewPerc = Divide_FloatFloat(Abs(deltaX), Subtract_FloatFloat(MyScrollZone.ActualWidth(), GripWidth));
	if(Less_FloatFloat(deltaX, float(0)))
	{
		MultiplyEqual_FloatFloat(NewPerc, float(-1));
	}
	NewLeft = FClamp(Add_FloatFloat(GripLeft, NewPerc), 0.0000000, 1.0000000);
	UpdateGripPosition(NewLeft);
	return true;
	return;
}

function ZoneClick(float Delta)
{
	if(Less_FloatFloat(Controller.MouseX, MyGripButton.Bounds[0]))
	{
		MoveGripBy(Subtract_PreInt(MyList.ItemsPerPage));
	}
	else
	{
		if(Greater_FloatFloat(Controller.MouseX, MyGripButton.Bounds[2]))
		{
			MoveGripBy(MyList.ItemsPerPage);
		}
	}
	return;
	return;
}

function MoveGripBy(int Items)
{
	local int LeftItem;

	LeftItem = Add_IntInt(MyList.Top, Items);
	if(Greater_IntInt(MyList.ItemCount, 0))
	{
		MyList.SetTopItem(LeftItem);
		AlignThumb();
	}
	SetDirty();
	return;
}

function LeftTickClick(GUIComponent Sender)
{
	WheelUp();
	return;
}

function RightTickClick(GUIComponent Sender)
{
	WheelDown();
	return;
}

function WheelUp()
{
	if(Not_PreBool(Controller.CtrlPressed))
	{
		MoveGripBy(-1);
	}
	else
	{
		MoveGripBy(Subtract_PreInt(MyList.ItemsPerPage));
	}
	return;
}

function WheelDown()
{
	if(Not_PreBool(Controller.CtrlPressed))
	{
		MoveGripBy(1);
	}
	else
	{
		MoveGripBy(MyList.ItemsPerPage);
	}
	return;
}

function AlignThumb()
{
	local float NewLeft;

	if(EqualEqual_IntInt(MyList.ItemCount, 0))
	{
		NewLeft = 0.0000000;
	}
	else
	{
		NewLeft = Divide_FloatFloat(float(MyList.Top), float(Subtract_IntInt(MyList.ItemCount, MyList.ItemsPerPage)));
		NewLeft = FClamp(NewLeft, 0.0000000, 1.0000000);
	}
	GripLeft = NewLeft;
	SetDirty();
	return;
}

defaultproperties
{
	WinWidth=0.0375000
}