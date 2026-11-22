class TestMenu extends GUIPage
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(TestGui) private export editinline config GUIButton MyStartButton;
var(TestGui) private export editinline config GUIButton MyBackButton;
var(TestGui) private export editinline config GUIButton MyMainMenuButton;
var(TestGui) private export editinline config GUIButton MyQuitButton;

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	MyStartButton.__OnClick__Delegate = MyButtOnClick;
	MyBackButton.__OnClick__Delegate = MyButtOnClick;
	MyMainMenuButton.__OnClick__Delegate = MyButtOnClick;
	MyQuitButton.__OnClick__Delegate = MyButtOnClick;
	return;
}

function InternalOnDlgReturned(int Selection, string Passback)
{
	switch(Passback)
	{
		case "PlayerReady":
			if(EqualEqual_IntInt(Selection, QBTN_Yes))
			{
				Controller.CloseMenu();
			}
			break;
		case "Quit":
			if(EqualEqual_IntInt(Selection, QBTN_Yes))
			{
				Controller.ConsoleCommand("Quit");
			}
			break;
		default:
			break;
	}
	return;
}

function MyButtOnClick(GUIComponent Sender)
{
	switch(Sender)
	{
		case MyStartButton:
			OpenDlg("Do you wish to close the menu?", QBTN_YesNoCancel, "PlayerReady");
			break;
		case MyBackButton:
			break;
		case MyMainMenuButton:
			break;
		case MyQuitButton:
			OpenDlg("Do you wish to quit?", QBTN_YesNo, "Quit");
			break;
		default:
			break;
	}
	return;
}

defaultproperties
{
	OnDlgReturned=TestMenu.InternalOnDlgReturned
}