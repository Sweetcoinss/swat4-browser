class ActionKill extends Action
	editinlinenew
	collapsecategories
	hidecategories(Object);

var name Target;

latent function Variable execute()
{
	local Pawn P;

	super.execute();
	foreach parentScript.actorLabel(Class'Engine.Pawn', P, Target)
	{
		P.Died(none, Class'Engine.GenericDamageType', vect(0.0000000, 0.0000000, 0.0000000), vect(0.0000000, 0.0000000, 0.0000000));
	}
	return none;
	return;
}

function editorDisplayString(out string S)
{
	S = Concat_StrStr("Kill Pawn ", propertyDisplayString('Target'));
	return;
}

defaultproperties
{
	actionDisplayName="Kill Pawn"
	actionHelp="Kills the target Pawn"
	category="Actor"
}