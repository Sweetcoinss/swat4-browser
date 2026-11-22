class ActionDestroyActor extends Action
	editinlinenew
	collapsecategories
	hidecategories(Object);

var name Target;

latent function Variable execute()
{
	local Actor A;
	local Pawn Pawn;

	super.execute();
	foreach parentScript.actorLabel(Class'Engine.Actor', A, Target)
	{
		Pawn = Pawn(A);
		if(NotEqual_ObjectObject(Pawn, none))
		{
			A.Level.Game.NotifyKilled(Pawn.Controller, Pawn.Controller, Pawn);
		}
		A.Destroy();
	}
	return none;
	return;
}

function editorDisplayString(out string S)
{
	S = Concat_StrStr("Destroy Actor ", propertyDisplayString('Target'));
	return;
}

defaultproperties
{
	actionDisplayName="Destroy Actor"
	actionHelp="Removes the target Actor from the game"
	category="Actor"
}