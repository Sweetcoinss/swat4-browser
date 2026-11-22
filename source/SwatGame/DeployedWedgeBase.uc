class DeployedWedgeBase extends DeployedTacticalAid implements IAmUsedByToolkit
	native
	config(SwatEquipment)
	hidecategories(Karma,Force,LightColor,Lighting,Object,Sound);

var(Wedge) StaticMesh PreviewStaticMesh;
var config float QualifyTimeForToolkit;
var private SwatDoor AssociatedDoor;

replication
{
	// Pos:0x000
	reliable if(EqualEqual_IntInt(int(Role), int(ROLE_Authority)))
		AssociatedDoor;
}

function SetAssociatedDoor(SwatDoor inAssociatedDoor)
{
	AssociatedDoor = inAssociatedDoor;
	return;
}

simulated function Door GetDoorDeployedOn()
{
	if(IsDeployed())
	{
		return AssociatedDoor;
	}
	return none;
	return;
}

simulated function OnDeployed()
{
	SetCollision(true, false, false);
	Show();
	return;
}

simulated function OnRemoved()
{
	SetCollision(false, true, true);
	Hide();
	AssociatedDoor.OnUnwedged();
	return;
}

simulated function bool CanBeUsedByToolkitNow()
{
	return true;
	return;
}

function OnUsingByToolkitBegan(Pawn User)
{
	return;
}

function OnUsedByToolkit(Pawn User)
{
	OnRemoved();
	return;
}

function OnUsingByToolkitInterrupted(Pawn User)
{
	return;
}

simulated function float GetQualifyTimeForToolkit()
{
	return QualifyTimeForToolkit;
	return;
}

defaultproperties
{
	CollisionRadius=14.0000000
	CollisionHeight=20.0000000
	bBlockNonZeroExtentTraces=false
}