class OfficerSquadAction extends AI_SquadAction
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Pawn CommandGiver;
var(Parameters) Vector CommandOrigin;
var(Parameters) bool bHasBeenCopied;

function PawnDied(Pawn Pawn)
{
	super(ActionBase).PawnDied(Pawn);
	if(EqualEqual_IntInt(squad().pawns.Length, 0))
	{
		instantFail(9);
	}
	else
	{
		NotifyPawnDied(Pawn);
	}
	return;
}

protected function NotifyPawnDied(Pawn Pawn)
{
	return;
}

function Pawn GetClosestOfficerWithEquipmentTo(HandheldEquipment.EquipmentSlot Slot, Vector Point)
{
	assert(squad().IsA('OfficerTeamInfo'));
	return OfficerTeamInfo(squad()).GetClosestOfficerWithEquipmentTo(Slot, Point);
	return;
}

function bool DoesAnOfficerHaveUsableEquipment(HandheldEquipment.EquipmentSlot Slot, optional name EquipmentClassName)
{
	assert(squad().IsA('OfficerTeamInfo'));
	return OfficerTeamInfo(squad()).DoesAnOfficerHaveUsableEquipment(Slot, EquipmentClassName);
	return;
}

function Pawn GetFirstOfficer()
{
	assert(squad().IsA('OfficerTeamInfo'));
	return OfficerTeamInfo(squad()).GetFirstOfficer();
	return;
}

function Pawn GetSecondOfficer()
{
	assert(squad().IsA('OfficerTeamInfo'));
	return OfficerTeamInfo(squad()).GetSecondOfficer();
	return;
}

function Pawn GetClosestOfficerTo(Actor Target, optional bool bRequiresLineOfSight, optional bool bUsePathfindingDistance)
{
	assert(squad().IsA('OfficerTeamInfo'));
	return OfficerTeamInfo(squad()).GetClosestOfficerTo(Target, bRequiresLineOfSight, bUsePathfindingDistance);
	return;
}

function Pawn GetClosestOfficerWithEquipment(Vector Location, HandheldEquipment.EquipmentSlot Slot, optional name EquipmentClassName)
{
	assert(squad().IsA('OfficerTeamInfo'));
	return OfficerTeamInfo(squad()).GetClosestOfficerWithEquipment(Location, Slot, EquipmentClassName);
	return;
}
