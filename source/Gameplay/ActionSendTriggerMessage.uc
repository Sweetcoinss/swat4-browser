class ActionSendTriggerMessage extends Action
	editinlinenew
	collapsecategories
	hidecategories(Object);

var name Instigator;

overloaded function Construct()
{
	super.Construct_Void();
	Instigator = parentScript.Label;
	return;
}

latent function Variable execute()
{
	parentScript.dispatchMessage(Class'Gameplay.MessageTrigger'.static.Allocate(self)., construct_NameName(parentScript.Label, Instigator));
	return none;
	return;
}

defaultproperties
{
	actionDisplayName="Send Trigger Message"
	actionHelp="Sends a MessageTrigger that can be used to open doors, move movers, etc."
	category="Script"
}