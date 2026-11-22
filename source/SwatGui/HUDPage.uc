class HUDPage extends HUDPageBase
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(HUD) export editinline SwatChatPanel ChatPanel "The chat panel.";
var(HUD) export editinline SwatImportantMessageDisplay ImportantMessageDisplay "The Important Message Display.";
var(HUD) export editinline SwatImportantMessageDisplay RespawnMessageDisplay "The Respawn Message Display (MP Only).";
var(HUD) export editinline SwatTimeDisplay SpecialTimeDisplay "The Special Time Display.";
var(HUD) export editinline SwatTimeDisplay RespawnTimeDisplay "The Respawn Time Display (MP Only).";

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	return;
}

function OnConstruct(GUIController MyController)
{
	super.OnConstruct(MyController);
	ChatPanel = SwatChatPanel(AddComponent("SwatGUI.SwatChatPanel", "HudChatPanel"));
	ImportantMessageDisplay = SwatImportantMessageDisplay(AddComponent("SwatGUI.SwatImportantMessageDisplay", "HUDPage_ImportantMessageDisplay"));
	RespawnMessageDisplay = SwatImportantMessageDisplay(AddComponent("SwatGUI.SwatImportantMessageDisplay", "HUDPage_RespawnMessageDisplay"));
	SpecialTimeDisplay = SwatTimeDisplay(AddComponent("SwatGUI.SwatTimeDisplay", "HUDPage_SpecialTimeDisplay"));
	RespawnTimeDisplay = SwatTimeDisplay(AddComponent("SwatGUI.SwatTimeDisplay", "HUDPage_RespawnTimeDisplay"));
	return;
}

function CloseGUIGenericComponents()
{
	assert(NotEqual_ObjectObject(ImportantMessageDisplay, none));
	ImportantMessageDisplay.Hide();
	return;
}

function CloseGUIMPComponents()
{
	assert(NotEqual_ObjectObject(RespawnMessageDisplay, none));
	RespawnMessageDisplay.Hide();
	assert(NotEqual_ObjectObject(RespawnTimeDisplay, none));
	RespawnTimeDisplay.StopTimer();
	RespawnTimeDisplay.Hide();
	return;
}

function OpenGUIGenericComponents()
{
	assert(NotEqual_ObjectObject(ChatPanel, none));
	if(PlayerOwner().Level.IsTraining)
	{
		ChatPanel.RePosition('Training');
	}
	else
	{
		ChatPanel.RePosition('Default');
	}
	ChatPanel.Show();
	assert(NotEqual_ObjectObject(ImportantMessageDisplay, none));
	ImportantMessageDisplay.ClearDisplay();
	ImportantMessageDisplay.Hide();
	return;
}

function OpenGUIMPComponents()
{
	assert(NotEqual_ObjectObject(RespawnMessageDisplay, none));
	RespawnMessageDisplay.Hide();
	assert(NotEqual_ObjectObject(RespawnTimeDisplay, none));
	RespawnTimeDisplay.Hide();
	return;
}

protected function CloseComponents()
{
	super.CloseComponents();
	switch(SwatGUIControllerBase(Controller).GuiConfig.SwatGameRole)
	{
		case 0:
		case 1:
		case 2:
		case 3:
			break;
		case 4:
		case 5:
			CloseGUIMPComponents();
			break;
		default:
			assert(false);
			break;
			break;
	}
	CloseGUIGenericComponents();
	return;
}

protected function OpenComponents()
{
	super.OpenComponents();
	switch(SwatGUIControllerBase(Controller).GuiConfig.SwatGameRole)
	{
		case 0:
		case 1:
		case 2:
		case 3:
			break;
		case 4:
		case 5:
			OpenGUIMPComponents();
			break;
		default:
			assert(false);
			break;
			break;
	}
	OpenGUIGenericComponents();
	return;
}

function OnPlayerDied()
{
	CloseComponents();
	return;
}

function OnPlayerRespawned()
{
	OpenComponents();
	return;
}

function OnGameOver()
{
	super.OnGameOver();
	assert(NotEqual_ObjectObject(SpecialTimeDisplay, none));
	SpecialTimeDisplay.StopTimer();
	SpecialTimeDisplay.Hide();
	return;
}
