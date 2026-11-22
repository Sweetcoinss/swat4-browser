class CustomScenario_HostagesTabPanel extends CustomScenarioTabPanel
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(SwatGui) export editinline config GUICheckBoxButton chk_campaign;
var(SwatGui) export editinline config GUIPanel pnl_body;
var(SwatGui) export editinline config GUIImage pnl_DisabledOverlay;
var(SwatGui) export editinline config GUIDualSelectionLists dlist_archetypes;
var(SwatGui) export editinline config GUILabel lbl_count;
var(SwatGui) export editinline config GUINumericEdit spin_count_min;
var(SwatGui) export editinline config GUILabel lbl_count_min;
var(SwatGui) export editinline config GUILabel lbl_count_max;
var(SwatGui) export editinline config GUINumericEdit spin_count_max;
var(SwatGui) export editinline config GUILabel lbl_morale;
var(SwatGui) export editinline config GUISlider slide_morale_min;
var(SwatGui) export editinline config GUILabel lbl_morale_min;
var(SwatGui) export editinline config GUILabel lbl_morale_max;
var(SwatGui) export editinline config GUISlider slide_morale_max;

function InitComponent(GUIComponent MyOwner)
{
	super(SwatGUIPanel).InitComponent(MyOwner);
	data = CustomScenarioPage.CustomScenarioCreatorData;
	chk_campaign.__OnChange__Delegate = chk_campaign_OnChange;
	spin_count_min.__OnChange__Delegate = spin_count_min_OnChange;
	spin_count_max.__OnChange__Delegate = spin_count_max_OnChange;
	slide_morale_min.__OnChange__Delegate = slide_morale_min_OnChange;
	slide_morale_max.__OnChange__Delegate = slide_morale_max_OnChange;
	return;
}

event Activate()
{
	super(GUIMultiComponent).Activate();
	SetPanelActive();
	return;
}

private function SetPanelActive()
{
	pnl_body.SetActive(Not_PreBool(chk_campaign.bChecked));
	pnl_DisabledOverlay.SetVisibility(chk_campaign.bChecked);
	return;
}

function chk_campaign_OnChange(GUIComponent Sender)
{
	SetPanelActive();
	return;
}

function spin_count_min_OnChange(GUIComponent Sender)
{
	if(Less_IntInt(spin_count_max.Value, spin_count_min.Value))
	{
		spin_count_max.SetValue(spin_count_min.Value);
	}
	return;
}

function spin_count_max_OnChange(GUIComponent Sender)
{
	if(Greater_IntInt(spin_count_min.Value, spin_count_max.Value))
	{
		spin_count_min.SetValue(spin_count_max.Value);
	}
	return;
}

function slide_morale_min_OnChange(GUIComponent Sender)
{
	if(Less_FloatFloat(slide_morale_max.Value, slide_morale_min.Value))
	{
		slide_morale_max.SetValue(slide_morale_min.Value);
	}
	return;
}

function slide_morale_max_OnChange(GUIComponent Sender)
{
	if(Greater_FloatFloat(slide_morale_min.Value, slide_morale_max.Value))
	{
		slide_morale_min.SetValue(slide_morale_max.Value);
	}
	return;
}

function PopulateFieldsFromScenario(bool NewScenario)
{
	local CustomScenario Scenario;
	local HostageArchetype Archetype;
	local int i, j;

	Scenario = CustomScenarioPage.GetCustomScenario();
	chk_campaign.SetChecked(Scenario.UseCampaignHostageSettings, true);
	spin_count_min.SetValue(Scenario.HostageCountRangeCow.Min, true);
	spin_count_max.SetValue(Scenario.HostageCountRangeCow.Max, true);
	slide_morale_min.SetValue(Scenario.HostageMorale.Min);
	slide_morale_max.SetValue(Scenario.HostageMorale.Max);
	dlist_archetypes.ListBoxA.Clear();
	dlist_archetypes.ListBoxB.Clear();
	i = 0;
	J0xF5:

	if(Less_IntInt(i, data.HostageArchetype.Length))
	{
		Archetype = Class'SwatGame.HostageArchetype'.static.Allocate(self, none, string(data.HostageArchetype[i].Archetype)).;
		Construct_Void();
		if(NewScenario)
		{
			if(data.HostageArchetype[i].ByDefault)
			{
				dlist_archetypes.ListBoxB.List.Add(string(data.HostageArchetype[i].Archetype),, Archetype.Description);
			}
			else
			{
				dlist_archetypes.ListBoxA.List.Add(string(data.HostageArchetype[i].Archetype),, Archetype.Description);
			}
			// [Explicit Continue]
			goto J0x31B;
		}
		j = 0;
		J0x214:

		if(Less_IntInt(j, Scenario.HostageArchetypes.Length))
		{
			if(EqualEqual_NameName(Scenario.HostageArchetypes[j], data.HostageArchetype[i].Archetype))
			{
				dlist_archetypes.ListBoxB.List.Add(string(data.HostageArchetype[i].Archetype),, Archetype.Description);
				// [Explicit Break]
				goto J0x2B7;
			}
			AddAdd_PreInt(j);
			// [Loop Continue]
			goto J0x214;
		}
		J0x2B7:

		if(EqualEqual_IntInt(j, Scenario.HostageArchetypes.Length))
		{
			dlist_archetypes.ListBoxA.List.Add(string(data.HostageArchetype[i].Archetype),, Archetype.Description);
		}
		J0x31B:

		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0xF5;
	}
	dlist_archetypes.ListBoxA.setIndex(0);
	dlist_archetypes.ListBoxB.setIndex(0);
	return;
}

function GatherScenarioFromFields()
{
	local CustomScenario Scenario;
	local int i;

	Scenario = CustomScenarioPage.GetCustomScenario();
	Scenario.UseCampaignHostageSettings = chk_campaign.bChecked;
	Scenario.HostageCountRangeCow.Min = spin_count_min.Value;
	Scenario.HostageCountRangeCow.Max = spin_count_max.Value;
	Scenario.HostageMorale.Min = slide_morale_min.Value;
	Scenario.HostageMorale.Max = slide_morale_max.Value;
	Scenario.HostageArchetypes.Remove(0, Scenario.HostageArchetypes.Length);
	i = 0;
	J0xE2:

	if(Less_IntInt(i, dlist_archetypes.ListBoxB.List.Elements.Length))
	{
		Scenario.HostageArchetypes[Scenario.HostageArchetypes.Length] = string(dlist_archetypes.ListBoxB.List.GetItemAtIndex(i));
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0xE2;
	}
	return;
}
