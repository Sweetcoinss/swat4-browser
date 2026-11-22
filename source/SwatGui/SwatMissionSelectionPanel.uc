class SwatMissionSelectionPanel extends SwatGUIPanel
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(SwatGui) private export editinline config GUILabel MyCampaignNameLabel;
var(SwatGui) private export editinline config GUIScrollTextBox MyMissionInfoBox;
var(SwatGui) private export editinline config GUIListBox MyMissionSelectionBox;
var(SwatGui) private export editinline config GUIComboBox MyDifficultySelector;
var(SwatGui) private export editinline config GUILabel MyDifficultyLabel;
var(SwatGui) private export editinline config GUILabel MyMissionNameLabel;
var(SwatGui) private export editinline config GUIImage MyThumbnail;
var(SwatGui) private export editinline config GUIScrollTextBox MyMissionInfo;
var(DEBUG) private editconst bool bAddingMissions;
var(DEBUG) private Campaign theCampaign;
var private config localized string DifficultyLabelString;

function InitComponent(GUIComponent MyOwner)
{
	local int i;

	super.InitComponent(MyOwner);
	i = 0;
	J0x12:

	if(Less_IntInt(i, int(4)))
	{
		MyDifficultySelector.AddItem(GC.DifficultyString[i]);
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x12;
	}
	MyMissionSelectionBox.__OnChange__Delegate = MyMissionSelectionBox_OnChange;
	MyDifficultySelector.__OnChange__Delegate = MyDifficultySelector_OnChange;
	MyDifficultySelector.setIndex(int(GC.CurrentDifficulty));
	return;
}

function InternalOnActivate()
{
	if(EqualEqual_IntInt(int(GC.SwatGameRole), int(2)))
	{
		assert(NotEqual_ObjectObject(GC.GetCustomScenarioPack(), none));
		theCampaign = none;
		MyCampaignNameLabel.SetCaption(GC.GetPakFriendlyName());
		PopulateCustomScenarioList();
		MyMissionSelectionBox.List.FindExtra(GC.GetScenarioName());
	}
	else
	{
		assert(EqualEqual_IntInt(int(GC.SwatGameRole), int(1)));
		theCampaign = SwatGUIController(Controller).GetCampaign();
		MyCampaignNameLabel.SetCaption(theCampaign.StringName);
		PopulateCampaignMissionList();
		if(AndAnd_BoolBool(GreaterEqual_IntInt(theCampaign.GetAvailableIndex(), MyMissionSelectionBox.Num()), Not_PreBool(theCampaign.HasPlayedCreditsOnCampaignCompletion())))
		{
			CompletedCampaign();
		}
		if(NotEqual_ObjectObject(GC.CurrentMission, none))
		{
			EqualEqual_StrStr(MyMissionSelectionBox.List.find(string(GC.CurrentMission.Name)), "");
		}
	}
	if(EqualEqual_ObjectObject(GC.CurrentMission, none))
	{
		MyMissionSelectionBox.setIndex(Subtract_IntInt(MyMissionSelectionBox.Num(), 1));
	}
	return;
}

function DisplayMissionResults(MissionResults Results)
{
	local int i;
	local MissionResult Result;
	local string scoreString;

	MyMissionInfoBox.SetContent("");
	i = 0;
	J0x18:

	if(Less_IntInt(i, int(4)))
	{
		Result = Results.GetResult(byte(i));
		if(Not_PreBool(Result.Played))
		{
			scoreString = "( - )";
		}
		else
		{
			scoreString = string(Result.Score);
			if(Not_PreBool(Result.Completed))
			{
				scoreString = At_StrStr(At_StrStr("(", scoreString), ")");
			}
		}
		scoreString = At_StrStr(":", scoreString);
		MyMissionInfoBox.AddText(Concat_StrStr(GC.GetDifficultyString(byte(i)), scoreString));
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x18;
	}
	return;
}

function MyMissionSelectionBox_OnChange(GUIComponent Sender)
{
	local CustomScenario CustomScen;

	if(bAddingMissions)
	{
		return;
	}
	CustomScen = CustomScenario(MyMissionSelectionBox.List.GetObject());
	GC.SetCurrentMission(string(MyMissionSelectionBox.List.Get()), MyMissionSelectionBox.List.GetExtra(), CustomScen);
	if(OrOr_BoolBool(OrOr_BoolBool(EqualEqual_ObjectObject(CustomScen, none), Not_PreBool(CustomScen.SpecifyStartPoint)), Not_PreBool(CustomScen.UseSecondaryStartPoint)))
	{
		GC.SetDesiredEntryPoint(0);
	}
	if(AndAnd_BoolBool(NotEqual_ObjectObject(CustomScen, none), NotEqual_StrStr(CustomScen.Difficulty, "Any")))
	{
		MyDifficultySelector.DisableComponent();
		if(EqualEqual_StrStr(CustomScen.Difficulty, "Easy"))
		{
			MyDifficultySelector.setIndex(int(0));
		}
		else
		{
			if(EqualEqual_StrStr(CustomScen.Difficulty, "Normal"))
			{
				MyDifficultySelector.setIndex(int(1));
			}
			else
			{
				if(EqualEqual_StrStr(CustomScen.Difficulty, "Hard"))
				{
					MyDifficultySelector.setIndex(int(2));
				}
				else
				{
					if(EqualEqual_StrStr(CustomScen.Difficulty, "Elite"))
					{
						MyDifficultySelector.setIndex(int(3));
					}
					else
					{
						AssertWithDescription(false, "[tcohen] SwatMissionSelectionPanel::InternalOnActivate() CustomScenario.Difficulty was not recognized as Easy, Normal, or Hard.");
					}
				}
			}
		}
	}
	else
	{
		MyDifficultySelector.EnableComponent();
	}
	if(NotEqual_ObjectObject(CustomScen, none))
	{
		DisplayMissionResults(GC.GetMissionResults(string(Concat_StrStr(Concat_StrStr(GC.GetPakFriendlyName(), "_"), MyMissionSelectionBox.List.GetExtra()))));
	}
	else
	{
		DisplayMissionResults(theCampaign.GetMissionResults(string(MyMissionSelectionBox.List.Get())));
	}
	ShowMissionDescription();
	return;
}

private function ShowMissionDescription()
{
	local int i;
	local string Content;

	if(EqualEqual_ObjectObject(GC.CurrentMission.CustomScenario, none))
	{
		Content = "";
		i = 0;
		J0x2C:

		if(Less_IntInt(i, GC.CurrentMission.MissionDescription.Length))
		{
			Content = Concat_StrStr(Concat_StrStr(Content, GC.CurrentMission.MissionDescription[i]), "|");
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x2C;
		}
	}
	else
	{
		Content = GC.CurrentMission.CustomScenario.Notes;
	}
	MyMissionInfo.SetContent(Content);
	MyThumbnail.Image = GC.CurrentMission.Thumbnail;
	MyMissionNameLabel.SetCaption(GC.CurrentMission.FriendlyName);
	return;
}

function MyDifficultySelector_OnChange(GUIComponent Sender)
{
	GC.CurrentDifficulty = byte(MyDifficultySelector.GetIndex());
	MyDifficultyLabel.SetCaption(FormatTextString(DifficultyLabelString, string(GC.DifficultyScoreRequirement[int(GC.CurrentDifficulty)])));
	GC.SaveConfig();
	return;
}

private function PopulateCustomScenarioList()
{
	local int i, ScenarioIterator;
	local CustomScenario CustomScen;
	local string ScenarioString;

	bAddingMissions = true;
	MyMissionSelectionBox.List.Clear();
	ScenarioIterator = -1;
	i = 0;
	J0x32:

	ScenarioString = GC.GetCustomScenarioPack().NextScenario(ScenarioIterator);
	if(GreaterEqual_IntInt(ScenarioIterator, 0))
	{
		CustomScen = Class'SwatGame.CustomScenario'.static.Allocate(self).;
		Construct_Void();
		GC.GetCustomScenarioPack().LoadCustomScenarioInPlace(CustomScen, ScenarioString, GC.GetPakName(), GC.GetPakExtension());
		MyMissionSelectionBox.List.Add(string(CustomScen.LevelLabel), CustomScen, ScenarioString, i,, true);
		AddAdd_Int(i);
	}
	if(!(Less_IntInt(ScenarioIterator, 0)))
		goto J0x32;
	MyMissionSelectionBox.List.bSortForward = true;
	MyMissionSelectionBox.List.Sort();
	bAddingMissions = false;
	return;
}

private function PopulateCampaignMissionList()
{
	local int Index;

	bAddingMissions = true;
	MyMissionSelectionBox.List.Clear();
	Index = 0;
	J0x27:

	if(Less_IntInt(Index, GC.MissionName.Length))
	{
		if(LessEqual_IntInt(Index, theCampaign.GetAvailableIndex()))
		{
			MyMissionSelectionBox.List.Add(string(GC.MissionName[Index]),, GC.FriendlyName[Index], Index,, true);
		}
		AddAdd_Int(Index);
		// [Loop Continue]
		goto J0x27;
	}
	MyMissionSelectionBox.List.bSortForward = true;
	MyMissionSelectionBox.List.Sort();
	bAddingMissions = false;
	return;
}

private function CompletedCampaign()
{
	theCampaign.SetHasPlayedCreditsOnCampaignCompletion();
	Controller.OpenMenu("SwatGui.SwatCreditsMenu", "SwatCreditsMenu");
	return;
}

defaultproperties
{
	DifficultyLabelString="Score of [b]%1[° required to advance."
	OnActivate=SwatMissionSelectionPanel.InternalOnActivate
}