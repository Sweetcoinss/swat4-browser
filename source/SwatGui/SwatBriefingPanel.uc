class SwatBriefingPanel extends SwatGUIPanel
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(SwatGui) private export editinline config GUILabel MissionNameLabel;
var(SwatGui) private export editinline config GUIRadioButton BriefingAudioToggle;
var(SwatGui) private export editinline config GUIRadioButton Swat911AudioToggle;
var(SwatGui) private export editinline config GUIRadioButton NoAudioToggle;
var(SwatGui) private string LevelContextString;

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	return;
}

event Show()
{
	super.Show();
	MissionNameLabel.SetCaption(GC.CurrentMission.FriendlyName);
	Swat911AudioToggle.SetEnabled(GC.CurrentMission.bHas911DispatchAudio);
	if(Not_PreBool(GC.CurrentMission.bBriefingPlayed))
	{
		SetRadioGroup(BriefingAudioToggle);
	}
	else
	{
		SetRadioGroup(NoAudioToggle);
	}
	return;
}

event Hide()
{
	StopBriefingAudio();
	Stop911Audio();
	super(GUIMultiComponent).Hide();
	return;
}

function SetRadioGroup(GUIRadioButton Group)
{
	super(GUIMultiComponent).SetRadioGroup(Group);
	switch(Group)
	{
		case BriefingAudioToggle:
			Stop911Audio();
			StartBriefingAudio();
			break;
		case Swat911AudioToggle:
			StopBriefingAudio();
			Start911Audio();
			break;
		case NoAudioToggle:
			StopBriefingAudio();
			Stop911Audio();
			break;
		default:
			break;
	}
	return;
}

private function StartBriefingAudio()
{
	GC.CurrentMission.bBriefingPlayed = true;
	PlayerOwner().TriggerEffectEvent('UIMissionBriefing',,,,,,,, GetMissionContext());
	return;
}

private function StopBriefingAudio()
{
	PlayerOwner().UnTriggerEffectEvent('UIMissionBriefing', GetMissionContext());
	return;
}

private function Start911Audio()
{
	PlayerOwner().TriggerEffectEvent('UIMission911Call',,,,,,,, GetMissionContext());
	return;
}

private function Stop911Audio()
{
	PlayerOwner().UnTriggerEffectEvent('UIMission911Call', GetMissionContext());
	return;
}

private function name GetMissionContext()
{
	return string(Concat_StrStr(LevelContextString, string(GC.CurrentMission.Name)));
	return;
}

defaultproperties
{
	LevelContextString="Level_"
}