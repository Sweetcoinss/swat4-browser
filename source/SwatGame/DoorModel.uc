class DoorModel extends DoorAttachment implements ICanBeUsed
	transient
	native
	config(SwatGame)
	hidecategories(Karma,Force,LightColor,Lighting,Object,Sound);

cpptext
{
	void ProcedurallyOpenDoorModel(DoorPosition OpenPosition);
	void ProcedurallyCloseDoorModel();

}

var SwatDoor Door;
var private Rotator SavedRotation;
var private Vector SavedLocation;

replication
{
	// Pos:0x000
	reliable if(AndAnd_BoolBool(bNetDirty, EqualEqual_IntInt(int(Role), int(ROLE_Authority))))
		Door;
}

simulated function bool CanBeUsedNow()
{
	return SwatDoor(Owner).CanInteract();
	return;
}

simulated function OnUsed(Pawn Other)
{
	SwatDoor(Owner).Interact(Other);
	return;
}

simulated function PostUsed()
{
	return;
}

defaultproperties
{
	bWorldGeometry=true
	MaxDynamicLights=2
	bCollideActors=true
	bBlockActors=true
	bBlockPlayers=true
	bBlockHavok=true
	HavokDataClass=Class'SwatGame.HavokDoorRigidBody'
}