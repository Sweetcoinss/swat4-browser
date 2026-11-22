class ClassicCommandInterface_MP extends ClassicCommandInterface
	config(PlayerInterface_Command_MP)
	notplaceable
	hidecategories(Karma);

simulated function CheckTeam()
{
	return;
}

defaultproperties
{
	ElementString="What Should Go Here?"
	RedTeamString="Red Team -"
	BlueTeamString="Blue Team -"
	BackString="Backspace: Main Menu"
	ContextsListClass=Class'SwatGame.CommandInterfaceContextsList_MP'
	MenuInfoClass=Class'SwatGame.CommandInterfaceMenuInfo_MP'
	StaticCommandsClass=Class'SwatGame.CommandInterfaceStaticCommands_MP'
	CommandClass=Class'SwatGame.Command_MP'
	Range=2000.0000000
	DoorRelatedContextClass=Class'SwatGame.CommandInterfaceDoorRelatedContext_MP'
	ContextClass=Class'SwatGame.CommandInterfaceContext_MP'
}