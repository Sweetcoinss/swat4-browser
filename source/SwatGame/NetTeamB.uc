class NetTeamB extends NetTeam
	config
	hidecategories(Karma,Movement,Collision,Lighting,LightColor,Karma,Force);

simulated function int GetTeamNumber()
{
	return 1;
	return;
}

defaultproperties
{
	TeamName="Suspects"
	DefaultPlayerClass=Class'SwatGame.NetPlayerTeamB'
}