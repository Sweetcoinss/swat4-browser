class SwatCustomScenarioPageBase extends SwatGUIPage
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var CustomScenarioCreatorData CustomScenarioCreatorData;
var private CustomScenarioPack CustomScenarioPack;
var array<string> ScenarioPacks;

function InitComponent(GUIComponent MyOwner)
{
	CustomScenarioCreatorData = Class'SwatGame.CustomScenarioCreatorData'.static.Allocate(self).;
	Construct_Void();
	assert(NotEqual_ObjectObject(CustomScenarioCreatorData, none));
	CustomScenarioCreatorData.Init(SwatGUIController(Controller).GuiConfig);
	CustomScenarioPack = Class'SwatGame.CustomScenarioPack'.static.Allocate(self).;
	Construct_Void();
	assert(NotEqual_ObjectObject(CustomScenarioPack, none));
	super.InitComponent(MyOwner);
	return;
}

function SetCustomScenarioPack(string Pack)
{
	CustomScenarioPack.Reset(PackPlusExtension(Pack), CustomScenarioCreatorData.ScenariosPath);
	return;
}

function CustomScenarioPack GetPack()
{
	return CustomScenarioPack;
	return;
}

function RefreshCustomScenarioPackList()
{
	local string PackFilename;

	ScenarioPacks.Remove(0, ScenarioPacks.Length);
	foreach FileMatchingPattern(Concat_StrStr("*.", CustomScenarioCreatorData.PackExtension), PackFilename)
	{
		ScenarioPacks[ScenarioPacks.Length] = PackMinusExtension(PackFilename);
	}
	return;
}

function string NextCustomScenarioPack(out int PackIterator)
{
	local int Index;

	assert(Less_IntInt(PackIterator, ScenarioPacks.Length));
	Index = Add_IntInt(PackIterator, 1);
	if(Less_IntInt(Index, ScenarioPacks.Length))
	{
		AddAdd_Int(PackIterator);
		return ScenarioPacks[Index];
	}
	else
	{
		PackIterator = -1;
		return "";
	}
	return;
}

function string PackPlusExtension(string PackName)
{
	local string extension;

	extension = Concat_StrStr(".", CustomScenarioCreatorData.PackExtension);
	if(EqualEqual_StrStr(Right(PackName, Len(extension)), extension))
	{
		return PackName;
	}
	else
	{
		return Concat_StrStr(PackName, extension);
	}
	return;
}

function string PackMinusExtension(string PackName)
{
	local string extension;

	extension = Concat_StrStr(".", CustomScenarioCreatorData.PackExtension);
	if(NotEqual_StrStr(Right(PackName, Len(extension)), extension))
	{
		return PackName;
	}
	else
	{
		return Left(PackName, Subtract_IntInt(Len(PackName), Len(extension)));
	}
	return;
}
