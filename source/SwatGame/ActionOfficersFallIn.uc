class ActionOfficersFallIn extends Action
	editinlinenew
	collapsecategories
	hidecategories(Object);

var name Team "Who you want to Fall-In; should be Element, Red, or Blue.";

latent function Variable execute()
{
	local OfficerTeamInfo TeamInfo;
	local Pawn Player;

	if(NotEqual_IntInt(int(parentScript.Level.NetMode), int(NM_Standalone)))
	{
		return none;
	}
	switch(Team)
	{
		case 'Element':
			TeamInfo = SwatAIRepository(parentScript.Level.AIRepo).GetElementSquad();
			break;
		case 'Red':
			TeamInfo = SwatAIRepository(parentScript.Level.AIRepo).GetRedSquad();
			break;
		case 'Blue':
			TeamInfo = SwatAIRepository(parentScript.Level.AIRepo).GetBlueSquad();
			break;
		default:
			AssertWithDescription(false, Concat_StrStr(Concat_StrStr("[tcohen] ActionOfficersFallIn: The 'Team' specified as ", string(Team)), " is invalid.  Please specify 'Element', 'Red', or 'Blue'."));
			break;
	}
	if(NotEqual_ObjectObject(TeamInfo, none))
	{
		Player = parentScript.Level.GetLocalPlayerController().Pawn;
		TeamInfo.FallIn(Player, Player.Location);
	}
	return none;
	return;
}

function editorDisplayString(out string S)
{
	switch(Team)
	{
		case 'Element':
			S = "Tell the Element to Fall-In";
			break;
		case 'Red':
			S = "Tell the Red Team to Fall-In";
			break;
		case 'Blue':
			S = "Tell the Blue Team to Fall-In";
			break;
		default:
			S = "Tell an Officer Team to Fall-In";
			break;
	}
	return;
}

defaultproperties
{
	Team="Element"
	actionDisplayName="Tell an Officer Team to Fall-In"
	actionHelp="Tells an Officer Team to Fall-In"
	category="AI"
}