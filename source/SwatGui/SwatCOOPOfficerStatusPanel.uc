class SwatCOOPOfficerStatusPanel extends SwatGUIPanel
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(SwatGui) private export editinline config GUIMultiColumnListBox MyTeamBox;
var private config localized string IncapacitatedString;
var private config localized string InjuredString;
var private config localized string HealthyString;
var private config localized string NotAvailable;
var private config localized string NotReady;
var private config localized string Ready;
var private bool bSelectThisPlayer;
var private int SelectPlayerCount;

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	return;
}

event Show()
{
	super.Show();
	SetTimer(GC.MPPollingDelay, true);
	return;
}

event Timer()
{
	if(Greater_IntInt(AddAdd_Int(SelectPlayerCount), 10))
	{
		bSelectThisPlayer = true;
	}
	DisplayScores();
	return;
}

function DisplayScores()
{
	local SwatGameReplicationInfo SGRI;
	local SwatPlayerReplicationInfo PlayerInfo;
	local int i, Row, lastSelected;
	local string PlayerName;

	SGRI = SwatGameReplicationInfo(PlayerOwner().GameReplicationInfo);
	if(EqualEqual_ObjectObject(SGRI, none))
	{
		return;
	}
	lastSelected = MyTeamBox.GetIndex();
	MyTeamBox.Clear();
	i = 0;
	J0x52:

	if(Less_IntInt(i, 16))
	{
		PlayerInfo = SGRI.PRIStaticArray[i];
		if(NotEqual_ObjectObject(PlayerInfo, none))
		{
			PlayerName = PlayerInfo.PlayerName;
			MyTeamBox.AddNewRowElement("Ping",,, Min(999, PlayerInfo.Ping));
			MyTeamBox.AddNewRowElement("Teamnames",, PlayerName, PlayerInfo.SwatPlayerID);
			MyTeamBox.AddNewRowElement("Health",, GetStatusString(PlayerInfo.COOPPlayerStatus));
			Row = MyTeamBox.PopulateRow();
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x52;
	}
	if(bSelectThisPlayer)
	{
		if(EqualEqual_IntInt(MyTeamBox.GetColumn("Teamnames").FindExtraIntData(SwatPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo).SwatPlayerID,, true), -1))
		{
			MyTeamBox.MyActiveList.setIndex(-1,, true);
		}
	}
	else
	{
		MyTeamBox.MyActiveList.setIndex(lastSelected,, true);
	}
	if(bSelectThisPlayer)
	{
		bSelectThisPlayer = false;
		SelectPlayerCount = 0;
	}
	return;
}

private function string GetStatusString(SwatPlayerReplicationInfo.COOPStatus Status)
{
	switch(Status)
	{
		case 0:
			if(NotEqual_IntInt(int(GC.SwatGameState), int(4)))
			{
				return NotReady;
			}
			else
			{
				return NotAvailable;
			}
		case 1:
			if(NotEqual_IntInt(int(GC.SwatGameState), int(4)))
			{
				return Ready;
			}
			else
			{
				return NotAvailable;
			}
		case 2:
			return HealthyString;
		case 3:
			return InjuredString;
		case 4:
			return IncapacitatedString;
		default:
			return "";
			break;
	}
	return;
}

defaultproperties
{
	IncapacitatedString="[c=ff0000][b]Incapacitated"
	InjuredString="[c=ff0000]Injured"
	HealthyString="Healthy"
	NotAvailable="[c=ff00ff][b]Not Available"
	NotReady="[c=FF0000]Not Ready"
	Ready="[c=00FF00]Ready"
}