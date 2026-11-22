class ActionDealDamage extends Action
	editinlinenew
	collapsecategories
	hidecategories(Object);

var name Target;
var float DamageAmount;

latent function Variable execute()
{
	local Actor A;

	super.execute();
	foreach parentScript.actorLabel(Class'Engine.Actor', A, Target)
	{
		A.TakeDamage(int(DamageAmount), none, vect(0.0000000, 0.0000000, 0.0000000), vect(0.0000000, 0.0000000, 0.0000000), Class'Engine.GenericDamageType');
	}
	return none;
	return;
}

function editorDisplayString(out string S)
{
	S = Concat_StrStr(Concat_StrStr(Concat_StrStr("Deal ", propertyDisplayString('DamageAmount')), " points of damage to "), propertyDisplayString('Target'));
	return;
}

defaultproperties
{
	actionDisplayName="Deal Damage"
	actionHelp="Deals damage to target actors"
	category="Actor"
}