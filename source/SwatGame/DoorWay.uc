class DoorWay extends Actor
	native
	config
	notplaceable
	hidecategories(Karma);

simulated function PostBeginPlay()
{
	local SwatDoor Door;

	super.PostBeginPlay();
	Door = SwatDoor(Owner);
	assert(NotEqual_ObjectObject(Door, none));
	return;
}

simulated event SwatDoor GetDoor()
{
	local SwatDoor SwatDoor;

	SwatDoor = SwatDoor(Owner);
	assert(NotEqual_ObjectObject(SwatDoor, none));
	return SwatDoor;
	return;
}

simulated function float GetMomentumToPenetrate(Vector HitLocation, Vector HitNormal, Material MaterialHit)
{
	return 0.0000000;
	return;
}

defaultproperties
{
	DrawType=8
	bHidden=true
	bStasis=true
	bCollideActors=true
}