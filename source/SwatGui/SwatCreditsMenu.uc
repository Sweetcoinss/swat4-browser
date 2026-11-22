class SwatCreditsMenu extends SwatGUIPage
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(SwatGui) private export editinline config GUIButton MyEscapeButton;
var(SwatGui) editconst editinline array<export editinline GUILabel> Credits;
var(Credits) private config float ScrollDelay;
var(Credits) private config float InitialDelay;
var(Credits) private config float RepeatDelay;
var(Credits) private config sDynamicPositionSpec InitialPlacement;
var(Credits) private config sDynamicPositionSpec FinalPlacement;
var(Credits) private int NextToStartScrolling;
var(Credits) private bool bTriggeredCreditsMusic;

function InitComponent(GUIComponent MyOwner)
{
	local int i;
	local Swat4Credits CreditObj;

	super.InitComponent(MyOwner);
	MyEscapeButton.__OnClick__Delegate = InternalOnClick;
	CreditObj = Class'SwatGui.Swat4Credits'.static.Allocate(self).;
	Construct_Void();
	AssertWithDescription(EqualEqual_IntInt(CreditObj.CreditLines.Length, CreditObj.CreditLineStyles.Length), "The number of lines of credits specified in SwatCredits.ini does not match the number of styles!");
	i = 0;
	J0xCF:

	if(Less_IntInt(i, CreditObj.CreditLines.Length))
	{
		Credits[i] = GUILabel(AddComponent("GUI.GUILabel", Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self.Name), "_"), string(i)), "_Label"), true));
		assert(NotEqual_ObjectObject(Credits[i], none));
		Credits[i].SetCaption(CreditObj.CreditLines[i]);
		Credits[i].StyleName = CreditObj.CreditLineStyles[i];
		Credits[i].Style = Controller.GetStyle(CreditObj.CreditLineStyles[i]);
		Credits[i].MovePositions[0] = FinalPlacement;
		Credits[i].MovePositions[1] = InitialPlacement;
		Credits[i].RePosition(InitialPlacement.KeyName, true);
		Credits[i].__OnRePositionCompleted__Delegate = InternalOnRePositionCompleted;
		Credits[i].TextAlign = 1;
		Credits[i].bAllowHTMLTextFormatting = true;
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0xCF;
	}
	return;
}

private function InternalOnShow()
{
	if(Less_IntInt(Credits.Length, 1))
	{
		return;
	}
	NextToStartScrolling = 0;
	bTriggeredCreditsMusic = false;
	SetTimer(InitialDelay);
	return;
}

private function InternalOnHide()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Credits.Length))
	{
		Credits[i].RePosition(InitialPlacement.KeyName, true);
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

event Timer()
{
	if(AndAnd_BoolBool(AndAnd_BoolBool(Not_PreBool(bTriggeredCreditsMusic), Not_PreBool(bNeverTriggerEffectEvents)), NotEqual_ObjectObject(Style, none)))
	{
		bTriggeredCreditsMusic = true;
		PlayerOwner().TriggerEffectEvent('UIMenuLoop',,,,,,,, Style.EffectCategory);
	}
	ScrollNext();
	return;
}

private function ScrollNext()
{
	if(GreaterEqual_IntInt(NextToStartScrolling, Credits.Length))
	{
		ScrollingCompleted();
		return;
	}
	Credits[NextToStartScrolling].RePosition(FinalPlacement.KeyName);
	AddAdd_Int(NextToStartScrolling);
	SetTimer(ScrollDelay);
	return;
}

private function InternalOnRePositionCompleted(GUIComponent Sender, name NewPosLabel)
{
	if(EqualEqual_NameName(NewPosLabel, FinalPlacement.KeyName))
	{
		Sender.RePosition(InitialPlacement.KeyName, true);
	}
	return;
}

private function ScrollingCompleted()
{
	NextToStartScrolling = 0;
	SetTimer(RepeatDelay);
	return;
}

private function InternalOnClick(GUIComponent Sender)
{
	Close();
	return;
}

private function Close()
{
	Controller.CloseMenu();
	Free(true);
	return;
}

event Free(optional bool bForce)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Credits.Length))
	{
		Credits[i] = none;
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	Credits.Remove(0, Credits.Length);
	MyEscapeButton = none;
	super.Free(bForce);
	return;
}

defaultproperties
{
	ScrollDelay=1.0000000
	InitialDelay=1.0000000
	RepeatDelay=1.0000000
	StyleName="STY_CreditsMenu"
	OnHide=SwatCreditsMenu.InternalOnHide
	OnShow=SwatCreditsMenu.InternalOnShow
}