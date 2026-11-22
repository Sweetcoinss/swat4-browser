class SwatVideoSettingsPanel extends SwatSettingsPanel
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(SwatGui) private export editinline config GUIComboBox MyBMDBox;
var(SwatGui) private export editinline config GUIComboBox MyDSDBox;
var(SwatGui) private export editinline config GUIComboBox MyGlowDBox;
var(SwatGui) private export editinline config GUIComboBox MyResBox;
var(SwatGui) private export editinline config GUIComboBox MyTexDBox;
var(SwatGui) private export editinline config GUIComboBox MyPixelShadersBox;
var(SwatGui) private export editinline config GUIComboBox MyMirrorsBox;
var(SwatGui) private export editinline config GUISlider MyBrightnessSlider;
var(SwatGui) private export editinline config GUISlider MyContrastSlider;
var(SwatGui) private export editinline config GUISlider MyGammaSlider;
var(SwatGui) private export editinline config GUIComboBox MyWorldDetailBox;
var(SwatGui) private export editinline config GUIComboBox MyRenderDetailBox;
var private float DefaultBrightness;
var private float DefaultContrast;
var private float DefaultGamma;
var private string LastResolution;
var private config localized string WarningTextVideoResolutionChange;

function InitComponent(GUIComponent MyOwner)
{
	local int i;

	super.InitComponent(MyOwner);
	i = 0;
	J0x12:

	if(Less_IntInt(i, GC.OtherDetailChoices.Length))
	{
		MyBMDBox.AddItem(GC.OtherDetailChoices[i],,, i);
		MyDSDBox.AddItem(GC.OtherDetailChoices[i],,, i);
		MyGlowDBox.AddItem(GC.OtherDetailChoices[i],,, i);
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x12;
	}
	i = 0;
	J0xBA:

	if(Less_IntInt(i, GC.ScreenResolutionChoices.Length))
	{
		MyResBox.AddItem(GC.ScreenResolutionChoices[i]);
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0xBA;
	}
	i = 0;
	J0x107:

	if(Less_IntInt(i, GC.TextureDetailChoices.Length))
	{
		MyTexDBox.AddItem(GC.TextureDetailChoices[i],,, i);
		MyWorldDetailBox.AddItem(GC.TextureDetailChoices[i],,, i);
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x107;
	}
	i = 0;
	J0x185:

	if(Less_IntInt(i, GC.RenderDetailChoices.Length))
	{
		MyRenderDetailBox.AddItem(GC.RenderDetailChoices[i]);
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x185;
	}
	i = 0;
	J0x1D2:

	if(Less_IntInt(i, GC.PixelShaderChoices.Length))
	{
		MyPixelShadersBox.AddItem(GC.PixelShaderChoices[i]);
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x1D2;
	}
	i = 0;
	J0x21F:

	if(Less_IntInt(i, GC.RealtimeMirrorChoices.Length))
	{
		MyMirrorsBox.AddItem(GC.RealtimeMirrorChoices[i]);
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x21F;
	}
	MyBMDBox.__OnChange__Delegate = ComboOnChange;
	MyDSDBox.__OnChange__Delegate = ComboOnChange;
	MyGlowDBox.__OnChange__Delegate = ComboOnChange;
	MyWorldDetailBox.__OnChange__Delegate = ComboOnChange;
	MyResBox.__OnChange__Delegate = ComboOnChange;
	MyTexDBox.__OnChange__Delegate = ComboOnChange;
	MyPixelShadersBox.__OnChange__Delegate = ComboOnChange;
	MyMirrorsBox.__OnChange__Delegate = ComboOnChange;
	MyBrightnessSlider.__OnChange__Delegate = ComboOnChange;
	MyContrastSlider.__OnChange__Delegate = ComboOnChange;
	MyGammaSlider.__OnChange__Delegate = ComboOnChange;
	MyRenderDetailBox.__OnChange__Delegate = RenderDetailOnChange;
	return;
}

function SaveSettings()
{
	Log("[dkaplan] >>> SaveSettings");
	PlayerOwner().ConsoleCommand("SAVERENDERCONFIG");
	PlayerOwner().ConsoleCommand("SAVECLIENTCONFIG");
	SetTimer(2.5000000);
	return;
}

function LoadSettings()
{
	Log("[dkaplan] >>> LoadSettings");
	PlayerOwner().ConsoleCommand("RESETCLIENTCONFIG");
	PlayerOwner().ConsoleCommand("RESETRENDERCONFIG");
	MyBrightnessSlider.SetValue(float(PlayerOwner().ConsoleCommand("GETBRIGHTNESS")));
	MyContrastSlider.SetValue(float(PlayerOwner().ConsoleCommand("GETCONTRAST")));
	MyGammaSlider.SetValue(float(PlayerOwner().ConsoleCommand("GETGAMMA")));
	MyResBox.find(PlayerOwner().ConsoleCommand("GETCURRENTRES"));
	MyResBox.SetEnabled(true);
	MyBrightnessSlider.SetEnabled(true);
	MyContrastSlider.SetEnabled(true);
	MyGammaSlider.SetEnabled(true);
	MyRenderDetailBox.setIndex(Add_IntInt(1, int(PlayerOwner().ConsoleCommand("RENDERDETAIL GET"))));
	SetTimer(2.5000000);
	return;
}

event Timer()
{
	if(OrOr_BoolBool(EqualEqual_IntInt(int(GC.SwatGameState), int(0)), AndAnd_BoolBool(NotEqual_IntInt(int(GC.SwatGameRole), int(4)), NotEqual_IntInt(int(GC.SwatGameRole), int(5)))))
	{
		PlayerOwner().UnTriggerEffectEvent('UIMenuLoop', 'SettingsMenu');
		PlayerOwner().TriggerEffectEvent('UIMenuLoop',,,,,,,, 'SettingsMenu');
	}
	return;
}

function LoadRenderConfigBasedSettings()
{
	local bool bRenderDetailSetToCustom;

	Log("[dkaplan] >>> LoadRenderConfigBasedSettings");
	bRenderDetailSetToCustom = EqualEqual_IntInt(MyRenderDetailBox.GetIndex(), 0);
	if(DynamicCheckOptionBumpMapDetail())
	{
		MyBMDBox.setIndex(int(PlayerOwner().ConsoleCommand("BUMPMAPDETAIL GET")));
	}
	else
	{
		MyBMDBox.setIndex(0);
	}
	MyBMDBox.SetEnabled(bRenderDetailSetToCustom);
	if(Not_PreBool(DynamicCheckOptionBumpMapDetail()))
	{
		MyBMDBox.DisableComponent();
	}
	MyDSDBox.setIndex(int(PlayerOwner().ConsoleCommand("SHADOWDETAIL GET")));
	MyDSDBox.SetEnabled(bRenderDetailSetToCustom);
	if(Not_PreBool(DynamicCheckOptionShadowDetail()))
	{
		MyDSDBox.DisableComponent();
	}
	if(DynamicCheckOptionGlowDetail())
	{
		MyGlowDBox.setIndex(int(PlayerOwner().ConsoleCommand("GLOWDETAIL GET")));
	}
	else
	{
		MyGlowDBox.setIndex(0);
	}
	MyGlowDBox.SetEnabled(bRenderDetailSetToCustom);
	if(Not_PreBool(DynamicCheckOptionGlowDetail()))
	{
		MyGlowDBox.DisableComponent();
	}
	MyWorldDetailBox.setIndex(Add_IntInt(-1, int(PlayerOwner().ConsoleCommand("WORLDDETAIL GET"))));
	MyWorldDetailBox.SetEnabled(bRenderDetailSetToCustom);
	if(Not_PreBool(DynamicCheckOptionWorldDetail()))
	{
		MyWorldDetailBox.DisableComponent();
	}
	MyTexDBox.setIndex(Add_IntInt(-1, int(PlayerOwner().ConsoleCommand("TEXTUREDETAIL GET"))));
	MyTexDBox.SetEnabled(bRenderDetailSetToCustom);
	if(Not_PreBool(DynamicCheckOptionTextureDetail()))
	{
		MyTexDBox.DisableComponent();
	}
	if(Not_PreBool(bRenderDetailSetToCustom))
	{
		if(DynamicCheckOptionSupportsPS20())
		{
			MyPixelShadersBox.setIndex(1);
		}
		else
		{
			MyPixelShadersBox.setIndex(0);
		}
	}
	MyPixelShadersBox.SetEnabled(bRenderDetailSetToCustom);
	if(Not_PreBool(DynamicCheckOptionSupportsPS20()))
	{
		MyPixelShadersBox.DisableComponent();
	}
	MyMirrorsBox.setIndex(int(PlayerOwner().ConsoleCommand("USEREALTIMEMIRRORS GET")));
	MyMirrorsBox.SetEnabled(bRenderDetailSetToCustom);
	return;
}

function RenderDetailOnChange(GUIComponent Sender)
{
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("[dkaplan] >>> RenderDetailOnChange. bActiveInput=", string(bActiveInput)), " bLoadingSettings="), string(bLoadingSettings)));
	if(Not_PreBool(bActiveInput))
	{
		return;
	}
	ApplySetting("RenderDetail");
	SaveSettings();
	LoadRenderConfigBasedSettings();
	return;
}

function ComboOnChange(GUIComponent Sender)
{
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[dkaplan] >>> ComboOnChange. Sender=", string(Sender.Name)), " bActiveInput="), string(bActiveInput)), " bLoadingSettings="), string(bLoadingSettings)));
	if(OrOr_BoolBool(Not_PreBool(bActiveInput), bLoadingSettings))
	{
		return;
	}
	switch(Sender)
	{
		case MyResBox:
			if(EqualEqual_StrStr(MyResBox.Get(), PlayerOwner().ConsoleCommand("GETCURRENTRES")))
			{
				Log("Resolution change is no-op, skipping application to prevent flush");
				// [Explicit Continue]
				goto J0x25A;
			}
			ApplyDangerousSetting("Resolution", WarningTextVideoResolutionChange);
			break;
		case MyBMDBox:
			ApplySetting("BumpMapDetail");
			break;
		case MyDSDBox:
			ApplySetting("ShadowDetail");
			break;
		case MyGlowDBox:
			ApplySetting("GlowDetail");
			break;
		case MyWorldDetailBox:
			ApplySetting("WorldDetail");
			break;
		case MyTexDBox:
			ApplySetting("TextureDetail");
			break;
		case MyPixelShadersBox:
			ApplySetting("AllowShaders20");
			break;
		case MyMirrorsBox:
			ApplySetting("Mirrors");
			break;
		case MyBrightnessSlider:
			ApplySetting("Brightness");
			break;
		case MyContrastSlider:
			ApplySetting("Contrast");
			break;
		case MyGammaSlider:
			ApplySetting("Gamma");
			break;
		default:
			break;
	}
	J0x25A:

	return;
}

function InternalApplySetting(string Setting, optional bool bRevertSetting)
{
	local string SettingValue, ConsoleCommand;
	local bool OnlyUpdateGUI;

	Log(Concat_StrStr(Concat_StrStr("dkaplan >>> InternalApplySetting( ", Setting), " )"));
	SettingValue = "";
	ConsoleCommand = "";
	OnlyUpdateGUI = bLoadingSettings;
	switch(Setting)
	{
		case "RenderDetail":
			SettingValue = string(Subtract_IntInt(MyRenderDetailBox.GetIndex(), 1));
			ConsoleCommand = "RENDERDETAIL";
			if(ComplementEqual_StrStr(SettingValue, PlayerOwner().ConsoleCommand("RENDERDETAIL GET")))
			{
				Log("RenderDetail change is no-op, skipping application to prevent flush");
				OnlyUpdateGUI = true;
			}
			break;
		case "Resolution":
			if(bRevertSetting)
			{
				PlayerOwner().ConsoleCommand(At_StrStr("SETRES", LastResolution));
				bLoadingSettings = true;
				MyResBox.find(PlayerOwner().ConsoleCommand("GETCURRENTRES"));
				bLoadingSettings = false;
				return;
			}
			else
			{
				LastResolution = PlayerOwner().ConsoleCommand("GETCURRENTRES");
				SettingValue = MyResBox.Get();
				ConsoleCommand = "SETRES";
			}
			break;
		case "BumpMapDetail":
			SettingValue = string(MyBMDBox.GetInt());
			ConsoleCommand = "BUMPMAPDETAIL";
			break;
		case "ShadowDetail":
			SettingValue = string(MyDSDBox.GetInt());
			ConsoleCommand = "SHADOWDETAIL";
			break;
		case "GlowDetail":
			SettingValue = string(MyGlowDBox.GetInt());
			ConsoleCommand = "GLOWDETAIL";
			break;
		case "WorldDetail":
			SettingValue = string(Add_IntInt(1, MyWorldDetailBox.GetInt()));
			ConsoleCommand = "WORLDDETAIL";
			break;
		case "TextureDetail":
			SettingValue = string(Add_IntInt(MyTexDBox.GetInt(), 1));
			ConsoleCommand = "TEXTUREDETAIL";
			if(ComplementEqual_StrStr(SettingValue, PlayerOwner().ConsoleCommand("TEXTUREDETAIL GET")))
			{
				Log("TextureDetail change is no-op, skipping application to prevent flush");
				OnlyUpdateGUI = true;
			}
			break;
		case "AllowShaders20":
			SettingValue = "0";
			if(NotEqual_IntInt(MyPixelShadersBox.GetIndex(), 0))
			{
				SettingValue = "1";
			}
			ConsoleCommand = "SHADERS20";
			break;
		case "Mirrors":
			SettingValue = "0";
			if(NotEqual_IntInt(MyMirrorsBox.GetIndex(), 0))
			{
				SettingValue = "1";
			}
			ConsoleCommand = "USEREALTIMEMIRRORS";
			break;
		case "Brightness":
			SettingValue = string(MyBrightnessSlider.Value);
			ConsoleCommand = "BRIGHTNESS";
			break;
		case "Contrast":
			SettingValue = string(MyContrastSlider.Value);
			ConsoleCommand = "CONTRAST";
			break;
		case "Gamma":
			SettingValue = string(MyGammaSlider.Value);
			ConsoleCommand = "GAMMA";
			break;
		default:
			break;
	}
	if(AndAnd_BoolBool(NotEqual_StrStr(SettingValue, ""), NotEqual_StrStr(ConsoleCommand, "")))
	{
		if(OnlyUpdateGUI)
		{
			Log(Concat_StrStr(At_StrStr(Concat_StrStr("SwatVideoSettingsPanel only needs to set GUI, so NOT Applying Setting: \"", ConsoleCommand), SettingValue), "\""));
		}
		else
		{
			Log(Concat_StrStr(At_StrStr(Concat_StrStr("SwatVideoSettingsPanel Applying Setting: \"", ConsoleCommand), SettingValue), "\""));
			PlayerOwner().ConsoleCommand(At_StrStr(ConsoleCommand, SettingValue));
		}
	}
	else
	{
		AssertWithDescription(false, Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("Invalid option application attempt for setting ", Setting), " (bRevertSetting="), string(bRevertSetting)), ").\nCommand = \""), ConsoleCommand), "\" Setting = "), SettingValue));
	}
	return;
}

function bool DynamicCheckOptionBumpMapDetail()
{
	local bool SupportsBumpmapping;

	SupportsBumpmapping = bool(PlayerOwner().ConsoleCommand("SUPPORTS BUMPMAP"));
	return SupportsBumpmapping;
	return;
}

function bool DynamicCheckOptionShadowDetail()
{
	return true;
	return;
}

function bool DynamicCheckOptionGlowDetail()
{
	local bool SupportsGlow;

	SupportsGlow = bool(PlayerOwner().ConsoleCommand("SUPPORTS GLOW"));
	return SupportsGlow;
	return;
}

function bool DynamicCheckOptionWorldDetail()
{
	return true;
	return;
}

function bool DynamicCheckOptionTextureDetail()
{
	return true;
	return;
}

function bool DynamicCheckOptionSupportsPS20()
{
	local int MaxPSVer;

	if(Not_PreBool(DynamicCheckOptionBumpMapDetail()))
	{
		return false;
	}
	MaxPSVer = int(PlayerOwner().ConsoleCommand("MAXPSVER GET"));
	return GreaterEqual_IntInt(MaxPSVer, 20);
	return;
}

protected function ResetToDefaults()
{
	local string DefaultRes, CurrentRes;

	Log("dkaplan >>> ResetToDefaults()");
	MyBrightnessSlider.SetValue(DefaultBrightness);
	MyContrastSlider.SetValue(DefaultContrast);
	MyGammaSlider.SetValue(DefaultGamma);
	CurrentRes = PlayerOwner().ConsoleCommand("GETCURRENTRES");
	DefaultRes = PlayerOwner().ConsoleCommand("GETBESTGUESSDEFAULTRESOLUTION");
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("CurrentRes = ", CurrentRes), " DefaultRes = "), DefaultRes));
	if(Not_PreBool(ComplementEqual_StrStr(CurrentRes, DefaultRes)))
	{
		Log(Concat_StrStr("Changing resolution to ", DefaultRes));
		PlayerOwner().ConsoleCommand(At_StrStr("SETRES", DefaultRes));
		MyResBox.find(PlayerOwner().ConsoleCommand("GETCURRENTRES"));
	}
	MyRenderDetailBox.setIndex(Add_IntInt(1, int(PlayerOwner().ConsoleCommand("RENDERDETAIL GET BESTGUESSDEFAULT"))));
	if(DynamicCheckOptionSupportsPS20())
	{
		MyPixelShadersBox.setIndex(int(PlayerOwner().ConsoleCommand("SHADERS20 GET BESTGUESSDEFAULT")));
	}
	else
	{
		MyPixelShadersBox.setIndex(0);
	}
	return;
}

defaultproperties
{
	DefaultBrightness=0.6000000
	DefaultContrast=0.6000000
	DefaultGamma=1.2000000
	WarningTextVideoResolutionChange="The game will now attempt to change video resolution. If this fails, the game will revert to the current setting after 10 seconds. Are you sure you want to change video resolution?"
	ConfirmResetString="Are you sure that you wish to reset all video settings to their defaults? This may take a few moments."
	ConfirmationDialogDelayBeforeRevert=30
}