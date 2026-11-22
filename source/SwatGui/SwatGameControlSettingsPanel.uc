class SwatGameControlSettingsPanel extends SwatSettingsPanel
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(SwatGui) private export editinline config GUIComboBox MyVoiceTypeBox;
var(SwatGui) private export editinline config GUIEditBox MyMPNameBox;
var(SwatGui) private export editinline config GUICheckBoxButton MyAlwaysRunCheck;
var(SwatGui) private export editinline config GUIComboBox MyNetSpeedBox;
var(SwatGui) private export editinline config GUICheckBoxButton MyHelpTextCheck;
var(SwatGui) private export editinline config GUICheckBoxButton MyShowSubtitlesCheck;
var(SwatGui) private export editinline config GUIRadioButton MyGraphicCICheck;
var(SwatGui) private export editinline config GUIRadioButton MyClassicCICheck;
var(SwatGui) private export editinline config GUISlider MyMouseSensitivity;
var(SwatGui) private export editinline config GUICheckBoxButton MyInvertMouseCheck;
var(SwatGui) private export editinline config GUIPanel MyGCIOptions;
var(SwatGui) private export editinline config GUIRadioButton MyGCIOption1Check;
var(SwatGui) private export editinline config GUIRadioButton MyGCIOption2Check;
var(SwatGui) private export editinline config GUIRadioButton MyGCIOption3Check;
var(SwatGui) private export editinline config GUIRadioButton MyGCIOption4Check;
var(SwatGui) private export editinline config GUIRadioButton MyGCIExitMenuOptionCheck;
var(SwatGui) private export editinline config GUILabel MyGCIOptionS1P1Label;
var(SwatGui) private export editinline config GUILabel MyGCIOptionS1P2Label;
var(SwatGui) private export editinline config GUILabel MyGCIOptionS1P3Label;
var(SwatGui) private export editinline config GUILabel MyGCIOptionS2P1Label;
var(SwatGui) private export editinline config GUILabel MyGCIOptionS2P2Label;
var(SwatGui) private export editinline config GUILabel MyGCIOptionS2P3Label;
var(SwatGui) private export editinline config GUILabel MyGCIOptionS3P1Label;
var(SwatGui) private export editinline config GUILabel MyGCIOptionS3P2Label;
var(SwatGui) private export editinline config GUILabel MyGCIOptionS3P3Label;
var(SwatGui) private export editinline config GUILabel MyGCIOptionS4P1Label;
var(SwatGui) private export editinline config GUILabel MyGCIOptionS4P2Label;
var(SwatGui) private export editinline config GUILabel MyGCIOptionS4P3Label;
var private config localized string GCIOptionS1P1String;
var private config localized string GCIOptionS1P2String;
var private config localized string GCIOptionS1P3String;
var private config localized string GCIOptionS2P1String;
var private config localized string GCIOptionS2P2String;
var private config localized string GCIOptionS2P3String;
var private config localized string GCIOptionS3P1String;
var private config localized string GCIOptionS3P2String;
var private config localized string GCIOptionS3P3String;
var private config localized string GCIOptionS4P1String;
var private config localized string GCIOptionS4P2String;
var private config localized string GCIOptionS4P3String;
var private float DefaultMouseSensitivity;

function InitComponent(GUIComponent MyOwner)
{
	local int i;

	super.InitComponent(MyOwner);
	MyMPNameBox.MaxWidth = GC.MPNameLength;
	MyMPNameBox.AllowedCharSet = GC.MPNameAllowableCharSet;
	i = 0;
	J0x4C:

	if(Less_IntInt(i, GC.NetworkConnectionChoices.Length))
	{
		MyNetSpeedBox.AddItem(GC.NetworkConnectionChoices[i],,, GC.NetworkConnectionSpeeds[i]);
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x4C;
	}
	MyNetSpeedBox.setIndex(0);
	i = 0;
	J0xBF:

	if(Less_IntInt(i, GC.VoiceTypeChoices.Length))
	{
		MyVoiceTypeBox.AddItem(GC.VoiceTypeChoices[i]);
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0xBF;
	}
	MyVoiceTypeBox.setIndex(0);
	MyMouseSensitivity.__OnChange__Delegate = OnMouseSensitivityChanged;
	MyInvertMouseCheck.__OnChange__Delegate = OnInvertMouseClicked;
	MyHelpTextCheck.__OnChange__Delegate = OnHelpTextClicked;
	MyGraphicCICheck.__OnChange__Delegate = OnCISelectionChanged;
	return;
}

event Show()
{
	super(SwatGUIPanel).Show();
	MyGCIOptionS1P1Label.SetCaption(ReplaceKeybindingCodes(GCIOptionS1P1String, "[k=", "]"));
	MyGCIOptionS1P2Label.SetCaption(ReplaceKeybindingCodes(GCIOptionS1P2String, "[k=", "]"));
	MyGCIOptionS1P3Label.SetCaption(ReplaceKeybindingCodes(GCIOptionS1P3String, "[k=", "]"));
	MyGCIOptionS2P1Label.SetCaption(ReplaceKeybindingCodes(GCIOptionS2P1String, "[k=", "]"));
	MyGCIOptionS2P2Label.SetCaption(ReplaceKeybindingCodes(GCIOptionS2P2String, "[k=", "]"));
	MyGCIOptionS2P3Label.SetCaption(ReplaceKeybindingCodes(GCIOptionS2P3String, "[k=", "]"));
	MyGCIOptionS3P1Label.SetCaption(ReplaceKeybindingCodes(GCIOptionS3P1String, "[k=", "]"));
	MyGCIOptionS3P2Label.SetCaption(ReplaceKeybindingCodes(GCIOptionS3P2String, "[k=", "]"));
	MyGCIOptionS3P3Label.SetCaption(ReplaceKeybindingCodes(GCIOptionS3P3String, "[k=", "]"));
	MyGCIOptionS4P1Label.SetCaption(ReplaceKeybindingCodes(GCIOptionS4P1String, "[k=", "]"));
	MyGCIOptionS4P2Label.SetCaption(ReplaceKeybindingCodes(GCIOptionS4P2String, "[k=", "]"));
	MyGCIOptionS4P3Label.SetCaption(ReplaceKeybindingCodes(GCIOptionS4P3String, "[k=", "]"));
	MyGCIOptions.SetActive(MyGraphicCICheck.bChecked);
	MyGCIOptions.SetVisibility(MyGraphicCICheck.bChecked);
	return;
}

function SaveSettings()
{
	local int NewNetSpeed;

	SwatPlayerController(PlayerOwner()).SetName(MyMPNameBox.GetText());
	GC.PreferredVoiceType = byte(MyVoiceTypeBox.GetIndex());
	NewNetSpeed = MyNetSpeedBox.List.GetExtraIntData();
	Class'Engine.Player'.default.ConfiguredInternetSpeed = NewNetSpeed;
	Class'Engine.Player'.static.StaticSaveConfig();
	PlayerOwner().SetNetSpeed(NewNetSpeed);
	GC.NetSpeedSelection = MyNetSpeedBox.GetIndex();
	GC.bUseExitMenu = MyGCIExitMenuOptionCheck.bChecked;
	if(MyGCIOption1Check.bChecked)
	{
		GC.GCIButtonMode = 1;
	}
	else
	{
		if(MyGCIOption2Check.bChecked)
		{
			GC.GCIButtonMode = 2;
		}
		else
		{
			if(MyGCIOption3Check.bChecked)
			{
				GC.GCIButtonMode = 3;
			}
			else
			{
				if(MyGCIOption4Check.bChecked)
				{
					GC.GCIButtonMode = 4;
				}
				else
				{
					GC.GCIButtonMode = 0;
				}
			}
		}
	}
	if(MyGraphicCICheck.bChecked)
	{
		GC.CommandInterfaceStyle = 2;
	}
	else
	{
		GC.CommandInterfaceStyle = 1;
	}
	GC.SetCurrentCommandInterfaceStyle(GC.CommandInterfaceStyle);
	if(NotEqual_ObjectObject(SwatGamePlayerController(PlayerOwner()), none))
	{
		SwatGamePlayerController(PlayerOwner()).SetCommandInterface(GC.CurrentCommandInterfaceStyle);
	}
	GC.bAlwaysRun = MyAlwaysRunCheck.bChecked;
	if(NotEqual_ObjectObject(SwatGamePlayerController(PlayerOwner()), none))
	{
		SwatGamePlayerController(PlayerOwner()).SetAlwaysRun(GC.bAlwaysRun);
	}
	GC.bShowSubtitles = MyShowSubtitlesCheck.bChecked;
	GC.SaveConfig();
	return;
}

function LoadSettings()
{
	local bool IsMouseInverted;
	local float MouseXMultiplier, MouseYMultiplier;

	MyMPNameBox.SetText(GC.MPName);
	MyNetSpeedBox.setIndex(GC.NetSpeedSelection);
	MyVoiceTypeBox.setIndex(int(GC.PreferredVoiceType));
	if(EqualEqual_IntInt(int(GC.CommandInterfaceStyle), int(2)))
	{
		SetRadioGroup(MyGraphicCICheck);
	}
	else
	{
		SetRadioGroup(MyClassicCICheck);
	}
	switch(GC.GCIButtonMode)
	{
		case 1:
			MyGCIOptions.SetRadioGroup(MyGCIOption1Check);
			break;
		case 2:
			MyGCIOptions.SetRadioGroup(MyGCIOption2Check);
			break;
		case 3:
			MyGCIOptions.SetRadioGroup(MyGCIOption3Check);
			break;
		case 4:
			MyGCIOptions.SetRadioGroup(MyGCIOption4Check);
			break;
		default:
			MyGCIOptions.SetRadioGroup(none);
			break;
			break;
	}
	MyGCIExitMenuOptionCheck.SetChecked(GC.bUseExitMenu);
	MyHelpTextCheck.SetChecked(GC.bShowHelp);
	MyAlwaysRunCheck.SetChecked(GC.bAlwaysRun);
	MouseXMultiplier = float(PlayerOwner().ConsoleCommand("Get WinDrv.WindowsClient MouseXMultiplier"));
	MouseYMultiplier = float(PlayerOwner().ConsoleCommand("Get WinDrv.WindowsClient MouseYMultiplier"));
	MyMouseSensitivity.SetValue(MouseXMultiplier);
	IsMouseInverted = bool(PlayerOwner().ConsoleCommand("Get PlayerInput bInvertMouse"));
	MyInvertMouseCheck.SetChecked(IsMouseInverted);
	MyShowSubtitlesCheck.SetChecked(GC.bShowSubtitles);
	return;
}

private function OnMouseSensitivityChanged(GUIComponent Sender)
{
	local float Multiplier;

	Multiplier = GUISlider(Sender).Value;
	Multiplier = FClamp(Multiplier, 0.0100000, 1.0000000);
	Controller.StaticExec(At_StrStr("Set WinDrv.WindowsClient MouseXMultiplier", string(Multiplier)));
	Controller.StaticExec(At_StrStr("Set WinDrv.WindowsClient MouseYMultiplier", string(Multiplier)));
	return;
}

private function OnInvertMouseClicked(GUIComponent Sender)
{
	Controller.StaticExec(Concat_StrStr("Set PlayerInput bInvertMouse ", string(MyInvertMouseCheck.bChecked)));
	return;
}

private function OnHelpTextClicked(GUIComponent Sender)
{
	GC.bShowHelp = MyHelpTextCheck.bChecked;
	Controller.bDontDisplayHelpText = Not_PreBool(GC.bShowHelp);
	Controller.TopPage().HelpText.SetVisibility(GC.bShowHelp);
	return;
}

private function OnCISelectionChanged(GUIComponent Sender)
{
	MyGCIOptions.SetActive(MyGraphicCICheck.bChecked);
	MyGCIOptions.SetVisibility(MyGraphicCICheck.bChecked);
	return;
}

protected function ResetToDefaults()
{
	MyMouseSensitivity.SetValue(DefaultMouseSensitivity);
	MyInvertMouseCheck.SetChecked(false);
	MyHelpTextCheck.SetChecked(true);
	MyAlwaysRunCheck.SetChecked(false);
	SetRadioGroup(MyGraphicCICheck);
	MyGCIOptions.SetRadioGroup(MyGCIOption2Check);
	return;
}

defaultproperties
{
	GCIOptionS1P1String="Hold [k=OpenGraphicCommandInterface | RightMouseAlias] to open menu"
	GCIOptionS1P2String="Click [k=Fire] to select"
	GCIOptionS1P3String="Release [k=OpenGraphicCommandInterface | RightMouseAlias] to cancel"
	GCIOptionS2P1String="Hold [k=OpenGraphicCommandInterface | RightMouseAlias] to open menu"
	GCIOptionS2P2String="Release [k=OpenGraphicCommandInterface | RightMouseAlias] to select"
	GCIOptionS2P3String="Click [k=Fire] to cancel"
	GCIOptionS3P1String="Click [k=OpenGraphicCommandInterface | RightMouseAlias] to open menu"
	GCIOptionS3P2String="Click [k=Fire] to select"
	GCIOptionS3P3String="Click [k=OpenGraphicCommandInterface | RightMouseAlias] to cancel"
	GCIOptionS4P1String="Click [k=OpenGraphicCommandInterface | RightMouseAlias] to open menu"
	GCIOptionS4P2String="Click [k=OpenGraphicCommandInterface | RightMouseAlias] to select"
	GCIOptionS4P3String="Click [k=Fire] to cancel"
	DefaultMouseSensitivity=0.5000000
	ConfirmResetString="Are you sure that you wish to reset all game settings to their defaults?"
}