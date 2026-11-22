class CustomScenario_NotesTabPanel extends CustomScenarioTabPanel
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(SwatGui) private export editinline config GUIEditBox txt_notes;
var(SwatGui) private export editinline config GUIScrollTextBox scroll_notes;

function InitComponent(GUIComponent MyOwner)
{
	super(SwatGUIPanel).InitComponent(MyOwner);
	data = CustomScenarioPage.CustomScenarioCreatorData;
	txt_notes.__OnChange__Delegate = txt_notes_OnChange;
	return;
}

function txt_notes_OnChange(GUIComponent Sender)
{
	scroll_notes.SetContent(txt_notes.GetText());
	return;
}

function PopulateFieldsFromScenario(bool NewScenario)
{
	local CustomScenario Scenario;

	Scenario = CustomScenarioPage.GetCustomScenario();
	txt_notes.SetText(Scenario.Notes);
	return;
}

function GatherScenarioFromFields()
{
	local CustomScenario Scenario;

	Scenario = CustomScenarioPage.GetCustomScenario();
	Scenario.Notes = txt_notes.GetText();
	return;
}
