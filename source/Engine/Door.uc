class Door extends NavigationPoint
	abstract
	native
	config
	notplaceable
	hidecategories(Karma,Lighting,LightColor,Karma,Force);

enum DoorPosition
{
	DoorPosition_Closed,            // 0
	DoorPosition_OpenLeft,          // 1
	DoorPosition_OpenRight          // 2
};

var Door.DoorPosition DesiredPosition;
var float SoundPropagationDistancePenalty "Distance this door will add to the attenuation distance for a sound playing behind this door when closed";
var Door.DoorPosition PendingPosition "The DoorPosition after the current animation finishes";
var array<Pawn> CurrentlyMovingThroughDoor;

replication
{
	// Pos:0x000
	reliable if(EqualEqual_IntInt(int(Role), int(ROLE_Authority)))
		DesiredPosition;
}

// Export UDoor::execIsOpenLeft(FFrame&, void* const)
native simulated function bool IsOpenLeft();

// Export UDoor::execIsOpenRight(FFrame&, void* const)
native simulated function bool IsOpenRight();

// Export UDoor::execIsOpeningLeft(FFrame&, void* const)
native simulated function bool IsOpeningLeft();

// Export UDoor::execIsOpeningRight(FFrame&, void* const)
native simulated function bool IsOpeningRight();

// Export UDoor::execIsClosed(FFrame&, void* const)
native simulated function bool IsClosed();

// Export UDoor::execIsClosing(FFrame&, void* const)
native simulated function bool IsClosing();

// Export UDoor::execIsOpen(FFrame&, void* const)
native simulated function bool IsOpen();

// Export UDoor::execIsOpening(FFrame&, void* const)
native simulated function bool IsOpening();

// Export UDoor::execIsBroken(FFrame&, void* const)
native simulated function bool IsBroken();

// Export UDoor::execIsLocked(FFrame&, void* const)
native simulated function bool IsLocked();

// Export UDoor::execIsWedged(FFrame&, void* const)
native simulated function bool IsWedged();

// Export UDoor::execIsEmptyDoorway(FFrame&, void* const)
native event bool IsEmptyDoorway();

simulated event DesiredPositionChanged()
{
	return;
}

defaultproperties
{
	SoundPropagationDistancePenalty=700.0000000
	bPropagatesSound=true
}