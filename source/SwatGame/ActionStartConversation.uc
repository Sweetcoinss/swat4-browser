class ActionStartConversation extends Action
	editinlinenew
	collapsecategories
	hidecategories(Object);

var name Conversation;

latent function Variable execute()
{
	SwatRepo(parentScript.Level.GetRepo()).GetConversationManager().StartConversation(Conversation);
	return none;
	return;
}

function editorDisplayString(out string S)
{
	S = Concat_StrStr("Start the Conversation named ", string(Conversation));
	return;
}

defaultproperties
{
	actionDisplayName="Start a Conversation"
	actionHelp="Starts a Conversation"
	category="Script"
}