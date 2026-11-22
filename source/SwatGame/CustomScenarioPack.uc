class CustomScenarioPack extends Object
	config(_DynamicallyDetermined_)
	perobjectconfig;

var config localized array<localized string> ScenarioStrings;

function Reset(string PackName, string Path)
{
	ScenarioStrings.Remove(0, ScenarioStrings.Length);
	ResetConfig("Pack_Catalog", Concat_StrStr(Path, PackName));
	return;
}

function LoadCustomScenarioInPlace(CustomScenario Scenario, string ScenarioString, string PackName, string Path)
{
	local string Section;
	local int Index;

	Reset(PackName, Path);
	Index = GetScenarioIndex(ScenarioString);
	if(GreaterEqual_IntInt(Index, ScenarioStrings.Length))
	{
		AssertWithDescription(false, Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] CustomScenarioPack::LoadCustomScenarioInPlace() The Scenario named ", ScenarioString), " was not found in the Pack with PackName = "), PackName), " at Path = "), Path), "."));
		return;
	}
	ScenarioStrings[Index] = ScenarioString;
	Section = Concat_StrStr("Scenario_", ComputeMD5Checksum(ScenarioString));
	Scenario.ResetConfig(Section, Concat_StrStr(Path, PackName));
	Scenario.ScenarioName = ScenarioString;
	Scenario.PackName = PackName;
	return;
}

function SaveCustomScenario(CustomScenario Scenario, string ScenarioString, string PackName, string Path)
{
	local string Section;
	local int Index;

	Reset(PackName, Path);
	Index = GetScenarioIndex(ScenarioString);
	ScenarioStrings[Index] = ScenarioString;
	SaveConfig("Pack_Catalog", Concat_StrStr(Path, PackName));
	Section = Concat_StrStr("Scenario_", ComputeMD5Checksum(ScenarioString));
	Scenario.SaveConfig(Section, Concat_StrStr(Path, PackName));
	return;
}

function DeleteCustomScenario(string ScenarioString, string PackName, string Path)
{
	local int Index;

	Reset(PackName, Path);
	Index = GetScenarioIndex(ScenarioString);
	if(GreaterEqual_IntInt(Index, ScenarioStrings.Length))
	{
		AssertWithDescription(false, Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] CustomScenarioPack::DeleteCustomScenario() The Scenario named ", ScenarioString), " was not found in the Pack at "), Path), PackName), "."));
		return;
	}
	ScenarioStrings.Remove(Index, 1);
	SaveConfig("Pack_Catalog", Concat_StrStr(Path, PackName));
	return;
}

private function int GetScenarioIndex(string ScenarioString)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, ScenarioStrings.Length))
	{
		if(EqualEqual_StrStr(ScenarioStrings[i], ScenarioString))
		{
			// [Explicit Break]
			goto J0x39;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	J0x39:

	return i;
	return;
}

function int GetScenarioCount()
{
	return ScenarioStrings.Length;
	return;
}

function string NextScenario(out int ScenarioIterator)
{
	local int Index;

	assert(Less_IntInt(ScenarioIterator, ScenarioStrings.Length));
	Index = Add_IntInt(ScenarioIterator, 1);
	if(Less_IntInt(Index, ScenarioStrings.Length))
	{
		AddAdd_Int(ScenarioIterator);
		return ScenarioStrings[Index];
	}
	else
	{
		ScenarioIterator = -1;
		return "";
	}
	return;
}

function bool HasScenario(string ScenarioString)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, ScenarioStrings.Length))
	{
		if(EqualEqual_StrStr(ScenarioStrings[i], ScenarioString))
		{
			return true;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return false;
	return;
}
