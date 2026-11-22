class SwatEntryOptionsPanel extends SwatGUIPanel
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(SwatGui) private export editinline config GUIScrollTextBox MyLocationInfoText;
var(SwatGui) private export editinline config GUIImage MyLocationImage;
var(SwatGui) editinline array<export editinline GUIImage> MyEntryImages;
var(SwatGui) editinline array<export editinline GUILabel> MyEntrySelectors;
var(SwatGui) editinline array<export editinline GUIScrollTextBox> MyEntryDescriptors;
var(SwatGui) editinline array<export editinline GUIRadioButton> MyEntryChecks;

function OnConstruct(GUIController MyController)
{
	local int i;

	super(GUIMultiComponent).OnConstruct(MyController);
	i = 0;
	J0x12:

	if(Less_IntInt(i, 2))
	{
		MyEntryImages[i] = GUIImage(AddComponent("GUI.GUIImage", Concat_StrStr(Concat_StrStr(string(self.Name), "_EntryImage_"), string(i))));
		MyEntrySelectors[i] = GUILabel(AddComponent("GUI.GUILabel", Concat_StrStr(Concat_StrStr(string(self.Name), "_EntryLabel_"), string(i))));
		MyEntryDescriptors[i] = GUIScrollTextBox(AddComponent("GUI.GUIScrollTextBox", Concat_StrStr(Concat_StrStr(string(self.Name), "_EntryDescription_"), string(i))));
		MyEntryChecks[i] = GUIRadioButton(AddComponent("GUI.GUIRadioButton", Concat_StrStr(Concat_StrStr(string(self.Name), "_EntryCheck_"), string(i))));
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x12;
	}
	return;
}

function InitComponent(GUIComponent MyOwner)
{
	local int i;

	super.InitComponent(MyOwner);
	i = 0;
	J0x12:

	if(Less_IntInt(i, 2))
	{
		MyEntryImages[i].RadioGroup = MyEntryChecks[i];
		MyEntrySelectors[i].RadioGroup = MyEntryChecks[i];
		MyEntryDescriptors[i].RadioGroup = MyEntryChecks[i];
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x12;
	}
	return;
}

function InternalOnShow()
{
	local int i;
	local string Content;

	Content = "";
	i = 0;
	J0x0F:

	if(Less_IntInt(i, GC.CurrentMission.LocationInfoText.Length))
	{
		Content = Concat_StrStr(Concat_StrStr(Content, GC.CurrentMission.LocationInfoText[i]), "|");
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x0F;
	}
	MyLocationInfoText.SetContent(Content);
	MyLocationImage.Image = GC.CurrentMission.Floorplans;
	AssertWithDescription(Greater_IntInt(GC.CurrentMission.EntryOptionTitle.Length, 0), Concat_StrStr(Concat_StrStr("There must be at least one entry option specified for mission \"", GC.CurrentMission.FriendlyName), "\" in SwatMissions.ini"));
	AssertWithDescription(LessEqual_IntInt(GC.CurrentMission.EntryOptionTitle.Length, 2), Concat_StrStr(Concat_StrStr("There cannot be more than two entry options specified for mission \"", GC.CurrentMission.FriendlyName), "\" in SwatMissions.ini"));
	AssertWithDescription(AndAnd_BoolBool(EqualEqual_IntInt(GC.CurrentMission.EntryOptionTitle.Length, GC.CurrentMission.EntryImage.Length), EqualEqual_IntInt(GC.CurrentMission.EntryOptionTitle.Length, GC.CurrentMission.EntryDescription.Length)), Concat_StrStr(Concat_StrStr("The number of EntryOptionTitles, EntryDescriptions, and EntryImages must be the same for mission \"", GC.CurrentMission.FriendlyName), "\" in SwatMissions.ini"));
	i = 0;
	J0x2DD:

	if(Less_IntInt(i, GC.CurrentMission.EntryOptionTitle.Length))
	{
		MyEntryImages[i].Image = GC.CurrentMission.EntryImage[i];
		MyEntrySelectors[i].SetCaption(GC.CurrentMission.EntryOptionTitle[i]);
		MyEntryDescriptors[i].SetContent(GC.CurrentMission.EntryDescription[i]);
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x2DD;
	}
	return;
}

function InternalOnActivate()
{
	assert(NotEqual_ObjectObject(MyEntryChecks[0], none));
	assert(NotEqual_ObjectObject(MyEntryChecks[1], none));
	MyEntryChecks[0].EnableComponent();
	MyEntryChecks[1].EnableComponent();
	if(AndAnd_BoolBool(NotEqual_ObjectObject(GC.CurrentMission.CustomScenario, none), GC.CurrentMission.CustomScenario.SpecifyStartPoint))
	{
		MyEntryChecks[0].SetEnabled(Not_PreBool(GC.CurrentMission.CustomScenario.UseSecondaryStartPoint));
		MyEntryChecks[1].SetEnabled(GC.CurrentMission.CustomScenario.UseSecondaryStartPoint);
		if(GC.CurrentMission.CustomScenario.UseSecondaryStartPoint)
		{
			MyEntryChecks[1].SelectRadioButton();
		}
		else
		{
			MyEntryChecks[0].SelectRadioButton();
		}
	}
	else
	{
		if(AndAnd_BoolBool(EqualEqual_IntInt(int(GC.GetDesiredEntryPoint()), int(1)), GreaterEqual_IntInt(GC.CurrentMission.EntryOptionTitle.Length, 2)))
		{
			MyEntryChecks[1].SelectRadioButton();
		}
		else
		{
			MyEntryChecks[0].SelectRadioButton();
		}
	}
	if(Less_IntInt(GC.CurrentMission.EntryOptionTitle.Length, 2))
	{
		MyEntryImages[1].Hide();
		MyEntrySelectors[1].Hide();
		MyEntryDescriptors[1].Hide();
		MyEntryChecks[1].Hide();
		MyEntryChecks[1].DeActivate();
		MyEntryChecks[1].DisableComponent();
	}
	return;
}

event Free(optional bool bForce)
{
	local int i;

	super(GUIMultiComponent).Free(bForce);
	i = 0;
	J0x13:

	if(Less_IntInt(i, MyEntryImages.Length))
	{
		RemoveComponent(MyEntryImages[i]);
		RemoveComponent(MyEntrySelectors[i]);
		RemoveComponent(MyEntryDescriptors[i]);
		RemoveComponent(MyEntryChecks[i]);
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x13;
	}
	MyEntryImages.Remove(0, MyEntryImages.Length);
	MyEntrySelectors.Remove(0, MyEntrySelectors.Length);
	MyEntryDescriptors.Remove(0, MyEntryDescriptors.Length);
	MyEntryChecks.Remove(0, MyEntryChecks.Length);
	return;
}

function SetRadioGroup(GUIRadioButton Group)
{
	if(AndAnd_BoolBool(NotEqual_ObjectObject(MyEntryChecks[0], Group), NotEqual_ObjectObject(MyEntryChecks[1], Group)))
	{
		return;
	}
	if(Less_IntInt(GC.CurrentMission.EntryOptionTitle.Length, 2))
	{
		Group = MyEntryChecks[0];
	}
	super(GUIMultiComponent).SetRadioGroup(Group);
	if(EqualEqual_ObjectObject(MyEntryChecks[1], Group))
	{
		GC.SetDesiredEntryPoint(1);
	}
	else
	{
		GC.SetDesiredEntryPoint(0);
	}
	return;
}

defaultproperties
{
	WinTop=0.2133300
	WinLeft=0.0500000
	WinWidth=0.8750000
	WinHeight=0.6666600
	OnShow=SwatEntryOptionsPanel.InternalOnShow
	OnActivate=SwatEntryOptionsPanel.InternalOnActivate
}