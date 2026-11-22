interface ISwatDoor
	parseconfig;

function bool IsOpen()
{
	return;
}

function bool IsOpenLeft()
{
	return;
}

function bool IsBroken()
{
	return;
}

function bool IsLocked()
{
	return;
}

function bool IsWedged()
{
	return;
}

function bool IsChargePlacedOnLeft()
{
	return;
}

function bool IsChargePlacedOnRight()
{
	return;
}

function ISwatAI.AIDoorUsageSide GetOpenPositions(Pawn Other, bool bPreferSides, out Vector OpenPoint, out Rotator PawnOpenRotation)
{
	return;
}

function bool IsOfficerAtSideOpenPoint(Pawn Officer, bool bOnLeftSide)
{
	return;
}

function Vector GetCenterOpenPoint(Pawn Other, out ISwatAI.AIDoorUsageSide DoorUsageSide)
{
	return;
}

function Rotator GetSidesOpenRotation(Vector OpenPoint)
{
	return;
}

function Vector GetClosePoint(bool bCloseFromLeft)
{
	return;
}

function Vector GetBreachFromPoint(Pawn Other)
{
	return;
}

function Vector GetBreachAimPoint(Pawn Other)
{
	return;
}

function name GetOpenAnimation(Pawn Other, ISwatAI.AIDoorUsageSide DoorUsageSide, optional bool bIsFranticOpen)
{
	return;
}

function name GetCloseAnimation(Pawn Other, bool bCloseFromBehind)
{
	return;
}

function name GetTryDoorAnimation(Pawn Other, ISwatAI.AIDoorUsageSide DoorUsageSide)
{
	return;
}

function Pawn GetLastInteractor()
{
	return;
}

function Pawn GetPendingInteractor()
{
	return;
}

function SetPendingInteractor(Pawn Interactor)
{
	return;
}

function bool IsBlockedFor(Pawn Other)
{
	return;
}

function bool WasBlockedBy(name BlockedClassName)
{
	return;
}

function array<StackupPoint> GetStackupPoints(Vector RequesterLocation)
{
	return;
}

function array<ClearPoint> GetClearPoints(Vector RequesterLocation)
{
	return;
}

function bool PointIsToMyLeft(Vector Point)
{
	return;
}

function bool ActorIsToMyLeft(Actor Other)
{
	return;
}

function Vector GetSkeletalRegionCenter(Actor.ESkeletalRegion Region)
{
	return;
}

function name GetLeftRoomName()
{
	return;
}

function name GetRightRoomName()
{
	return;
}

function Breached(Pawn Instigator)
{
	return;
}

function Blasted(Pawn Instigator)
{
	return;
}

function OnUnlocked()
{
	return;
}

function OnWedged()
{
	return;
}

function OnUnwedged()
{
	return;
}

function Actor GetDeployedWedge()
{
	return;
}

function bool CanBeLocked()
{
	return;
}

function Lock()
{
	return;
}

function RegisterInterestedInDoorOpening(IInterestedInDoorOpening Registrant)
{
	return;
}

function UnRegisterInterestedInDoorOpening(IInterestedInDoorOpening Registrant)
{
	return;
}

function float GetMoveAndClearPauseThreshold()
{
	return;
}

function bool WasDoorInitiallyOpen()
{
	return;
}

function PlacedThrowPoint GetPlacedThrowPoint(Vector Origin)
{
	return;
}

function float GetAdditionalGrenadeThrowDistance(Vector Origin)
{
	return;
}

function array<Actor> GetDoorModels()
{
	return;
}
