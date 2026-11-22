class Formation extends RefCount
	config(AI);

const kOutsidePathfindingLargeZDistance = 300.0;
const kOutsidePathfindingSmallZDistance = 128.0;
const kOutsidePathfindingWithSmallZDistance2D = 200.0;
const kInsidePathfindingWithSmallZDistance2D = 500.0;

var private Pawn Leader;
var array<Pawn> FormationMembers;
var array<Pawn> OrderedMembers;
var array<Vector> CachedOrderedMembersLocations;
var private Vector CachedLeaderLocation;
var private Timer ReorderTimer;
var config float ReorderTime;

overloaded function Construct()
{
	assert(false);
	return;
}

overloaded function Construct(Pawn NewLeader)
{
	SetLeader(NewLeader);
	SpawnReorderTimer();
	return;
}

function cleanup()
{
	ClearMembers();
	CleanupTimer();
	return;
}

private function SpawnReorderTimer()
{
	assert(EqualEqual_ObjectObject(ReorderTimer, none));
	assert(NotEqual_ObjectObject(Leader, none));
	ReorderTimer = Leader.Spawn(Class'Engine.Timer');
	ReorderTimer.__TimerDelegate__Delegate = ReorderMembers;
	ReorderTimer.StartTimer(ReorderTime, true);
	return;
}

private function CleanupTimer()
{
	if(NotEqual_ObjectObject(ReorderTimer, none))
	{
		ReorderTimer.StopTimer();
		ReorderTimer.__TimerDelegate__Delegate = None;
		ReorderTimer.Destroy();
		ReorderTimer = none;
	}
	return;
}

function Pawn GetOrderedMember(int Index)
{
	assert(GreaterEqual_IntInt(Index, 0));
	assert(Less_IntInt(Index, OrderedMembers.Length));
	return OrderedMembers[Index];
	return;
}

private function bool IsMemberOutsidePathfindingDistance(Pawn member)
{
	local float ZDelta, Distance2D;

	ZDelta = Abs(Subtract_FloatFloat(Leader.Location.Z, member.Location.Z));
	Distance2D = VSize2D(Subtract_VectorVector(Leader.Location, member.Location));
	if(Greater_FloatFloat(ZDelta, 300.0000000))
	{
		return true;
	}
	else
	{
		if(Greater_FloatFloat(ZDelta, 128.0000000))
		{
			return Greater_FloatFloat(Distance2D, 200.0000000);
		}
		else
		{
			return Greater_FloatFloat(Distance2D, 500.0000000);
		}
	}
	return;
}

function bool HasFormationMemberSizeChanged()
{
	if(OrOr_BoolBool(NotEqual_IntInt(FormationMembers.Length, OrderedMembers.Length), NotEqual_IntInt(OrderedMembers.Length, CachedOrderedMembersLocations.Length)))
	{
		return true;
	}
	return false;
	return;
}

function bool HasFormationLocationsChanged()
{
	local int i;

	if(NotEqual_VectorVector(Leader.Location, CachedLeaderLocation))
	{
		return true;
	}
	i = 0;
	J0x21:

	if(Less_IntInt(i, OrderedMembers.Length))
	{
		if(NotEqual_VectorVector(CachedOrderedMembersLocations[i], OrderedMembers[i].Location))
		{
			return true;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x21;
	}
	return false;
	return;
}

private function ReorderMembers()
{
	local bool bHasFormationMemberSizeChanged, bHasFormationLocationsChanged, bShouldDoFullPathBasedReordering;
	local int i, j, ClosestIndex;
	local float ClosestDistance;
	local array<Pawn> CurrentFormationMembers;
	local array<float> FormationMemberDistancesToLeader;

	bHasFormationMemberSizeChanged = HasFormationMemberSizeChanged();
	bHasFormationLocationsChanged = HasFormationLocationsChanged();
	if(OrOr_BoolBool(bHasFormationMemberSizeChanged, bHasFormationLocationsChanged))
	{
		if(EqualEqual_IntInt(FormationMembers.Length, 1))
		{
			OrderedMembers.Remove(0, OrderedMembers.Length);
			OrderedMembers[0] = FormationMembers[0];
		}
		else
		{
			if(AndAnd_BoolBool(Not_PreBool(bShouldDoFullPathBasedReordering), bHasFormationMemberSizeChanged))
			{
				bShouldDoFullPathBasedReordering = true;
			}
			if(Not_PreBool(bShouldDoFullPathBasedReordering))
			{
				bShouldDoFullPathBasedReordering = true;
				i = 0;
				J0x91:

				if(Less_IntInt(i, FormationMembers.Length))
				{
					if(IsMemberOutsidePathfindingDistance(FormationMembers[i]))
					{
						bShouldDoFullPathBasedReordering = false;
						// [Explicit Break]
						goto J0xCA;
					}
					AddAdd_PreInt(i);
					// [Loop Continue]
					goto J0x91;
				}
			}
			J0xCA:

			if(bShouldDoFullPathBasedReordering)
			{
				OrderedMembers.Remove(0, OrderedMembers.Length);
				CurrentFormationMembers = FormationMembers;
				i = 0;
				J0xF2:

				if(Less_IntInt(i, CurrentFormationMembers.Length))
				{
					FormationMemberDistancesToLeader[i] = CurrentFormationMembers[i].GetPathfindingDistanceToActor(Leader, true);
					AddAdd_PreInt(i);
					// [Loop Continue]
					goto J0xF2;
				}
				i = 0;
				J0x13A:

				if(Less_IntInt(i, FormationMembers.Length))
				{
					j = 0;
					J0x151:

					if(Less_IntInt(j, FormationMemberDistancesToLeader.Length))
					{
						if(OrOr_BoolBool(EqualEqual_IntInt(j, 0), Less_FloatFloat(FormationMemberDistancesToLeader[j], ClosestDistance)))
						{
							ClosestDistance = FormationMemberDistancesToLeader[j];
							ClosestIndex = j;
						}
						AddAdd_PreInt(j);
						// [Loop Continue]
						goto J0x151;
					}
					OrderedMembers[OrderedMembers.Length] = CurrentFormationMembers[ClosestIndex];
					CurrentFormationMembers.Remove(ClosestIndex, 1);
					FormationMemberDistancesToLeader.Remove(ClosestIndex, 1);
					AddAdd_PreInt(i);
					// [Loop Continue]
					goto J0x13A;
				}
			}
		}
		CachedOrderedMembersLocations.Remove(0, CachedOrderedMembersLocations.Length);
		i = 0;
		J0x1F7:

		if(Less_IntInt(i, OrderedMembers.Length))
		{
			CachedOrderedMembersLocations[i] = OrderedMembers[i].Location;
			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0x1F7;
		}
		CachedLeaderLocation = Leader.Location;
	}
	return;
}

function Pawn GetPawnInFront(Pawn CurrentMember)
{
	local int OrderedMemberIndex;

	assert(Not_PreBool(IsLeader(CurrentMember)));
	assert(IsInFormation(CurrentMember));
	OrderedMemberIndex = GetOrderedIndexForMember(CurrentMember);
	if(EqualEqual_IntInt(OrderedMemberIndex, 0))
	{
		return Leader;
	}
	else
	{
		return OrderedMembers[Subtract_IntInt(OrderedMemberIndex, 1)];
	}
	return;
}

function Pawn GetDestinationForMember(Pawn CurrentMember)
{
	local Pawn PawnInFront;

	AssertWithDescription(IsInFormation(CurrentMember), At_StrStr(At_StrStr(At_StrStr("Formation::GetDestinationForMember - ", string(CurrentMember.Name)), " could not be found in Formation:"), string(Name)));
	AssertWithDescription(Not_PreBool(IsLeader(CurrentMember)), At_StrStr(At_StrStr(At_StrStr("Formation::GetDestinationForMember - called when ", string(CurrentMember.Name)), " is a Leader in Formation:"), string(Name)));
	if(IsMemberOutsidePathfindingDistance(CurrentMember))
	{
		return Leader;
	}
	else
	{
		PawnInFront = GetPawnInFront(CurrentMember);
		return PawnInFront;
	}
	return;
}

function AddMember(Pawn NewMember)
{
	AssertWithDescription(Not_PreBool(IsInFormation(NewMember)), At_StrStr(At_StrStr(At_StrStr("Formation::AddMember -", string(NewMember.Name)), " is already in Formation:"), string(Name)));
	FormationMembers[FormationMembers.Length] = NewMember;
	ReorderMembers();
	return;
}

function AddMembers(array<Pawn> NewMembers)
{
	local int i;
	local Pawn NewMember;

	AssertWithDescription(Greater_IntInt(NewMembers.Length, 0), "Formation::AddMembers - NewMembers array passed in has no members!");
	i = 0;
	J0x5A:

	if(Less_IntInt(i, NewMembers.Length))
	{
		NewMember = NewMembers[i];
		AssertWithDescription(Not_PreBool(IsInFormation(NewMember)), At_StrStr(At_StrStr(At_StrStr("Formation::AddMember -", string(NewMember.Name)), " is already in Formation:"), string(Name)));
		FormationMembers[FormationMembers.Length] = NewMember;
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x5A;
	}
	ReorderMembers();
	return;
}

function RemoveMember(Pawn CurrentMember)
{
	local int MemberIndex;

	AssertWithDescription(IsInFormation(CurrentMember), At_StrStr(At_StrStr(At_StrStr("Formation::RemoveMember - ", string(CurrentMember.Name)), " could not be found in Formation:"), string(Name)));
	MemberIndex = GetFormationIndexForMember(CurrentMember);
	FormationMembers.Remove(MemberIndex, 1);
	ReorderMembers();
	return;
}

function ClearMembers()
{
	local int i;
	local Pawn Iter;

	i = 0;
	J0x07:

	if(Less_IntInt(i, FormationMembers.Length))
	{
		Iter = FormationMembers[i];
		if(Class'Engine.Pawn'.static.checkAlive(Iter))
		{
			ISwatOfficer(Iter).ClearFormation();
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	FormationMembers.Remove(0, FormationMembers.Length);
	return;
}

private function int GetFormationIndexForMember(Pawn CurrentMember)
{
	local int i;

	AssertWithDescription(IsInFormation(CurrentMember), At_StrStr(At_StrStr(At_StrStr("Formation::GetIndexForMember - ", string(CurrentMember.Name)), " could not be found in Formation:"), string(Name)));
	i = 0;
	J0x79:

	if(Less_IntInt(i, FormationMembers.Length))
	{
		if(EqualEqual_ObjectObject(FormationMembers[i], CurrentMember))
		{
			return i;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x79;
	}
	assert(false);
	return -1;
	return;
}

private function int GetOrderedIndexForMember(Pawn CurrentMember)
{
	local int i;

	AssertWithDescription(IsInFormation(CurrentMember), At_StrStr(At_StrStr(At_StrStr("Formation::GetIndexForMember - ", string(CurrentMember.Name)), " could not be found in Formation:"), string(Name)));
	i = 0;
	J0x79:

	if(Less_IntInt(i, OrderedMembers.Length))
	{
		if(EqualEqual_ObjectObject(OrderedMembers[i], CurrentMember))
		{
			return i;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x79;
	}
	assert(false);
	return -1;
	return;
}

private function bool IsInFormation(Pawn test)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, FormationMembers.Length))
	{
		if(EqualEqual_ObjectObject(FormationMembers[i], test))
		{
			return true;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return false;
	return;
}

private function SetLeader(Pawn NewLeader)
{
	assert(NotEqual_ObjectObject(NewLeader, none));
	Leader = NewLeader;
	return;
}

function Pawn GetLeader()
{
	return Leader;
	return;
}

function bool IsLeader(Pawn Pawn)
{
	return EqualEqual_ObjectObject(Pawn, Leader);
	return;
}
