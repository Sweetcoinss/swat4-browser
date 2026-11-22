class SwatLoadoutPanel extends SwatGUIPanel
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

struct sPocketTab
{
	var() config HandheldEquipment.Pocket DefaultPocket "The default pocket to be used when this tab is selected";
	var() HandheldEquipment.Pocket CurrentPocket "The current (main) pocket to be used when this tab is selected";
	var() config HandheldEquipment.Pocket AmmoPocket "The ammo pocket to be used, Pocket_Invalid if it has none";
	var() config array<HandheldEquipment.Pocket> SelectablePockets "The pockets that can be selected by buttons on this tab";
	var() config array<HandheldEquipment.Pocket> DisplayablePockets "The pockets that can be selected by buttons on this tab";
	var() export editinline GUIButton TabButton;
	var() export editinline GUIPanel TabPanel;
};

var(SwatGui) private export editinline config GUIImage MyEquipmentImage;
var(SwatGui) private export editinline config GUIImage MyAmmoImage;
var(SwatGui) private export editinline config GUILabel MyEquipmentNameLabel;
var(SwatGui) private export editinline config GUILabel MyAmmoNameLabel;
var(SwatGui) private export editinline config GUIScrollTextBox MyWeaponInfoBox;
var(SwatGui) private export editinline config GUIScrollTextBox MyEquipmentInfoBox;
var(SwatGui) private export editinline config GUIButton MyScrollLeftButton;
var(SwatGui) private export editinline config GUIButton MyScrollRightButton;
var(SwatGui) private export editinline config GUIButton MyScrollAmmoLeftButton;
var(SwatGui) private export editinline config GUIButton MyScrollAmmoRightButton;
var(SwatGui) private editconst editinline DynamicLoadOutSpec MyCurrentLoadOut "Holds all current loadout info";
var(SwatGui) editinline config array<editinline sPocketTab> PocketTabs "These are the tabs of selectable equipment";
var(SwatGui) editinline array<export editinline GUIList> EquipmentList "these are the lists of equipment";
var(SwatGui) editinline array<export editinline GUILabel> EquipmentLabel "These go next to the paperdoll figure";
var(SwatGui) editinline array<export editinline GUIButton> EquipmentSelectionButton "These go next to the paperdoll figure";
var private int ActiveTab;
var private HandheldEquipment.Pocket ActivePocket;
var private HandheldEquipment.Pocket ActiveAmmoPocket;
var private int FailedToValidate;

function InitComponent(GUIComponent MyOwner)
{
	local int i, j;
	local string PocketName;
	local HandheldEquipment.Pocket PocketID;
	local Class EquipmentClass;

	super.InitComponent(MyOwner);
	MyScrollLeftButton.__OnClick__Delegate = InternalOnScrollClick;
	MyScrollRightButton.__OnClick__Delegate = InternalOnScrollClick;
	MyScrollAmmoLeftButton.__OnClick__Delegate = InternalOnScrollClick;
	MyScrollAmmoRightButton.__OnClick__Delegate = InternalOnScrollClick;
	i = 0;
	J0x62:

	if(Less_IntInt(i, int(25)))
	{
		if(OrOr_BoolBool(Not_PreBool(CheckValidity(GC.AvailableEquipmentPockets[i].DisplayValidity)), LessEqual_IntInt(GC.AvailableEquipmentPockets[i].EquipmentClassName.Length, 0)))
		{
			// [Explicit Continue]
			goto J0x2AC;
		}
		PocketName = string(GetEnum(Enum'Engine.HandheldEquipment.Pocket', i));
		EquipmentLabel[i] = GUILabel(AddComponent("GUI.GUILabel", Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self.Name), "_"), PocketName), "_Label"), true));
		EquipmentList[i] = GUIList(AddComponent("GUI.GUIList", Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self.Name), "_"), PocketName), "_EquipmentList"), true));
		EquipmentList[i].bAcceptsInput = false;
		EquipmentList[i].bCanBeShown = false;
		EquipmentList[i].bNeverSort = true;
		j = 0;
		J0x1BC:

		if(Less_IntInt(j, GC.AvailableEquipmentPockets[i].EquipmentClassName.Length))
		{
			if(OrOr_BoolBool(Not_PreBool(GC.AvailableEquipmentPockets[i].bSelectable[j]), Not_PreBool(CheckValidity(GC.AvailableEquipmentPockets[i].Validity[j]))))
			{
				// [Explicit Continue]
				goto J0x2A2;
			}
			EquipmentClass = Class<Object>(DynamicLoadObject(GC.AvailableEquipmentPockets[i].EquipmentClassName[j], Class'Core.Class'));
			EquipmentList[i].Add(string(EquipmentClass.Name), EquipmentClass);
			J0x2A2:

			AddAdd_Int(j);
			// [Loop Continue]
			goto J0x1BC;
		}
		J0x2AC:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x62;
	}
	i = 0;
	J0x2BD:

	if(Less_IntInt(i, PocketTabs.Length))
	{
		PocketTabs[i].TabPanel = GUIPanel(AddComponent("GUI.GUIPanel", Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self.Name), "_"), string(i)), "_TabPanel"), true));
		PocketTabs[i].TabButton = GUIButton(AddComponent("GUI.GUIButton", Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self.Name), "_"), string(i)), "_TabButton"), true));
		PocketTabs[i].TabButton.__OnClick__Delegate = InternalTabButtonOnClick;
		PocketTabs[i].CurrentPocket = PocketTabs[i].DefaultPocket;
		j = 0;
		J0x3BA:

		if(Less_IntInt(j, PocketTabs[i].SelectablePockets.Length))
		{
			PocketID = PocketTabs[i].SelectablePockets[j];
			PocketName = string(GetEnum(Enum'Engine.HandheldEquipment.Pocket', int(PocketID)));
			EquipmentSelectionButton[int(PocketID)] = GUIButton(PocketTabs[i].TabPanel.AddComponent("GUI.GUIButton", Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self.Name), "_"), PocketName), "_Button"), true));
			EquipmentSelectionButton[int(PocketID)].__OnClick__Delegate = InternalSelectorButtonOnClick;
			AddAdd_Int(j);
			// [Loop Continue]
			goto J0x3BA;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x2BD;
	}
	ActiveTab = 0;
	return;
}

event Activate()
{
	super(GUIMultiComponent).Activate();
	SpawnLoadouts();
	InitialDisplay();
	return;
}

event Hide()
{
	DestroyLoadouts();
	super(GUIMultiComponent).Hide();
	return;
}

protected function SpawnLoadouts()
{
	return;
}

protected function DestroyLoadouts()
{
	return;
}

function InitialDisplay()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, int(25)))
	{
		if(Not_PreBool(CheckValidity(GC.AvailableEquipmentPockets[i].DisplayValidity)))
		{
			// [Explicit Continue]
			goto J0x5A;
		}
		UpdateIndex(byte(i));
		DisplayEquipment(byte(i));
		J0x5A:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	DisplayTab(ActiveTab);
	return;
}

function LoadLoadOut(string LoadOutName, optional bool bForceSpawn)
{
	if(AndAnd_BoolBool(NotEqual_ObjectObject(MyCurrentLoadOut, none), bForceSpawn))
	{
		MyCurrentLoadOut.Destroy();
	}
	if(OrOr_BoolBool(EqualEqual_ObjectObject(MyCurrentLoadOut, none), bForceSpawn))
	{
		MyCurrentLoadOut = PlayerOwner().Spawn(Class'SwatGame.DynamicLoadOutSpec', none, string(LoadOutName));
	}
	else
	{
		MyCurrentLoadOut.ResetConfig(LoadOutName);
	}
	AssertWithDescription(NotEqual_ObjectObject(MyCurrentLoadOut, none), Concat_StrStr(Concat_StrStr("[dkaplan]: Failed to load loadout [", LoadOutName), "]"));
	return;
}

function SaveLoadOut(string LoadOutName)
{
	MyCurrentLoadOut.SaveConfig(LoadOutName);
	return;
}

function bool CheckValidity(SwatGUIConfig.eNetworkValidity Type)
{
	return EqualEqual_IntInt(int(Type), int(3));
	return;
}

function LoadAmmoForWeapon(HandheldEquipment.Pocket ThePocket, Class<FiredWeapon> WeaponClass)
{
	local HandheldEquipment.Pocket OtherPocket;
	local string Str;

	OtherPocket = GC.AvailableEquipmentPockets[int(ThePocket)].DependentPocket;
	AssertWithDescription(Greater_IntInt(WeaponClass.default.PlayerAmmoOption.Length, 0), Concat_StrStr(Concat_StrStr("The weapon class ", string(WeaponClass.Name)), " must have at least one PlayerAmmoOption specified in SwatEquipment.ini."));
	MyScrollAmmoLeftButton.SetActive(Greater_IntInt(WeaponClass.default.PlayerAmmoOption.Length, 1));
	MyScrollAmmoRightButton.SetActive(Greater_IntInt(WeaponClass.default.PlayerAmmoOption.Length, 1));
	Str = string(MyCurrentLoadOut.LoadOutSpec[int(OtherPocket)].Name);
	EquipmentList[int(OtherPocket)].find(Str);
	if(Not_PreBool(MyCurrentLoadOut.ValidForLoadoutSpec(Class<Actor>(EquipmentList[int(OtherPocket)].GetObject()), OtherPocket)))
	{
		Scrolled(OtherPocket, false);
	}
	return;
}

function ChangeLoadOut(HandheldEquipment.Pocket ThePocket)
{
	local Class<Actor> theItem;

	theItem = Class<Actor>(EquipmentList[int(ThePocket)].GetObject());
	MyCurrentLoadOut.LoadOutSpec[int(ThePocket)] = theItem;
	switch(ThePocket)
	{
		case 0:
		case 2:
			LoadAmmoForWeapon(ThePocket, Class<FiredWeapon>(theItem));
			break;
		case 9:
			if(EqualEqual_ObjectObject(theItem, Class'SwatEquipment.C2Charge'))
			{
				MyCurrentLoadOut.LoadOutSpec[int(16)] = Class'SwatEquipment.C2Charge';
				MyCurrentLoadOut.LoadOutSpec[int(17)] = Class'SwatEquipment.C2Charge';
			}
			else
			{
				MyCurrentLoadOut.LoadOutSpec[int(16)] = none;
				MyCurrentLoadOut.LoadOutSpec[int(17)] = none;
			}
			break;
		default:
			break;
	}
	return;
}

function DisplayEquipment(HandheldEquipment.Pocket ThePocket)
{
	local Class<ICanBeSelectedInTheGUI> Equipment;

	if(EqualEqual_ObjectObject(EquipmentList[int(ThePocket)], none))
	{
		return;
	}
	Equipment = Class<ICanBeSelectedInTheGUI>(EquipmentList[int(ThePocket)].GetObject());
	EquipmentLabel[int(ThePocket)].SetCaption(Equipment.static.GetFriendlyName());
	if(NotEqual_ObjectObject(EquipmentSelectionButton[int(ThePocket)], none))
	{
		EquipmentSelectionButton[int(ThePocket)].SetCaption(Equipment.static.GetFriendlyName());
	}
	if(Not_PreBool(IsPocketDisplayedInActiveTab(ThePocket)))
	{
		return;
	}
	switch(ThePocket)
	{
		case 0:
		case 2:
			MyEquipmentNameLabel.SetCaption(Equipment.static.GetFriendlyName());
			MyEquipmentImage.Image = Equipment.static.GetGUIImage();
			MyWeaponInfoBox.SetContent(Equipment.static.GetDescription());
			break;
		case 1:
		case 3:
			MyAmmoImage.Image = Equipment.static.GetGUIImage();
			MyAmmoNameLabel.SetCaption(Equipment.static.GetFriendlyName());
			MyWeaponInfoBox.SetContent(Equipment.static.GetDescription());
			break;
		default:
			MyEquipmentImage.Image = Equipment.static.GetGUIImage();
			MyEquipmentNameLabel.SetCaption(Equipment.static.GetFriendlyName());
			MyEquipmentInfoBox.SetContent(Equipment.static.GetDescription());
			break;
			break;
	}
	return;
}

function Scrolled(HandheldEquipment.Pocket ThePocket, bool bLeftUsed)
{
	if(bLeftUsed)
	{
		EquipmentList[int(ThePocket)].setIndex(Add_IntInt(EquipmentList[int(ThePocket)].GetIndex(), 1));
	}
	else
	{
		EquipmentList[int(ThePocket)].setIndex(Subtract_IntInt(EquipmentList[int(ThePocket)].GetIndex(), 1));
	}
	if(Less_IntInt(EquipmentList[int(ThePocket)].GetIndex(), 0))
	{
		if(bLeftUsed)
		{
			EquipmentList[int(ThePocket)].setIndex(0);
		}
		else
		{
			EquipmentList[int(ThePocket)].setIndex(Subtract_IntInt(EquipmentList[int(ThePocket)].Elements.Length, 1));
		}
	}
	if(Not_PreBool(MyCurrentLoadOut.ValidForLoadoutSpec(Class<Actor>(EquipmentList[int(ThePocket)].GetObject()), ThePocket)))
	{
		if(GreaterEqual_IntInt(FailedToValidate, 0))
		{
			if(EqualEqual_IntInt(FailedToValidate, EquipmentList[int(ThePocket)].GetIndex()))
			{
				Log("!!!!!!!Failed to validate equipment for the following loadout:");
				MyCurrentLoadOut.PrintLoadOutSpecToMPLog();
				AssertWithDescription(false, Concat_StrStr(Concat_StrStr(Concat_StrStr("None of the equipment specified in SwatEquipment.ini for pocket ", string(GetEnum(Enum'Engine.HandheldEquipment.Pocket', int(ThePocket)))), " validates for dynamic loadout spec "), string(MyCurrentLoadOut)));
			}
		}
		else
		{
			FailedToValidate = EquipmentList[int(ThePocket)].GetIndex();
		}
		Scrolled(ThePocket, bLeftUsed);
		return;
	}
	FailedToValidate = -1;
	ChangeLoadOut(ThePocket);
	DisplayEquipment(ThePocket);
	return;
}

function UpdateIndex(HandheldEquipment.Pocket ThePocket)
{
	local string Str;

	if(EqualEqual_ObjectObject(EquipmentList[int(ThePocket)], none))
	{
		return;
	}
	Str = string(MyCurrentLoadOut.LoadOutSpec[int(ThePocket)].Name);
	EquipmentList[int(ThePocket)].find(Str);
	if(OrOr_BoolBool(EqualEqual_IntInt(int(ThePocket), int(0)), EqualEqual_IntInt(int(ThePocket), int(2))))
	{
		LoadAmmoForWeapon(ThePocket, Class<FiredWeapon>(EquipmentList[int(ThePocket)].GetObject()));
	}
	return;
}

private function InternalOnScrollClick(GUIComponent Sender)
{
	local bool bLeftScrollUsed;

	bLeftScrollUsed = false;
	switch(Sender)
	{
		case MyScrollLeftButton:
			bLeftScrollUsed = true;
		case MyScrollRightButton:
			UpdateIndex(ActivePocket);
			Scrolled(ActivePocket, bLeftScrollUsed);
			break;
		case MyScrollAmmoLeftButton:
			bLeftScrollUsed = true;
		case MyScrollAmmoRightButton:
			UpdateIndex(ActiveAmmoPocket);
			Scrolled(ActiveAmmoPocket, bLeftScrollUsed);
			break;
		default:
			break;
	}
	return;
}

private function InternalSelectorButtonOnClick(GUIComponent Sender)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, EquipmentSelectionButton.Length))
	{
		if(EqualEqual_ObjectObject(EquipmentSelectionButton[i], none))
		{
			// [Explicit Continue]
			goto J0x7A;
		}
		if(EqualEqual_ObjectObject(EquipmentSelectionButton[i], Sender))
		{
			ActivePocket = byte(i);
			EquipmentSelectionButton[i].DisableComponent();
			// [Explicit Continue]
			goto J0x7A;
		}
		EquipmentSelectionButton[i].EnableComponent();
		J0x7A:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	UpdateIndex(ActivePocket);
	DisplayEquipment(ActivePocket);
	return;
}

private function InternalTabButtonOnClick(GUIComponent Sender)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, PocketTabs.Length))
	{
		if(EqualEqual_ObjectObject(PocketTabs[i].TabButton, Sender))
		{
			ActiveTab = i;
			// [Explicit Break]
			goto J0x49;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	J0x49:

	DisplayTab(ActiveTab);
	return;
}

private function DisplayTab(int tabNum)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, PocketTabs.Length))
	{
		if(EqualEqual_IntInt(i, tabNum))
		{
			PocketTabs[i].TabPanel.Show();
			PocketTabs[i].TabPanel.Activate();
			PocketTabs[i].TabButton.DisableComponent();
			ActivePocket = PocketTabs[i].CurrentPocket;
			ActiveAmmoPocket = PocketTabs[i].AmmoPocket;
			MyScrollAmmoLeftButton.SetVisibility(NotEqual_IntInt(int(ActiveAmmoPocket), int(24)));
			MyScrollAmmoRightButton.SetVisibility(NotEqual_IntInt(int(ActiveAmmoPocket), int(24)));
			MyScrollAmmoLeftButton.SetActive(NotEqual_IntInt(int(ActiveAmmoPocket), int(24)));
			MyScrollAmmoRightButton.SetActive(NotEqual_IntInt(int(ActiveAmmoPocket), int(24)));
			MyWeaponInfoBox.SetVisibility(NotEqual_IntInt(int(ActiveAmmoPocket), int(24)));
			MyEquipmentInfoBox.SetVisibility(EqualEqual_IntInt(int(ActiveAmmoPocket), int(24)));
			MyAmmoImage.SetVisibility(NotEqual_IntInt(int(ActiveAmmoPocket), int(24)));
			MyAmmoNameLabel.SetVisibility(NotEqual_IntInt(int(ActiveAmmoPocket), int(24)));
			if(NotEqual_IntInt(int(ActiveAmmoPocket), int(24)))
			{
				MyEquipmentImage.RePosition('Weapon', true);
				MyEquipmentNameLabel.RePosition('Weapon', true);
				MyScrollRightButton.RePosition('Weapon', true);
			}
			else
			{
				MyEquipmentImage.RePosition('Equipment', true);
				MyEquipmentNameLabel.RePosition('Equipment', true);
				MyScrollRightButton.RePosition('Equipment', true);
			}
			if(NotEqual_ObjectObject(EquipmentSelectionButton[int(ActivePocket)], none))
			{
				InternalSelectorButtonOnClick(EquipmentSelectionButton[int(ActivePocket)]);
			}
			// [Explicit Continue]
			goto J0x288;
		}
		PocketTabs[i].TabPanel.Hide();
		PocketTabs[i].TabPanel.DeActivate();
		PocketTabs[i].TabButton.EnableComponent();
		J0x288:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	UpdateIndex(ActivePocket);
	UpdateIndex(ActiveAmmoPocket);
	DisplayEquipment(ActiveAmmoPocket);
	DisplayEquipment(ActivePocket);
	return;
}

function DynamicLoadOutSpec GetCurrentLoadout()
{
	return MyCurrentLoadOut;
	return;
}

private function bool IsPocketDisplayedInActiveTab(HandheldEquipment.Pocket pock)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, PocketTabs[ActiveTab].DisplayablePockets.Length))
	{
		if(EqualEqual_IntInt(int(PocketTabs[ActiveTab].DisplayablePockets[i]), int(pock)))
		{
			return true;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return false;
	return;
}
