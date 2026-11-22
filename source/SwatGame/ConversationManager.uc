class ConversationManager extends Actor
	native
	config(Conversations)
	notplaceable
	hidecategories(Karma);

cpptext
{
    UBOOL Tick(FLOAT DeltaSeconds, enum ELevelTick TickType);

}

var config float DefaultInterLineDelay;
var array<Conversation> ActiveConversations;

function StartConversation(name ConversationName)
{
	local SwatGamePlayerController SGPC;
	local Controller Current;

	Current = Level.ControllerList;
	J0x14:

	if(NotEqual_ObjectObject(Current, none))
	{
		SGPC = SwatGamePlayerController(Current);
		if(NotEqual_ObjectObject(SGPC, none))
		{
			SGPC.ClientStartConversation(ConversationName);
		}
		Current = Current.nextController;
		// [Loop Continue]
		goto J0x14;
	}
	return;
}

simulated function ClientStartConversation(name ConversationName)
{
	local Conversation Conversation;

	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "::ClientStartConversation( "), string(ConversationName)), " )"));
	Conversation = Class'SwatGame.Conversation'.static.Allocate(self, none, string(ConversationName)).;
	Construct_Void();
	assert(NotEqual_ObjectObject(Conversation, none));
	AssertWithDescription(Greater_IntInt(Conversation.Line.Length, 0), Concat_StrStr(Concat_StrStr("[tcohen] The ConversationManager was called to start the conversation named ", string(ConversationName)), ".  But that Conversation doesn't seem to exist (or it is empty) in Conversations.ini.  Please check the name and the config file."));
	Conversation.__OnConversationEnded__Delegate = OnConversationEnded;
	ActiveConversations[ActiveConversations.Length] = Conversation;
	Conversation.Start(self);
	return;
}

simulated function OnConversationEnded(Conversation Ended, bool Completed)
{
	local int i;

	Label = Ended.Name;
	dispatchMessage(Class'SwatGame.MessageConversationEnded'.static.Allocate(self)., construct_Bool(Completed));
	i = 0;
	J0x42:

	if(Less_IntInt(i, ActiveConversations.Length))
	{
		if(EqualEqual_ObjectObject(ActiveConversations[i], Ended))
		{
			ActiveConversations[i].__OnConversationEnded__Delegate = None;
			ActiveConversations[i].CleanupActorRefs();
			ActiveConversations.Remove(i, 1);
			return;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x42;
	}
	assert(false);
	return;
}

simulated event Destroyed()
{
	super.Destroyed();
	J0x06:

	if(Greater_IntInt(ActiveConversations.Length, 0))
	{
		ActiveConversations[0].__OnConversationEnded__Delegate = None;
		ActiveConversations[0].CleanupActorRefs();
		ActiveConversations.Remove(0, 1);
		// [Loop Continue]
		goto J0x06;
	}
	return;
}

defaultproperties
{
	bHidden=true
	bStasis=true
	Label="ConversationManager"
}