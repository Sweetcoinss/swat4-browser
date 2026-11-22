class GUIBattleRoom extends GUIMultiComponent
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object);

const MAX_MENU_ITEMS = 5;
const MENU_GOD = 0;
const MENU_DEBUG = 1;
const MENU_HEALTH = 2;
const MENU_MORALE = 3;
const MENU_CANCEL = 4;

var export editinline GUIButton BattleRoomMenu[5];
var string MenuOptions[5];
var export editinline GUIImage ScreenCanvas;
var Pawn MenuPawn;
var bool bMenuOpen;
var bool bSavedMenuPause;

function OnConstruct(GUIController MyController)
{
	local int ct;

	super.OnConstruct(MyController);
	ScreenCanvas = GUIImage(AddComponent("GUI.GUIImage", "HUDPage_BattleRoomScreen"));
	ct = 0;
	J0x4B:

	if(Less_IntInt(ct, 5))
	{
		BattleRoomMenu[ct] = GUIButton(AddComponent("GUI.GUIButton", Concat_StrStr(Concat_StrStr(string(Class.Name), "_Button"), string(ct))));
		AddAdd_PreInt(ct);
		// [Loop Continue]
		goto J0x4B;
	}
	return;
}

function InitComponent(GUIComponent Owner)
{
	local int ct;

	Log("init component!");
	super.InitComponent(Owner);
	Log(Concat_StrStr("menu owner=", string(MenuOwner)));
	ct = 0;
	J0x3D:

	if(Less_IntInt(ct, 5))
	{
		BattleRoomMenu[ct].Style = Style;
		BattleRoomMenu[ct].bBoundToParent = false;
		BattleRoomMenu[ct].bScaleToParent = false;
		BattleRoomMenu[ct].WinWidth = 0.1000000;
		BattleRoomMenu[ct].WinHeight = 0.0100000;
		BattleRoomMenu[ct].SetCaption(MenuOptions[ct]);
		BattleRoomMenu[ct].Hide();
		AddAdd_PreInt(ct);
		// [Loop Continue]
		goto J0x3D;
	}
	return;
}

function CommandClicked(GUIComponent Component)
{
	local int ct;

	ct = 0;
	J0x07:

	if(Less_IntInt(ct, 5))
	{
		if(EqualEqual_ObjectObject(Component, BattleRoomMenu[ct]))
		{
			switch(ct)
			{
				case 0:
					MenuPawn.Controller.bGodMode = Not_PreBool(MenuPawn.Controller.bGodMode);
					break;
				case 1:
					MenuPawn.bDisplayBattleDebug = Not_PreBool(MenuPawn.bDisplayBattleDebug);
					break;
				case 3:
					if(MenuPawn.IsA('SwatAI'))
					{
						SwatAI(MenuPawn).GetCommanderAction().ChangeMorale(0.4000000, "Battle Room Morale Boost!");
					}
					break;
				case 2:
					MenuPawn.Health = 1000;
					MenuPawn.default.Health = 1000;
					break;
				default:
					break;
			}
		}
		else
		{
			AddAdd_PreInt(ct);
			// [Loop Continue]
			goto J0x07;
		}/* !MISMATCHING REMOVE, tried Loop got Type:Else Position:0x11E! */
		CloseMenu();
		return;
	}/* !MISMATCHING REMOVE, tried Else got Type:Loop Position:0x007! */
}

function Open()
{
	Style = Controller.GetStyle("STY_lunarblue");
	Show();
	ScreenCanvas.FillOwner();
	ScreenCanvas.Show();
	return;
}

function OpenMenu(Pawn inPawn)
{
	local int ct;

	Activate();
	ScreenCanvas.bActiveInput = false;
	ScreenCanvas.bAcceptsInput = false;
	MenuPawn = inPawn;
	Focus();
	Press();
	MenuReposition();
	ct = 0;
	J0x4C:

	if(Less_IntInt(ct, 5))
	{
		BattleRoomMenu[ct].SetCaption(MenuOptions[ct]);
		BattleRoomMenu[ct].Style = Style;
		BattleRoomMenu[ct].__OnMouseRelease__Delegate = CommandClicked;
		BattleRoomMenu[ct].Show();
		AddAdd_PreInt(ct);
		// [Loop Continue]
		goto J0x4C;
	}
	bMenuOpen = true;
	Controller.ActiveControl = self;
	bSavedMenuPause = Controller.ViewportOwner.Actor.Level.bPlayersOnly;
	Controller.ViewportOwner.Actor.Level.bPlayersOnly = true;
	return;
}

function MenuReposition()
{
	local int ct;
	local sDynamicPositionSpec Position;
	local Vector Screen;

	Screen = Controller.WorldToScreen(MenuPawn.Location);
	ct = 0;
	J0x2A:

	if(Less_IntInt(ct, 5))
	{
		Controller.GetGuiResolution();
		Position.WinLeft = Divide_FloatFloat(Add_FloatFloat(Screen.X, float(50)), float(Controller.ResolutionX));
		Position.WinTop = Add_FloatFloat(Divide_FloatFloat(Subtract_FloatFloat(Screen.Y, float(Multiply_IntInt(20, 5))), float(Controller.ResolutionY)), Multiply_FloatFloat(0.0500000, float(ct)));
		Position.WinWidth = 0.1100000;
		Position.WinHeight = 0.0500000;
		Position.TransitionTime = 0.0000000;
		Position.KeyName = 'temp';
		BattleRoomMenu[ct].bBoundToParent = false;
		BattleRoomMenu[ct].bScaleToParent = false;
		BattleRoomMenu[ct].WinWidth = 0.1100000;
		BattleRoomMenu[ct].WinHeight = 0.0500000;
		BattleRoomMenu[ct].RePositionTo(Position);
		AddAdd_PreInt(ct);
		// [Loop Continue]
		goto J0x2A;
	}
	return;
}

function CloseMenu()
{
	local int ct;

	ScreenCanvas.Show();
	ScreenCanvas.bActiveInput = true;
	ScreenCanvas.bAcceptsInput = true;
	ct = 0;
	J0x38:

	if(Less_IntInt(ct, 5))
	{
		BattleRoomMenu[ct].Hide();
		AddAdd_PreInt(ct);
		// [Loop Continue]
		goto J0x38;
	}
	Controller.ActiveControl = self;
	bMenuOpen = false;
	if(Not_PreBool(bSavedMenuPause))
	{
		Controller.ViewportOwner.Actor.Level.bPlayersOnly = false;
	}
	return;
}

function Close()
{
	Hide();
	DeActivate();
	return;
}

defaultproperties
{
	MenuOptions[0]="Toggle god."
	MenuOptions[1]="Toggle Debug."
	MenuOptions[2]="1000 Health."
	MenuOptions[3]="Boost Morale."
	MenuOptions[4]="Cancel."
}