class SwatAudioSettingsPanel extends SwatSettingsPanel
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(SwatGui) private export editinline config GUISlider MyMusicVolumeSlider;
var(SwatGui) private export editinline config GUISlider MySoundVolumeSlider;
var(SwatGui) private export editinline config GUISlider MyVoiceVolumeSlider;
var private float DefaultMusicVolume;
var private float DefaultSoundVolume;
var private float DefaultVoiceVolume;
var private float DefaultAmbientVolume;

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	MyMusicVolumeSlider.__OnChange__Delegate = OnMusicVolumeChanged;
	MySoundVolumeSlider.__OnChange__Delegate = OnSoundVolumeChanged;
	MyVoiceVolumeSlider.__OnChange__Delegate = OnVoiceVolumeChanged;
	return;
}

function SaveSettings()
{
	GC.SaveConfig();
	return;
}

function LoadSettings()
{
	MySoundVolumeSlider.Value = float(PlayerOwner().ConsoleCommand("get alaudio.alaudiosubsystem soundvolume"));
	MyMusicVolumeSlider.Value = float(PlayerOwner().ConsoleCommand("get alaudio.alaudiosubsystem musicvolume"));
	MyVoiceVolumeSlider.Value = float(PlayerOwner().ConsoleCommand("get alaudio.alaudiosubsystem Voicevolume"));
	return;
}

private function OnMusicVolumeChanged(GUIComponent Sender)
{
	local float Multiplier;

	Multiplier = GUISlider(Sender).Value;
	Controller.StaticExec(Concat_StrStr("set alaudio.alaudiosubsystem musicvolume ", string(Multiplier)));
	return;
}

private function OnSoundVolumeChanged(GUIComponent Sender)
{
	local float Multiplier;

	Multiplier = GUISlider(Sender).Value;
	Controller.StaticExec(Concat_StrStr("set alaudio.alaudiosubsystem soundvolume ", string(Multiplier)));
	Controller.StaticExec(Concat_StrStr("set alaudio.alaudiosubsystem Ambientvolume ", string(Multiplier)));
	return;
}

private function OnVoiceVolumeChanged(GUIComponent Sender)
{
	local float Multiplier;

	Multiplier = GUISlider(Sender).Value;
	Controller.StaticExec(Concat_StrStr("set alaudio.alaudiosubsystem Voicevolume ", string(Multiplier)));
	return;
}

protected function ResetToDefaults()
{
	MyMusicVolumeSlider.SetValue(DefaultMusicVolume);
	MySoundVolumeSlider.SetValue(DefaultSoundVolume);
	MyVoiceVolumeSlider.SetValue(DefaultVoiceVolume);
	return;
}

defaultproperties
{
	DefaultMusicVolume=0.9000000
	DefaultSoundVolume=0.9000000
	DefaultVoiceVolume=0.9000000
	ConfirmResetString="Are you sure that you wish to reset all audio settings to their defaults?"
}