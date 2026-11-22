class Mover extends Actor
	native
	nativereplication
	config
	notplaceable
	hidecategories(Karma);

enum EMoverEncroachType
{
	ME_StopWhenEncroach,            // 0
	ME_ReturnWhenEncroach,          // 1
	ME_CrushWhenEncroach,           // 2
	ME_IgnoreWhenEncroach           // 3
};

enum EMoverGlideType
{
	MV_MoveByTime,                  // 0
	MV_GlideByTime                  // 1
};

enum EBumpType
{
	BT_PlayerBump,                  // 0
	BT_PawnBump,                    // 1
	BT_AnyBump                      // 2
};

var Mover.EMoverEncroachType MoverEncroachType;
var Mover.EMoverGlideType MoverGlideType;
var Mover.EBumpType BumpType;
var byte KeyNum;
var byte PrevKeyNum;
var const byte NumKeys;
var const byte WorldRaytraceKey;
var const byte BrushRaytraceKey;
var float MoveTime;
var float StayOpenTime;
var float OtherTime;
var int EncroachDamage;
var bool bTriggerOnceOnly;
var bool bSlave;
var bool bUseTriggered;
var bool bDamageTriggered;
var bool bDynamicLightMover;
var bool bUseShortestRotation;
var(ReturnGroup) bool bIsLeader;
var name PlayerBumpEvent;
var name BumpEvent;
var Actor SavedTrigger;
var float DamageThreshold;
var int numTriggerEvents;
var Mover Leader;
var Mover Follower;
var(ReturnGroup) name ReturnGroup;
var float DelayTime;
var(MoverSounds) Sound OpeningSound;
var(MoverSounds) Sound OpenedSound;
var(MoverSounds) Sound ClosingSound;
var(MoverSounds) Sound ClosedSound;
var(MoverSounds) Sound LoopSound;
var(MoverEvents) name OpeningEvent;
var(MoverEvents) name OpenedEvent;
var(MoverEvents) name ClosingEvent;
var(MoverEvents) name ClosedEvent;
var(MoverEvents) name LoopEvent;
var Vector KeyPos[24];
var Rotator KeyRot[24];
var Vector BasePos;
var Vector OldPos;
var Vector OldPrePivot;
var Vector SavedPos;
var Rotator BaseRot;
var Rotator OldRot;
var Rotator SavedRot;
var float PhysAlpha;
var float PhysRate;
var NavigationPoint myMarker;
var bool bOpening;
var bool bDelaying;
var bool bClientPause;
var bool bClosed;
var bool bPlayerOnly;
var(AI) bool bAutoDoor;
var(AI) bool bNoAIRelevance;
var Vector SimOldPos;
var int SimOldRotPitch;
var int SimOldRotYaw;
var int SimOldRotRoll;
var Vector SimInterpolate;
var Vector RealPosition;
var Rotator RealRotation;
var int ClientUpdate;
var array<AntiPortalActor> AntiPortals;
var name AntiPortalTag;

replication
{
	// Pos:0x000
	reliable if(EqualEqual_IntInt(int(Role), int(ROLE_Authority)))
		RealPosition, RealRotation,
		SimInterpolate, SimOldPos,
		SimOldRotPitch, SimOldRotRoll,
		SimOldRotYaw;
}

simulated function StartInterpolation()
{
	GotoState('None');
	bInterpolating = true;
	SetPhysics(0);
	return;
}

simulated function Timer()
{
	if(NotEqual_VectorVector(Velocity, vect(0.0000000, 0.0000000, 0.0000000)))
	{
		bClientPause = false;
		return;
	}
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		if(EqualEqual_IntInt(ClientUpdate, 0))
		{
			if(bClientPause)
			{
				if(Greater_FloatFloat(VSize(Subtract_VectorVector(RealPosition, Location)), float(3)))
				{
					SetLocation(RealPosition);
				}
				else
				{
					RealPosition = Location;
				}
				SetRotation(RealRotation);
				bClientPause = false;
			}
			else
			{
				if(NotEqual_VectorVector(RealPosition, Location))
				{
					bClientPause = true;
				}
			}
		}
		else
		{
			bClientPause = false;
		}
	}
	else
	{
		RealPosition = Location;
		RealRotation = Rotation;
	}
	return;
}

final simulated function InterpolateTo(byte NewKeyNum, float Seconds)
{
	NewKeyNum = byte(Clamp(int(NewKeyNum), 0, Subtract_IntInt(24, 1)));
	if(AndAnd_BoolBool(EqualEqual_IntInt(int(NewKeyNum), int(PrevKeyNum)), NotEqual_IntInt(int(KeyNum), int(PrevKeyNum))))
	{
		PhysAlpha = Subtract_FloatFloat(1.0000000, PhysAlpha);
		OldPos = Add_VectorVector(BasePos, KeyPos[int(KeyNum)]);
		OldRot = Add_RotatorRotator(BaseRot, KeyRot[int(KeyNum)]);
	}
	else
	{
		OldPos = Location;
		OldRot = Rotation;
		PhysAlpha = 0.0000000;
	}
	SetPhysics(8);
	bInterpolating = true;
	PrevKeyNum = KeyNum;
	KeyNum = NewKeyNum;
	PhysRate = Divide_FloatFloat(1.0000000, FMax(Seconds, 0.0050000));
	AddAdd_Int(ClientUpdate);
	SimOldPos = OldPos;
	SimOldRotYaw = OldRot.Yaw;
	SimOldRotPitch = OldRot.Pitch;
	SimOldRotRoll = OldRot.Roll;
	SimInterpolate.X = Multiply_FloatFloat(100.0000000, PhysAlpha);
	SimInterpolate.Y = Multiply_FloatFloat(100.0000000, FMax(0.0100000, PhysRate));
	SimInterpolate.Z = Add_FloatFloat(Multiply_FloatFloat(256.0000000, float(PrevKeyNum)), float(KeyNum));
	return;
}

final function SetKeyframe(byte NewKeyNum, Vector NewLocation, Rotator NewRotation)
{
	KeyNum = byte(Clamp(int(NewKeyNum), 0, Subtract_IntInt(24, 1)));
	KeyPos[int(KeyNum)] = NewLocation;
	KeyRot[int(KeyNum)] = NewRotation;
	return;
}

simulated event KeyFrameReached()
{
	local byte OldKeyNum;

	OldKeyNum = PrevKeyNum;
	PrevKeyNum = KeyNum;
	PhysAlpha = 0.0000000;
	SubtractSubtract_Int(ClientUpdate);
	if(AndAnd_BoolBool(Greater_IntInt(int(KeyNum), 0), Less_IntInt(int(KeyNum), int(OldKeyNum))))
	{
		InterpolateTo(byte(Subtract_IntInt(int(KeyNum), 1)), MoveTime);
	}
	else
	{
		if(AndAnd_BoolBool(Less_IntInt(int(KeyNum), Subtract_IntInt(int(NumKeys), 1)), Greater_IntInt(int(KeyNum), int(OldKeyNum))))
		{
			InterpolateTo(byte(Add_IntInt(int(KeyNum), 1)), MoveTime);
		}
		else
		{
			if(AndAnd_BoolBool(EqualEqual_IntInt(ClientUpdate, 0), NotEqual_IntInt(int(Level.NetMode), int(NM_Client))))
			{
				RealPosition = Location;
				RealRotation = Rotation;
			}
		}
	}
	return;
}

function FinishNotify()
{
	local Controller C;

	C = Level.ControllerList;
	J0x14:

	if(NotEqual_ObjectObject(C, none))
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(C.Pawn, none), EqualEqual_ObjectObject(C.PendingMover, self)))
		{
			C.MoverFinished();
		}
		C = C.nextController;
		// [Loop Continue]
		goto J0x14;
	}
	return;
}

function FinishedClosing()
{
	local Mover M;

	UnTriggerEffectEvent('Closing');
	TriggerEffectEvent('Closed');
	TriggerEvent(ClosedEvent, self, Instigator);
	if(NotEqual_ObjectObject(SavedTrigger, none))
	{
		SavedTrigger.EndEvent();
	}
	SavedTrigger = none;
	Instigator = none;
	if(NotEqual_ObjectObject(myMarker, none))
	{
		myMarker.MoverClosed();
	}
	bClosed = true;
	FinishNotify();
	M = Leader;
	J0x82:

	if(NotEqual_ObjectObject(M, none))
	{
		if(Not_PreBool(M.bClosed))
		{
			return;
		}
		M = M.Follower;
		// [Loop Continue]
		goto J0x82;
	}
	UntriggerEvent(OpeningEvent, self, Instigator);
	return;
}

function FinishedOpening()
{
	UnTriggerEffectEvent('Opening');
	TriggerEffectEvent('Opened');
	TriggerEvent(Event, self, Instigator);
	TriggerEvent(OpenedEvent, self, Instigator);
	if(NotEqual_ObjectObject(myMarker, none))
	{
		myMarker.MoverOpened();
	}
	FinishNotify();
	return;
}

function DoOpen()
{
	bOpening = true;
	bDelaying = false;
	InterpolateTo(1, MoveTime);
	MakeNoise(1.0000000);
	TriggerEffectEvent('Opening');
	TriggerEvent(OpeningEvent, self, Instigator);
	if(NotEqual_ObjectObject(Follower, none))
	{
		Follower.DoOpen();
	}
	return;
}

function DoClose()
{
	bOpening = false;
	bDelaying = false;
	InterpolateTo(byte(Max(0, Subtract_IntInt(int(KeyNum), 1))), MoveTime);
	MakeNoise(1.0000000);
	TriggerEffectEvent('Closing');
	UntriggerEvent(Event, self, Instigator);
	TriggerEvent(ClosingEvent, self, Instigator);
	if(NotEqual_ObjectObject(Follower, none))
	{
		Follower.DoClose();
	}
	return;
}

simulated function BeginPlay()
{
	local AntiPortalActor AntiPortal;

	if(NotEqual_NameName(AntiPortalTag, 'None'))
	{
		foreach AllActors(Class'Engine.AntiPortalActor', AntiPortal, AntiPortalTag)
		{
			AntiPortals.Length = Add_IntInt(AntiPortals.Length, 1);
			AntiPortals[Subtract_IntInt(AntiPortals.Length, 1)] = AntiPortal;
		}
	}
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)))
		{
			SetTimer(4.0000000, true);
		}
		else
		{
			SetTimer(1.0000000, true);
		}
		if(Less_IntInt(int(Role), int(ROLE_Authority)))
		{
			return;
		}
	}
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		RealPosition = Location;
		RealRotation = Rotation;
	}
	super.BeginPlay();
	KeyNum = byte(Clamp(int(KeyNum), 0, Subtract_IntInt(24, 1)));
	PhysAlpha = 0.0000000;
	Move(Subtract_VectorVector(Add_VectorVector(BasePos, KeyPos[int(KeyNum)]), Location));
	SetRotation(Add_RotatorRotator(BaseRot, KeyRot[int(KeyNum)]));
	if(EqualEqual_NameName(ReturnGroup, 'None'))
	{
		ReturnGroup = Tag;
	}
	Leader = none;
	Follower = none;
	return;
}

function PostBeginPlay()
{
	local Mover M;

	if(Not_PreBool(bSlave))
	{
		foreach DynamicActors(Class'Engine.Mover', M, Tag)
		{
			if(M.bSlave)
			{
				M.GotoState('None');
				M.SetBase(self);
			}
		}
	}
	if(bIsLeader)
	{
		Leader = self;
		foreach DynamicActors(Class'Engine.Mover', M)
		{
			if(AndAnd_BoolBool(NotEqual_ObjectObject(M, self), EqualEqual_NameName(M.ReturnGroup, ReturnGroup)))
			{
				M.Leader = self;
				M.Follower = Follower;
				Follower = M;
			}
		}
	}
	else
	{
		if(EqualEqual_ObjectObject(Leader, none))
		{
			foreach DynamicActors(Class'Engine.Mover', M)
			{
				if(AndAnd_BoolBool(NotEqual_ObjectObject(M, self), EqualEqual_NameName(M.ReturnGroup, ReturnGroup)))
				{
					return;
				}
			}
			Leader = self;
		}
	}
	return;
}

function MakeGroupStop()
{
	bInterpolating = false;
	GotoState(, 'None');
	if(NotEqual_ObjectObject(Follower, none))
	{
		Follower.MakeGroupStop();
	}
	return;
}

function MakeGroupReturn()
{
	bInterpolating = false;
	if(OrOr_BoolBool(bIsLeader, EqualEqual_ObjectObject(Leader, self)))
	{
		if(Less_IntInt(int(KeyNum), int(PrevKeyNum)))
		{
			GotoState(, 'Open');
		}
		else
		{
			GotoState(, 'Close');
		}
	}
	if(NotEqual_ObjectObject(Follower, none))
	{
		Follower.MakeGroupReturn();
	}
	return;
}

function bool EncroachingOn(Actor Other)
{
	local Pawn P;

	if(EqualEqual_ObjectObject(Other, none))
	{
		return false;
	}
	if(OrOr_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(Pawn(Other), none), EqualEqual_ObjectObject(Pawn(Other).Controller, none)), Other.IsA('Decoration')))
	{
		Other.TakeDamage(10000, none, Other.Location, vect(0.0000000, 0.0000000, 0.0000000), Class'Engine.Crushed');
		return false;
	}
	if(Other.IsA('Pickup'))
	{
		if(AndAnd_BoolBool(Not_PreBool(Other.bAlwaysRelevant), EqualEqual_ObjectObject(Other.Owner, none)))
		{
			Other.Destroy();
		}
		return false;
	}
	if(OrOr_BoolBool(OrOr_BoolBool(Other.IsA('Fragment'), Other.IsA('Gib')), Other.IsA('Projectile')))
	{
		Other.Destroy();
		return false;
	}
	if(NotEqual_IntInt(EncroachDamage, 0))
	{
		Other.TakeDamage(EncroachDamage, Instigator, Other.Location, vect(0.0000000, 0.0000000, 0.0000000), Class'Engine.Crushed');
	}
	P = Pawn(Other);
	if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(P, none), NotEqual_ObjectObject(P.Controller, none)), P.IsPlayerPawn()))
	{
		DoPlayerBumpEvent(Other);
		if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(P, none), NotEqual_ObjectObject(P.Controller, none)), NotEqual_ObjectObject(P.Base, self)), EqualEqual_ObjectObject(P.Controller.PendingMover, self)))
		{
			P.Controller.UnderLift(self);
		}
	}
	if(EqualEqual_IntInt(int(MoverEncroachType), int(0)))
	{
		Leader.MakeGroupStop();
		return true;
	}
	else
	{
		if(EqualEqual_IntInt(int(MoverEncroachType), int(1)))
		{
			Leader.MakeGroupReturn();
			if(Other.IsA('Pawn'))
			{
				Pawn(Other).PlayMoverHitSound();
			}
			return true;
		}
		else
		{
			if(EqualEqual_IntInt(int(MoverEncroachType), int(2)))
			{
				Other.KilledBy(Instigator);
				return false;
			}
			else
			{
				if(EqualEqual_IntInt(int(MoverEncroachType), int(3)))
				{
					return false;
				}
			}
		}
	}
	return;
}

function DoPlayerBumpEvent(Actor Other)
{
	if(NotEqual_NameName(PlayerBumpEvent, 'None'))
	{
		Bump(Other);
	}
	return;
}

function DoBumpEvent(Actor Other)
{
	TriggerEvent(BumpEvent, self, Pawn(Other));
	return;
}

function PostBump(Actor Other)
{
	local Pawn P;

	P = Pawn(Other);
	if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(bUseTriggered, NotEqual_ObjectObject(P, none)), Not_PreBool(P.IsHumanControlled())), P.IsPlayerPawn()))
	{
		Trigger(P, P);
		P.Controller.WaitForMover(self);
	}
	if(AndAnd_BoolBool(NotEqual_IntInt(int(BumpType), int(2)), EqualEqual_ObjectObject(P, none)))
	{
		return;
	}
	if(AndAnd_BoolBool(EqualEqual_IntInt(int(BumpType), int(0)), Not_PreBool(P.IsPlayerPawn())))
	{
		return;
	}
	if(AndAnd_BoolBool(EqualEqual_IntInt(int(BumpType), int(1)), P.bAmbientCreature))
	{
		return;
	}
	DoBumpEvent(P);
	if(AndAnd_BoolBool(NotEqual_ObjectObject(P, none), P.IsPlayerPawn()))
	{
		DoPlayerBumpEvent(P);
	}
	return;
}

function PostTakeDamage(int Damage, Pawn InstigatedBy, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType)
{
	if(AndAnd_BoolBool(bDamageTriggered, GreaterEqual_FloatFloat(float(Damage), DamageThreshold)))
	{
		self.Trigger(self, InstigatedBy);
	}
	return;
}

state OpenTimedMover
{Open:

	bClosed = false;
	DisableTrigger();
	if(Greater_FloatFloat(DelayTime, float(0)))
	{
		bDelaying = true;
		Sleep(DelayTime);
	}
	DoOpen();
	FinishInterpolation();
	FinishedOpening();
	Sleep(StayOpenTime);
	if(bTriggerOnceOnly)
	{
		GotoState('None');
	}
Close:

	DoClose();
	FinishInterpolation();
	FinishedClosing();
	EnableTrigger();
	stop;
}

state() StandOpenTimed extends OpenTimedMover
{
	function Attach(Actor Other)
	{
		local Pawn P;

		P = Pawn(Other);
		if(AndAnd_BoolBool(NotEqual_IntInt(int(BumpType), int(2)), EqualEqual_ObjectObject(P, none)))
		{
			return;
		}
		if(AndAnd_BoolBool(EqualEqual_IntInt(int(BumpType), int(0)), Not_PreBool(P.IsPlayerPawn())))
		{
			return;
		}
		if(AndAnd_BoolBool(EqualEqual_IntInt(int(BumpType), int(1)), Less_FloatFloat(Other.Mass, float(10))))
		{
			return;
		}
		SavedTrigger = none;
		GotoState('StandOpenTimed', 'Open');
		return;
	}

	function DisableTrigger()
	{
		Disable('Attach');
		return;
	}

	function EnableTrigger()
	{
		Enable('Attach');
		return;
	}
	stop;
}

state() BumpOpenTimed extends OpenTimedMover
{
	function PostBump(Actor Other)
	{
		if(AndAnd_BoolBool(NotEqual_IntInt(int(BumpType), int(2)), EqualEqual_ObjectObject(Pawn(Other), none)))
		{
			return;
		}
		if(AndAnd_BoolBool(EqualEqual_IntInt(int(BumpType), int(0)), Not_PreBool(Pawn(Other).IsPlayerPawn())))
		{
			return;
		}
		if(AndAnd_BoolBool(EqualEqual_IntInt(int(BumpType), int(1)), Less_FloatFloat(Other.Mass, float(10))))
		{
			return;
		}
		global.PostBump(Other);
		SavedTrigger = none;
		Instigator = Pawn(Other);
		Instigator.Controller.WaitForMover(self);
		GotoState('BumpOpenTimed', 'Open');
		return;
	}

	function DisableTrigger()
	{
		Disable('Bump');
		return;
	}

	function EnableTrigger()
	{
		Enable('Bump');
		return;
	}
	stop;
}

state() TriggerOpenTimed extends OpenTimedMover
{
	function Trigger(Actor Other, Pawn EventInstigator)
	{
		SavedTrigger = Other;
		Instigator = EventInstigator;
		if(NotEqual_ObjectObject(SavedTrigger, none))
		{
			SavedTrigger.BeginEvent();
		}
		GotoState('TriggerOpenTimed', 'Open');
		return;
	}

	function DisableTrigger()
	{
		Disable('Trigger');
		return;
	}

	function EnableTrigger()
	{
		Enable('Trigger');
		return;
	}
	stop;
}

state() TriggerToggle
{
	function Trigger(Actor Other, Pawn EventInstigator)
	{
		SavedTrigger = Other;
		Instigator = EventInstigator;
		if(NotEqual_ObjectObject(SavedTrigger, none))
		{
			SavedTrigger.BeginEvent();
		}
		if(OrOr_BoolBool(EqualEqual_IntInt(int(KeyNum), 0), Less_IntInt(int(KeyNum), int(PrevKeyNum))))
		{
			GotoState('TriggerToggle', 'Open');
		}
		else
		{
			GotoState('TriggerToggle', 'Close');
		}
		return;
	}
Open:

	bClosed = false;
	if(Greater_FloatFloat(DelayTime, float(0)))
	{
		bDelaying = true;
		Sleep(DelayTime);
	}
	DoOpen();
	FinishInterpolation();
	FinishedOpening();
	if(NotEqual_ObjectObject(SavedTrigger, none))
	{
		SavedTrigger.EndEvent();
	}
	stop;
Close:

	DoClose();
	FinishInterpolation();
	FinishedClosing();
	stop;
}

state() TriggerControl
{
	function Trigger(Actor Other, Pawn EventInstigator)
	{
		AddAdd_Int(numTriggerEvents);
		SavedTrigger = Other;
		Instigator = EventInstigator;
		if(NotEqual_ObjectObject(SavedTrigger, none))
		{
			SavedTrigger.BeginEvent();
		}
		GotoState('TriggerControl', 'Open');
		return;
	}

	function UnTrigger(Actor Other, Pawn EventInstigator)
	{
		SubtractSubtract_Int(numTriggerEvents);
		if(LessEqual_IntInt(numTriggerEvents, 0))
		{
			numTriggerEvents = 0;
			SavedTrigger = Other;
			Instigator = EventInstigator;
			SavedTrigger.BeginEvent();
			GotoState('TriggerControl', 'Close');
		}
		return;
	}

	function BeginState()
	{
		numTriggerEvents = 0;
		return;
	}
Open:

	bClosed = false;
	if(Greater_FloatFloat(DelayTime, float(0)))
	{
		bDelaying = true;
		Sleep(DelayTime);
	}
	DoOpen();
	FinishInterpolation();
	FinishedOpening();
	SavedTrigger.EndEvent();
	if(bTriggerOnceOnly)
	{
		GotoState('None');
	}
	stop;
Close:

	DoClose();
	FinishInterpolation();
	FinishedClosing();
	stop;
}

state() TriggerPound
{
	function Trigger(Actor Other, Pawn EventInstigator)
	{
		AddAdd_Int(numTriggerEvents);
		SavedTrigger = Other;
		Instigator = EventInstigator;
		GotoState('TriggerPound', 'Open');
		return;
	}

	function UnTrigger(Actor Other, Pawn EventInstigator)
	{
		SubtractSubtract_Int(numTriggerEvents);
		if(LessEqual_IntInt(numTriggerEvents, 0))
		{
			numTriggerEvents = 0;
			SavedTrigger = none;
			Instigator = none;
			GotoState('TriggerPound', 'Close');
		}
		return;
	}

	function BeginState()
	{
		numTriggerEvents = 0;
		return;
	}
Open:

	bClosed = false;
	if(Greater_FloatFloat(DelayTime, float(0)))
	{
		bDelaying = true;
		Sleep(DelayTime);
	}
	DoOpen();
	FinishInterpolation();
	Sleep(OtherTime);
Close:

	DoClose();
	FinishInterpolation();
	Sleep(StayOpenTime);
	if(bTriggerOnceOnly)
	{
		GotoState('None');
	}
	if(NotEqual_ObjectObject(SavedTrigger, none))
	{
		goto 'Open';
	}
	stop;
}

state() BumpButton
{
	function PostBump(Actor Other)
	{
		if(AndAnd_BoolBool(NotEqual_IntInt(int(BumpType), int(2)), EqualEqual_ObjectObject(Pawn(Other), none)))
		{
			return;
		}
		if(AndAnd_BoolBool(EqualEqual_IntInt(int(BumpType), int(0)), Not_PreBool(Pawn(Other).IsPlayerPawn())))
		{
			return;
		}
		if(AndAnd_BoolBool(EqualEqual_IntInt(int(BumpType), int(1)), Less_FloatFloat(Other.Mass, float(10))))
		{
			return;
		}
		Bump(Other);
		SavedTrigger = Other;
		Instigator = Pawn(Other);
		Instigator.Controller.WaitForMover(self);
		GotoState('BumpButton', 'Open');
		return;
	}

	function BeginEvent()
	{
		bSlave = true;
		return;
	}

	function EndEvent()
	{
		bSlave = false;
		Instigator = none;
		GotoState('BumpButton', 'Close');
		return;
	}
Open:

	bClosed = false;
	Disable('Bump');
	if(Greater_FloatFloat(DelayTime, float(0)))
	{
		bDelaying = true;
		Sleep(DelayTime);
	}
	DoOpen();
	FinishInterpolation();
	FinishedOpening();
	if(bTriggerOnceOnly)
	{
		GotoState('None');
	}
	if(bSlave)
	{
		stop;
	}
Close:

	DoClose();
	FinishInterpolation();
	FinishedClosing();
	Enable('Bump');
	stop;
}

defaultproperties
{
	MoverEncroachType=1
	MoverGlideType=1
	NumKeys=2
	MoveTime=1.0000000
	StayOpenTime=4.0000000
	bClosed=true
	Physics=8
	bNoDelete=true
	bAlwaysRelevant=true
	bOnlyDirtyReplication=true
	RemoteRole=2
	NetPriority=2.7000000
	InitialState="BumpOpenTimed"
	bShadowCast=true
	CollisionRadius=160.0000000
	CollisionHeight=160.0000000
	bCollideActors=true
	bBlockActors=true
	bBlockPlayers=true
	bEdShouldSnap=true
	bPathColliding=true
}