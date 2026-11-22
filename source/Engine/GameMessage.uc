class GameMessage extends LocalMessage
	config
	notplaceable
	hidecategories(Karma,Movement,Collision,Lighting,LightColor,Karma,Force);

var localized string SwitchLevelMessage;
var localized string LeftMessage;
var localized string FailedTeamMessage;
var localized string FailedPlaceMessage;
var localized string FailedSpawnMessage;
var localized string EnteredMessage;
var localized string MaxedOutMessage;
var localized string OvertimeMessage;
var localized string GlobalNameChange;
var localized string NewTeamMessage;
var localized string NewTeamMessageTrailer;
var localized string NoNameChange;
var localized string VoteStarted;
var localized string VotePassed;
var localized string MustHaveStats;
var localized string NewPlayerMessage;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	switch(Switch)
	{
		case 0:
			return default.OvertimeMessage;
			break;
		case 1:
			if(EqualEqual_ObjectObject(RelatedPRI_1, none))
			{
				return default.NewPlayerMessage;
			}
			return Concat_StrStr(RelatedPRI_1.PlayerName, default.EnteredMessage);
			break;
		case 2:
			if(EqualEqual_ObjectObject(RelatedPRI_1, none))
			{
				return "";
			}
			return At_StrStr(At_StrStr(RelatedPRI_1.OldName, default.GlobalNameChange), RelatedPRI_1.PlayerName);
			break;
		case 3:
			if(EqualEqual_ObjectObject(RelatedPRI_1, none))
			{
				return "";
			}
			if(EqualEqual_ObjectObject(OptionalObject, none))
			{
				return "";
			}
			return Concat_StrStr(At_StrStr(At_StrStr(RelatedPRI_1.PlayerName, default.NewTeamMessage), TeamInfo(OptionalObject).GetHumanReadableName()), default.NewTeamMessageTrailer);
			break;
		case 4:
			if(EqualEqual_ObjectObject(RelatedPRI_1, none))
			{
				return "";
			}
			return Concat_StrStr(RelatedPRI_1.PlayerName, default.LeftMessage);
			break;
		case 5:
			return default.SwitchLevelMessage;
			break;
		case 6:
			return default.FailedTeamMessage;
			break;
		case 7:
			return default.MaxedOutMessage;
			break;
		case 8:
			return default.NoNameChange;
			break;
		case 9:
			return At_StrStr(RelatedPRI_1.PlayerName, default.VoteStarted);
			break;
		case 10:
			return default.VotePassed;
			break;
		case 11:
			return default.MustHaveStats;
			break;
		default:
			break;
	}
	return "";
	return;
}

defaultproperties
{
	SwitchLevelMessage="Switching Levels"
	LeftMessage=" left the game."
	FailedTeamMessage="Could not find team for player"
	FailedPlaceMessage="Could not find a starting spot"
	FailedSpawnMessage="Could not spawn player"
	EnteredMessage=" entered the game."
	MaxedOutMessage="Server is already at capacity."
	OvertimeMessage="Score tied at the end of regulation. Sudden Death Overtime!!!"
	GlobalNameChange="changed name to"
	NewTeamMessage="is now on"
	NoNameChange="Name is already in use."
	VoteStarted="started a vote."
	VotePassed="Vote passed."
	MustHaveStats="Must have stats enabled to join this server."
	NewPlayerMessage="A new player entered the game."
	bIsSpecial=false
}