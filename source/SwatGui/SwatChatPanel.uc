class SwatChatPanel extends SwatGUIPanel
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

struct ChatLine
{
	var() string msg;
	var() bool bIsChat;
};

var(SwatGui) export editinline config SwatChatEntry MyChatEntry;
var(SwatGui) export editinline config GUIListBox MyChatHistory;
var private bool bGlobal;
var(StaticConfig) config int MaxChatLines "Maximum number of lines used for chat";
var(StaticConfig) config int MSGTimeout "Time (in seconds) for messages to remain before being pulled (0 = never pull)";
var(StaticConfig) config bool bDisplayDeaths "if true, will display death messages";
var(StaticConfig) config bool bDisplayConnects "if true, will display connect/disconnect messages";
var private config localized string TeamChatMessage;
var private config localized string GlobalChatMessage;
var private config localized string NameChangeMessage;
var private config localized string KickMessage;
var private config localized string BanMessage;
var private config localized string SwitchTeamsMessage;
var private config localized string SwatSuicideMessage;
var private config localized string SuspectsSuicideMessage;
var private config localized string SwatTeamKillMessage;
var private config localized string SuspectsTeamKillMessage;
var private config localized string SwatKillMessage;
var private config localized string SuspectsKillMessage;
var private config localized string SwatArrestMessage;
var private config localized string SuspectsArrestMessage;
var private config localized string ConnectedMessage;
var private config localized string DisconnectedMessage;
var private config localized string EquipNotAvailableString;
var private config localized string SniperAlertedString;
var private config localized string NewObjectiveString;
var private config localized string MissionCompletedString;
var private config localized string MissionFailedString;
var private config localized string SettingsUpdatedString;
var private config localized string DebugMessageString;
var private config localized string PromptToDebriefMessage;
var private config localized string SomeoneString;
var private config localized string SlotNames[15];
var array<ChatLine> FullChatHistory;
var int ChatIndex;

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	SwatGUIController(Controller).SetChatPanel(self);
	MyChatEntry.__OnEntryCompleted__Delegate = InternalOnEntryCompleted;
	MyChatEntry.__OnEntryCancelled__Delegate = InternalOnEntryCancelled;
	SetFocusInstead(MyChatEntry);
	MyChatEntry.bCaptureMouse = false;
	MyChatHistory.bCaptureMouse = false;
	return;
}

event Show()
{
	MyChatHistory.Show();
	super.Show();
	if(Greater_IntInt(MSGTimeout, 0))
	{
		SetTimer(float(MSGTimeout), true);
	}
	if(EqualEqual_StrStr(SwatGUIController(Controller).EnteredChatText, ""))
	{
		CloseChatEntry();
	}
	else
	{
		OpenChatEntry(SwatGUIController(Controller).EnteredChatGlobal);
	}
	return;
}

event Hide()
{
	super(GUIMultiComponent).Hide();
	SwatGUIController(Controller).EnteredChatGlobal = bGlobal;
	SwatGUIController(Controller).EnteredChatText = MyChatEntry.GetText();
	return;
}

function MessageRecieved(string MsgText, name Type, optional bool bDisplaySpecial)
{
	local string StrA, StrB, StrC, Keys, DisplayPromptString;

	local bool MsgIsChat, DisplayPromptToDebriefMessage;

	StrA = GetFirstField(MsgText, "	");
	StrB = GetFirstField(MsgText, "	");
	StrC = GetFirstField(MsgText, "	");
	switch(Type)
	{
		case 'EquipNotAvailable':
			MsgText = FormatTextString(EquipNotAvailableString, SlotNames[int(StrA)]);
			break;
		case 'Caption':
			MsgText = StrA;
			break;
		case 'SniperAlerted':
			Keys = PlayerOwner().ConsoleCommand("GETLOCALIZEDKEYFORBINDING ShowViewport Sniper");
			MsgText = FormatTextString(SniperAlertedString, GetFirstField(Keys, ", "));
			break;
		case 'ObjectiveShown':
			MsgText = NewObjectiveString;
			break;
		case 'MissionCompleted':
			MsgText = MissionCompletedString;
			break;
		case 'MissionFailed':
			MsgText = MissionFailedString;
			break;
		case 'SettingsUpdated':
			MsgText = FormatTextString(SettingsUpdatedString, StrA);
			break;
		case 'TeamSay':
			MsgText = FormatTextString(TeamChatMessage, StrA, StrB);
			MsgIsChat = true;
			break;
		case 'Say':
			MsgText = FormatTextString(GlobalChatMessage, StrA, StrB);
			MsgIsChat = true;
			break;
		case 'SwitchTeams':
			MsgText = FormatTextString(SwitchTeamsMessage, StrA);
			break;
		case 'NameChange':
			MsgText = FormatTextString(NameChangeMessage, StrA, StrB);
			break;
		case 'Kick':
			MsgText = FormatTextString(KickMessage, StrA, StrB);
			break;
		case 'KickBan':
			MsgText = FormatTextString(BanMessage, StrA, StrB);
			break;
		case 'SwatSuicide':
			MsgText = FormatTextString(SwatSuicideMessage, StrA);
			break;
		case 'SuspectsSuicide':
			MsgText = FormatTextString(SuspectsSuicideMessage, StrA);
			break;
		case 'SwatTeamKill':
			if(EqualEqual_StrStr(StrB, ""))
			{
				StrB = SomeoneString;
			}
			MsgText = FormatTextString(SwatTeamKillMessage, StrA, StrB, StrC);
			break;
		case 'SuspectsTeamKill':
			if(EqualEqual_StrStr(StrB, ""))
			{
				StrB = SomeoneString;
			}
			MsgText = FormatTextString(SuspectsTeamKillMessage, StrA, StrB, StrC);
			break;
		case 'SwatKill':
			if(EqualEqual_StrStr(StrB, ""))
			{
				StrB = SomeoneString;
			}
			MsgText = FormatTextString(SwatKillMessage, StrA, StrB, StrC);
			break;
		case 'SuspectsKill':
			if(EqualEqual_StrStr(StrB, ""))
			{
				StrB = SomeoneString;
			}
			MsgText = FormatTextString(SuspectsKillMessage, StrA, StrB, StrC);
			break;
		case 'SwatArrest':
			if(EqualEqual_StrStr(StrB, ""))
			{
				StrB = SomeoneString;
			}
			MsgText = FormatTextString(SwatArrestMessage, StrA, StrB);
			break;
		case 'SuspectsArrest':
			if(EqualEqual_StrStr(StrB, ""))
			{
				StrB = SomeoneString;
			}
			MsgText = FormatTextString(SuspectsArrestMessage, StrA, StrB);
			break;
		case 'PlayerConnect':
			if(Not_PreBool(bDisplayConnects))
			{
				return;
			}
			MsgText = FormatTextString(ConnectedMessage, StrA);
			break;
		case 'PlayerDisconnect':
			if(Not_PreBool(bDisplayConnects))
			{
				return;
			}
			MsgText = FormatTextString(DisconnectedMessage, StrA);
			break;
		case 'CommandGiven':
			MsgText = StrA;
			break;
		case 'DebugMessage':
			if(PlayerOwner().Level.GetEngine().EnableDevTools)
			{
				Show();
				MsgText = FormatTextString(DebugMessageString, StrA);
			}
			break;
		default:
			break;
	}
	AddChat(MsgText, MsgIsChat);
	if(bDisplaySpecial)
	{
		if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(EqualEqual_IntInt(int(GC.SwatGameRole), int(1)), OrOr_BoolBool(EqualEqual_NameName(Type, 'MissionCompleted'), EqualEqual_NameName(Type, 'MissionFailed'))), NotEqual_ObjectObject(GC.CurrentMission, none)), OrOr_BoolBool(OrOr_BoolBool(EqualEqual_StrStr(GC.CurrentMission.MapName, "SP-FoodWall"), EqualEqual_StrStr(GC.CurrentMission.MapName, "SP-FairfaxResidence")), EqualEqual_StrStr(GC.CurrentMission.MapName, "SP-ConvenienceStore"))))
		{
			DisplayPromptToDebriefMessage = true;
			DisplayPromptString = ReplaceKeybindingCodes(PromptToDebriefMessage, "[k=", "]");
			AddChat(DisplayPromptString, false);
		}
		MyChatHistory.Clear();
		MyChatHistory.List.Add(MsgText);
		if(DisplayPromptToDebriefMessage)
		{
			MyChatHistory.List.Add(DisplayPromptString);
		}
		KillTimer();
	}
	return;
}

event Timer()
{
	MoveChatUp();
	return;
}

private function AddChat(string NewText, optional bool newIsChat)
{
	local array<string> WrappedLines;
	local int i;
	local string InitialColor;

	if(AndAnd_BoolBool(Greater_IntInt(Len(NewText), 6), EqualEqual_StrStr(Caps(Left(NewText, 3)), "[C=")))
	{
		InitialColor = Left(NewText, 10);
		NewText = Mid(NewText, 10);
	}
	MyChatHistory.WrapStringToArray(NewText, WrappedLines);
	i = 0;
	J0x63:

	if(Less_IntInt(i, WrappedLines.Length))
	{
		AddChatLine(Concat_StrStr(InitialColor, WrappedLines[i]), newIsChat);
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x63;
	}
	ScrollChatToEnd();
	return;
}

private function AddChatLine(string NewText, optional bool newIsChat)
{
	local ChatLine NewLine;

	NewLine.msg = NewText;
	NewLine.bIsChat = newIsChat;
	FullChatHistory[FullChatHistory.Length] = NewLine;
	return;
}

private function MoveChatUp()
{
	MyChatHistory.List.Add("",, "");
	if(UpdateChatAlpha())
	{
		if(Greater_IntInt(MSGTimeout, 0))
		{
			SetTimer(float(MSGTimeout), true);
		}
	}
	else
	{
		KillTimer();
	}
	return;
}

private function bool UpdateChatAlpha()
{
	local int i;
	local bool bAnyVisible;
	local string CurrentMsg;
	local Color CurrentColor;

	i = 0;
	J0x07:

	if(Less_IntInt(i, MaxChatLines))
	{
		CurrentMsg = MyChatHistory.List.GetExtraAtIndex(i);
		if(EqualEqual_StrStr(CurrentMsg, ""))
		{
			// [Explicit Continue]
			goto J0xA8;
		}
		bAnyVisible = true;
		CurrentColor.A = byte(int(Divide_FloatFloat(Multiply_FloatFloat(255.0000000, float(Add_IntInt(i, 1))), float(MaxChatLines))));
		MyChatHistory.List.SetItemAtIndex(i, Concat_StrStr(MakeColorCode(CurrentColor), CurrentMsg));
		J0xA8:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return bAnyVisible;
	return;
}

private function SetChatIndex(int NewIndex)
{
	local bool bAnyVisible;
	local int i;

	ChatIndex = NewIndex;
	MyChatHistory.Clear();
	i = ChatIndex;
	J0x25:

	if(AndAnd_BoolBool(GreaterEqual_IntInt(i, 0), Greater_IntInt(i, Subtract_IntInt(ChatIndex, MaxChatLines))))
	{
		MyChatHistory.List.Insert(0, "",, FullChatHistory[i].msg);
		SubtractSubtract_Int(i);
		// [Loop Continue]
		goto J0x25;
	}
	i = MyChatHistory.Num();
	J0x93:

	if(Less_IntInt(i, MaxChatLines))
	{
		MyChatHistory.List.Insert(0, "",, "");
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x93;
	}
	bAnyVisible = UpdateChatAlpha();
	if(AndAnd_BoolBool(AndAnd_BoolBool(bAnyVisible, Greater_IntInt(MSGTimeout, 0)), EqualEqual_IntInt(ChatIndex, Subtract_IntInt(FullChatHistory.Length, 1))))
	{
		SetTimer(float(MSGTimeout), true);
	}
	else
	{
		KillTimer();
	}
	return;
}

function ScrollChatPageUp()
{
	AdjustChatIndex(Multiply_IntInt(-1, MaxChatLines));
	return;
}

function ScrollChatPageDown()
{
	AdjustChatIndex(MaxChatLines);
	return;
}

function ScrollChatUp()
{
	AdjustChatIndex(-1);
	return;
}

function ScrollChatDown()
{
	AdjustChatIndex(1);
	return;
}

function ScrollChatToHome()
{
	SetChatIndex(0);
	return;
}

function ScrollChatToEnd()
{
	SetChatIndex(Subtract_IntInt(FullChatHistory.Length, 1));
	return;
}

private function AdjustChatIndex(int Offset)
{
	SetChatIndex(Clamp(Add_IntInt(ChatIndex, Offset), 0, Subtract_IntInt(FullChatHistory.Length, 1)));
	return;
}

function InternalOnEntryCompleted(GUIComponent Sender)
{
	local string ChatText;

	ChatText = MyChatEntry.GetText();
	CloseChatEntry();
	if(NotEqual_StrStr(ChatText, ""))
	{
		SwatGUIController(Controller).AddChatMessage(ChatText, bGlobal);
	}
	return;
}

function InternalOnEntryCancelled(GUIComponent Sender)
{
	CloseChatEntry();
	return;
}

function OpenChatEntry(bool bSendGlobal)
{
	KillTimer();
	MyChatHistory.Show();
	bGlobal = bSendGlobal;
	if(Controller.TopPage().bIsHUD)
	{
		Controller.SetCaptureScriptExec(true);
		Controller.TopPage().Activate();
	}
	Focus();
	MyChatEntry.bDontReleaseMouse = true;
	MyChatEntry.bReadOnly = false;
	MyChatEntry.Show();
	MyChatEntry.Activate();
	MyChatEntry.Focus();
	MyChatEntry.SetText(SwatGUIController(Controller).EnteredChatText);
	MyChatEntry.CaretPos = Len(MyChatEntry.GetText());
	Controller.bSwallowNextKeyType = true;
	return;
}

function CloseChatEntry()
{
	MyChatEntry.AddEntryToHistory(MyChatEntry.GetText());
	MyChatEntry.bDontReleaseMouse = false;
	if(Greater_IntInt(MSGTimeout, 0))
	{
		SetTimer(float(MSGTimeout), true);
	}
	MyChatEntry.bReadOnly = true;
	MyChatEntry.DisableComponent();
	MyChatEntry.DeActivate();
	MyChatEntry.Hide();
	if(Controller.TopPage().bIsHUD)
	{
		Controller.TopPage().DeActivate();
		Controller.SetCaptureScriptExec(false);
	}
	else
	{
		Controller.TopPage().Focus();
	}
	SwatGUIController(Controller).EnteredChatText = "";
	return;
}

function RemoveNonChatMessagesFromHistory()
{
	local int i;

	i = Subtract_IntInt(FullChatHistory.Length, 1);
	J0x0F:

	if(GreaterEqual_IntInt(i, 0))
	{
		if(Not_PreBool(FullChatHistory[i].bIsChat))
		{
			FullChatHistory.Remove(i, 1);
		}
		SubtractSubtract_Int(i);
		// [Loop Continue]
		goto J0x0F;
	}
	ScrollChatToEnd();
	return;
}

function ClearChatHistory()
{
	FullChatHistory.Remove(0, FullChatHistory.Length);
	return;
}

defaultproperties
{
	MSGTimeout=15
	bDisplayDeaths=true
	bDisplayConnects=true
	TeamChatMessage="[c=808080][b]%1[\\b]: %2"
	GlobalChatMessage="[c=00ff00][b]%1[\\b]: %2"
	NameChangeMessage="[c=ff00ff][b]%1[\\b] changed name to [b]%2[\\b]."
	KickMessage="[c=ff00ff][b]%1[\\b] kicked [b]%2[\\b]."
	BanMessage="[c=ff00ff][b]%1[\\b] BANNED [b]%2[\\b]!"
	SwitchTeamsMessage="[c=00ffff][b]%1[\\b] switched teams."
	SwatSuicideMessage="[c=0000ff][b]%1[\\b] suicided!"
	SuspectsSuicideMessage="[c=ff0000][b]%1[\\b] suicided!"
	SwatTeamKillMessage="[c=0000ff][b]%1[\\b] betrayed [b]%2[\\b] with a %3!"
	SuspectsTeamKillMessage="[c=ff0000][b]%1[\\b] double crossed [b]%2[\\b] with a %3!"
	SwatKillMessage="[c=0000ff][b]%1[\\b] neutralized [b]%2[\\b] with a %3!"
	SuspectsKillMessage="[c=ff0000][b]%1[\\b] killed [b]%2[\\b] with a %3!"
	SwatArrestMessage="[c=0000ff][b]%1[\\b] arrested [b]%2[\\b]!"
	SuspectsArrestMessage="[c=ff0000][b]%1[\\b] arrested [b]%2[\\b]!"
	ConnectedMessage="[c=ffff00][b]%1[\\b] connected to the server."
	DisconnectedMessage="[c=ffff00][b]%1[\\b] dropped from the server."
	EquipNotAvailableString="[c=ffffff]No %1 available to equip."
	SniperAlertedString="[c=ffffff]Press %1 to activate the sniper view."
	NewObjectiveString="[c=ffffff]You have received a new objective."
	MissionCompletedString="[c=ffffff]You have [c=00ff00]COMPLETED[c=ffffff] the mission!"
	MissionFailedString="[c=ffffff]You have [c=ff0000]FAILED[c=ffffff] the mission!"
	SettingsUpdatedString="[c=ffff00][b]%1[\\b] updated the server settings."
	DebugMessageString="[c=ffffff]DEBUG_MSG: %1"
	PromptToDebriefMessage="[c=ffffff]Press '[k=GUICloseMenu]' to proceed to Debrief."
	SomeoneString="someone"
	SlotNames[0]="Invalid"
	SlotNames[1]="Primary Weapon"
	SlotNames[2]="Backup Weapon"
	SlotNames[3]="Flashbang Grenade"
	SlotNames[4]="CS Gas Grenade"
	SlotNames[5]="Sting Grenade"
	SlotNames[6]="Pepper Spray"
	SlotNames[7]="breaching device"
	SlotNames[8]="Toolkit"
	SlotNames[9]="Optiwand"
	SlotNames[10]="Wedge"
	SlotNames[11]="ZipCuff"
	PropagateVisibility=false
	PropagateActivity=false
}