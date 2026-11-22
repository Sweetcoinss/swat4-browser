class SwatAIRepository extends AIRepository
	native
	config
	hidecategories(Karma);

var private IdleActionsList idleActions;
var private InitialReactionsList InitialReactions;
var native const transient map<name, NavigationPointList> RoomNavigationPoints;
var private CharacterTypesList CharacterTypes;
var private ElementSquadInfo ElementSquad;
var private RedSquadInfo RedSquad;
var private BlueSquadInfo BlueSquad;
var private Hive HiveMind;
var private Pawn CurrentEnemyInHostageConversation;

event PreBeginPlay()
{
	super(Actor).PreBeginPlay();
	CreateCharacterTypesList();
	CreateIdleActionClassesList();
	CreateInitialReactionClassesList();
	CreateHive();
	CreateOfficerSquads();
	return;
}

event PostBeginPlay()
{
	super(Actor).PostBeginPlay();
	return;
}

private function CreateCharacterTypesList()
{
	CharacterTypes = Spawn(Class'SwatAICommon.CharacterTypesList', self);
	assert(NotEqual_ObjectObject(CharacterTypes, none));
	return;
}

function name GetVoiceTypeForCharacterType(name CharacterType)
{
	assert(NotEqual_NameName(CharacterType, 'None'));
	return CharacterTypes.GetVoiceTypeForCharacterType(CharacterType);
	return;
}

function bool IsAFemaleCharacterType(name inCharacterType)
{
	assert(NotEqual_NameName(inCharacterType, 'None'));
	return CharacterTypes.IsAFemaleCharacterType(inCharacterType);
	return;
}

function bool VerifyVoiceTypeExists(name inVoiceType)
{
	assert(NotEqual_NameName(inVoiceType, 'None'));
	return CharacterTypes.VerifyVoiceTypeExists(inVoiceType);
	return;
}

function bool VerifyCharacterTypeExists(name inCharacterType)
{
	assert(NotEqual_NameName(inCharacterType, 'None'));
	return CharacterTypes.VerifyCharacterTypeExists(inCharacterType);
	return;
}

private function CreateHive()
{
	HiveMind = Class'SwatAICommon.Hive'.static.Allocate(self, self).;
	Construct_Void();
	assert(NotEqual_ObjectObject(HiveMind, none));
	HiveMind.SwatAIRepo = self;
	return;
}

function Hive GetHive()
{
	return HiveMind;
	return;
}

private function CreateOfficerSquads()
{
	ElementSquad = Spawn(Class'SwatAICommon.ElementSquadInfo');
	assert(NotEqual_ObjectObject(ElementSquad, none));
	ElementSquad.SwatAIRepo = self;
	ElementSquad.Label = 'Element';
	RedSquad = Spawn(Class'SwatAICommon.RedSquadInfo');
	assert(NotEqual_ObjectObject(RedSquad, none));
	RedSquad.SwatAIRepo = self;
	RedSquad.Label = 'RedTeam';
	BlueSquad = Spawn(Class'SwatAICommon.BlueSquadInfo');
	assert(NotEqual_ObjectObject(BlueSquad, none));
	BlueSquad.SwatAIRepo = self;
	BlueSquad.Label = 'BlueTeam';
	return;
}

// Export USwatAIRepository::execGetElementSquad(FFrame&, void* const)
native function ElementSquadInfo GetElementSquad();

// Export USwatAIRepository::execGetRedSquad(FFrame&, void* const)
native function RedSquadInfo GetRedSquad();

// Export USwatAIRepository::execGetBlueSquad(FFrame&, void* const)
native function BlueSquadInfo GetBlueSquad();

function bool IsOfficerMovingAndClearing(Pawn Officer)
{
	assert(NotEqual_ObjectObject(Officer, none));
	return OrOr_BoolBool(OrOr_BoolBool(ElementSquad.IsMovingAndClearing(), AndAnd_BoolBool(RedSquad.IsOfficerOnTeam(Officer), RedSquad.IsMovingAndClearing())), AndAnd_BoolBool(BlueSquad.IsOfficerOnTeam(Officer), BlueSquad.IsMovingAndClearing()));
	return;
}

function UpdateDoorKnowledgeForOfficers(Door TargetDoor)
{
	local ISwatDoor SwatTargetDoor;
	local bool bDoorBroken, bDoorLocked, bDoorWedged;

	assert(NotEqual_ObjectObject(TargetDoor, none));
	SwatTargetDoor = ISwatDoor(TargetDoor);
	assert(NotEqual_ObjectObject(SwatTargetDoor, none));
	bDoorBroken = SwatTargetDoor.IsBroken();
	bDoorLocked = SwatTargetDoor.IsLocked();
	bDoorWedged = SwatTargetDoor.IsWedged();
	if(Not_PreBool(bDoorBroken))
	{
		if(bDoorLocked)
		{
			NotifyOfficersDoorLocked(TargetDoor);
		}
		if(bDoorWedged)
		{
			NotifyOfficersDoorWedged(TargetDoor);
		}
	}
	if(OrOr_BoolBool(AndAnd_BoolBool(Not_PreBool(bDoorLocked), Not_PreBool(bDoorWedged)), SwatTargetDoor.IsBroken()))
	{
		NotifyOfficersDoorCanOpen(TargetDoor);
	}
	return;
}

private function NotifyOfficersDoorLocked(Door TargetDoor)
{
	local int i;
	local Pawn OfficerIter;

	i = 0;
	J0x07:

	if(Less_IntInt(i, GetElementSquad().pawns.Length))
	{
		OfficerIter = GetElementSquad().pawns[i];
		if(AndAnd_BoolBool(NotEqual_ObjectObject(OfficerIter, none), OfficerIter.isAlive()))
		{
			ISwatPawn(OfficerIter).SetDoorLockedBelief(TargetDoor, true);
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	ISwatPawn(Level.GetLocalPlayerController().Pawn).SetDoorLockedBelief(TargetDoor, true);
	return;
}

function NotifyOfficersDoorWedged(Door TargetDoor)
{
	local int i;
	local Pawn OfficerIter;

	i = 0;
	J0x07:

	if(Less_IntInt(i, GetElementSquad().pawns.Length))
	{
		OfficerIter = GetElementSquad().pawns[i];
		if(AndAnd_BoolBool(NotEqual_ObjectObject(OfficerIter, none), OfficerIter.isAlive()))
		{
			ISwatPawn(OfficerIter).SetDoorWedgedBelief(TargetDoor, true);
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	ISwatPawn(Level.GetLocalPlayerController().Pawn).SetDoorWedgedBelief(TargetDoor, true);
	return;
}

function NotifyOfficersDoorWedgeRemoved(Door TargetDoor)
{
	local int i;
	local Pawn OfficerIter;

	i = 0;
	J0x07:

	if(Less_IntInt(i, GetElementSquad().pawns.Length))
	{
		OfficerIter = GetElementSquad().pawns[i];
		if(AndAnd_BoolBool(NotEqual_ObjectObject(OfficerIter, none), OfficerIter.isAlive()))
		{
			ISwatPawn(OfficerIter).SetDoorWedgedBelief(TargetDoor, false);
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	ISwatPawn(Level.GetLocalPlayerController().Pawn).SetDoorWedgedBelief(TargetDoor, false);
	return;
}

private function NotifyOfficersDoorCanOpen(Door TargetDoor)
{
	local int i;
	local Pawn OfficerIter;

	i = 0;
	J0x07:

	if(Less_IntInt(i, GetElementSquad().pawns.Length))
	{
		OfficerIter = GetElementSquad().pawns[i];
		if(AndAnd_BoolBool(NotEqual_ObjectObject(OfficerIter, none), OfficerIter.isAlive()))
		{
			ISwatPawn(OfficerIter).SetDoorLockedBelief(TargetDoor, false);
			ISwatPawn(OfficerIter).SetDoorWedgedBelief(TargetDoor, false);
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	ISwatPawn(Level.GetLocalPlayerController().Pawn).SetDoorLockedBelief(TargetDoor, false);
	ISwatPawn(Level.GetLocalPlayerController().Pawn).SetDoorWedgedBelief(TargetDoor, false);
	return;
}

private function CreateIdleActionClassesList()
{
	idleActions = Spawn(Class'SwatAICommon.IdleActionsList', self);
	assert(NotEqual_ObjectObject(idleActions, none));
	return;
}

function IdleActionsList GetIdleActions()
{
	return idleActions;
	return;
}

private function CreateInitialReactionClassesList()
{
	InitialReactions = Spawn(Class'SwatAICommon.InitialReactionsList', self);
	assert(NotEqual_ObjectObject(InitialReactions, none));
	return;
}

function InitialReactionsList GetInitialReactions()
{
	return InitialReactions;
	return;
}

function bool IsEnemyHostageConversationActive()
{
	return NotEqual_ObjectObject(CurrentEnemyInHostageConversation, none);
	return;
}

function ActivateEnemyHostageConversation(Pawn inEnemy)
{
	assert(EqualEqual_ObjectObject(CurrentEnemyInHostageConversation, none));
	CurrentEnemyInHostageConversation = inEnemy;
	return;
}

function DeactivateEnemyHostageConversation(Pawn inEnemy)
{
	if(EqualEqual_ObjectObject(CurrentEnemyInHostageConversation, inEnemy))
	{
		CurrentEnemyInHostageConversation = none;
	}
	return;
}

// Export USwatAIRepository::execSetNavigationPointListForRoom(FFrame&, void* const)
native function SetNavigationPointListForRoom(name RoomName, NavigationPointList NavPoints);

// Export USwatAIRepository::execGetRoomNavigationPoints(FFrame&, void* const)
native function NavigationPointList GetRoomNavigationPoints(name RoomName);

function AddNavigationPointToRoomList(NavigationPoint NavPoint, name RoomName)
{
	local NavigationPointList NavPointList;

	NavPointList = GetRoomNavigationPoints(RoomName);
	if(EqualEqual_ObjectObject(NavPointList, none))
	{
		NavPointList = GetNewNavigationPointList();
		assert(NotEqual_ObjectObject(NavPointList, none));
		SetNavigationPointListForRoom(RoomName, NavPointList);
	}
	NavPointList.Add(NavPoint);
	return;
}

function bool DoesRoomHaveAny(name RoomName, name PointClassName)
{
	local int i;
	local NavigationPointList RoomNavPointList;
	local NavigationPoint Iter;
	local int NumRoomNavPoints;

	AssertWithDescription(NotEqual_NameName(RoomName, 'None'), "SwatAIRepository::DoesRoomHaveAny - RoomName passed in is empty, a Navigation Point is missing a room name in this map!  Check for Errors in UnrealEd!");
	AssertWithDescription(NotEqual_NameName(PointClassName, 'None'), "SwatAIRepository::DoesRoomHaveAny - PointClassName is empty!");
	RoomNavPointList = GetRoomNavigationPoints(RoomName);
	NumRoomNavPoints = RoomNavPointList.GetSize();
	i = 0;
	J0x127:

	if(Less_IntInt(i, NumRoomNavPoints))
	{
		Iter = RoomNavPointList.GetEntryAt(i);
		if(Iter.IsA('PointClassName'))
		{
			return true;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x127;
	}
	return false;
	return;
}

// Export USwatAIRepository::execGetRoomNavigationPointsOfType(FFrame&, void* const)
native event NavigationPointList GetRoomNavigationPointsOfType(name RoomName, name PointClassName, optional Vector Location, optional float MinimumDistanceFromLocation);

function NavigationPoint GetClosestNavigationPointInRoom(name RoomName, Vector Location, optional float MinimumDistanceFromLocation, optional name PointClassName, optional name ExclusionPointClassName)
{
	local NavigationPointList RoomNavPointList;
	local NavigationPoint ClosestPoint, IterPoint;
	local float ClosestDistance, IterDistance;
	local int i, NumRoomNavPoints;

	AssertWithDescription(NotEqual_NameName(RoomName, 'None'), "SwatAIRepository::GetClosestNavigationPointInRoom - RoomName passed in is empty, a Navigation Point is missing a room name in this map!  Check for Errors in UnrealEd!");
	RoomNavPointList = GetRoomNavigationPoints(RoomName);
	NumRoomNavPoints = RoomNavPointList.GetSize();
	i = 0;
	J0xE7:

	if(Less_IntInt(i, NumRoomNavPoints))
	{
		IterPoint = RoomNavPointList.GetEntryAt(i);
		if(OrOr_BoolBool(EqualEqual_NameName(PointClassName, 'None'), IterPoint.IsA(PointClassName)))
		{
			if(OrOr_BoolBool(EqualEqual_NameName(ExclusionPointClassName, 'None'), Not_PreBool(IterPoint.IsA(ExclusionPointClassName))))
			{
				IterDistance = VSize(Subtract_VectorVector(IterPoint.Location, Location));
				if(OrOr_BoolBool(EqualEqual_FloatFloat(MinimumDistanceFromLocation, 0.0000000), GreaterEqual_FloatFloat(IterDistance, MinimumDistanceFromLocation)))
				{
					if(OrOr_BoolBool(EqualEqual_ObjectObject(ClosestPoint, none), Less_FloatFloat(IterDistance, ClosestDistance)))
					{
						ClosestPoint = IterPoint;
						ClosestDistance = IterDistance;
					}
				}
			}
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0xE7;
	}
	return ClosestPoint;
	return;
}

function NavigationPoint FindRandomPointInRoom(name RoomName, optional name PointClassName)
{
	local NavigationPointList RoomPoints;
	local NavigationPoint RandomPoint;

	RoomPoints = GetRoomNavigationPointsOfType(RoomName, PointClassName);
	RandomPoint = RoomPoints.GetRandomEntry();
	ReleaseNavigationPointList(RoomPoints);
	return RandomPoint;
	return;
}

function FleePoint FindUnclaimedFleePointInRoom(name RoomName)
{
	local NavigationPointList RoomPoints;
	local int i;
	local FleePoint Iter, RandomPoint;

	RoomPoints = GetRoomNavigationPointsOfType(RoomName, 'FleePoint');
	i = 0;
	J0x1D:

	if(Less_IntInt(i, RoomPoints.GetSize()))
	{
		Iter = FleePoint(RoomPoints.GetEntryAt(i));
		if(NotEqual_ObjectObject(Iter.GetFleePointUser(), none))
		{
			RoomPoints.Remove(Iter);
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x1D;
	}
	RandomPoint = FleePoint(RoomPoints.GetRandomEntry());
	ReleaseNavigationPointList(RoomPoints);
	return RandomPoint;
	return;
}

function NavigationPointList GetNavigationPointsInRoomThatCanHitPoint(name RoomName, Vector Point)
{
	local int i;
	local NavigationPointList NavigationPointsThatCanHitPoint, RoomPoints;
	local NavigationPoint Iter;

	NavigationPointsThatCanHitPoint = GetNewNavigationPointList();
	RoomPoints = GetRoomNavigationPoints(RoomName);
	i = 0;
	J0x24:

	if(Less_IntInt(i, RoomPoints.GetSize()))
	{
		Iter = RoomPoints.GetEntryAt(i);
		if(EqualEqual_BoolBool(FastTrace(Point, Iter.GetAimLocation(none)), true))
		{
			NavigationPointsThatCanHitPoint.Add(Iter);
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x24;
	}
	return NavigationPointsThatCanHitPoint;
	return;
}

// Export USwatAIRepository::execGetClosestRoomNameToPoint(FFrame&, void* const)
native function name GetClosestRoomNameToPoint(Vector Point, Pawn TestPawn);

event ReleaseNavigationPointList(NavigationPointList NavPointList)
{
	assert(NotEqual_ObjectObject(NavPointList, none));
	NavPointList.Empty();
	Level.ObjectPool.FreeObject(NavPointList);
	return;
}

event NavigationPointList GetNewNavigationPointList()
{
	local NavigationPointList NavPointList;

	NavPointList = NavigationPointList(Level.ObjectPool.AllocateObject(Class'Engine.NavigationPointList'));
	assert(NotEqual_ObjectObject(NavPointList, none));
	AssertWithDescription(EqualEqual_IntInt(NavPointList.GetSize(), 0), "SwatAIRepository::GetNewNavigationPointList - NavPointList GetSize > 0!");
	return NavPointList;
	return;
}

function NavigationPoint FindClosestNavigationPointTo(Vector testLocation)
{
	return FindClosestOfNavigationPointClass(Class'Engine.NavigationPoint', testLocation);
	return;
}

// Export USwatAIRepository::execFindAllOfNavigationPointClass(FFrame&, void* const)
native event NavigationPointList FindAllOfNavigationPointClass(Class<NavigationPoint> ClassType, optional NavigationPointList ExcludeList);

// Export USwatAIRepository::execFindClosestOfNavigationPointClass(FFrame&, void* const)
native event NavigationPoint FindClosestOfNavigationPointClass(Class<NavigationPoint> ClassType, Vector testLocation, optional NavigationPointList ExcludeList);

// Export USwatAIRepository::execDoesRoomContainAIs(FFrame&, void* const)
native function bool DoesRoomContainAIs(name RoomName, optional name SpecifiedAIClassName, optional bool bMustMoveFreely);

// Export USwatAIRepository::execGetClosestUncompliantViewableAIInRoom(FFrame&, void* const)
native function Pawn GetClosestUncompliantViewableAIInRoom(name RoomName, Pawn TestCharacter, optional name SpecifiedAIClassName);
