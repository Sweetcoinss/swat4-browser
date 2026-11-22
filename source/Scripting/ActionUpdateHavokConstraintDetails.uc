class ActionUpdateHavokConstraintDetails extends Action
	editinlinenew
	collapsecategories
	hidecategories(Object);

var name Target;

latent function Variable execute()
{
	local HavokConstraint A;

	super.execute();
	foreach parentScript.actorLabel(Class'Engine.HavokConstraint', A, Target)
	{
		A.UpdateConstraintDetails();
	}
	return none;
	return;
}

function editorDisplayString(out string S)
{
	S = Concat_StrStr("Update Havok constraint details for HavocConstraints Labeled ", propertyDisplayString('Target'));
	return;
}

defaultproperties
{
	actionDisplayName="Update Havok Constraint Details"
	actionHelp="Updates Havok Constraint Details"
	category="Havok"
}