class GUIDualSelectionLists extends GUIMultiComponent
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

var export editinline GUIListBox ListBoxA;
var export editinline GUIListBox ListBoxB;
var export editinline GUILabel ListBoxAH;
var export editinline GUILabel ListBoxBH;
var export editinline GUIGFXButton AtoB;
var export editinline GUIGFXButton BtoA;
var private export editinline GUIListBox LBA;
var private export editinline GUIListBox LBB;
var private export editinline GUILabel LBAH;
var private export editinline GUILabel LBBH;
var private export editinline GUIGFXButton ABButton;
var private export editinline GUIGFXButton BAButton;
var() config bool bSwitchListBoxLocations "If true, will layout the list boxes & headers in the other order";
var() config bool bVerticalLayout "If true, will layout this component vertically instead of horizontally";
var() config float ListBoxSpacing "Determines spacing of the lists (80% default)";
var() config float HeaderPercent "Determines spacing of the headers (100% default)";
var() config bool ProhibitEmptyingListA "If true, user will not be permitted to remove the last item from List A";
var() config bool ProhibitEmptyingListB "If true, user will not be permitted to remove the last item from List B";
var() config localized string BoxAHeader "Caption to use over ListBox A";
var() config localized string BoxBHeader "Caption to use over ListBox B";
var() config localized string LeftCaption "Caption to use on Arrow Pointing Left";
var() config localized string RightCaption "Caption to use on Arrow Pointing Right";
var() config localized string UpCaption "Caption to use on Arrow Pointing Up";
var() config localized string DownCaption "Caption to use on Arrow Pointing Down";
var() config Material LeftImage "Image to use on Arrow Pointing Left";
var() config Material RightImage "Image to use on Arrow Pointing Right";
var() config Material UpImage "Image to use on Arrow Pointing Up";
var() config Material DownImage "Image to use on Arrow Pointing Down";

function OnConstruct(GUIController MyController)
{
	super.OnConstruct(MyController);
	ListBoxA = GUIListBox(AddComponent("GUI.GUIListBox", Concat_StrStr(string(self.Name), "_LBA")));
	ListBoxB = GUIListBox(AddComponent("GUI.GUIListBox", Concat_StrStr(string(self.Name), "_LBB")));
	ListBoxAH = GUILabel(AddComponent("GUI.GUILabel", Concat_StrStr(string(self.Name), "_HeaderA")));
	ListBoxBH = GUILabel(AddComponent("GUI.GUILabel", Concat_StrStr(string(self.Name), "_HeaderB")));
	AtoB = GUIGFXButton(AddComponent("GUI.GUIGFXButton", Concat_StrStr(string(self.Name), "_AB")));
	BtoA = GUIGFXButton(AddComponent("GUI.GUIGFXButton", Concat_StrStr(string(self.Name), "_BA")));
	return;
}

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	AssignComponents();
	ListBoxAH.TextAlign = 1;
	ListBoxBH.TextAlign = 1;
	ListBoxAH.SetCaption(BoxAHeader);
	ListBoxBH.SetCaption(BoxBHeader);
	if(bVerticalLayout)
	{
		if(Not_PreBool(bSwitchListBoxLocations))
		{
			ABButton.SetCaption(UpCaption);
			BAButton.SetCaption(DownCaption);
			ABButton.Graphic = UpImage;
			BAButton.Graphic = DownImage;
		}
		else
		{
			ABButton.SetCaption(DownCaption);
			BAButton.SetCaption(UpCaption);
			ABButton.Graphic = DownImage;
			BAButton.Graphic = UpImage;
		}
	}
	else
	{
		if(Not_PreBool(bSwitchListBoxLocations))
		{
			ABButton.SetCaption(LeftCaption);
			BAButton.SetCaption(RightCaption);
			ABButton.Graphic = LeftImage;
			BAButton.Graphic = RightImage;
		}
		else
		{
			ABButton.SetCaption(RightCaption);
			BAButton.SetCaption(LeftCaption);
			ABButton.Graphic = RightImage;
			BAButton.Graphic = LeftImage;
		}
	}
	ABButton.__OnClick__Delegate = MoveAB;
	BAButton.__OnClick__Delegate = MoveBA;
	LBA.List.__OnDblClick__Delegate = MoveAB;
	LBB.List.__OnDblClick__Delegate = MoveBA;
	LBA.__OnClick__Delegate = OnListClicked;
	LBB.__OnClick__Delegate = OnListClicked;
	return;
}

event Activate()
{
	super.Activate();
	CheckListSelection(LBA);
	CheckListSelection(LBB);
	return;
}

event OnChangeLayout()
{
	AssignComponents();
	LBAH.SetCaption(BoxAHeader);
	LBBH.SetCaption(BoxBHeader);
	super(GUIComponent).OnChangeLayout();
	return;
}

function MoveAB(GUIComponent Sender)
{
	if(OrOr_BoolBool(Less_IntInt(LBA.GetIndex(), 0), EqualEqual_StrStr(LBA.List.Get(), "")))
	{
		return;
	}
	if(AndAnd_BoolBool(ProhibitEmptyingListA, EqualEqual_IntInt(LBA.ItemCount(), 1)))
	{
		return;
	}
	LBB.List.AddElement(LBA.List.GetElement());
	LBA.List.Remove(LBA.GetIndex());
	CheckListSelection(LBA);
	CheckListSelection(LBB);
	OnChange(self);
	return;
}

function MoveBA(GUIComponent Sender)
{
	if(OrOr_BoolBool(Less_IntInt(LBB.GetIndex(), 0), EqualEqual_StrStr(LBB.List.Get(), "")))
	{
		return;
	}
	if(AndAnd_BoolBool(ProhibitEmptyingListB, EqualEqual_IntInt(LBB.ItemCount(), 1)))
	{
		return;
	}
	LBA.List.AddElement(LBB.List.GetElement());
	LBB.List.Remove(LBB.GetIndex());
	CheckListSelection(LBA);
	CheckListSelection(LBB);
	OnChange(self);
	return;
}

function OnListClicked(GUIComponent Sender)
{
	local export editinline GUIListBox ListBox;

	ListBox = GUIListBox(Sender);
	assert(NotEqual_ObjectObject(ListBox, none));
	CheckListSelection(ListBox);
	SetDirty();
	OnChange(self);
	return;
}

private function CheckListSelection(GUIListBox ListBox)
{
	if(OrOr_BoolBool(Less_IntInt(ListBox.GetIndex(), 0), Greater_IntInt(ListBox.GetIndex(), ListBox.Num())))
	{
		switch(ListBox)
		{
			case LBA:
				AtoB.DisableComponent();
				break;
			case LBB:
				BtoA.DisableComponent();
				break;
			default:
				break;
		}
	}
	else
	{
		switch(ListBox)
		{
			case LBA:
				AtoB.EnableComponent();
				break;
			case LBB:
				BtoA.EnableComponent();
				break;
			default:
				break;
		}
	}
	return;
}

private function AssignComponents()
{
	if(bSwitchListBoxLocations)
	{
		LBA = ListBoxB;
		LBB = ListBoxA;
		LBAH = ListBoxBH;
		LBBH = ListBoxAH;
	}
	else
	{
		LBA = ListBoxA;
		LBB = ListBoxB;
		LBAH = ListBoxAH;
		LBBH = ListBoxBH;
	}
	ABButton = AtoB;
	BAButton = BtoA;
	return;
}

defaultproperties
{
	ListBoxSpacing=0.9300000
	HeaderPercent=1.0000000
	LeftCaption="<<<"
	RightCaption=">>>"
	UpCaption="^^^"
	DownCaption="vvv"
	WinTop=0.3000000
	WinLeft=0.0500000
	WinWidth=0.9000000
	WinHeight=0.4000000
}