class GameMode extends Actor
	abstract
	native
	config(SwatGame)
	notplaceable
	hidecategories(Karma);

var SwatGameInfo SGI;

function EndGame()
{
	assert(false);
	return;
}

function Initialize()
{
	MPLog(Concat_StrStr(string(self), "---GameMode::Initialize()."));
	SGI = SwatGameInfo(Owner);
	assert(NotEqual_ObjectObject(SGI, none));
	return;
}

function OnMissionEnded()
{
	return;
}

function SetStartClustersForRoundStart()
{
	assert(false);
	return;
}

function AssignPlayerRoles()
{
	assert(false);
	return;
}

function SwatMPStartPoint FindNetPlayerStart(Controller Player)
{
	assert(false);
	return none;
	return;
}

function NetRoundTimeRemaining(int TimeRemaining)
{
	assert(false);
	return;
}

function NetRoundTimerExpired()
{
	assert(false);
	return;
}

function SetSpawnClusterEnabled(name ClusterName, bool SetEnabled)
{
	assert(false);
	return;
}

function RespawnAll()
{
	assert(false);
	return;
}

function PlayerJoinedTeam(SwatGamePlayerController Player, int Team)
{
	assert(false);
	return;
}

defaultproperties
{
	bHidden=true
}