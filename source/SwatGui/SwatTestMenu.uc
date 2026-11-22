class SwatTestMenu extends GUIPage
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(SwatGui) private export editinline GUITabControl TabControl;
var int Number;

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	TabControl = GUITabControl(AddComponent("GUI.GUITabControl", Concat_StrStr(string(self.Name), "_GUITabControl"), true));
	TabControl.WinLeft = 0.0000000;
	TabControl.WinTop = 0.0000000;
	TabControl.WinWidth = 1.0000000;
	TabControl.WinHeight = 1.0000000;
	return;
}

private function InternalOnActivate()
{
	SetTimer(2.0000000, true);
	return;
}

event Timer()
{
	local bool bAddOne;
	local int i;

	bAddOne = Greater_FloatFloat(FRand(), 0.5000000);
	i = Rand(10);
	J0x1A:

	if(Greater_IntInt(i, 0))
	{
		if(OrOr_BoolBool(TabControl.IsEmpty(), bAddOne))
		{
			AddTab();
			// [Explicit Continue]
			goto J0x51;
		}
		RemoveTab();
		J0x51:

		SubtractSubtract_Int(i);
		// [Loop Continue]
		goto J0x1A;
	}
	ReAlign();
	return;
}

function AddTab()
{
	Log(Concat_StrStr(string(self), "::AddTab()"));
	TabControl.AddTab_StrStrStrStr("GUI.GUIPanel", Concat_StrStr(Concat_StrStr("Tab", string(Number)), "Panel"), "GUI.GUIButton", Concat_StrStr(Concat_StrStr("Tab", string(Number)), "Header"));
	AddAdd_Int(Number);
	return;
}

function RemoveTab()
{
	Log(Concat_StrStr(string(self), "::RemoveTab()"));
	TabControl.RemoveTab_Int(Rand(Subtract_IntInt(TabControl.Num(), 1)));
	return;
}

function ReAlign()
{
	local int Dir, numPerRow;
	local float RowSpacing;
	local bool ButtonsAlignedTopLeft;

	Dir = Rand(Subtract_IntInt(int(4), 1));
	if(Less_IntInt(Dir, 2))
	{
		RowSpacing = 20.0000000;
		numPerRow = 10;
	}
	else
	{
		RowSpacing = 80.0000000;
		numPerRow = 30;
	}
	ButtonsAlignedTopLeft = Greater_FloatFloat(FRand(), 0.5000000);
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "::ReAlign() ... Dir = "), string(GetEnum(Enum'GUI.GUI.eProgressDirection', Dir))), ", ButtonsAlignedTopLeft = "), string(ButtonsAlignedTopLeft)));
	TabControl.AlignTabs(byte(Dir), ButtonsAlignedTopLeft, numPerRow, RowSpacing, 1.0000000, 2.0000000);
	return;
}

defaultproperties
{
	OnActivate=SwatTestMenu.InternalOnActivate
}