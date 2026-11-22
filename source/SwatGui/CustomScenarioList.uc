class CustomScenarioList extends GUIMultiColumnListBox
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

final function Empty()
{
	Clear();
	return;
}

final function AddRow(string ScenarioString, string Pack)
{
	local int newRow;

	ClearRow();
	AddNewRowElement("Scenario",, ScenarioString);
	AddNewRowElement("Pack",, Pack);
	newRow = PopulateRow();
	assert(GreaterEqual_IntInt(newRow, 0));
	return;
}

final function GetSelectedRow(out string ScenarioString, out string Pack)
{
	local export editinline GUIList List;

	List = GetColumn("Scenario");
	assert(NotEqual_ObjectObject(List, none));
	ScenarioString = List.GetExtra();
	List = GetColumn("Pack");
	assert(NotEqual_ObjectObject(List, none));
	Pack = List.GetExtra();
	return;
}
