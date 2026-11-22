class SwatSPLoadoutPanel extends SwatLoadoutPanel
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

enum LoadOutOwner
{
	LoadOutOwner_Player,            // 0
	LoadOutOwner_RedOne,            // 1
	LoadOutOwner_RedTwo,            // 2
	LoadOutOwner_BlueOne,           // 3
	LoadOutOwner_BlueTwo            // 4
};

var SwatSPLoadoutPanel.LoadOutOwner ActiveLoadOutOwner;
var(SwatGui) editinline config array<export editinline GUIRadioButton> MyPlayerSelectorButtons;
var(SwatGui) editinline config array<export editinline GUILabel> MyPlayerNameLabels;
var(SwatGui) private export editinline config GUIScrollTextBox MyOfficerInfoBox "Holds all the custom loadouts that can be applied to the current loadout";
var(SwatGui) private export editinline config GUIScrollTextBox MyOfficerVitalsBox "Holds all the custom loadouts that can be applied to the current loadout";
var(SwatGui) private export editinline config GUIButton MyApplyToAllButton;
var(SwatGui) private export editinline config GUIButton MyLoadDefaultButton;
var(SwatGui) private export editinline config GUIButton MySaveCustomButton;
var(SwatGui) private export editinline config GUIButton MyDeleteCustomButton;
var(SwatGui) private export editinline config GUIComboBox MyCustomLoadoutCombo "Holds all the custom loadouts that can be applied to the current loadout";
var(SwatGui) private editconst editinline DynamicLoadOutSpec MyCurrentLoadOuts[5] "holds all current loadout info";
var(SwatGui) config localized string NoLoadoutNameEntered;
var(SwatGui) config localized string ConfirmOverwrite;
var(SwatGui) config localized string ConfirmDelete;
var(SwatGui) config localized string ConfirmApplyToAll;
var private bool bDontLoadCustom;
var private bool bSavePopupOpen;
var(SwatGui) config localized string OfficerInfo[5];
var(SwatGui) config localized string OfficerVitals[5];

function InitComponent(GUIComponent MyOwner)
{
	local int i;

	super.InitComponent(MyOwner);
	MyApplyToAllButton.__OnClick__Delegate = AttemptApplyToAll;
	if(NotEqual_ObjectObject(MyCustomLoadoutCombo, none))
	{
		i = 0;
		J0x31:

		if(Less_IntInt(i, GC.CustomEquipmentLoadouts.Length))
		{
			MyCustomLoadoutCombo.AddItem(GC.CustomEquipmentLoadoutFriendlyNames[i],, GC.CustomEquipmentLoadouts[i],, AndAnd_BoolBool(Less_IntInt(i, GC.LoadoutIsUndeletable.Length), GC.LoadoutIsUndeletable[i]));
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x31;
		}
		MyCustomLoadoutCombo.setIndex(0);
		MyCustomLoadoutCombo.__OnChange__Delegate = AttemptLoadCustomLoadout;
	}
	MyCustomLoadoutCombo.Edit.bReadOnly = true;
	if(NotEqual_ObjectObject(MySaveCustomButton, none))
	{
		MySaveCustomButton.__OnClick__Delegate = AttemptSaveCustomLoadout;
	}
	if(NotEqual_ObjectObject(MyLoadDefaultButton, none))
	{
		MyLoadDefaultButton.__OnClick__Delegate = AttemptLoadDefaultLoadout;
	}
	if(NotEqual_ObjectObject(MyDeleteCustomButton, none))
	{
		MyDeleteCustomButton.__OnClick__Delegate = AttemptDeleteCustomLoadout;
	}
	return;
}

event Activate()
{
	if(bActiveInput)
	{
		InitialDisplay();
		return;
	}
	super.Activate();
	assert(NotEqual_ObjectObject(GC.CurrentMission, none));
	CheckCustomScenarioOfficerSettings(GC.CurrentMission.CustomScenario);
	MyPlayerSelectorButtons[int(ActiveLoadOutOwner)].SelectRadioButton();
	SetOfficerInfo(ActiveLoadOutOwner);
	MyDeleteCustomButton.SetEnabled(Not_PreBool(MyCustomLoadoutCombo.List.GetExtraBoolData()));
	return;
}

protected function SpawnLoadouts()
{
	local int i;
	local SwatSPLoadoutPanel.LoadOutOwner LastOwner;

	if(bSavePopupOpen)
	{
		LastOwner = ActiveLoadOutOwner;
	}
	i = 0;
	J0x1B:

	if(Less_IntInt(i, int(5)))
	{
		if(NotEqual_ObjectObject(MyCurrentLoadOuts[i], none))
		{
			// [Explicit Continue]
			goto J0x7F;
		}
		ActiveLoadOutOwner = byte(i);
		LoadLoadOut(Concat_StrStr("Current", GetConfigName(ActiveLoadOutOwner)), true);
		MyCurrentLoadOuts[i] = MyCurrentLoadOut;
		MyCurrentLoadOut = none;
		J0x7F:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x1B;
	}
	if(bSavePopupOpen)
	{
		bSavePopupOpen = false;
		ActiveLoadOutOwner = LastOwner;
	}
	else
	{
		ActiveLoadOutOwner = 0;
	}
	MyCurrentLoadOut = MyCurrentLoadOuts[int(ActiveLoadOutOwner)];
	return;
}

protected function DestroyLoadouts()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, int(5)))
	{
		if(NotEqual_ObjectObject(MyCurrentLoadOuts[i], none))
		{
			MyCurrentLoadOuts[i].Destroy();
		}
		MyCurrentLoadOuts[i] = none;
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	if(NotEqual_ObjectObject(MyCurrentLoadOut, none))
	{
		MyCurrentLoadOut.Destroy();
	}
	MyCurrentLoadOut = none;
	return;
}

function LoadLoadOut(string LoadOutName, optional bool bForceSpawn)
{
	super.LoadLoadOut(LoadOutName, bForceSpawn);
	return;
}

function CopyLoadOutWeaponry(DynamicLoadOutSpec to, DynamicLoadOutSpec From)
{
	local int i;

	assert(NotEqual_ObjectObject(From, none));
	assert(NotEqual_ObjectObject(to, none));
	i = 0;
	J0x1D:

	if(Less_IntInt(i, int(25)))
	{
		to.LoadOutSpec[i] = From.LoadOutSpec[i];
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x1D;
	}
	return;
}

function string GetConfigName(SwatSPLoadoutPanel.LoadOutOwner theOfficer)
{
	local string ret;

	switch(theOfficer)
	{
		case 0:
			ret = "PlayerLoadOut";
			break;
		case 1:
			ret = "OfficerRedOneLoadOut";
			break;
		case 2:
			ret = "OfficerRedTwoLoadOut";
			break;
		case 3:
			ret = "OfficerBlueOneLoadOut";
			break;
		case 4:
			ret = "OfficerBlueTwoLoadOut";
			break;
		default:
			break;
	}
	return ret;
	return;
}

function ChangeLoadOut(HandheldEquipment.Pocket ThePocket)
{
	super.ChangeLoadOut(ThePocket);
	SaveLoadOut(Concat_StrStr("Current", GetConfigName(ActiveLoadOutOwner)));
	return;
}

function bool CheckValidity(SwatGUIConfig.eNetworkValidity Type)
{
	return OrOr_BoolBool(EqualEqual_IntInt(int(Type), int(1)), super.CheckValidity(Type));
	return;
}

function AttemptApplyToAll(GUIComponent Sender)
{
	assert(EqualEqual_ObjectObject(Sender, MyApplyToAllButton));
	Controller.TopPage().__OnDlgReturned__Delegate = OnApplyToAllDlgReturned;
	Controller.TopPage().OpenDlg(ConfirmApplyToAll, QBTN_YesNo);
	return;
}

function OnApplyToAllDlgReturned(int returnButton, optional string Passback)
{
	if(EqualEqual_IntInt(returnButton, QBTN_Yes))
	{
		ApplyToAll();
	}
	return;
}

function ApplyToAll()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, int(5)))
	{
		if(EqualEqual_IntInt(int(ActiveLoadOutOwner), i))
		{
			// [Explicit Continue]
			goto J0x5D;
		}
		CopyLoadOutWeaponry(MyCurrentLoadOuts[i], MyCurrentLoadOut);
		SaveLoadOut(Concat_StrStr("Current", GetConfigName(byte(i))));
		J0x5D:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

function SetRadioGroup(GUIRadioButton Group)
{
	local string ForcedLoadout;

	super(GUIMultiComponent).SetRadioGroup(Group);
	switch(Group)
	{
		case MyPlayerSelectorButtons[int(0)]:
			ActiveLoadOutOwner = 0;
			break;
		case MyPlayerSelectorButtons[int(1)]:
			ActiveLoadOutOwner = 1;
			if(AndAnd_BoolBool(NotEqual_ObjectObject(GC.CurrentMission.CustomScenario, none), NotEqual_NameName(GC.CurrentMission.CustomScenario.RedOneLoadOut, 'Any')))
			{
				ForcedLoadout = string(GC.CurrentMission.CustomScenario.RedOneLoadOut);
			}
			break;
		case MyPlayerSelectorButtons[int(2)]:
			ActiveLoadOutOwner = 2;
			if(AndAnd_BoolBool(NotEqual_ObjectObject(GC.CurrentMission.CustomScenario, none), NotEqual_NameName(GC.CurrentMission.CustomScenario.RedTwoLoadOut, 'Any')))
			{
				ForcedLoadout = string(GC.CurrentMission.CustomScenario.RedTwoLoadOut);
			}
			break;
		case MyPlayerSelectorButtons[int(3)]:
			ActiveLoadOutOwner = 3;
			if(AndAnd_BoolBool(NotEqual_ObjectObject(GC.CurrentMission.CustomScenario, none), NotEqual_NameName(GC.CurrentMission.CustomScenario.BlueOneLoadOut, 'Any')))
			{
				ForcedLoadout = string(GC.CurrentMission.CustomScenario.BlueOneLoadOut);
			}
			break;
		case MyPlayerSelectorButtons[int(4)]:
			ActiveLoadOutOwner = 4;
			if(AndAnd_BoolBool(NotEqual_ObjectObject(GC.CurrentMission.CustomScenario, none), NotEqual_NameName(GC.CurrentMission.CustomScenario.BlueTwoLoadOut, 'Any')))
			{
				ForcedLoadout = string(GC.CurrentMission.CustomScenario.BlueTwoLoadOut);
			}
			break;
		default:
			break;
	}
	MyCurrentLoadOut = MyCurrentLoadOuts[int(ActiveLoadOutOwner)];
	SetOfficerInfo(ActiveLoadOutOwner);
	if(NotEqual_StrStr(ForcedLoadout, ""))
	{
		LoadLoadOut(ForcedLoadout);
		InitialDisplay();
		MyScrollLeftButton.DisableComponent();
		MyScrollRightButton.DisableComponent();
		MyScrollAmmoLeftButton.DisableComponent();
		MyScrollAmmoRightButton.DisableComponent();
		MySaveCustomButton.DisableComponent();
		MyLoadDefaultButton.DisableComponent();
		MyCustomLoadoutCombo.DisableComponent();
		MyApplyToAllButton.DisableComponent();
		MyDeleteCustomButton.DisableComponent();
	}
	else
	{
		MyScrollLeftButton.EnableComponent();
		MyScrollRightButton.EnableComponent();
		MyScrollAmmoLeftButton.EnableComponent();
		MyScrollAmmoRightButton.EnableComponent();
		MySaveCustomButton.EnableComponent();
		MyLoadDefaultButton.EnableComponent();
		MyCustomLoadoutCombo.EnableComponent();
		MyApplyToAllButton.EnableComponent();
		MyDeleteCustomButton.EnableComponent();
		InitialDisplay();
	}
	if(AndAnd_BoolBool(NotEqual_ObjectObject(GC.CurrentMission.CustomScenario, none), GC.CurrentMission.CustomScenario.LoneWolf))
	{
		MyApplyToAllButton.DisableComponent();
	}
	return;
}

private function CheckCustomScenarioOfficerSettings(CustomScenario Scenario)
{
	MyPlayerSelectorButtons[int(1)].SetEnabled(OrOr_BoolBool(EqualEqual_ObjectObject(Scenario, none), AndAnd_BoolBool(Not_PreBool(Scenario.LoneWolf), Scenario.HasOfficerRedOne)));
	MyPlayerNameLabels[int(1)].SetEnabled(OrOr_BoolBool(EqualEqual_ObjectObject(Scenario, none), AndAnd_BoolBool(Not_PreBool(Scenario.LoneWolf), Scenario.HasOfficerRedOne)));
	MyPlayerSelectorButtons[int(2)].SetEnabled(OrOr_BoolBool(EqualEqual_ObjectObject(Scenario, none), AndAnd_BoolBool(Not_PreBool(Scenario.LoneWolf), Scenario.HasOfficerRedTwo)));
	MyPlayerNameLabels[int(2)].SetEnabled(OrOr_BoolBool(EqualEqual_ObjectObject(Scenario, none), AndAnd_BoolBool(Not_PreBool(Scenario.LoneWolf), Scenario.HasOfficerRedTwo)));
	MyPlayerSelectorButtons[int(3)].SetEnabled(OrOr_BoolBool(EqualEqual_ObjectObject(Scenario, none), AndAnd_BoolBool(Not_PreBool(Scenario.LoneWolf), Scenario.HasOfficerBlueOne)));
	MyPlayerNameLabels[int(3)].SetEnabled(OrOr_BoolBool(EqualEqual_ObjectObject(Scenario, none), AndAnd_BoolBool(Not_PreBool(Scenario.LoneWolf), Scenario.HasOfficerBlueOne)));
	MyPlayerSelectorButtons[int(4)].SetEnabled(OrOr_BoolBool(EqualEqual_ObjectObject(Scenario, none), AndAnd_BoolBool(Not_PreBool(Scenario.LoneWolf), Scenario.HasOfficerBlueTwo)));
	MyPlayerNameLabels[int(4)].SetEnabled(OrOr_BoolBool(EqualEqual_ObjectObject(Scenario, none), AndAnd_BoolBool(Not_PreBool(Scenario.LoneWolf), Scenario.HasOfficerBlueTwo)));
	return;
}

private function SetOfficerInfo(SwatSPLoadoutPanel.LoadOutOwner Officer)
{
	local string Content;

	Content = OfficerVitals[int(Officer)];
	if(EqualEqual_IntInt(int(Officer), int(0)))
	{
		Content = Concat_StrStr(SwatGUIController(Controller).GetCampaigns().CurCampaignName, Content);
	}
	MyOfficerVitalsBox.SetContent(Content);
	Content = OfficerInfo[int(Officer)];
	MyOfficerInfoBox.SetContent(Content);
	return;
}

private function SaveCustomLoadout(string SaveName)
{
	local string SaveLoadoutName;

	DeleteCustomLoadout(SaveName);
	SaveLoadoutName = ComputeMD5Checksum(SaveName);
	SaveLoadOut(SaveLoadoutName);
	GC.CustomEquipmentLoadouts[GC.CustomEquipmentLoadouts.Length] = SaveLoadoutName;
	GC.CustomEquipmentLoadoutFriendlyNames[GC.CustomEquipmentLoadoutFriendlyNames.Length] = SaveName;
	GC.SaveConfig();
	bDontLoadCustom = true;
	MyCustomLoadoutCombo.AddItem(SaveName,, SaveLoadoutName);
	MyCustomLoadoutCombo.find(SaveName);
	bDontLoadCustom = false;
	return;
}

private function DeleteCustomLoadout(string DeleteName)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, GC.CustomEquipmentLoadouts.Length))
	{
		if(EqualEqual_StrStr(GC.CustomEquipmentLoadoutFriendlyNames[i], DeleteName))
		{
			AssertWithDescription(Not_PreBool(GC.LoadoutIsUndeletable[i]), Concat_StrStr("Attempted to delete predefined loadout ", DeleteName));
			GC.CustomEquipmentLoadouts.Remove(i, 1);
			GC.CustomEquipmentLoadoutFriendlyNames.Remove(i, 1);
			GC.SaveConfig();
			// [Explicit Break]
			goto J0xCD;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	J0xCD:

	bDontLoadCustom = true;
	if(NotEqual_StrStr(MyCustomLoadoutCombo.find(DeleteName), ""))
	{
		MyCustomLoadoutCombo.RemoveItem(MyCustomLoadoutCombo.GetIndex(), 1);
	}
	bDontLoadCustom = false;
	return;
}

private function LoadCustomLoadout()
{
	local string LoadName, LoadLoadoutName;
	local DynamicLoadOutSpec CustomLO;

	if(bDontLoadCustom)
	{
		return;
	}
	LoadName = MyCustomLoadoutCombo.List.Get();
	LoadLoadoutName = MyCustomLoadoutCombo.List.GetExtra();
	CustomLO = PlayerOwner().Spawn(Class'SwatGame.DynamicLoadOutSpec', none, string(LoadLoadoutName));
	CopyLoadOutWeaponry(MyCurrentLoadOut, CustomLO);
	CustomLO.Destroy();
	SaveLoadOut(Concat_StrStr("Current", GetConfigName(ActiveLoadOutOwner)));
	InitialDisplay();
	return;
}

function AttemptSaveCustomLoadout(GUIComponent Sender)
{
	Controller.TopPage().__OnPopupReturned__Delegate = InternalOnPopupReturned;
	bSavePopupOpen = true;
	SwatGUIPage(Controller.TopPage()).OpenPopup("SwatGui.SwatSaveCustomPopup", "SwatSaveCustomPopup");
	return;
}

function AttemptLoadCustomLoadout(GUIComponent Sender)
{
	MyDeleteCustomButton.SetEnabled(Not_PreBool(MyCustomLoadoutCombo.List.GetExtraBoolData()));
	LoadCustomLoadout();
	return;
}

function AttemptDeleteCustomLoadout(GUIComponent Sender)
{
	local string DeleteName;

	DeleteName = MyCustomLoadoutCombo.GetText();
	Controller.TopPage().__OnDlgReturned__Delegate = InternalOnDeleteDlgReturned;
	Controller.TopPage().OpenDlg(FormatTextString(ConfirmDelete, DeleteName), QBTN_YesNo, DeleteName);
	return;
}

function AttemptLoadDefaultLoadout(GUIComponent Sender)
{
	LoadLoadOut(Concat_StrStr("Default", GetConfigName(ActiveLoadOutOwner)));
	SaveLoadOut(Concat_StrStr("Current", GetConfigName(ActiveLoadOutOwner)));
	InitialDisplay();
	return;
}

function TryToSaveLoadout(string SaveName)
{
	if(NotEqual_StrStr(MyCustomLoadoutCombo.find(SaveName,, true), ""))
	{
		Controller.TopPage().__OnDlgReturned__Delegate = InternalOnSaveDlgReturned;
		Controller.TopPage().OpenDlg(FormatTextString(ConfirmOverwrite, SaveName), QBTN_YesNo, SaveName);
	}
	else
	{
		SaveCustomLoadout(SaveName);
	}
	return;
}

function InternalOnPopupReturned(GUIListElem returnObj, optional string Passback)
{
	switch(Passback)
	{
		case "SaveCustom":
			TryToSaveLoadout(returnObj.Item);
			break;
		default:
			break;
	}
	return;
}

function InternalOnSaveDlgReturned(int returnButton, optional string Passback)
{
	if(EqualEqual_IntInt(returnButton, QBTN_Yes))
	{
		SaveCustomLoadout(Passback);
	}
	return;
}

function InternalOnDeleteDlgReturned(int returnButton, optional string Passback)
{
	if(EqualEqual_IntInt(returnButton, QBTN_Yes))
	{
		DeleteCustomLoadout(Passback);
	}
	return;
}

defaultproperties
{
	ConfirmOverwrite="A loadout named '%1' already exists; are you sure that you wish to overwrite it?"
	ConfirmDelete="Delete loadout '%1'?"
	ConfirmApplyToAll="Are you sure that you wish to apply the selected loadout to your entire team?"
	OfficerInfo[0]="A recent transfer from Los Angeles, the Sergeant is cool under fire and always business like.  With a new element to command he will have to gain the respect of his squad while on the job."
	OfficerInfo[1]="A thirty year veteran of the force, and 25 year veteran of SWAT, Officer Reynolds is the most experienced member of the element.  His experience has taught him that staying calm can be the key to survival as a SWAT officer.  Realizing the value of his experience, he is always willing to give his advice to the element."
	OfficerInfo[2]="Officer Girard is a local boy, born and raised in the metropolitan area.  Girard has been a member of SWAT for 6 years and been decorated for his bravery on 2 occasions."
	OfficerInfo[3]="Spending only 2 years on the street before passing the rigorous SWAT training course and trials, Officer Fields is one of the youngest officers on the force to be promoted to SWAT.  Although a bit of a loudmouth, he has proven to be a very capable operator."
	OfficerInfo[4]="Officer Jackson has had a long and distinguished career on SWAT.  As well as being a top-notch operator, Jackson prides himself on being an athlete.  He is in peak physical condition and can be an intimidating presence on any operation."
	OfficerVitals[0]="|Nickname:  Boss|Badge No.:  3187|Years of Service:  15"
	OfficerVitals[1]="Officer Steven Reynolds|Nickname:  Gramps|Badge No.:  3077|Years of Service: 30"
	OfficerVitals[2]="Officer Anthony Girard|Nickname:  Subway|Badge No.:  3518|Years of Service: 14"
	OfficerVitals[3]="Officer Zachary Fields|Nickname:  Hollywood|Badge No.: 3975|Years of Service:  6"
	OfficerVitals[4]="Officer Allen Jackson|Nickname:  Python|Badge No.:  3248|Years of Service:  18"
}