class SquadDeployThrownItemThroughDoorGoal extends SquadMoveAndClearGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) HandheldEquipment.EquipmentSlot ThrownItemSlot;

overloaded function Construct(AI_Resource R, Pawn inCommandGiver, Vector inCommandOrigin, Door inTargetDoor, HandheldEquipment.EquipmentSlot inThrownItemSlot)
{
	construct_AI_ResourcePawnVectorDoorBool(R, inCommandGiver, inCommandOrigin, inTargetDoor);
	ThrownItemSlot = inThrownItemSlot;
	return;
}

defaultproperties
{
	goalName="SquadDeployThrownItemThroughDoor"
}