class SquadDeployThrownItemGoal extends SquadCommandGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) HandheldEquipment.EquipmentSlot ThrownItemSlot;
var(Parameters) Vector TargetThrowLocation;

overloaded function Construct(AI_Resource R, Pawn inCommandGiver, Vector inCommandOrigin, HandheldEquipment.EquipmentSlot inThrownItemSlot, Vector inTargetThrowLocation)
{
	construct_AI_ResourcePawnVector(R, inCommandGiver, inCommandOrigin);
	ThrownItemSlot = inThrownItemSlot;
	TargetThrowLocation = inTargetThrowLocation;
	return;
}

defaultproperties
{
	goalName="SquadDeployThrownItem"
}