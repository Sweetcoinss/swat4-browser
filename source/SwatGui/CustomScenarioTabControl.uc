class CustomScenarioTabControl extends GUITabControl
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

enum ETabPanels
{
	Tab_Selection,                  // 0
	Tab_Mission,                    // 1
	Tab_Squad,                      // 2
	Tab_Hostages,                   // 3
	Tab_Enemies,                    // 4
	Tab_Notes,                      // 5
	Tab_Save                        // 6
};

function OpenTabByIndex(int Index)
{
	InternalOpenTabPair(MyTabs[Index]);
	return;
}

function InternalOpenTabPair(sTabButtonPair theTab)
{
	local int i;

	if(AndAnd_BoolBool(theTab == MyTabs[int(0)], CustomScenarioPage(MenuOwner).CustomScenarioCreatorData.IsCurrentMisisonDirty()))
	{
		CustomScenarioPage(MenuOwner).ConfirmQuitOrSave("Selection");
		return;
	}
	super.InternalOpenTabPair(theTab);
	if(theTab == MyTabs[int(0)])
	{
		i = 0;
		J0x83:

		if(Less_IntInt(i, int(7)))
		{
			if(EqualEqual_IntInt(i, int(0)))
			{
				// [Explicit Continue]
				goto J0xBC;
			}
			MyTabs[i].TabHeader.DisableComponent();
			J0xBC:

			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x83;
		}
	}
	else
	{
		if(theTab == MyTabs[int(6)])
		{
			MyTabs[int(0)].TabHeader.DisableComponent();
		}
		else
		{
			i = 0;
			J0x103:

			if(Less_IntInt(i, int(7)))
			{
				if(MyTabs[i] != theTab)
				{
					MyTabs[i].TabHeader.EnableComponent();
				}
				AddAdd_Int(i);
				// [Loop Continue]
				goto J0x103;
			}
		}
	}
	return;
}
