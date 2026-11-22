class Trigger extends Triggers
	native
	config
	placeable
	hidecategories(Karma);

enum ETriggerType
{
	TT_PlayerProximity,             // 0
	TT_PawnProximity,               // 1
	TT_ClassProximity,              // 2
	TT_AnyProximity,                // 3
	TT_Shoot,                       // 4
	TT_HumanPlayerProximity         // 5
};

var Trigger.ETriggerType TriggerType;
var localized string Message;
var bool bTriggerOnceOnly;
var bool bInitiallyActive;
var Class<Actor> ClassProximityType;
var float RepeatTriggerTime;
var float ReTriggerDelay;
var float TriggerTime;
var float DamageThreshold;
var Actor TriggerActor;
var Actor TriggerActor2;
var bool bSavedInitialCollision;
var bool bSavedInitialActive;

function PreBeginPlay()
{
	super(Actor).PreBeginPlay();
	if(OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(EqualEqual_IntInt(int(TriggerType), int(0)), EqualEqual_IntInt(int(TriggerType), int(1))), EqualEqual_IntInt(int(TriggerType), int(5))), AndAnd_BoolBool(EqualEqual_IntInt(int(TriggerType), int(2)), ClassIsChildOf(ClassProximityType, Class'Engine.Pawn'))))
	{
		OnlyAffectPawns(true);
	}
	return;
}

function PostBeginPlay()
{
	if(Not_PreBool(bInitiallyActive))
	{
		FindTriggerActor();
	}
	if(EqualEqual_IntInt(int(TriggerType), int(4)))
	{
		bHidden = false;
		bProjTarget = true;
		SetDrawType(0);
	}
	bSavedInitialActive = bInitiallyActive;
	bSavedInitialCollision = bCollideActors;
	super(Actor).PostBeginPlay();
	return;
}

function Reset()
{
	super(Actor).Reset();
	bInitiallyActive = bSavedInitialActive;
	SetCollision(bSavedInitialCollision, bBlockActors, bBlockPlayers);
	return;
}

function FindTriggerActor()
{
	local Actor A;

	TriggerActor = none;
	TriggerActor2 = none;
	foreach AllActors(Class'Engine.Actor', A)
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

function Actor SpecialHandling(Pawn Other)
{
	local Actor A;

	if(AndAnd_BoolBool(bTriggerOnceOnly, Not_PreBool(bCollideActors)))
	{
		return none;
	}
	if(AndAnd_BoolBool(EqualEqual_IntInt(int(TriggerType), int(5)), Not_PreBool(Other.IsHumanControlled())))
	{
		return none;
	}
	if(AndAnd_BoolBool(EqualEqual_IntInt(int(TriggerType), int(0)), Not_PreBool(Other.IsPlayerPawn())))
	{
		return none;
	}
	if(Not_PreBool(bInitiallyActive))
	{
		if(EqualEqual_ObjectObject(TriggerActor, none))
		{
			FindTriggerActor();
		}
		if(EqualEqual_ObjectObject(TriggerActor, none))
		{
			return none;
		}
		if(AndAnd_BoolBool(NotEqual_ObjectObject(TriggerActor2, none), Less_FloatFloat(VSize(Subtract_VectorVector(TriggerActor2.Location, Other.Location)), VSize(Subtract_VectorVector(TriggerActor.Location, Other.Location)))))
		{
			return TriggerActor2;
		}
		else
		{
			return TriggerActor;
		}
	}
	if(IsRelevant(Other))
	{
		foreach TouchingActors(Class'Engine.Actor', A)
		{
			if(EqualEqual_ObjectObject(A, Other))
			{
				Touch(Other);
			}
		}
		return self;
	}
	return self;
	return;
}

function CheckTouchList()
{
	local Actor A;

	foreach TouchingActors(Class'Engine.Actor', A)
	{
		Touch(A);
	}
	return;
}

function bool IsRelevant(Actor Other)
{
	if(Not_PreBool(bInitiallyActive))
	{
		return false;
	}
	switch(TriggerType)
	{
		case 5:
			return AndAnd_BoolBool(NotEqual_ObjectObject(Pawn(Other), none), Pawn(Other).IsHumanControlled());
		case 0:
			return AndAnd_BoolBool(NotEqual_ObjectObject(Pawn(Other), none), OrOr_BoolBool(Pawn(Other).IsPlayerPawn(), Pawn(Other).WasPlayerPawn()));
		case 1:
			return AndAnd_BoolBool(NotEqual_ObjectObject(Pawn(Other), none), Pawn(Other).CanTrigger(self));
		case 2:
			return ClassIsChildOf(Other.Class, ClassProximityType);
		case 3:
			return true;
		case 4:
			return AndAnd_BoolBool(NotEqual_ObjectObject(Projectile(Other), none), GreaterEqual_FloatFloat(Projectile(Other).Damage, DamageThreshold));
		default:
			return;
			break;
	}
}

function Touch(Actor Other)
{
	local int i;

	if(IsRelevant(Other))
	{
		if(Greater_FloatFloat(ReTriggerDelay, float(0)))
		{
			if(Less_FloatFloat(Subtract_FloatFloat(Level.TimeSeconds, TriggerTime), ReTriggerDelay))
			{
				return;
			}
			TriggerTime = Level.TimeSeconds;
		}
		TriggerEvent(Event, self, Other.Instigator);
		if(AndAnd_BoolBool(NotEqual_ObjectObject(Pawn(Other), none), NotEqual_ObjectObject(Pawn(Other).Controller, none)))
		{
			i = 0;
			J0x9C:

			if(Less_IntInt(i, 4))
			{
				if(EqualEqual_ObjectObject(Pawn(Other).Controller.GoalList[i], self))
				{
					Pawn(Other).Controller.GoalList[i] = none;
					// [Explicit Break]
					goto J0x101;
				}
				AddAdd_Int(i);
				// [Loop Continue]
				goto J0x9C;
			}
		}
		J0x101:

		if(AndAnd_BoolBool(NotEqual_StrStr(Message, ""), NotEqual_ObjectObject(Other.Instigator, none)))
		{
			Other.Instigator.ClientMessage(Message);
		}
		if(bTriggerOnceOnly)
		{
			SetCollision(false);
		}
		else
		{
			if(Greater_FloatFloat(RepeatTriggerTime, float(0)))
			{
				SetTimer(RepeatTriggerTime, false);
			}
		}
	}
	return;
}

function Timer()
{
	local bool bKeepTiming;
	local Actor A;

	bKeepTiming = false;
	foreach TouchingActors(Class'Engine.Actor', A)
	{
		if(IsRelevant(A))
		{
			bKeepTiming = true;
			Touch(A);
		}
	}
	if(bKeepTiming)
	{
		SetTimer(RepeatTriggerTime, false);
	}
	return;
}

function PostTakeDamage(int Damage, Pawn InstigatedBy, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType)
{
	if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(bInitiallyActive, EqualEqual_IntInt(int(TriggerType), int(4))), GreaterEqual_FloatFloat(float(Damage), DamageThreshold)), NotEqual_ObjectObject(InstigatedBy, none)))
	{
		if(Greater_FloatFloat(ReTriggerDelay, float(0)))
		{
			if(Less_FloatFloat(Subtract_FloatFloat(Level.TimeSeconds, TriggerTime), ReTriggerDelay))
			{
				return;
			}
			TriggerTime = Level.TimeSeconds;
		}
		DoTrigger(InstigatedBy);
		if(NotEqual_StrStr(Message, ""))
		{
			InstigatedBy.Instigator.ClientMessage(Message);
		}
		if(bTriggerOnceOnly)
		{
			SetCollision(false);
		}
	}
	return;
}

function DoTrigger(Pawn Instigator)
{
	TriggerEvent(Event, self, Instigator);
	return;
}

function UnTouch(Actor Other)
{
	if(IsRelevant(Other))
	{
		UntriggerEvent(Event, self, Other.Instigator);
	}
	return;
}

state() NormalTrigger
{	stop;
}

state() OtherTriggerToggles
{
	function Trigger(Actor Other, Pawn EventInstigator)
	{
		bInitiallyActive = Not_PreBool(bInitiallyActive);
		if(bInitiallyActive)
		{
			CheckTouchList();
		}
		return;
	}
	stop;
}

state() OtherTriggerTurnsOn
{
	function Trigger(Actor Other, Pawn EventInstigator)
	{
		local bool bWasActive;

		bWasActive = bInitiallyActive;
		bInitiallyActive = true;
		if(Not_PreBool(bWasActive))
		{
			CheckTouchList();
		}
		return;
	}
	stop;
}

state() OtherTriggerTurnsOff
{
	function Trigger(Actor Other, Pawn EventInstigator)
	{
		bInitiallyActive = false;
		return;
	}
	stop;
}

defaultproperties
{
	bInitiallyActive=true
	InitialState="NormalTrigger"
	Texture=Texture'Engine_res.S_Trigger'
}