class GraphicCommandInterface_MP extends GraphicCommandInterface
	config(PlayerInterface_Command_MP)
	notplaceable
	hidecategories(Karma);

simulated function CheckTeam()
{
	return;
}

defaultproperties
{
	ContextsListClass=Class'SwatGame.CommandInterfaceContextsList_MP'
	MenuInfoClass=Class'SwatGame.CommandInterfaceMenuInfo_MP'
	StaticCommandsClass=Class'SwatGame.CommandInterfaceStaticCommands_MP'
	CommandClass=Class'SwatGame.Command_MP'
	Range=2000.0000000
	DoorRelatedContextClass=Class'SwatGame.CommandInterfaceDoorRelatedContext_MP'
	ContextClass=Class'SwatGame.CommandInterfaceContext_MP'
}