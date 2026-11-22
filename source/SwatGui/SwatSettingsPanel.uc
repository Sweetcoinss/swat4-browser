class SwatSettingsPanel extends SwatGUIPanel
	abstract
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(SwatGui) private export editinline config GUIButton MyResetToDefaultsButton;
var private bool bLoadingSettings;
var private config localized string ConfirmResetString;
var private config localized string ConfirmationTextSettingsChange;
var private config int ConfirmationDialogDelayBeforeRevert "If the user does not confirm the change in settings within this amount of time, the settings will be reverted to their previous values.";

function LoadSettings()
{
	return;
}

function SaveSettings()
{
	return;
}

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	MyResetToDefaultsButton.__OnClick__Delegate = ConfirmReset;
	__OnActivate__Delegate = InternalOnActivate;
	__OnDeActivate__Delegate = InternalOnDeActivate;
	return;
}

function InternalOnActivate()
{
	bLoadingSettings = true;
	LoadSettings();
	bLoadingSettings = false;
	Controller.TopPage().__OnPopupReturned__Delegate = InternalOnPopupReturned;
	return;
}

function InternalOnDeActivate()
{
	SaveSettings();
	return;
}

final function ApplySetting(string Setting)
{
	InternalApplySetting(Setting);
	SaveSettings();
	return;
}

final function ApplyDangerousSetting(string Passback, string Caption)
{
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("dkaplan >>> ApplyDangerousSetting( ", Passback), ", "), Caption), ")"));
	Controller.TopPage().__OnDlgReturned__Delegate = InternalDlgReturned;
	Controller.TopPage().OpenDlg(Caption, QBTN_YesNo, Concat_StrStr("Confirm", Passback));
	return;
}

final function InternalDlgReturned(int returnButton, optional string Passback)
{
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("dkaplan >>> InternalDlgReturned( ", string(returnButton)), ", "), Passback), ")"));
	if(OrOr_BoolBool(OrOr_BoolBool(NotEqual_IntInt(And_IntInt(returnButton, QBTN_Cancel), 0), NotEqual_IntInt(And_IntInt(returnButton, QBTN_No), 0)), NotEqual_IntInt(And_IntInt(returnButton, QBTN_TimeOut), 0)))
	{
		bLoadingSettings = true;
		LoadSettings();
		bLoadingSettings = false;
		if(GreaterEqual_IntInt(InStr(Passback, "Test"), 0))
		{
			Passback = Right(Passback, Subtract_IntInt(Len(Passback), 4));
			InternalApplySetting(Passback, true);
		}
	}
	else
	{
		AssertWithDescription(OrOr_BoolBool(EqualEqual_IntInt(returnButton, QBTN_Ok), EqualEqual_IntInt(returnButton, QBTN_Yes)), Concat_StrStr(Concat_StrStr("Return value ", string(returnButton)), " from confirmation dialog was not valid in SwatVideoSettingsPanel."));
		if(GreaterEqual_IntInt(InStr(Passback, "Confirm"), 0))
		{
			Passback = Right(Passback, Subtract_IntInt(Len(Passback), 7));
			InternalApplySetting(Passback);
			Controller.TopPage().__OnDlgReturned__Delegate = InternalDlgReturned;
			Controller.TopPage().OpenDlg(ConfirmationTextSettingsChange, QBTN_YesNo, Concat_StrStr("Test", Passback), ConfirmationDialogDelayBeforeRevert);
			return;
		}
		SaveSettings();
	}
	return;
}

function InternalOnPopupReturned(GUIListElem returnObj, optional string Passback)
{
	return;
}

function InternalApplySetting(string Setting, optional bool bDontSave)
{
	return;
}

private function ConfirmReset(GUIComponent Sender)
{
	Controller.TopPage().__OnDlgReturned__Delegate = InternalOnDlgReturned;
	Controller.TopPage().OpenDlg(ConfirmResetString, QBTN_YesNo, "");
	return;
}

private function InternalOnDlgReturned(int Selection, string Passback)
{
	if(EqualEqual_IntInt(Selection, QBTN_Yes))
	{
		ResetToDefaults();
	}
	return;
}

protected function ResetToDefaults()
{
	return;
}

defaultproperties
{
	ConfirmResetString="Are you sure that you wish to reset these settings to their defaults? This may take a few moments."
	ConfirmationTextSettingsChange="Do you wish to keep these new settings?"
	ConfirmationDialogDelayBeforeRevert=10
	WinTop=0.2133300
	WinLeft=0.0500000
	WinWidth=0.8750000
	WinHeight=0.6666600
}