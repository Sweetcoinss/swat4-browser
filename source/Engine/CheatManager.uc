class CheatManager extends Object within PlayerController
	native;

var Rotator LockedRotation;
var private localized string LookingAtString;

exec function ReviewJumpSpots(name TestLabel)
{
	if(EqualEqual_NameName(TestLabel, 'Transloc'))
	{
		TestLabel = 'Begin';
	}
	else
	{
		if(EqualEqual_NameName(TestLabel, 'Jump'))
		{
			TestLabel = 'Finished';
		}
		else
		{
			if(EqualEqual_NameName(TestLabel, 'Combo'))
			{
				TestLabel = 'FinishedJumping';
			}
			else
			{
				if(EqualEqual_NameName(TestLabel, 'LowGrav'))
				{
					TestLabel = 'FinishedComboJumping';
				}
			}
		}
	}
	Log(Concat_StrStr("TestLabel is ", string(TestLabel)));
	Outer.Level.Game.ReviewJumpSpots(TestLabel);
	return;
}

exec function ListDynamicActors()
{
	local Actor A;
	local int i;

	foreach Outer.DynamicActors(Class'Engine.Actor', A)
	{
		AddAdd_Int(i);
		Log(At_StrStr(string(i), string(A)));
	}
	Log(Concat_StrStr("Num dynamic actors: ", string(i)));
	return;
}

exec function FreezeFrame(float Delay)
{
	Outer.Level.Game.SetPause(true, Outer);
	Outer.Level.PauseDelay = Add_FloatFloat(Outer.Level.TimeSeconds, Delay);
	return;
}

exec function WriteToLog()
{
	Log("NOW!");
	return;
}

exec function SetFlash(float F)
{
	Outer.FlashScale.X = F;
	return;
}

exec function SetFogR(float F)
{
	Outer.FlashFog.X = F;
	return;
}

exec function SetFogG(float F)
{
	Outer.FlashFog.Y = F;
	return;
}

exec function SetFogB(float F)
{
	Outer.FlashFog.Z = F;
	return;
}

exec function KillViewedActor()
{
	if(NotEqual_ObjectObject(Outer.ViewTarget, none))
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(Pawn(Outer.ViewTarget), none), NotEqual_ObjectObject(Pawn(Outer.ViewTarget).Controller, none)))
		{
			Pawn(Outer.ViewTarget).Controller.Destroy();
		}
		Outer.ViewTarget.Destroy();
		Outer.SetViewTarget(none);
	}
	return;
}

exec function LogScriptedSequences()
{
	return;
}

exec function Teleport()
{
	local Actor HitActor;
	local Vector HitNormal, HitLocation;

	HitActor = Outer.Trace(HitLocation, HitNormal, Add_VectorVector(Outer.ViewTarget.Location, Multiply_FloatVector(float(10000), Vector(Outer.Rotation))), Outer.ViewTarget.Location, true);
	if(EqualEqual_ObjectObject(HitActor, none))
	{
		HitLocation = Add_VectorVector(Outer.ViewTarget.Location, Multiply_FloatVector(float(10000), Vector(Outer.Rotation)));
	}
	else
	{
		HitLocation = Add_VectorVector(HitLocation, Multiply_FloatVector(Outer.ViewTarget.CollisionRadius, HitNormal));
	}
	Outer.ViewTarget.SetLocation(HitLocation);
	return;
}

exec function ChangeSize(float F)
{
	if(Outer.Pawn.SetCollisionSize(Multiply_FloatFloat(Outer.Pawn.default.CollisionRadius, F), Multiply_FloatFloat(Outer.Pawn.default.CollisionHeight, F)))
	{
		Outer.Pawn.SetDrawScale(F);
		Outer.Pawn.SetLocation(Outer.Pawn.Location);
	}
	return;
}

exec function LockCamera()
{
	local Vector LockedLocation;
	local Rotator LockedRot;
	local Actor LockedActor;

	if(Not_PreBool(Outer.bCameraPositionLocked))
	{
		Outer.PlayerCalcView(LockedActor, LockedLocation, LockedRot);
		Outer.SetLocation(LockedLocation);
		LockedRotation = LockedRot;
		Outer.SetViewTarget(Outer);
	}
	else
	{
		Outer.SetViewTarget(Outer.Pawn);
	}
	Outer.bCameraPositionLocked = Not_PreBool(Outer.bCameraPositionLocked);
	Outer.bBehindView = Outer.bCameraPositionLocked;
	Outer.bFreeCamera = false;
	return;
}

exec function SetCameraDist(float F)
{
	Outer.CameraDist = FMax(F, 2.0000000);
	return;
}

exec function EndPath()
{
	return;
}

exec function FreeCamera(bool B)
{
	Outer.bFreeCamera = B;
	Outer.bBehindView = B;
	return;
}

exec function CauseEvent(name EventName)
{
	Outer.TriggerEvent(EventName, Outer.Pawn, Outer.Pawn);
	return;
}

exec function Fly()
{
	if(EqualEqual_ObjectObject(Outer.Pawn, none))
	{
		return;
	}
	Outer.ClientMessage("You feel much lighter");
	Outer.Pawn.SetCollision(true, true, true);
	Outer.Pawn.bCollideWorld = true;
	Outer.bCheatFlying = true;
	Outer.GotoState('PlayerFlying');
	return;
}

exec function Walk()
{
	if(NotEqual_ObjectObject(Outer.Pawn, none))
	{
		Outer.bCheatFlying = false;
		Outer.Pawn.SetCollision(true, true, true);
		Outer.Pawn.SetPhysics(1);
		Outer.Pawn.bCollideWorld = true;
		Outer.ClientRestart();
	}
	return;
}

exec function Ghost()
{
	if(AndAnd_BoolBool(NotEqual_ObjectObject(Outer.Pawn, none), Not_PreBool(Outer.Pawn.IsA('Vehicle'))))
	{
		Outer.ClientMessage("You feel ethereal");
		Outer.Pawn.SetCollision(false, false, false);
		Outer.Pawn.bCollideWorld = false;
		Outer.bCheatFlying = true;
		Outer.GotoState('PlayerFlying');
	}
	else
	{
		Log("Can't Ghost In Vehicles");
	}
	return;
}

exec function Invisible(bool B)
{
	Outer.Pawn.bHidden = B;
	if(B)
	{
		Outer.Pawn.Visibility = 0;
	}
	else
	{
		Outer.Pawn.Visibility = Outer.Pawn.default.Visibility;
	}
	return;
}

exec function God()
{
	if(EqualEqual_IntInt(int(Outer.Level.NetMode), int(NM_Client)))
	{
		return;
	}
	if(NotEqual_IntInt(int(Outer.Level.NetMode), int(NM_Standalone)))
	{
		if(Outer.Level.IsCOOPServer)
		{
			ToggleGodModeForCoopPlayers();
		}
		return;
	}
	if(Outer.bGodMode)
	{
		Outer.bGodMode = false;
		Outer.ClientMessage("God mode off");
		return;
	}
	Outer.bGodMode = true;
	Outer.ClientMessage("God Mode on");
	return;
}

function ToggleGodModeForCoopPlayers()
{
	local Controller Controller;
	local PlayerController PlayerController;

	Outer.bGodMode = Not_PreBool(Outer.bGodMode);
	if(Outer.bGodMode)
	{
		Outer.ClientMessage("God mode on");
	}
	else
	{
		Outer.ClientMessage("God mode off");
	}
	Controller = Outer.Level.ControllerList;
	J0x8C:

	if(NotEqual_ObjectObject(Controller, none))
	{
		PlayerController = PlayerController(Controller);
		if(NotEqual_ObjectObject(PlayerController, none))
		{
			PlayerController.bGodMode = Outer.bGodMode;
		}
		Controller = Controller.nextController;
		// [Loop Continue]
		goto J0x8C;
	}
	return;
}

exec function SloMo(float t)
{
	Outer.Level.Game.SetGameSpeed(t);
	return;
}

exec function SetJumpZ(float F)
{
	Outer.Pawn.JumpZ = F;
	return;
}

exec function SetGravity(float F)
{
	Outer.PhysicsVolume.Gravity.Z = F;
	return;
}

exec function SetSpeed(float F)
{
	Outer.Pawn.GroundSpeed = Multiply_FloatFloat(Outer.Pawn.default.GroundSpeed, F);
	Outer.Pawn.WaterSpeed = Multiply_FloatFloat(Outer.Pawn.default.WaterSpeed, F);
	return;
}

exec function KillAll(Class<Actor> aClass)
{
	local Actor A;

	if(ClassIsChildOf(aClass, Class'Engine.Pawn'))
	{
		KillAllPawns(Class<Pawn>(aClass));
		return;
	}
	foreach Outer.DynamicActors(Class'Engine.Actor', A)
	{
		if(ClassIsChildOf(A.Class, aClass))
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("KillAll(", string(aClass.Name)), ") destroying "), string(A)));
			A.Destroy();
		}
	}
	return;
}

function KillAllPawns(Class<Pawn> aClass)
{
	local Pawn P;

	Outer.Level.Game.KillBots(Outer.Level.Game.NumBots);
	foreach Outer.DynamicActors(Class'Engine.Pawn', P)
	{
		if(AndAnd_BoolBool(ClassIsChildOf(P.Class, aClass), Not_PreBool(P.IsPlayerPawn())))
		{
			P.TakeDamage(10000, none, vect(0.0000000, 0.0000000, 0.0000000), vect(0.0000000, 0.0000000, 0.0000000), Class'Engine.DamageType');
		}
	}
	return;
}

exec function KillPawns()
{
	KillAllPawns(Class'Engine.Pawn');
	return;
}

exec function Avatar(string ClassName)
{
	local Class<Actor> NewClass;
	local Pawn P;

	NewClass = Class<Actor>(DynamicLoadObject(ClassName, Class'Core.Class'));
	if(NotEqual_ObjectObject(NewClass, none))
	{
		foreach Outer.DynamicActors(Class'Engine.Pawn', P)
		{
			if(AndAnd_BoolBool(EqualEqual_ObjectObject(P.Class, NewClass), NotEqual_ObjectObject(P, Outer.Pawn)))
			{
				if(NotEqual_ObjectObject(Outer.Pawn.Controller, none))
				{
					Outer.Pawn.Controller.PawnDied(Outer.Pawn);
				}
				Outer.Possess(P);
				break;
			}
		}
	}
	return;
}

exec function Summon(string ClassName)
{
	local Class<Actor> NewClass;
	local Vector SpawnLoc;

	Log(Concat_StrStr("Fabricate ", ClassName));
	NewClass = Class<Actor>(DynamicLoadObject(ClassName, Class'Core.Class'));
	if(NotEqual_ObjectObject(NewClass, none))
	{
		if(NotEqual_ObjectObject(Outer.Pawn, none))
		{
			SpawnLoc = Outer.Pawn.Location;
		}
		else
		{
			SpawnLoc = Outer.Location;
		}
		Outer.Spawn(NewClass,,, Add_VectorVector(Add_VectorVector(SpawnLoc, Multiply_FloatVector(float(72), Vector(Outer.Rotation))), Multiply_VectorFloat(vect(0.0000000, 0.0000000, 1.0000000), float(15))));
	}
	return;
}

exec function PlayersOnly()
{
	Outer.Level.bPlayersOnly = Not_PreBool(Outer.Level.bPlayersOnly);
	return;
}

exec function CheatView(Class<Actor> aClass, optional bool bQuiet)
{
	ViewClass(aClass, bQuiet, true);
	return;
}

exec function RememberSpot()
{
	if(NotEqual_ObjectObject(Outer.Pawn, none))
	{
		Outer.Destination = Outer.Pawn.Location;
	}
	else
	{
		Outer.Destination = Outer.Location;
	}
	return;
}

exec function ViewSelf(optional bool bQuiet)
{
	Outer.bBehindView = false;
	Outer.bViewBot = false;
	if(NotEqual_ObjectObject(Outer.Pawn, none))
	{
		Outer.SetViewTarget(Outer.Pawn);
	}
	else
	{
		Outer.SetViewTarget(Outer);
	}
	if(Not_PreBool(bQuiet))
	{
		Outer.ClientMessage(Outer.OwnCamera, 'DebugMessage');
	}
	Outer.FixFOV();
	return;
}

exec function ViewPlayer(string S)
{
	local Controller P;

	P = Outer.Level.ControllerList;
	J0x1D:

	if(NotEqual_ObjectObject(P, none))
	{
		if(AndAnd_BoolBool(P.bIsPlayer, ComplementEqual_StrStr(P.PlayerReplicationInfo.PlayerName, S)))
		{
			// [Explicit Break]
			goto J0x77;
		}
		P = P.nextController;
		// [Loop Continue]
		goto J0x1D;
	}
	J0x77:

	if(NotEqual_ObjectObject(P.Pawn, none))
	{
		Outer.ClientMessage(At_StrStr(LookingAtString, P.PlayerReplicationInfo.PlayerName), 'DebugMessage');
		Outer.SetViewTarget(P.Pawn);
	}
	Outer.bBehindView = NotEqual_ObjectObject(Outer.ViewTarget, Outer.Pawn);
	if(Outer.bBehindView)
	{
		Outer.ViewTarget.BecomeViewTarget();
	}
	return;
}

exec function ViewActor(name ActorName)
{
	local Actor A;

	foreach Outer.AllActors(Class'Engine.Actor', A)
	{
		if(EqualEqual_NameName(A.Name, ActorName))
		{
			Outer.SetViewTarget(A);
			Outer.bBehindView = true;
			return;
		}
	}
	return;
}

exec function ViewBot()
{
	local Actor first;
	local bool bFound;
	local Controller C;

	Outer.bViewBot = true;
	C = Outer.Level.ControllerList;
	J0x2E:

	if(NotEqual_ObjectObject(C, none))
	{
		if(AndAnd_BoolBool(C.IsA('AIController'), NotEqual_ObjectObject(C.Pawn, none)))
		{
			if(OrOr_BoolBool(bFound, EqualEqual_ObjectObject(first, none)))
			{
				first = C.Pawn;
				if(bFound)
				{
					// [Explicit Break]
					goto J0xD9;
				}
			}
			if(EqualEqual_ObjectObject(C.Pawn, Outer.ViewTarget))
			{
				bFound = true;
			}
		}
		C = C.nextController;
		// [Loop Continue]
		goto J0x2E;
	}
	J0xD9:

	if(NotEqual_ObjectObject(first, none))
	{
		Outer.SetViewTarget(first);
		Outer.bBehindView = true;
		Outer.ViewTarget.BecomeViewTarget();
		Outer.FixFOV();
	}
	else
	{
		ViewSelf(true);
	}
	return;
}

exec function ViewClass(Class<Actor> aClass, optional bool bQuiet, optional bool bCheat)
{
	local Actor Other, first;
	local bool bFound;

	if(AndAnd_BoolBool(AndAnd_BoolBool(Not_PreBool(bCheat), NotEqual_ObjectObject(Outer.Level.Game, none)), Not_PreBool(Outer.Level.Game.bCanViewOthers)))
	{
		return;
	}
	first = none;
	foreach Outer.AllActors(aClass, Other)
	{
		if(OrOr_BoolBool(bFound, EqualEqual_ObjectObject(first, none)))
		{
			first = Other;
			if(bFound)
			{
				break;
			}
		}
		if(EqualEqual_ObjectObject(Other, Outer.ViewTarget))
		{
			bFound = true;
		}
	}
	if(NotEqual_ObjectObject(first, none))
	{
		if(Not_PreBool(bQuiet))
		{
			if(NotEqual_ObjectObject(Pawn(first), none))
			{
				Outer.ClientMessage(At_StrStr(LookingAtString, first.GetHumanReadableName()), 'DebugMessage');
			}
			else
			{
				Outer.ClientMessage(At_StrStr(LookingAtString, string(first)), 'DebugMessage');
			}
		}
		Outer.SetViewTarget(first);
		Outer.bBehindView = NotEqual_ObjectObject(Outer.ViewTarget, Outer);
		if(Outer.bBehindView)
		{
			Outer.ViewTarget.BecomeViewTarget();
		}
		Outer.FixFOV();
	}
	else
	{
		ViewSelf(bQuiet);
	}
	return;
}

exec function DebugShadowProjectors()
{
	local ShadowProjector SP;

	Log("Toggling Shadow volume debugging");
	foreach Outer.AllActors(Class'Engine.ShadowProjector', SP)
	{
		SP.bDebugShadow = Not_PreBool(SP.bDebugShadow);
	}
	return;
}

exec function SetShadowProjectorClipShift(float ShiftAmount)
{
	local ShadowProjector SP;

	Log("Setting Shadow volume NearClip position shift");
	foreach Outer.AllActors(Class'Engine.ShadowProjector', SP)
	{
		SP.bShiftNearClip = true;
		SP.NearClipShiftAmount = ShiftAmount;
	}
	return;
}

defaultproperties
{
	LookingAtString="Now viewing: "
}