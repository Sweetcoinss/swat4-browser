class SwatNPCPanel extends SwatGUIPanel
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(SwatGui) editinline array<export editinline GUIImage> MyNPCImage;
var(SwatGui) editinline array<export editinline GUILabel> MyNPCName;
var(SwatGui) editinline array<export editinline GUIScrollTextBox> MyNPCVitals;
var(SwatGui) editinline array<export editinline GUIScrollTextBox> MyNPCDescription;
var(SwatGui) private export editinline config GUIImage MyInvalidImage;
var(SwatGui) private editinline config bool bIsHostagePanel;

function InitComponent(GUIComponent MyOwner)
{
	local int i;

	super.InitComponent(MyOwner);
	i = 0;
	J0x12:

	if(Less_IntInt(i, 3))
	{
		MyNPCName[i] = GUILabel(AddComponent("GUI.GUILabel", Concat_StrStr(Concat_StrStr(string(self.Name), "_NPCName_"), string(i)), true));
		MyNPCImage[i] = GUIImage(AddComponent("GUI.GUIImage", Concat_StrStr(Concat_StrStr(string(self.Name), "_NPCImage_"), string(i)), true));
		MyNPCVitals[i] = GUIScrollTextBox(AddComponent("GUI.GUIScrollTextBox", Concat_StrStr(Concat_StrStr(string(self.Name), "_NPCVitals_"), string(i)), true));
		MyNPCDescription[i] = GUIScrollTextBox(AddComponent("GUI.GUIScrollTextBox", Concat_StrStr(Concat_StrStr(string(self.Name), "_NPCDescription_"), string(i)), true));
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x12;
	}
	return;
}

function InternalOnActivate()
{
	if(bIsHostagePanel)
	{
		AssertWithDescription(AndAnd_BoolBool(EqualEqual_IntInt(GC.CurrentMission.HostageName.Length, GC.CurrentMission.HostageImage.Length), EqualEqual_IntInt(GC.CurrentMission.HostageName.Length, GC.CurrentMission.HostageDescription.Length)), Concat_StrStr(Concat_StrStr("The number of HostageNames, HostageDescriptions, and HostageImages must be the same for mission \"", GC.CurrentMission.FriendlyName), "\" in SwatMissions.ini"));
		ShowNPCs(GC.CurrentMission.HostageName, GC.CurrentMission.HostageImage, GC.CurrentMission.HostageVitals, GC.CurrentMission.HostageDescription);
	}
	else
	{
		AssertWithDescription(AndAnd_BoolBool(EqualEqual_IntInt(GC.CurrentMission.SuspectName.Length, GC.CurrentMission.SuspectImage.Length), EqualEqual_IntInt(GC.CurrentMission.SuspectName.Length, GC.CurrentMission.SuspectDescription.Length)), Concat_StrStr(Concat_StrStr("The number of SuspectNames, SuspectDescriptions, and SuspectImages must be the same for mission \"", GC.CurrentMission.FriendlyName), "\" in SwatMissions.ini"));
		ShowNPCs(GC.CurrentMission.SuspectName, GC.CurrentMission.SuspectImage, GC.CurrentMission.SuspectVitals, GC.CurrentMission.SuspectDescription);
	}
	MyInvalidImage.SetVisibility(NotEqual_ObjectObject(GC.CurrentMission.CustomScenario, none));
	return;
}

event Free(optional bool bForce)
{
	local int i;

	super(GUIMultiComponent).Free(bForce);
	i = 0;
	J0x13:

	if(Less_IntInt(i, MyNPCName.Length))
	{
		RemoveComponent(MyNPCName[i]);
		RemoveComponent(MyNPCImage[i]);
		RemoveComponent(MyNPCVitals[i]);
		RemoveComponent(MyNPCDescription[i]);
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x13;
	}
	MyNPCName.Remove(0, MyNPCName.Length);
	MyNPCImage.Remove(0, MyNPCImage.Length);
	MyNPCVitals.Remove(0, MyNPCVitals.Length);
	MyNPCDescription.Remove(0, MyNPCDescription.Length);
	return;
}

private function ShowNPCs(array<string> Names, array<Material> Images, array<string> Vitals, array<string> Descriptions)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, 3))
	{
		assert(NotEqual_ObjectObject(MyNPCName[i], none));
		assert(NotEqual_ObjectObject(MyNPCImage[i], none));
		assert(NotEqual_ObjectObject(MyNPCVitals[i], none));
		assert(NotEqual_ObjectObject(MyNPCDescription[i], none));
		if(Less_IntInt(i, Names.Length))
		{
			MyNPCName[i].SetCaption(Names[i]);
			MyNPCImage[i].Image = Images[i];
			MyNPCVitals[i].SetContent(Vitals[i]);
			MyNPCDescription[i].SetContent(Descriptions[i]);
			// [Explicit Continue]
			goto J0x13E;
		}
		MyNPCName[i].Hide();
		MyNPCImage[i].Hide();
		MyNPCVitals[i].Hide();
		MyNPCDescription[i].Hide();
		J0x13E:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

defaultproperties
{
	WinTop=0.2133300
	WinLeft=0.0500000
	WinWidth=0.8750000
	WinHeight=0.6666600
	OnActivate=SwatNPCPanel.InternalOnActivate
}