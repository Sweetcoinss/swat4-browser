class GraphicCommandInterface_SP extends GraphicCommandInterface
	config(PlayerInterface_Command_SP)
	notplaceable
	hidecategories(Karma);

defaultproperties
{
	ContextsListClass=Class'SwatGame.CommandInterfaceContextsList_SP'
	MenuInfoClass=Class'SwatGame.CommandInterfaceMenuInfo_SP'
	StaticCommandsClass=Class'SwatGame.CommandInterfaceStaticCommands_SP'
	CommandClass=Class'SwatGame.Command_SP'
	SometimesSendInterruptedCommand=true
	Range=2000.0000000
	DoorRelatedContextClass=Class'SwatGame.CommandInterfaceDoorRelatedContext_SP'
	ContextClass=Class'SwatGame.CommandInterfaceContext_SP'
}