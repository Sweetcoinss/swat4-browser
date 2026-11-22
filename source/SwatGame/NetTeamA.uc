class NetTeamA extends NetTeam
	config
	hidecategories(Karma,Movement,Collision,Lighting,LightColor,Karma,Force);

simulated function int GetTeamNumber()
{
	return 0;
	return;
}

defaultproperties
{
	TeamName="SWAT"
	DefaultPlayerClass=Class'SwatGame.NetPlayerTeamA'
}