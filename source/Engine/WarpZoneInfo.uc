class WarpZoneInfo extends ZoneInfo
	native
	config
	placeable
	hidecategories(Karma,Movement,Collision,Lighting,LightColor,Karma,Force);

var string OtherSideURL;
var name ThisTag;
var bool bNoTeleFrag;
var const int iWarpZone;
var const Coords WarpCoords;
var transient WarpZoneInfo OtherSideActor;
var transient Object OtherSideLevel;
var string Destinations[8];
var int numDestinations;

replication
{
	// Pos:0x000
	reliable if(EqualEqual_IntInt(int(Role), int(ROLE_Authority)))
		OtherSideActor, OtherSideURL,
		ThisTag;
}

// Export UWarpZoneInfo::execWarp(FFrame&, void* const)
native(314) final function Warp(out Vector Loc, out Vector Vel, out Rotator R);

// Export UWarpZoneInfo::execUnWarp(FFrame&, void* const)
native(315) final function UnWarp(out Vector Loc, out Vector Vel, out Rotator R);

function PreBeginPlay()
{
	super.PreBeginPlay();
	Generate();
	numDestinations = 0;
	J0x13:

	if(Less_IntInt(numDestinations, 8))
	{
		if(NotEqual_StrStr(Destinations[numDestinations], ""))
		{
			AddAdd_Int(numDestinations);
		}
		else
		{
			numDestinations = 8;
		}
		// [Loop Continue]
		goto J0x13;
	}
	if(AndAnd_BoolBool(Greater_IntInt(numDestinations, 0), EqualEqual_StrStr(OtherSideURL, "")))
	{
		OtherSideURL = Destinations[0];
	}
	return;
}

function Trigger(Actor Other, Pawn EventInstigator)
{
	local int nextPick;

	if(EqualEqual_IntInt(numDestinations, 0))
	{
		return;
	}
	nextPick = 0;
	J0x14:

	if(AndAnd_BoolBool(Less_IntInt(nextPick, 8), NotEqual_StrStr(Destinations[nextPick], OtherSideURL)))
	{
		AddAdd_Int(nextPick);
		// [Loop Continue]
		goto J0x14;
	}
	AddAdd_Int(nextPick);
	if(OrOr_BoolBool(Greater_IntInt(nextPick, 7), EqualEqual_StrStr(Destinations[nextPick], "")))
	{
		nextPick = 0;
	}
	OtherSideURL = Destinations[nextPick];
	ForceGenerate();
	return;
}

simulated event Generate()
{
	if(NotEqual_ObjectObject(OtherSideLevel, none))
	{
		return;
	}
	ForceGenerate();
	return;
}

simulated event ForceGenerate()
{
	if(GreaterEqual_IntInt(InStr(OtherSideURL, "/"), 0))
	{
		OtherSideLevel = none;
		OtherSideActor = none;
	}
	else
	{
		OtherSideLevel = XLevel;
		foreach AllActors(Class'Engine.WarpZoneInfo', OtherSideActor)
		{
			if(AndAnd_BoolBool(ComplementEqual_StrStr(string(OtherSideActor.ThisTag), OtherSideURL), NotEqual_ObjectObject(OtherSideActor, self)))
			{
				break;
			}
		}
	}
	return;
}

simulated function ActorEntered(Actor Other)
{
	local Vector L;
	local Rotator R;
	local Controller P;

	if(Not_PreBool(Other.bJustTeleported))
	{
		Generate();
		if(NotEqual_ObjectObject(OtherSideActor, none))
		{
			Other.Disable('Touch');
			Other.Disable('UnTouch');
			L = Other.Location;
			if(NotEqual_ObjectObject(Pawn(Other), none))
			{
				R = Pawn(Other).GetViewRotation();
			}
			UnWarp(L, Other.Velocity, R);
			OtherSideActor.Warp(L, Other.Velocity, R);
			if(Other.IsA('Pawn'))
			{
				Pawn(Other).bWarping = bNoTeleFrag;
				if(Other.SetLocation(L))
				{
					if(EqualEqual_IntInt(int(Role), int(ROLE_Authority)))
					{
						P = Level.ControllerList;
						J0x129:

						if(NotEqual_ObjectObject(P, none))
						{
							if(EqualEqual_ObjectObject(P.Enemy, Other))
							{
								P.LineOfSightTo(Other);
							}
							P = P.nextController;
							// [Loop Continue]
							goto J0x129;
						}
					}
					R.Roll = 0;
					Pawn(Other).SetViewRotation(R);
					Pawn(Other).ClientSetLocation(L, R);
					if(NotEqual_ObjectObject(Pawn(Other).Controller, none))
					{
						Pawn(Other).Controller.MoveTimer = -1.0000000;
					}
				}
				else
				{
					GotoState('DelayedWarp');
				}
			}
			else
			{
				Other.SetLocation(L);
				Other.SetRotation(R);
			}
			Other.Enable('Touch');
			Other.Enable('UnTouch');
		}
	}
	return;
}

event ActorLeaving(Actor Other)
{
	if(Other.IsA('Pawn'))
	{
		Pawn(Other).bWarping = false;
	}
	return;
}

state DelayedWarp
{
	function Tick(float DeltaTime)
	{
		local Controller P;
		local bool bFound;

		P = Level.ControllerList;
		J0x14:

		if(NotEqual_ObjectObject(P, none))
		{
			if(AndAnd_BoolBool(P.Pawn.bWarping, EqualEqual_ObjectObject(P.Pawn.Region.Zone, self)))
			{
				bFound = true;
				ActorEntered(P);
			}
			P = P.nextController;
			// [Loop Continue]
			goto J0x14;
		}
		if(Not_PreBool(bFound))
		{
			GotoState('None');
		}
		return;
	}
	stop;
}
