class GUIVertScrollBar extends GUIScrollBarBase
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

var export editinline GUIVertScrollZone MyScrollZone;
var export editinline GUIVertScrollButton MyUpButton;
var export editinline GUIVertScrollButton MyDownButton;
var export editinline GUIVertGripButton MyGripButton;
var float GripTop;
var float GripHeight;
var float GrabOffset;

function OnConstruct(GUIController MyController)
{
	super(GUIMultiComponent).OnConstruct(MyController);
	MyScrollZone = GUIVertScrollZone(AddComponent("GUI.GUIVertScrollZone", Concat_StrStr(string(self.Name), "_SZone")));
	MyUpButton = GUIVertScrollButton(AddComponent("GUI.GUIVertScrollButton", Concat_StrStr(string(self.Name), "_Up")));
	MyDownButton = GUIVertScrollButton(AddComponent("GUI.GUIVertScrollButton", Concat_StrStr(string(self.Name), "_Down")));
	MyGripButton = GUIVertGripButton(AddComponent("GUI.GUIVertGripButton", Concat_StrStr(string(self.Name), "_Grip")));
	return;
}

function InitComponent(GUIComponent MyOwner)
{
	super(GUIMultiComponent).InitComponent(MyOwner);
	MyUpButton.UpButton = true;
	MyDownButton.UpButton = false;
	MyScrollZone.__OnScrollZoneClick__Delegate = ZoneClick;
	MyUpButton.__OnClick__Delegate = UpTickClick;
	MyDownButton.__OnClick__Delegate = DownTickClick;
	MyGripButton.__OnCapturedMouseMove__Delegate = GripMouseMove;
	MyGripButton.__OnMousePressed__Delegate = GripClick;
	Refocus(MyList);
	return;
}

function UpdateGripPosition(float NewPos)
{
	MyList.MakeVisible(NewPos);
	GripTop = NewPos;
	SetDirty();
	return;
}

function GripClick(GUIComponent Sender)
{
	GrabOffset = Subtract_FloatFloat(Controller.MouseY, MyGripButton.ActualTop());
	return;
}

function bool GripMouseMove(float deltaX, float deltaY)
{
	local float NewPerc, NewTop;

	NewPerc = Divide_FloatFloat(Subtract_FloatFloat(Controller.MouseY, Add_FloatFloat(GrabOffset, MyScrollZone.ActualTop())), Subtract_FloatFloat(MyScrollZone.ActualHeight(), GripHeight));
	NewTop = FClamp(NewPerc, 0.0000000, 1.0000000);
	UpdateGripPosition(NewTop);
	return true;
	return;
}

function ZoneClick(float Delta)
{
	if(Less_FloatFloat(Controller.MouseY, MyGripButton.Bounds[1]))
	{
		MoveGripBy(Subtract_PreInt(MyList.ItemsPerPage));
	}
	else
	{
		if(Greater_FloatFloat(Controller.MouseY, MyGripButton.Bounds[3]))
		{
			MoveGripBy(MyList.ItemsPerPage);
		}
	}
	return;
	return;
}

function MoveGripBy(int Items)
{
	local int TopItem;

	TopItem = Add_IntInt(MyList.Top, Items);
	if(Greater_IntInt(MyList.ItemCount, 0))
	{
		MyList.SetTopItem(TopItem);
		AlignThumb();
	}
	SetDirty();
	return;
}

function UpTickClick(GUIComponent Sender)
{
	WheelUp();
	return;
}

function DownTickClick(GUIComponent Sender)
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
	local float NewTop;

	if(EqualEqual_IntInt(MyList.ItemCount, 0))
	{
		NewTop = 0.0000000;
	}
	else
	{
		NewTop = Divide_FloatFloat(float(MyList.Top), float(Subtract_IntInt(MyList.ItemCount, MyList.ItemsPerPage)));
		NewTop = FClamp(NewTop, 0.0000000, 1.0000000);
	}
	GripTop = NewTop;
	SetDirty();
	return;
}

defaultproperties
{
	WinWidth=0.0375000
}