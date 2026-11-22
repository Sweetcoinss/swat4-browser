class SquadMoveAndClearGoal extends SquadStackUpGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var private name RoomNameToClear;

overloaded function Construct(AI_Resource R, Pawn inCommandGiver, Vector inCommandOrigin, Door inTargetDoor, optional bool bInTriggerCouldntBreachLockedSpeech)
{
	super.construct_AI_ResourcePawnVectorDoorBool(R, inCommandGiver, inCommandOrigin, inTargetDoor, bInTriggerCouldntBreachLockedSpeech);
	if(ISwatDoor(inTargetDoor).PointIsToMyLeft(inCommandOrigin))
	{
		RoomNameToClear = ISwatDoor(inTargetDoor).GetRightRoomName();
	}
	else
	{
		RoomNameToClear = ISwatDoor(inTargetDoor).GetLeftRoomName();
	}
	return;
}

function name GetRoomNameToClear()
{
	return RoomNameToClear;
	return;
}

defaultproperties
{
	bIsCharacterInteractionCommandGoal=true
	goalName="SquadMoveAndClear"
}