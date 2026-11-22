class BoobyTrap_World extends BoobyTrap
	config(SwatGame)
	hidecategories(Karma,Force,LightColor,Lighting,Object,Sound);

var Class<BoobyTrapDoorAttachment> DoorAttachmentClass "Specifies the class of door attachment that is spawned and attached to the door that is tied in with this placed boobytrap.";
var private BoobyTrapDoorAttachment DoorAttachment;

function OnBoobyTrapInitialize()
{
	Log(Concat_StrStr("BoobyTrap_World intiialized, door associated is: ", string(BoobyTrapDoor)));
	if(NotEqual_ObjectObject(DoorAttachmentClass, none))
	{
		DoorAttachment = Spawn(DoorAttachmentClass, self);
		BoobyTrapDoor.AttachToBone(DoorAttachment, AttachSocket);
		Log(Concat_StrStr(Concat_StrStr(string(self), " has attached to the door! ... staticmesh: "), string(DoorAttachment.StaticMesh)));
		Log(Concat_StrStr("BoobyTrap attached to door: ", string(BoobyTrapDoor)));
	}
	return;
}

function ReactToUsed(Actor Other)
{
	if(AndAnd_BoolBool(bActive, NotEqual_ObjectObject(DoorAttachment, none)))
	{
		DoorAttachment.ReactToUsed(Other);
	}
	super.ReactToUsed(Other);
	return;
}

function ReactToTriggered(Actor Other)
{
	if(AndAnd_BoolBool(bActive, NotEqual_ObjectObject(DoorAttachment, none)))
	{
		DoorAttachment.ReactToTriggered(Other);
	}
	super.ReactToTriggered(Other);
	SetCollision(false, false, false);
	return;
}

defaultproperties
{
	QualifyTime=1.0000000
	StaticMesh=StaticMesh'arms_sm.arms_bathsink'
	DrawScale=0.5000000
	bCollideWorld=true
	bBlockActors=true
}