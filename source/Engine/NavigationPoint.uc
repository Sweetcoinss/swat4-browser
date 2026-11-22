class NavigationPoint extends Actor
	native
	config
	notplaceable
	hidecategories(Karma,Lighting,LightColor,Karma,Force);

struct native VisibleAwarenessPoint
{
	var AwarenessPoint AwarenessPoint;
	var array<Door> DependsOnDoors;
};

struct native OcclusionNodeInformation
{
	var name OtherOcclusionNode;
	var float ShortestDistanceTo;
	var array<Door> DoorsInBetween;
};

var const array<ReachSpec> PathList;
var name ProscribedPaths[4];
var name ForcedPaths[4];
var int visitedWeight;
var const int bestPathWeight;
var const NavigationPoint nextNavigationPoint;
var const NavigationPoint nextOrdered;
var const NavigationPoint prevOrdered;
var const NavigationPoint previousPath;
var int cost;
var int ExtraCost;
var transient int TransientCost;
var transient int FearCost;
var bool bAlreadyVisited;
var transient bool bEndPoint;
var transient bool bTransientEndPoint;
var bool taken;
var bool bPropagatesSound;
var bool bBlocked;
var bool bOneWayPath;
var bool bNeverUseStrafing;
var bool bAlwaysUseStrafing;
var const bool bForceNoStrafing;
var const bool bAutoBuilt;
var bool bSpecialMove;
var bool bNoAutoConnect;
var const bool bNotBased;
var const bool bPathsChanged;
var bool bDestinationOnly;
var bool bSourceOnly;
var bool bSpecialForced;
var bool bMustBeReachable;
var float InventoryDist;
var private string RoomName;
var private name InternalRoomName;
var /*0x00000000-0x00080000*/ const array<VisibleAwarenessPoint> VisibleAwarenessPoints;
var /*0x00000000-0x00080000*/ private AwarenessPoint ClosestAwarenessPoint;
var /*0x00000000-0x00080000*/ private float ClosestAwarenessPointDistance;
var float TimeOfLastSpawn;
var const array<OcclusionNodeInformation> OcclusionNodes;
var native const transient map<name, OcclusionNodeInformation> OcclusionMap;

// Export UNavigationPoint::execInitOcclusionMap(FFrame&, void* const)
private native function InitOcclusionMap();

simulated function PostBeginPlay()
{
	ExtraCost = Max(ExtraCost, 0);
	super.PostBeginPlay();
	if(OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)), Level.IsCOOPServer))
	{
		AddSelfToRoomList();
	}
	InitOcclusionMap();
	return;
}

function AddSelfToRoomList()
{
	if(NotEqual_ObjectObject(Level.AIRepo, none))
	{
		if(EqualEqual_NameName(InternalRoomName, 'None'))
		{
			InternalRoomName = string(RoomName);
		}
		Level.AIRepo.AddNavigationPointToRoomList(self, InternalRoomName);
	}
	return;
}

// Export UNavigationPoint::execGetRoomName(FFrame&, void* const)
native function name GetRoomName(Pawn Requester);

event int SpecialCost(Pawn Seeker, ReachSpec Path)
{
	return;
}

event bool Accept(Actor Incoming, Actor Source)
{
	taken = Incoming.SetLocation(Location);
	if(taken)
	{
		Incoming.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
		Incoming.SetRotation(Rotation);
	}
	Incoming.PlayTeleportEffect(true, false);
	TriggerEvent(Event, self, Pawn(Incoming));
	return taken;
	return;
}

event float DetourWeight(Pawn Other, float PathWeight)
{
	return;
}

event bool SuggestMovePreparation(Pawn Other)
{
	return false;
	return;
}

function bool ProceedWithMove(Pawn Other)
{
	return true;
	return;
}

function MoverOpened()
{
	return;
}

function MoverClosed()
{
	return;
}

function AwarenessPoint GetClosestAwarenessPoint()
{
	return ClosestAwarenessPoint;
	return;
}

function float GetClosestAwarenessPointDistance()
{
	return ClosestAwarenessPointDistance;
	return;
}

defaultproperties
{
	TimeOfLastSpawn=-1.0000000
	bStatic=true
	bHidden=true
	bNoDelete=true
	Texture=Texture'Engine_res.S_NavP'
	bCollideWhenPlacing=true
	CollisionRadius=30.0000000
	CollisionHeight=80.0000000
}