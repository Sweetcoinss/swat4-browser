class HighGroundVolume extends PhysicsVolume implements IEffectObserver, IInterested_GameEvent_PawnDied, IInterested_GameEvent_PawnArrested, IInterested_GameEvent_PawnIncapacitated, IInterested_GameEvent_PostGameStarted
	config(HighGround)
	hidecategories(Karma,Events,Force,Karma,LightColor,Lighting,Sound,Object);

struct HighGroundCondition
{
	var() config name Subject;
	var() config name Archetype;
	var() config name Action;
	var() config name Object;
	var() config int Priority;
	var() config float Delay;
	var() config bool bShrinkOnAction;
	var name Instance;
};

var name RoomName;
var config array<HighGroundCondition> Conditions;
var transient array<HighGroundCondition> PriorityQueue;
var const HighGroundCondition NullCondition;
var bool bStillPlaying;
var HighGroundCondition PlayingCondition;
var bool bGameStarted;

function PostBeginPlay()
{
	super(Volume).PostBeginPlay();
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		SwatGameInfo(Level.Game).GameEvents.PostGameStarted.Register(self);
		SwatGameInfo(Level.Game).GameEvents.PawnDied.Register(self);
		SwatGameInfo(Level.Game).GameEvents.PawnArrested.Register(self);
		SwatGameInfo(Level.Game).GameEvents.PawnIncapacitated.Register(self);
	}
	else
	{
		OnPostGameStarted();
	}
	return;
}

function OnPostGameStarted()
{
	local int ct;

	bGameStarted = true;
	ct = 0;
	J0x0F:

	if(Less_IntInt(ct, Touching.Length))
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(Touching[ct], none), Touching[ct].IsA('Pawn')))
		{
			PawnEnteredVolume(Pawn(Touching[ct]));
		}
		AddAdd_PreInt(ct);
		// [Loop Continue]
		goto J0x0F;
	}
	return;
}

private final function string ConditionToString(HighGroundCondition inCondition)
{
	return Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(inCondition.Subject), " has "), string(inCondition.Action)), " "), string(inCondition.Object)), ".  Instance: "), string(inCondition.Instance));
	return;
}

private final function QueueEvent(HighGroundCondition inCondition)
{
	local int ct;

	if(EqualEqual_IntInt(PriorityQueue.Length, 0))
	{
		PriorityQueue.Insert(0, 1);
		PriorityQueue[0] = inCondition;
	}
	else
	{
		ct = 0;
		J0x2B:

		if(Less_IntInt(ct, PriorityQueue.Length))
		{
			if(LessEqual_IntInt(inCondition.Priority, PriorityQueue[ct].Priority))
			{
				PriorityQueue.Insert(ct, 1);
				PriorityQueue[ct] = inCondition;
				// [Explicit Break]
				goto J0x84;
			}
			AddAdd_Int(ct);
			// [Loop Continue]
			goto J0x2B;
		}
	}
	J0x84:

	return;
}

private final function QueueShrinkOnSubject(name inSubject)
{
	local int ct;

	ct = Subtract_IntInt(PriorityQueue.Length, 1);
	J0x0F:

	if(GreaterEqual_IntInt(ct, 0))
	{
		if(SubjectsMatch(PriorityQueue[ct].Subject, inSubject))
		{
			PriorityQueue.Remove(ct, 1);
		}
		SubtractSubtract_Int(ct);
		// [Loop Continue]
		goto J0x0F;
	}
	return;
}

private final function QueueShrinkOnSubjectAndAction(name inSubject, name inAction)
{
	local int ct;

	ct = Subtract_IntInt(PriorityQueue.Length, 1);
	J0x0F:

	if(GreaterEqual_IntInt(ct, 0))
	{
		if(AndAnd_BoolBool(SubjectsMatch(PriorityQueue[ct].Subject, inSubject), EqualEqual_NameName(PriorityQueue[ct].Action, inAction)))
		{
			PriorityQueue.Remove(ct, 1);
		}
		SubtractSubtract_Int(ct);
		// [Loop Continue]
		goto J0x0F;
	}
	return;
}

private final function bool SubjectsMatch(name inSubject1, name inSubject2)
{
	if(AndAnd_BoolBool(OrOr_BoolBool(EqualEqual_NameName(inSubject1, 'SwatOfficer'), EqualEqual_NameName(inSubject1, 'SwatPlayer')), OrOr_BoolBool(EqualEqual_NameName(inSubject2, 'SwatOfficer'), EqualEqual_NameName(inSubject2, 'SwatPlayer'))))
	{
		return true;
	}
	return EqualEqual_NameName(inSubject1, inSubject2);
	return;
}

private final function HighGroundCondition QueueExtract()
{
	local HighGroundCondition returnType;

	if(EqualEqual_IntInt(PriorityQueue.Length, 0))
	{
		return NullCondition;
	}
	returnType = PriorityQueue[0];
	PriorityQueue.Remove(0, 1);
	return returnType;
	return;
}

private final function HighGroundCondition FindCondition(Actor inSubject, name inAction, Actor inObject)
{
	local int ct;

	ct = 0;
	J0x07:

	if(Less_IntInt(ct, Conditions.Length))
	{
		if(AndAnd_BoolBool(inSubject.IsA(Conditions[ct].Subject), EqualEqual_NameName(inAction, Conditions[ct].Action)))
		{
			if(OrOr_BoolBool(EqualEqual_ObjectObject(inObject, none), inObject.IsA(Conditions[ct].Object)))
			{
				return Conditions[ct];
			}
		}
		AddAdd_Int(ct);
		// [Loop Continue]
		goto J0x07;
	}
	return NullCondition;
	return;
}

private final function bool IsConditionQueued(name inSubject, name inAction, name inObject)
{
	local int ct;

	ct = Subtract_IntInt(PriorityQueue.Length, 1);
	J0x0F:

	if(GreaterEqual_IntInt(ct, 0))
	{
		if(SubjectsMatch(PriorityQueue[ct].Subject, inSubject))
		{
			return true;
		}
		SubtractSubtract_Int(ct);
		// [Loop Continue]
		goto J0x0F;
	}
	if(AndAnd_BoolBool(SubjectsMatch(PlayingCondition.Subject, inSubject), EqualEqual_NameName(PlayingCondition.Action, inAction)))
	{
		return true;
	}
	else
	{
		return false;
	}
	return;
}

private final function PlayCondition(Actor inSubject, name inAction, Actor inObject)
{
	local HighGroundCondition condition;

	condition = FindCondition(inSubject, inAction, inObject);
	if(condition != NullCondition)
	{
		condition.Instance = inSubject.Name;
		if(IsConditionQueued(condition.Subject, condition.Action, condition.Object))
		{
			return;
		}
		if(OrOr_BoolBool(bStillPlaying, Not_PreBool(bGameStarted)))
		{
			QueueEvent(condition);
		}
		else
		{
			PlayConditionEffect(condition);
		}
	}
	return;
}

private final function name GetEffectName(HighGroundCondition inCondition)
{
	return string(Concat_StrStr(Concat_StrStr(string(inCondition.Subject), string(inCondition.Action)), string(inCondition.Object)));
	return;
}

function OnConditionPlayed()
{
	return;
}

function bool ShouldRejectCondition(HighGroundCondition inCondition)
{
	return;
}

final function PlayConditionEffect(HighGroundCondition inCondition)
{
	if(ShouldRejectCondition(inCondition))
	{
		return;
	}
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		GetAnySwatPlayer().TriggerEffectEvent(GetEffectName(inCondition),,,,,,, self, RoomName);
	}
	else
	{
		GetAnySwatPlayer().BroadcastEffectEvent(GetEffectName(inCondition),,,,,,, self, RoomName);
	}
	bStillPlaying = true;
	SetTimer(inCondition.Delay, false);
	PlayingCondition = inCondition;
	OnConditionPlayed();
	return;
}

event Timer()
{
	local HighGroundCondition QueuedCondition;

	QueueShrinkOnSubjectAndAction(PlayingCondition.Subject, PlayingCondition.Action);
	QueuedCondition = QueueExtract();
	if(QueuedCondition == NullCondition)
	{
		bStillPlaying = false;
		PlayingCondition = NullCondition;
	}
	else
	{
		PlayConditionEffect(QueuedCondition);
	}
	return;
}

simulated function OnEffectStarted(Actor inStartedEffect)
{
	return;
}

simulated function OnEffectStopped(Actor inStoppedEffect, bool Completed)
{
	if(Completed)
	{
		GetAnySwatPlayer().TriggerEffectEvent('RepliedAcknowledged',,,,,,,, 'TOC');
	}
	return;
}

simulated function OnEffectInitialized(Actor inInitializedEffect)
{
	return;
}

simulated function SwatPlayer GetAnySwatPlayer()
{
	local SwatPlayer Player;

	foreach AllActors(Class'SwatGame.SwatPlayer', Player)
	{
		return Player;
	}
	return;
}

function OnPawnDied(Pawn Pawn, Actor Killer, bool WasAThreat)
{
	if(AndAnd_BoolBool(NotEqual_ObjectObject(Controller(Killer), none), Controller(Killer).Pawn.IsInVolume(self)))
	{
		PlayCondition(Killer, 'Killed', Pawn);
	}
	return;
}

event PawnEnteredVolume(Pawn Other)
{
	PlayCondition(Other, 'Entered', self);
	return;
}

event PawnLeavingVolume(Pawn Other)
{
	if(Not_PreBool(Class'Engine.Pawn'.static.checkDead(Other)))
	{
		PlayCondition(Other, 'Left', self);
	}
	return;
}

event ActorEnteredVolume(Actor Other)
{
	PlayCondition(Other, 'Entered', self);
	return;
}

event ActorLeavingVolume(Actor Other)
{
	PlayCondition(Other, 'Left', self);
	return;
}

function OnPawnArrested(Pawn Arrestee, Pawn Arrester)
{
	if(Arrestee.IsInVolume(self))
	{
		PlayCondition(Arrestee, 'Restrained', Arrestee);
	}
	return;
}

function OnPawnIncapacitated(Pawn Pawn, Actor Incapacitator, bool WasAThreat)
{
	if(Pawn.IsInVolume(self))
	{
		PlayCondition(Incapacitator, 'Incapacitated', Pawn);
	}
	return;
}

simulated event Destroyed()
{
	SwatGameInfo(Level.Game).GameEvents.PawnDied.UnRegister(self);
	SwatGameInfo(Level.Game).GameEvents.PawnArrested.UnRegister(self);
	SwatGameInfo(Level.Game).GameEvents.PawnIncapacitated.UnRegister(self);
	super(Actor).Destroyed();
	return;
}

defaultproperties
{
	Conditions[0]=(Subject="SwatPlayer",Archetype="None",Action="Entered",Object="Volume",Priority=2,Delay=15.0000000,bShrinkOnAction=false,Instance="None")
	Conditions[1]=(Subject="SwatOfficer",Archetype="None",Action="Entered",Object="Volume",Priority=3,Delay=15.0000000,bShrinkOnAction=false,Instance="None")
	Conditions[2]=(Subject="SwatPlayer",Archetype="None",Action="Left",Object="Volume",Priority=2,Delay=15.0000000,bShrinkOnAction=false,Instance="None")
	Conditions[3]=(Subject="SwatOfficer",Archetype="None",Action="Left",Object="Volume",Priority=3,Delay=15.0000000,bShrinkOnAction=false,Instance="None")
	Conditions[4]=(Subject="SwatEnemy",Archetype="None",Action="Entered",Object="Volume",Priority=2,Delay=15.0000000,bShrinkOnAction=false,Instance="None")
	Conditions[5]=(Subject="SwatEnemy",Archetype="None",Action="Left",Object="Volume",Priority=3,Delay=15.0000000,bShrinkOnAction=false,Instance="None")
	bOccludedByGeometryInEditor=true
	bStatic=false
}