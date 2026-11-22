class Teleporter extends SmallNavigationPoint
	native
	config
	placeable
	hidecategories(Karma,Lighting,LightColor,Karma,Force);

var string URL;
var name ProductRequired;
var bool bChangesVelocity;
var bool bChangesYaw;
var bool bReversesX;
var bool bReversesY;
var bool bReversesZ;
var bool bEnabled;
var Vector TargetVelocity;
var Actor TriggerActor;
var Actor TriggerActor2;
var float LastFired;

replication
{
	// Pos:0x000
	reliable if(EqualEqual_IntInt(int(Role), int(ROLE_Authority)))
		URL, bEnabled;

	// Pos:0x00D
	reliable if(AndAnd_BoolBool(bNetInitial, EqualEqual_IntInt(int(Role), int(ROLE_Authority))))
		TargetVelocity, bChangesVelocity,
		bChangesYaw, bReversesX,
		bReversesY, bReversesZ;
}

function PostBeginPlay()
{
	if(ComplementEqual_StrStr(URL, ""))
	{
		SetCollision(false, false, false);
	}
	if(Not_PreBool(bEnabled))
	{
		FindTriggerActor();
	}
	super(NavigationPoint).PostBeginPlay();
	return;
}

function FindTriggerActor()
{
	local Actor A;

	TriggerActor = none;
	TriggerActor2 = none;
	foreach DynamicActors(Class'Engine.Actor', A)
	{
		if(EqualEqual_NameName(A.Event, Tag))
		{
			if(EqualEqual_ObjectObject(TriggerActor, none))
			{
				TriggerActor = A;
				continue;
			}
			TriggerActor2 = A;
			return;
		}
	}
	return;
}

simulated function bool Accept(Actor Incoming, Actor Source)
{
	local Rotator NewRot, OldRot;
	local float mag;
	local Vector oldDir;
	local Controller P;

	if(EqualEqual_ObjectObject(Incoming, none))
	{
		return false;
	}
	Disable('Touch');
	NewRot = Incoming.Rotation;
	if(bChangesYaw)
	{
		OldRot = Incoming.Rotation;
		NewRot.Yaw = Rotation.Yaw;
		if(NotEqual_ObjectObject(Source, none))
		{
			AddEqual_IntInt(NewRot.Yaw, Subtract_IntInt(Add_IntInt(32768, Incoming.Rotation.Yaw), Source.Rotation.Yaw));
		}
	}
	if(NotEqual_ObjectObject(Pawn(Incoming), none))
	{
		if(EqualEqual_IntInt(int(Role), int(ROLE_Authority)))
		{
			P = Level.ControllerList;
			J0xD4:

			if(NotEqual_ObjectObject(P, none))
			{
				if(EqualEqual_ObjectObject(P.Enemy, Incoming))
				{
					P.LineOfSightTo(Incoming);
				}
				P = P.nextController;
				// [Loop Continue]
				goto J0xD4;
			}
		}
		if(Not_PreBool(Pawn(Incoming).SetLocation(Location)))
		{
			Log(Concat_StrStr(Concat_StrStr(string(self), " Teleport failed for "), string(Incoming)));
			return false;
		}
		if(OrOr_BoolBool(EqualEqual_IntInt(int(Role), int(ROLE_Authority)), Greater_FloatFloat(Subtract_FloatFloat(Level.TimeSeconds, LastFired), 0.5000000)))
		{
			NewRot.Roll = 0;
			Pawn(Incoming).SetRotation(NewRot);
			Pawn(Incoming).SetViewRotation(NewRot);
			Pawn(Incoming).ClientSetRotation(NewRot);
			LastFired = Level.TimeSeconds;
		}
		if(NotEqual_ObjectObject(Pawn(Incoming).Controller, none))
		{
			Pawn(Incoming).Controller.MoveTimer = -1.0000000;
			Pawn(Incoming).Anchor = self;
			Pawn(Incoming).SetMoveTarget(self);
		}
		Incoming.PlayTeleportEffect(false, true);
	}
	else
	{
		if(Not_PreBool(Incoming.SetLocation(Location)))
		{
			Enable('Touch');
			return false;
		}
		if(bChangesYaw)
		{
			Incoming.SetRotation(NewRot);
		}
	}
	Enable('Touch');
	if(bChangesVelocity)
	{
		Incoming.Velocity = TargetVelocity;
	}
	else
	{
		if(bChangesYaw)
		{
			if(EqualEqual_IntInt(int(Incoming.Physics), int(1)))
			{
				OldRot.Pitch = 0;
			}
			oldDir = Vector(OldRot);
			mag = Dot_VectorVector(Incoming.Velocity, oldDir);
			Incoming.Velocity = Add_VectorVector(Subtract_VectorVector(Incoming.Velocity, Multiply_FloatVector(mag, oldDir)), Multiply_FloatVector(mag, Vector(Incoming.Rotation)));
		}
		if(bReversesX)
		{
			MultiplyEqual_FloatFloat(Incoming.Velocity.X, -1.0000000);
		}
		if(bReversesY)
		{
			MultiplyEqual_FloatFloat(Incoming.Velocity.Y, -1.0000000);
		}
		if(bReversesZ)
		{
			MultiplyEqual_FloatFloat(Incoming.Velocity.Z, -1.0000000);
		}
	}
	return true;
	return;
}

function Trigger(Actor Other, Pawn EventInstigator)
{
	local Actor A;

	bEnabled = Not_PreBool(bEnabled);
	if(bEnabled)
	{
		foreach TouchingActors(Class'Engine.Actor', A)
		{
			PostTouch(A);
		}
	}
	return;
}

event Touch(Actor Other)
{
	if(OrOr_BoolBool(Not_PreBool(bEnabled), EqualEqual_ObjectObject(Other, none)))
	{
		return;
	}
	if(AndAnd_BoolBool(Other.bCanTeleport, EqualEqual_BoolBool(Other.PreTeleport(self), false)))
	{
		PendingTouch = Other.PendingTouch;
		Other.PendingTouch = self;
	}
	return;
}

simulated function PostTouch(Actor Other)
{
	local Teleporter D, Dest[16];
	local int i;

	if(OrOr_BoolBool(GreaterEqual_IntInt(InStr(URL, "/"), 0), GreaterEqual_IntInt(InStr(URL, "#"), 0)))
	{
		if(AndAnd_BoolBool(AndAnd_BoolBool(EqualEqual_IntInt(int(Role), int(ROLE_Authority)), NotEqual_ObjectObject(Pawn(Other), none)), Pawn(Other).IsHumanControlled()))
		{
			Level.Game.SendPlayer(PlayerController(Pawn(Other).Controller), URL);
		}
	}
	else
	{
		foreach AllActors(Class'Engine.Teleporter', D)
		{
			if(AndAnd_BoolBool(ComplementEqual_StrStr(string(D.Tag), URL), NotEqual_ObjectObject(D, self)))
			{
				Dest[i] = D;
				AddAdd_Int(i);
				if(Greater_IntInt(i, 16))
				{
					break;
				}
			}
		}
		i = Rand(i);
		if(NotEqual_ObjectObject(Dest[i], none))
		{
			if(Other.IsA('Pawn'))
			{
				Other.PlayTeleportEffect(false, true);
			}
			Dest[i].Accept(Other, self);
			if(NotEqual_ObjectObject(Pawn(Other), none))
			{
				TriggerEvent(Event, self, Pawn(Other));
			}
		}
	}
	return;
}

function Actor SpecialHandling(Pawn Other)
{
	local Vector Dist2D;

	if(AndAnd_BoolBool(AndAnd_BoolBool(bEnabled, NotEqual_ObjectObject(Teleporter(Other.Controller.RouteCache[1]), none)), ComplementEqual_StrStr(string(Other.Controller.RouteCache[1].Tag), URL)))
	{
		if(Less_FloatFloat(Abs(Subtract_FloatFloat(Location.Z, Other.Location.Z)), Add_FloatFloat(CollisionHeight, Other.CollisionHeight)))
		{
			Dist2D = Subtract_VectorVector(Location, Other.Location);
			Dist2D.Z = 0.0000000;
			if(Less_FloatFloat(VSize(Dist2D), Add_FloatFloat(CollisionRadius, Other.CollisionRadius)))
			{
				PostTouch(Other);
			}
		}
		return self;
	}
	if(EqualEqual_ObjectObject(TriggerActor, none))
	{
		FindTriggerActor();
		if(EqualEqual_ObjectObject(TriggerActor, none))
		{
			return none;
		}
	}
	if(AndAnd_BoolBool(NotEqual_ObjectObject(TriggerActor2, none), Less_FloatFloat(VSize(Subtract_VectorVector(TriggerActor2.Location, Other.Location)), VSize(Subtract_VectorVector(TriggerActor.Location, Other.Location)))))
	{
		return TriggerActor2;
	}
	return TriggerActor;
	return;
}

defaultproperties
{
	bChangesYaw=true
	bEnabled=true
	RemoteRole=2
	Texture=Texture'Engine_res.S_Teleport'
	bCollideActors=true
	bDirectional=true
}