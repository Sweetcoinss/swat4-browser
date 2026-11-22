class SwatMPLoadoutPanel extends SwatLoadoutPanel
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	SwatGUIController(Controller).SetMPLoadoutPanel(self);
	return;
}

function LoadMultiPlayerLoadout()
{
	SpawnLoadouts();
	DestroyLoadouts();
	return;
}

protected function SpawnLoadouts()
{
	LoadLoadOut("CurrentMultiplayerLoadOut", true);
	return;
}

protected function DestroyLoadouts()
{
	if(NotEqual_ObjectObject(MyCurrentLoadOut, none))
	{
		MyCurrentLoadOut.Destroy();
	}
	MyCurrentLoadOut = none;
	return;
}

function LoadLoadOut(string LoadOutName, optional bool bForceSpawn)
{
	super.LoadLoadOut(LoadOutName, bForceSpawn);
	SwatGUIController(Controller).SetMPLoadOut(MyCurrentLoadOut);
	return;
}

function ChangeLoadOut(HandheldEquipment.Pocket ThePocket)
{
	local Class<Actor> theItem;

	super.ChangeLoadOut(ThePocket);
	SaveLoadOut("CurrentMultiPlayerLoadout");
	switch(ThePocket)
	{
		case 0:
		case 1:
			SwatGUIController(Controller).SetMPLoadOutPocketWeapon(0, MyCurrentLoadOut.LoadOutSpec[int(0)], MyCurrentLoadOut.LoadOutSpec[int(1)]);
			break;
		case 2:
		case 3:
			SwatGUIController(Controller).SetMPLoadOutPocketWeapon(2, MyCurrentLoadOut.LoadOutSpec[int(2)], MyCurrentLoadOut.LoadOutSpec[int(3)]);
			break;
		case 9:
			SwatGUIController(Controller).SetMPLoadOutPocketItem(9, MyCurrentLoadOut.LoadOutSpec[int(9)]);
			SwatGUIController(Controller).SetMPLoadOutPocketItem(16, MyCurrentLoadOut.LoadOutSpec[int(16)]);
			SwatGUIController(Controller).SetMPLoadOutPocketItem(17, MyCurrentLoadOut.LoadOutSpec[int(17)]);
			break;
		default:
			theItem = Class<Actor>(EquipmentList[int(ThePocket)].GetObject());
			SwatGUIController(Controller).SetMPLoadOutPocketItem(ThePocket, theItem);
			break;
			break;
	}
	return;
}

function bool CheckValidity(SwatGUIConfig.eNetworkValidity Type)
{
	return OrOr_BoolBool(EqualEqual_IntInt(int(Type), int(2)), super.CheckValidity(Type));
	return;
}
