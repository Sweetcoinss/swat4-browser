class CustomScenario_EnemiesTabPanel extends CustomScenarioTabPanel
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(SwatGui) export editinline config GUICheckBoxButton chk_campaign;
var(SwatGui) export editinline config GUIPanel pnl_body;
var(SwatGui) export editinline config GUIImage pnl_DisabledOverlay;
var(SwatGui) export editinline config GUIDualSelectionLists dlist_archetypes;
var(SwatGui) export editinline config GUIComboBox cbo_primary_type;
var(SwatGui) export editinline config GUIComboBox cbo_primary_specific;
var(SwatGui) export editinline config GUIComboBox cbo_backup_type;
var(SwatGui) export editinline config GUIComboBox cbo_backup_specific;
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
var(SwatGui) export editinline config GUIComboBox cbo_skill;

function InitComponent(GUIComponent MyOwner)
{
	local int i;

	super(SwatGUIPanel).InitComponent(MyOwner);
	data = CustomScenarioPage.CustomScenarioCreatorData;
	chk_campaign.__OnChange__Delegate = chk_campaign_OnChange;
	cbo_primary_type.__OnListIndexChanged__Delegate = cbo_primary_type_OnChanged;
	cbo_primary_type.__OnChange__Delegate = cbo_primary_type_OnChanged;
	cbo_backup_type.__OnListIndexChanged__Delegate = cbo_backup_type_OnChanged;
	cbo_backup_type.__OnChange__Delegate = cbo_backup_type_OnChanged;
	spin_count_min.__OnChange__Delegate = spin_count_min_OnChange;
	spin_count_max.__OnChange__Delegate = spin_count_max_OnChange;
	slide_morale_min.__OnChange__Delegate = slide_morale_min_OnChange;
	slide_morale_max.__OnChange__Delegate = slide_morale_max_OnChange;
	cbo_skill.AddItem("Any",, data.AnyString);
	cbo_skill.AddItem("Low",, data.LowString);
	cbo_skill.AddItem("Medium",, data.MediumString);
	cbo_skill.AddItem("High",, data.HighString);
	cbo_primary_type.AddItem("Any",, data.AnyString);
	cbo_backup_type.AddItem("Any",, data.AnyString);
	cbo_primary_type.AddItem("None",, data.NoneString);
	cbo_backup_type.AddItem("None",, data.NoneString);
	i = 0;
	J0x1F8:

	if(Less_IntInt(i, data.PrimaryWeaponCategory.Length))
	{
		cbo_primary_type.AddItem(string(data.PrimaryWeaponCategory[i]),, data.PrimaryWeaponCategoryDescription[i]);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x1F8;
	}
	i = 0;
	J0x25C:

	if(Less_IntInt(i, data.BackupWeaponCategory.Length))
	{
		cbo_backup_type.AddItem(string(data.BackupWeaponCategory[i]),, data.BackupWeaponCategoryDescription[i]);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x25C;
	}
	cbo_primary_specific.AddItem("Any",, data.AnyString);
	cbo_primary_specific.SetEnabled(false);
	cbo_backup_specific.AddItem("Any",, data.AnyString);
	cbo_backup_specific.SetEnabled(false);
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

function cbo_primary_type_OnChanged(GUIComponent Sender)
{
	local int i;
	local name SelectedType;
	local Class<FiredWeapon> WeaponClass;

	SelectedType = string(cbo_primary_type.List.Get());
	cbo_primary_specific.Clear();
	switch(SelectedType)
	{
		case 'Any':
			cbo_primary_specific.AddItem("Any",, data.AnyString);
			cbo_primary_specific.SetEnabled(false);
			break;
		case 'None':
			cbo_primary_specific.AddItem("None",, data.NoneString);
			cbo_primary_specific.SetEnabled(false);
			break;
		default:
			cbo_primary_specific.AddItem("Any",, data.AnyString);
			i = 0;
			J0xE0:

			if(Less_IntInt(i, data.PrimaryWeapon.Length))
			{
				if(EqualEqual_NameName(data.PrimaryWeapon[i].category, SelectedType))
				{
					WeaponClass = Class<FiredWeapon>(DynamicLoadObject(data.PrimaryWeapon[i].Weapon, Class'Core.Class'));
					AssertWithDescription(NotEqual_ObjectObject(WeaponClass, none), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] CustomScenario_EnemiesTabPanel::cbo_primary_type_OnChanged() ", "While populating specific weapon choices for primary weapon type "), string(SelectedType)), ", found that PrimaryWeapon["), string(i)), "].Weapon, specified as "), data.PrimaryWeapon[i].Weapon), " could not be DLO'd."));
					cbo_primary_specific.AddItem(data.PrimaryWeapon[i].Weapon,, WeaponClass.default.FriendlyName);
				}
				AddAdd_PreInt(i);
				// [Loop Continue]
				goto J0xE0;
			}
			cbo_primary_specific.SetEnabled(true);
			break;
	}
	return;
}

function cbo_backup_type_OnChanged(GUIComponent Sender)
{
	local int i;
	local name SelectedType;
	local Class<FiredWeapon> WeaponClass;

	SelectedType = string(cbo_backup_type.List.Get());
	cbo_backup_specific.Clear();
	switch(SelectedType)
	{
		case 'Any':
			cbo_backup_specific.AddItem("Any",, data.AnyString);
			cbo_backup_specific.SetEnabled(false);
			break;
		case 'None':
			cbo_backup_specific.AddItem("None",, data.NoneString);
			cbo_backup_specific.SetEnabled(false);
			break;
		default:
			cbo_backup_specific.AddItem("Any",, data.AnyString);
			i = 0;
			J0xE0:

			if(Less_IntInt(i, data.BackupWeapon.Length))
			{
				if(EqualEqual_NameName(data.BackupWeapon[i].category, SelectedType))
				{
					WeaponClass = Class<FiredWeapon>(DynamicLoadObject(data.BackupWeapon[i].Weapon, Class'Core.Class'));
					AssertWithDescription(NotEqual_ObjectObject(WeaponClass, none), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] CustomScenario_EnemiesTabPanel::cbo_backup_type_OnChanged() ", "While populating specific weapon choices for backup weapon type "), string(SelectedType)), ", found that BackupWeapon["), string(i)), "].Weapon, specified as "), data.BackupWeapon[i].Weapon), " could not be DLO'd."));
					cbo_backup_specific.AddItem(data.BackupWeapon[i].Weapon,, WeaponClass.default.FriendlyName);
				}
				AddAdd_PreInt(i);
				// [Loop Continue]
				goto J0xE0;
			}
			cbo_backup_specific.SetEnabled(true);
			break;
	}
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
	local EnemyArchetype Archetype;
	local int i, j;

	Scenario = CustomScenarioPage.GetCustomScenario();
	chk_campaign.SetChecked(Scenario.UseCampaignEnemySettings, true);
	spin_count_min.SetValue(Scenario.EnemyCountRangeCow.Min, true);
	spin_count_max.SetValue(Scenario.EnemyCountRangeCow.Max, true);
	slide_morale_min.SetValue(Scenario.EnemyMorale.Min);
	slide_morale_max.SetValue(Scenario.EnemyMorale.Max);
	dlist_archetypes.ListBoxA.Clear();
	dlist_archetypes.ListBoxB.Clear();
	i = 0;
	J0xF5:

	if(Less_IntInt(i, data.EnemyArchetype.Length))
	{
		Archetype = Class'SwatGame.EnemyArchetype'.static.Allocate(self, none, string(data.EnemyArchetype[i].Archetype)).;
		Construct_Void();
		if(NewScenario)
		{
			if(data.EnemyArchetype[i].ByDefault)
			{
				dlist_archetypes.ListBoxB.List.Add(string(data.EnemyArchetype[i].Archetype),, Archetype.Description);
			}
			else
			{
				dlist_archetypes.ListBoxA.List.Add(string(data.EnemyArchetype[i].Archetype),, Archetype.Description);
			}
			// [Explicit Continue]
			goto J0x31B;
		}
		j = 0;
		J0x214:

		if(Less_IntInt(j, Scenario.EnemyArchetypes.Length))
		{
			if(EqualEqual_NameName(Scenario.EnemyArchetypes[j], data.EnemyArchetype[i].Archetype))
			{
				dlist_archetypes.ListBoxB.List.Add(string(data.EnemyArchetype[i].Archetype),, Archetype.Description);
				// [Explicit Break]
				goto J0x2B7;
			}
			AddAdd_PreInt(j);
			// [Loop Continue]
			goto J0x214;
		}
		J0x2B7:

		if(EqualEqual_IntInt(j, Scenario.EnemyArchetypes.Length))
		{
			dlist_archetypes.ListBoxA.List.Add(string(data.EnemyArchetype[i].Archetype),, Archetype.Description);
		}
		J0x31B:

		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0xF5;
	}
	dlist_archetypes.ListBoxA.setIndex(0);
	dlist_archetypes.ListBoxB.setIndex(0);
	if(NewScenario)
	{
		cbo_skill.setIndex(0);
		cbo_primary_type.setIndex(0);
		cbo_primary_specific.setIndex(0);
		cbo_backup_type.setIndex(0);
		cbo_backup_specific.setIndex(0);
	}
	else
	{
		cbo_skill.List.find(Scenario.EnemySkill, true);
		cbo_primary_type.List.find(Scenario.EnemyPrimaryWeaponType, true);
		cbo_primary_specific.List.find(Scenario.EnemyPrimaryWeaponSpecific, true);
		cbo_backup_type.List.find(Scenario.EnemyBackupWeaponType, true);
		cbo_backup_specific.List.find(Scenario.EnemyBackupWeaponSpecific, true);
	}
	return;
}

function GatherScenarioFromFields()
{
	local CustomScenario Scenario;
	local int i;

	Scenario = CustomScenarioPage.GetCustomScenario();
	Scenario.UseCampaignEnemySettings = chk_campaign.bChecked;
	Scenario.EnemyCountRangeCow.Min = spin_count_min.Value;
	Scenario.EnemyCountRangeCow.Max = spin_count_max.Value;
	Scenario.EnemyMorale.Min = slide_morale_min.Value;
	Scenario.EnemyMorale.Max = slide_morale_max.Value;
	Scenario.EnemyArchetypes.Remove(0, Scenario.EnemyArchetypes.Length);
	i = 0;
	J0xE2:

	if(Less_IntInt(i, dlist_archetypes.ListBoxB.List.Elements.Length))
	{
		Scenario.EnemyArchetypes[Scenario.EnemyArchetypes.Length] = string(dlist_archetypes.ListBoxB.List.GetItemAtIndex(i));
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0xE2;
	}
	Scenario.EnemySkill = cbo_skill.List.Get();
	Scenario.EnemyPrimaryWeaponType = cbo_primary_type.List.Get();
	Scenario.EnemyPrimaryWeaponSpecific = cbo_primary_specific.List.Get();
	GatherWeaponsOfType(Scenario.EnemyPrimaryWeaponType, Scenario.EnemyPrimaryWeaponSpecific, data.PrimaryWeapon, Scenario.EnemyPrimaryWeaponOptions);
	Scenario.EnemyBackupWeaponType = cbo_backup_type.List.Get();
	Scenario.EnemyBackupWeaponSpecific = cbo_backup_specific.List.Get();
	GatherWeaponsOfType(Scenario.EnemyBackupWeaponType, Scenario.EnemyBackupWeaponSpecific, data.BackupWeapon, Scenario.EnemyBackupWeaponOptions);
	return;
}

function GatherWeaponsOfType(string Type, string Specific, array<WeaponPresentation> WeaponOptions, out array<string> WeaponSelections)
{
	local int i;

	WeaponSelections.Remove(0, WeaponSelections.Length);
	if(EqualEqual_StrStr(Type, "None"))
	{
		return;
	}
	else
	{
		if(NotEqual_StrStr(Specific, "Any"))
		{
			WeaponSelections[WeaponSelections.Length] = Specific;
		}
		else
		{
			if(EqualEqual_StrStr(Type, "Any"))
			{
				i = 0;
				J0x5C:

				if(Less_IntInt(i, WeaponOptions.Length))
				{
					WeaponSelections[WeaponSelections.Length] = WeaponOptions[i].Weapon;
					AddAdd_PreInt(i);
					// [Loop Continue]
					goto J0x5C;
				}
			}
			else
			{
				i = 0;
				J0x9D:

				if(Less_IntInt(i, WeaponOptions.Length))
				{
					if(EqualEqual_StrStr(string(WeaponOptions[i].category), Type))
					{
						WeaponSelections[WeaponSelections.Length] = WeaponOptions[i].Weapon;
					}
					AddAdd_PreInt(i);
					// [Loop Continue]
					goto J0x9D;
				}
			}
		}
	}
	return;
}
