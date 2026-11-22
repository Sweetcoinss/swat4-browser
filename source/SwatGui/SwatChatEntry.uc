class SwatChatEntry extends GUIEditBox
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object,Menu,Object);

var array<string> ChatEntryHistory;
var int ChatEntryIndex;

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	return;
}

function bool InternalOnKeyEvent(out byte Key, out byte State, float Delta)
{
	if(EqualEqual_IntInt(int(State), int(1)))
	{
		if(KeyMatchesBinding(Key, "ScrollChatUp"))
		{
			ScrollChatEntryUp();
			return true;
		}
		if(KeyMatchesBinding(Key, "ScrollChatDown"))
		{
			ScrollChatEntryDown();
			return true;
		}
	}
	if(super.InternalOnKeyEvent(Key, State, Delta))
	{
		return true;
	}
	if(KeyMatchesBinding(Key, "Fire"))
	{
		return true;
	}
	if(EqualEqual_IntInt(int(State), int(3)))
	{
		return false;
	}
	return true;
	return;
}

function AddEntryToHistory(string newEntry)
{
	ChatEntryHistory[ChatEntryHistory.Length] = newEntry;
	SetChatEntryIndex(ChatEntryHistory.Length);
	return;
}

function ScrollChatEntryUp()
{
	SetChatEntryIndex(Clamp(Subtract_IntInt(ChatEntryIndex, 1), 0, ChatEntryHistory.Length));
	return;
}

function ScrollChatEntryDown()
{
	SetChatEntryIndex(Clamp(Add_IntInt(ChatEntryIndex, 1), 0, ChatEntryHistory.Length));
	return;
}

private function SetChatEntryIndex(int NewIndex)
{
	ChatEntryIndex = NewIndex;
	if(GreaterEqual_IntInt(ChatEntryIndex, ChatEntryHistory.Length))
	{
		SetText("");
	}
	else
	{
		SetText(ChatEntryHistory[ChatEntryIndex]);
	}
	return;
}
