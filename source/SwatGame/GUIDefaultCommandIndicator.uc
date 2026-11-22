class GUIDefaultCommandIndicator extends GUILabel
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(CommandInterface) config string RedTeamStyleName "The Syle to use when displaying a command for the RED team.";
var(CommandInterface) config string BlueTeamStyleName "The Syle to use when displaying a command for the BLUE team.";
var(CommandInterface) config string AsAnElementStyleName "The Syle to use when displaying a command for the entire ELEMENT.";

function OnCurrentTeamChanged(OfficerTeamInfo NewTeam)
{
	if(EqualEqual_ObjectObject(NewTeam, none))
	{
		Style = Controller.GetStyle(AsAnElementStyleName);
	}
	else
	{
		switch(NewTeam.Label)
		{
			case 'Element':
				Style = Controller.GetStyle(AsAnElementStyleName);
				break;
			case 'RedTeam':
				Style = Controller.GetStyle(RedTeamStyleName);
				break;
			case 'BlueTeam':
				Style = Controller.GetStyle(BlueTeamStyleName);
				break;
			default:
				Style = Controller.GetStyle(AsAnElementStyleName);
				break;
		}
	}
	return;
}

defaultproperties
{
	bPersistent=true
}