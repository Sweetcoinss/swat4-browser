class SwatMission extends RefCount
	config(SwatMissions)
	perobjectconfig;

var config string MapName "Name of the map that corresponds with this mission";
var editconst string FriendlyName "Name of the mission that will be displayed in the GUI";
var editconst editinline MissionObjectives Objectives "The objectives for this mission";
var config localized array<localized string> MissionDescription "A generic description of this mission (for the mission selection screen)";
var config Material Thumbnail "Image that will be displayed on the mission selection screen for this mission";
var config localized array<localized string> BriefingText "Briefing text that will be displayed for the mission";
var config localized array<localized string> LocationInfoText "Text that will be displayed for the mission on the LocationInfo panel";
var config Material Floorplans "An image that will be used as floorplans for this mission";
var config localized array<localized string> HostageName "The name of this Hostage";
var config localized array<localized string> HostageVitals "A description of this Hostages vital stats";
var config localized array<localized string> HostageDescription "A description of this Hostage";
var config array<Material> HostageImage "A picture of this Hostage, default should be -no picture available-";
var config localized array<localized string> SuspectName "The name of this Suspect";
var config localized array<localized string> SuspectVitals "A description of this Suspects vital stats";
var config localized array<localized string> SuspectDescription "A description of this Suspect";
var config array<Material> SuspectImage "A picture of this Suspect, default should be -no picture available-";
var config localized array<localized string> EntryOptionTitle "The title (usually 1 word) of this entry option";
var config localized array<localized string> EntryDescription "The description of this entry option";
var config array<Material> EntryImage "A picture of this Entry Option, default should be -no picture available-";
var config localized array<localized int> TimeLinePlot "The time of this entry as an int from 0 - 100";
var config localized array<localized string> TimeLineTime "The time of this entry (must be unique for each entry for this mission)";
var config localized array<localized string> TimeLineShortDescription "The description to be used on the timeline itself";
var config localized array<localized string> TimeLineLongDescription "The description to be used in the extended timeline scroll text";
var config localized string LoadingText "Text that will be displayed for the mission on the Loading Screen";
var config Material LoadingImage "An image that will be displayed for the mission on the Loading Screen";
var(DEBUG) CustomScenario CustomScenario;
var(DEBUG) bool bBriefingPlayed;
var(DEBUG) private bool bHasMetDifficultyRequirement;
var config bool bHas911DispatchAudio;

function Initialize(string theFriendlyName, CustomScenario inCustomScenario)
{
	FriendlyName = theFriendlyName;
	Objectives = Class'SwatGame.MissionObjectives'.static.Allocate(self, none, string(self.Name), 0).;
	Construct_Void();
	CustomScenario = inCustomScenario;
	if(NotEqual_ObjectObject(CustomScenario, none))
	{
		CustomScenario.MutateMissionObjectives(Objectives);
	}
	return;
}

function bool IsMissionCompleted()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Objectives.Objectives.Length))
	{
		if(AndAnd_BoolBool(AndAnd_BoolBool(Objectives.Objectives[i].IsA('Objective_Do'), Objectives.Objectives[i].IsPrimaryObjective), NotEqual_IntInt(int(Objectives.Objectives[i].GetStatus()), int(1))))
		{
			return false;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return true;
	return;
}

function bool IsMissionFailed()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Objectives.Objectives.Length))
	{
		if(AndAnd_BoolBool(Objectives.Objectives[i].IsPrimaryObjective, EqualEqual_IntInt(int(Objectives.Objectives[i].GetStatus()), int(2))))
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

function bool IsMissionTerminal()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Objectives.Objectives.Length))
	{
		if(AndAnd_BoolBool(Objectives.Objectives[i].IsTerminal, EqualEqual_IntInt(int(Objectives.Objectives[i].GetStatus()), int(2))))
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

function bool HasMetDifficultyRequirement()
{
	return bHasMetDifficultyRequirement;
	return;
}

function SetHasMetDifficultyRequirement(bool inSuccess)
{
	bHasMetDifficultyRequirement = inSuccess;
	return;
}
