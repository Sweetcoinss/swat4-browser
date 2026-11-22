class ActionTrigger extends Action
	editinlinenew
	collapsecategories
	hidecategories(Object);

var name Target;

latent function Variable execute()
{
	local ReactiveWorldObject A;

	super.execute();
	foreach parentScript.actorLabel(Class'RWOSupport.ReactiveWorldObject', A, Target)
	{
		A.BroadcastTrigger(none, none);
	}
	return none;
	return;
}

function editorDisplayString(out string S)
{
	S = "Trigger a Reactive World Object";
	return;
}

defaultproperties
{
	actionDisplayName="Trigger a ReactiveWorldObject"
	actionHelp="Triggers a Reactive WorldObject"
	category="Script"
}