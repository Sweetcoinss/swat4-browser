class ActionSetExpectedCommand extends Action
	editinlinenew
	collapsecategories
	hidecategories(Object);

var name ExpectedCommand "Should be in the form of 'Command_FallIn'.  See content/system/PlayerInterface_Command.ini for all of the commands.";
var name ExpectedCommandTeam "Should be (empty), Element, RedTeam, or BlueTeam";
var name ExpectedCommandTargetDoor "The Label of Door to which the ExpectedCommand should refer.";
var name ExpectedCommandSource "The expected Label of the source giving the command. Valid labels are: an empty string (the source doesn't matter), Player, RedTeam, BlueTeam, OfficerRedOne, OfficerRedTwo, OfficerBlueOne, OfficerBlueTwo";

latent function Variable execute()
{
	local CommandInterface CommandInterface;

	if(NotEqual_IntInt(int(parentScript.Level.NetMode), int(NM_Standalone)))
	{
		return none;
	}
	CommandInterface = SwatGamePlayerController(parentScript.Level.GetLocalPlayerController()).GetCommandInterface();
	CommandInterface.SetExpectedCommand(ExpectedCommand, ExpectedCommandTeam, ExpectedCommandTargetDoor, ExpectedCommandSource);
	return none;
	return;
}

function editorDisplayString(out string S)
{
	S = Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("Set the ExpectedCommand to [", string(ExpectedCommand)), "], the ExpectedCommandTeam to ["), string(ExpectedCommandTeam)), "], and the ExpectedCommandTargetDoor to ["), string(ExpectedCommandTargetDoor)), "], and the ExpectedCommandSource to ["), string(ExpectedCommandSource)), "]");
	return;
}

defaultproperties
{
	actionDisplayName="Set the CommandInterface ExpectedCommand & ExpectedCommandTeam"
	actionHelp="Sets the ExpectedCommand and ExpectedCommandTeam for the current CommandInterface.  The CommandInterface will only send the specified command to the specified team."
	category="Script"
}