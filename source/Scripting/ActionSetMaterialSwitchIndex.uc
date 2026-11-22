class ActionSetMaterialSwitchIndex extends Action
	editinlinenew
	collapsecategories
	hidecategories(Object);

var /*0x00000000-0x00100000*/ MaterialSwitch Material;
var float Index;

latent function Variable execute()
{
	super.execute();
	if(Not_PreBool(Material.Set(int(Index))))
	{
		logError(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("Index ", string(int(Index))), " out-of-bounds (0,"), string(Material.Materials.Length)), ")"));
	}
	return none;
	return;
}

function editorDisplayString(out string S)
{
	local string materialName;

	if(NotEqual_ObjectObject(Material, none))
	{
		materialName = string(Material.Name);
	}
	else
	{
		materialName = "None";
	}
	S = Concat_StrStr(Concat_StrStr(Concat_StrStr("Set the current index of ", materialName), " to "), propertyDisplayString('Index'));
	return;
}

defaultproperties
{
	actionDisplayName="Set MaterialSwitch Index"
	actionHelp="Sets the given MaterialSwitch's index to the given index. Fails if the index is out of bounds"
	category="AudioVisual"
}