class ActionTriggerMaterials extends Action
	editinlinenew
	collapsecategories
	hidecategories(Object);

var /*0x00000000-0x00100000*/ array<Material> Materials;

latent function Variable execute()
{
	local int i;

	super.execute();
	i = 0;
	J0x0D:

	if(Less_IntInt(i, Materials.Length))
	{
		Materials[i].Trigger(none, none);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x0D;
	}
	return none;
	return;
}

function editorDisplayString(out string S)
{
	local int i;

	S = "Trigger material";
	if(Less_IntInt(Materials.Length, 1))
	{
		S = Concat_StrStr(S, " None");
		return;
	}
	if(Greater_IntInt(Materials.Length, 1))
	{
		S = Concat_StrStr(S, "s");
	}
	i = 0;
	J0x5D:

	if(Less_IntInt(i, Subtract_IntInt(Materials.Length, 1)))
	{
		S = Concat_StrStr(At_StrStr(S, string(Materials[i])), ",");
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x5D;
	}
	S = At_StrStr(S, string(Materials[Subtract_IntInt(Materials.Length, 1)]));
	return;
}

defaultproperties
{
	actionDisplayName="Trigger Materials"
	actionHelp="Triggers a set of materials."
	category="AudioVisual"
}