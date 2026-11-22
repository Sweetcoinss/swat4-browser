class SwatPopupMenuBase extends SwatGUIPage
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(DEBUG) bool bPopup;

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	return;
}

event HandleParameters(string Param1, string Param2, optional int param3)
{
	super(GUIPage).HandleParameters(Param1, Param2, param3);
	bPopup = EqualEqual_StrStr(Param1, "Popup");
	return;
}

function PerformClose()
{
	ResumeGame();
	return;
}

protected function OpenGameSettings()
{
	Controller.OpenMenu("SwatGui.SwatGameSettingsMenu", "SwatGameSettingsMenu");
	return;
}

protected function AbortGame()
{
	return;
}

protected function ResumeGame()
{
	return;
}

protected function bool HandleKeyEvent(out byte Key, out byte State, float Delta)
{
	if(AndAnd_BoolBool(AndAnd_BoolBool(bPopup, EqualEqual_IntInt(int(State), int(3))), KeyMatchesBinding(Key, "ShowInGamePopup")))
	{
		PerformClose();
		return true;
	}
	if(EqualEqual_IntInt(int(State), int(3)))
	{
		return false;
	}
	if(OrOr_BoolBool(EqualEqual_IntInt(int(Key), int(228)), EqualEqual_IntInt(int(Key), int(229))))
	{
		return true;
	}
	if(super.HandleKeyEvent(Key, State, Delta))
	{
		return true;
	}
	return true;
	return;
}

defaultproperties
{
	bSwallowAllKeyEvents=false
}