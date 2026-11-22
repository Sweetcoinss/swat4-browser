class ActionKillAll extends Action
	editinlinenew
	collapsecategories
	hidecategories(Object);

latent function Variable execute()
{
	local Pawn P;

	super.execute();
	foreach parentScript.DynamicActors(Class'Engine.Pawn', P)
	{
		P.Died(none, Class'Engine.GenericDamageType', vect(0.0000000, 0.0000000, 0.0000000), vect(0.0000000, 0.0000000, 0.0000000));
	}
	return none;
	return;
}

function editorDisplayString(out string S)
{
	S = "Kill all Pawns";
	return;
}

defaultproperties
{
	actionDisplayName="Kill all Pawns"
	actionHelp="Kills all Pawns"
	category="Actor"
}