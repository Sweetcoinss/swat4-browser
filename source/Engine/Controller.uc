class Controller extends Actor
	abstract
	native
	nativereplication
	config
	notplaceable
	hidecategories(Karma);

const LATENT_MOVETOWARD = 503;

var Pawn Pawn;
var const int PlayerNum;
var float SightCounter;
var float FovAngle;
var globalconfig float Handedness;
var bool bIsPlayer;
var bool bGodMode;
var const bool bLOSflag;
var bool bAdvancedTactics;
var bool bCanOpenDoors;
var bool bCanDoSpecial;
var bool bAdjusting;
var bool bPreparingMove;
var bool bControlAnimations;
var bool bEnemyInfoValid;
var bool bNotifyApex;
var bool bUsePlayerHearing;
var bool bJumpOverWall;
var bool bEnemyAcquired;
var bool bSoaking;
var bool bHuntPlayer;
var bool bAllowedToTranslocate;
var bool bAllowedToImpactJump;
var input byte bLeanLeft;
var input byte bLeanRight;
var input byte bRun;
var input byte bDuck;
var input byte bFire;
var input byte bAltFire;
var Vector AdjustLoc;
var const Controller nextController;
var float Stimulus;
var float MoveTimer;
var Actor MoveTarget;
var Vector Destination;
var Vector FocalPoint;
var Actor Focus;
var Mover PendingMover;
var Actor GoalList[4];
var NavigationPoint home;
var float MinHitWall;
var float RespawnPredictionTime;
var int AcquisitionYawRate;
var Pawn Enemy;
var Actor Target;
var Vector LastSeenPos;
var Vector LastSeeingPos;
var float LastSeenTime;
var string VoiceType;
var float OldMessageTime;
var Actor RouteCache[16];
var ReachSpec CurrentPath;
var Vector CurrentPathDir;
var Actor RouteGoal;
var float RouteDist;
var float LastRouteFind;
var bool bNearbyPathFound;
var Vector RouteGoalPoint;
var Class<PlayerReplicationInfo> PlayerReplicationInfoClass;
var PlayerReplicationInfo PlayerReplicationInfo;
var Class<Pawn> PawnClass;
var Class<Pawn> PreviousPawnClass;
var float GroundPitchTime;
var Vector ViewX;
var Vector ViewY;
var Vector ViewZ;
var NavigationPoint StartSpot;
var Vector MonitorStartLoc;
var Pawn MonitoredPawn;
var float MonitorMaxDistSq;
var const Actor LastFailedReach;
var const float FailedReachTime;
var const Vector FailedReachLocation;

replication
{
	// Pos:0x078
	unreliable if(Less_IntInt(int(Role), int(ROLE_Authority)))
		SendVoiceMessage, SetPawnClass;

	// Pos:0x000
	reliable if(AndAnd_BoolBool(bNetDirty, EqualEqual_IntInt(int(Role), int(ROLE_Authority))))
		Pawn, PlayerReplicationInfo;

	// Pos:0x018
	reliable if(AndAnd_BoolBool(AndAnd_BoolBool(bNetDirty, EqualEqual_IntInt(int(Role), int(ROLE_Authority))), bNetOwner))
		PawnClass;

	// Pos:0x03B
	reliable if(EqualEqual_IntInt(int(RemoteRole), int(ROLE_AutonomousProxy)))
		ClientDying, ClientGameEnded,
		ClientSetLocation, ClientSetRotation;

	// Pos:0x048
	reliable if(AndAnd_BoolBool(OrOr_BoolBool(Not_PreBool(bDemoRecording), AndAnd_BoolBool(bClientDemoRecording, bClientDemoNetFunc)), EqualEqual_IntInt(int(Role), int(ROLE_Authority))))
		ClientVoiceMessage;

	// Pos:0x085
	reliable if(Less_IntInt(int(Role), int(ROLE_Authority)))
		ServerReStartPlayer;
}

// Export UController::execFinishRotation(FFrame&, void* const)
native(508) final latent function FinishRotation();

// Export UController::execLineOfSightTo(FFrame&, void* const)
native(514) final function bool LineOfSightTo(Actor Other);

// Export UController::execCanSee(FFrame&, void* const)
native(533) final function bool CanSee(Pawn Other);

// Export UController::execEAdjustJump(FFrame&, void* const)
native(523) final function Vector EAdjustJump(float BaseZ, float XYSpeed);

// Export UController::execPickWallAdjust(FFrame&, void* const)
native(526) final function bool PickWallAdjust(Vector HitNormal);

// Export UController::execWaitForLanding(FFrame&, void* const)
native(527) final latent function WaitForLanding();

// Export UController::execAddController(FFrame&, void* const)
native(529) final function AddController();

// Export UController::execRemoveController(FFrame&, void* const)
native(530) final function RemoveController();

// Export UController::execPickAnyTarget(FFrame&, void* const)
native(534) final function Actor PickAnyTarget(out float bestAim, out float bestDist, Vector FireDir, Vector projStart);

// Export UController::execInLatentExecution(FFrame&, void* const)
native final function bool InLatentExecution(int LatentActionNumber);

event MayFall()
{
	return;
}

function PendingStasis()
{
	bStasis = true;
	Pawn = none;
	return;
}

function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
	if(EqualEqual_ObjectObject(Pawn, none))
	{
		super.DisplayDebug(Canvas, YL, YPos);
		return;
	}
	Canvas.SetDrawColor(byte(255), 0, 0);
	Canvas.DrawText(Concat_StrStr(Concat_StrStr(Concat_StrStr("CONTROLLER ", GetItemName(string(self))), " Pawn "), GetItemName(string(Pawn))));
	AddEqual_FloatFloat(YPos, YL);
	Canvas.SetPos(4.0000000, YPos);
	if(NotEqual_ObjectObject(Enemy, none))
	{
		Canvas.DrawText(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("     STATE: ", string(GetStateName())), " Timer: "), string(TimerCounter)), " Enemy "), Enemy.GetHumanReadableName()), false);
	}
	else
	{
		Canvas.DrawText(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("     STATE: ", string(GetStateName())), " Timer: "), string(TimerCounter)), " NO Enemy "), false);
	}
	AddEqual_FloatFloat(YPos, YL);
	Canvas.SetPos(4.0000000, YPos);
	if(EqualEqual_ObjectObject(PlayerReplicationInfo, none))
	{
		Canvas.DrawText("     NO PLAYERREPLICATIONINFO", false);
	}
	else
	{
		PlayerReplicationInfo.DisplayDebug(Canvas, YL, YPos);
	}
	AddEqual_FloatFloat(YPos, YL);
	Canvas.SetPos(4.0000000, YPos);
	return;
}

simulated function string GetHumanReadableName()
{
	if(NotEqual_ObjectObject(PlayerReplicationInfo, none))
	{
		return PlayerReplicationInfo.PlayerName;
	}
	return GetItemName(string(self));
	return;
}

simulated function Rotator GetViewRotation()
{
	return Rotation;
	return;
}

function Reset()
{
	super.Reset();
	Enemy = none;
	LastSeenTime = 0.0000000;
	StartSpot = none;
	return;
}

function bool AvoidCertainDeath()
{
	return false;
	return;
}

function ClientSetLocation(Vector NewLocation, Rotator NewRotation)
{
	SetRotation(NewRotation);
	if(AndAnd_BoolBool(Greater_IntInt(Rotation.Pitch, RotationRate.Pitch), Less_IntInt(Rotation.Pitch, Subtract_IntInt(65536, RotationRate.Pitch))))
	{
		if(Less_IntInt(Rotation.Pitch, 32768))
		{
			NewRotation.Pitch = RotationRate.Pitch;
		}
		else
		{
			NewRotation.Pitch = Subtract_IntInt(65536, RotationRate.Pitch);
		}
	}
	if(NotEqual_ObjectObject(Pawn, none))
	{
		NewRotation.Roll = 0;
		Pawn.SetRotation(NewRotation);
		Pawn.SetLocation(NewLocation);
	}
	return;
}

function ClientSetRotation(Rotator NewRotation)
{
	SetRotation(NewRotation);
	if(NotEqual_ObjectObject(Pawn, none))
	{
		NewRotation.Pitch = 0;
		NewRotation.Roll = 0;
		Pawn.SetRotation(NewRotation);
	}
	return;
}

function ClientDying(Class<DamageType> DamageType, Vector HitLocation, Vector HitMomentum, Vector inKillerLocation)
{
	if(NotEqual_ObjectObject(Pawn, none))
	{
		Pawn.PlayDying(DamageType, HitLocation, HitMomentum, inKillerLocation);
		Pawn.GotoState('Dying');
	}
	return;
}

// Export UController::execGetDistanceToSound(FFrame&, void* const)
native function float GetDistanceToSound(Actor Listener, Vector SourceLocation, Vector ListenerLocation);

event AIHearSound(Actor Actor, Sound S, Vector SoundLocation, Vector Parameters, bool Attenuate)
{
	return;
}

event SoakStop(string problem)
{
	return;
}

function Possess(Pawn aPawn)
{
	aPawn.PossessedBy(self);
	Pawn = aPawn;
	if(NotEqual_ObjectObject(PlayerReplicationInfo, none))
	{
		PlayerReplicationInfo.bIsFemale = Pawn.bIsFemale;
	}
	FocalPoint = Add_VectorVector(Pawn.Location, Multiply_FloatVector(float(512), Vector(Pawn.Rotation)));
	Restart();
	return;
}

function UnPossess()
{
	if(NotEqual_ObjectObject(Pawn, none))
	{
		Pawn.UnPossessed();
	}
	Pawn = none;
	return;
}

function WasKilledBy(Controller Other)
{
	return;
}

function PawnDied(Pawn P)
{
	if(NotEqual_ObjectObject(Pawn, P))
	{
		return;
	}
	if(NotEqual_ObjectObject(Pawn, none))
	{
		SetLocation(Pawn.Location);
		Pawn.UnPossessed();
	}
	Pawn = none;
	PendingMover = none;
	if(bIsPlayer)
	{
		if(Not_PreBool(IsInState('GameEnded')))
		{
			GotoState('Dead');
		}
	}
	else
	{
		Destroy();
	}
	return;
}

function Restart()
{
	Enemy = none;
	return;
}

event LongFall()
{
	return;
}

event bool NotifyPhysicsVolumeChange(PhysicsVolume NewVolume)
{
	return;
}

event bool NotifyHeadVolumeChange(PhysicsVolume NewVolume)
{
	return;
}

event bool NotifyLanded(Vector HitNormal)
{
	return;
}

event bool NotifyHitWall(Vector HitNormal, Actor Wall)
{
	return;
}

event bool NotifyBump(Actor Other)
{
	return;
}

event NotifyHitMover(Vector HitNormal, Mover Wall)
{
	return;
}

event NotifyJumpApex()
{
	return;
}

event NotifyMissedJump()
{
	return;
}

function NotifyTakeHit(Pawn InstigatedBy, Vector HitLocation, int Damage, Class<DamageType> DamageType, Vector Momentum)
{
	return;
}

function SetFall()
{
	return;
}

function PawnIsInPain(PhysicsVolume PainVolume)
{
	return;
}

event PreBeginPlay()
{
	AddController();
	super.PreBeginPlay();
	if(bDeleteMe)
	{
		return;
	}
	SightCounter = Multiply_FloatFloat(0.2000000, FRand());
	return;
}

event PostBeginPlay()
{
	super.PostBeginPlay();
	if(AndAnd_BoolBool(AndAnd_BoolBool(Not_PreBool(bDeleteMe), bIsPlayer), EqualEqual_IntInt(int(Role), int(ROLE_Authority))))
	{
		PlayerReplicationInfo = Spawn(PlayerReplicationInfoClass, self,, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0));
		InitPlayerReplicationInfo();
	}
	return;
}

function InitPlayerReplicationInfo()
{
	if(EqualEqual_StrStr(PlayerReplicationInfo.PlayerName, ""))
	{
		PlayerReplicationInfo.SetPlayerName(Class'Engine.GameInfo'.default.DefaultPlayerName);
	}
	return;
}

function bool SameTeamAs(Controller C)
{
	if(OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(EqualEqual_ObjectObject(PlayerReplicationInfo, none), EqualEqual_ObjectObject(C, none)), EqualEqual_ObjectObject(C.PlayerReplicationInfo, none)), EqualEqual_ObjectObject(PlayerReplicationInfo.Team, none)))
	{
		return false;
	}
	return Level.Game.IsOnTeam(C, PlayerReplicationInfo.Team.TeamIndex);
	return;
}

simulated event Destroyed()
{
	if(Less_IntInt(int(Role), int(ROLE_Authority)))
	{
		super.Destroyed();
		return;
	}
	RemoveController();
	if(AndAnd_BoolBool(bIsPlayer, NotEqual_ObjectObject(Level.Game, none)))
	{
		Level.Game.Logout(self);
	}
	if(NotEqual_ObjectObject(PlayerReplicationInfo, none))
	{
		if(AndAnd_BoolBool(Not_PreBool(PlayerReplicationInfo.bOnlySpectator), NotEqual_ObjectObject(PlayerReplicationInfo.Team, none)))
		{
			PlayerReplicationInfo.Team.RemoveFromTeam(self);
		}
		PlayerReplicationInfo.Destroy();
	}
	super.Destroyed();
	return;
}

event bool AllowDetourTo(NavigationPoint n)
{
	return true;
	return;
}

function AdjustView(float DeltaTime)
{
	local Controller C;

	C = Level.ControllerList;
	J0x14:

	if(NotEqual_ObjectObject(C, none))
	{
		if(AndAnd_BoolBool(C.IsA('PlayerController'), EqualEqual_ObjectObject(PlayerController(C).ViewTarget, Pawn)))
		{
			return;
		}
		C = C.nextController;
		// [Loop Continue]
		goto J0x14;
	}
	Pawn.bUpdateEyeheight = false;
	Pawn.EyeHeight = Pawn.BaseEyeHeight;
	return;
}

function bool WantsSmoothedView()
{
	return AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(Pawn, none), EqualEqual_IntInt(int(Pawn.Physics), int(1))), Not_PreBool(Pawn.bJustLanded));
	return;
}

function GameHasEnded()
{
	GotoState('GameEnded');
	return;
}

function ClientGameEnded()
{
	GotoState('GameEnded');
	return;
}

simulated event RenderOverlays(Canvas Canvas)
{
	return;
}

function int GetFacingDirection()
{
	return 0;
	return;
}

function byte GetMessageIndex(name PhraseName)
{
	return 0;
	return;
}

function SendMessage(PlayerReplicationInfo Recipient, name MessageType, byte MessageID, float Wait, name BroadcastType)
{
	SendVoiceMessage(PlayerReplicationInfo, Recipient, MessageType, MessageID, BroadcastType);
	return;
}

function bool AllowVoiceMessage(name MessageType)
{
	if(Less_FloatFloat(Subtract_FloatFloat(Level.TimeSeconds, OldMessageTime), float(10)))
	{
		return false;
	}
	else
	{
		OldMessageTime = Level.TimeSeconds;
	}
	return true;
	return;
}

function SendVoiceMessage(PlayerReplicationInfo Sender, PlayerReplicationInfo Recipient, name MessageType, byte MessageID, name BroadcastType)
{
	local Controller P;

	if(Not_PreBool(AllowVoiceMessage(MessageType)))
	{
		return;
	}
	P = Level.ControllerList;
	J0x26:

	if(NotEqual_ObjectObject(P, none))
	{
		if(NotEqual_ObjectObject(PlayerController(P), none))
		{
			if(OrOr_BoolBool(EqualEqual_NameName(BroadcastType, 'Global'), Not_PreBool(Level.Game.bTeamGame)))
			{
				P.ClientVoiceMessage(Sender, Recipient, MessageType, MessageID);
			}
			else
			{
				if(EqualEqual_ObjectObject(Sender.Team, P.PlayerReplicationInfo.Team))
				{
					P.ClientVoiceMessage(Sender, Recipient, MessageType, MessageID);
				}
			}
		}
		else
		{
			if(AndAnd_BoolBool(EqualEqual_NameName(MessageType, 'ORDER'), OrOr_BoolBool(EqualEqual_ObjectObject(Recipient, none), EqualEqual_ObjectObject(Recipient, P.PlayerReplicationInfo))))
			{
				P.BotVoiceMessage(MessageType, MessageID, self);
			}
		}
		P = P.nextController;
		// [Loop Continue]
		goto J0x26;
	}
	return;
}

function ClientVoiceMessage(PlayerReplicationInfo Sender, PlayerReplicationInfo Recipient, name MessageType, byte MessageID)
{
	return;
}

function BotVoiceMessage(name MessageType, byte MessageID, Controller Sender)
{
	return;
}

function bool WouldReactToNoise(float Loudness, Actor NoiseMaker)
{
	return false;
	return;
}

function bool WouldReactToSeeing(Pawn Seen)
{
	return false;
	return;
}

function Vector AdjustToss(float TSpeed, Vector Start, Vector End, bool bNormalize)
{
	local Vector Dest2D, Result, Vel2D;
	local float Dist2D;

	if(Greater_FloatFloat(Start.Z, Add_FloatFloat(End.Z, float(64))))
	{
		Dest2D = End;
		Dest2D.Z = Start.Z;
		Dist2D = VSize(Subtract_VectorVector(Dest2D, Start));
		MultiplyEqual_FloatFloat(TSpeed, Divide_FloatFloat(Dist2D, VSize(Subtract_VectorVector(End, Start))));
		Result = SuggestFallVelocity(Dest2D, Start, TSpeed, TSpeed);
		Vel2D = Result;
		Vel2D.Z = 0.0000000;
		Result.Z = Add_FloatFloat(Result.Z, Divide_FloatFloat(Multiply_FloatFloat(Subtract_FloatFloat(End.Z, Start.Z), VSize(Vel2D)), Dist2D));
	}
	else
	{
		Result = SuggestFallVelocity(End, Start, TSpeed, TSpeed);
	}
	if(bNormalize)
	{
		return Multiply_FloatVector(TSpeed, Normal(Result));
	}
	else
	{
		return Result;
	}
	return;
}

event PrepareForMove(NavigationPoint Goal, ReachSpec Path)
{
	return;
}

function WaitForMover(Mover M)
{
	return;
}

function MoverFinished()
{
	return;
}

function UnderLift(Mover M)
{
	return;
}

event SetupSpecialPathAbilities()
{
	return;
}

event HearNoise(float Loudness, Actor NoiseMaker)
{
	return;
}

event SeePlayer(Pawn Seen)
{
	return;
}

event SeeMonster(Pawn Seen)
{
	return;
}

event EnemyNotVisible()
{
	return;
}

function ShakeView(float shaketime, float RollMag, Vector OffsetMag, float RollRate, Vector OffsetRate, float OffsetTime)
{
	return;
}

function NotifyKilled(Controller Killer, Controller Killed, Pawn Other)
{
	if(EqualEqual_ObjectObject(Enemy, Other))
	{
		Enemy = none;
	}
	return;
}

function StopFiring()
{
	bFire = 0;
	bAltFire = 0;
	return;
}

simulated function Rotator AdjustAim(Ammunition FiredAmmunition, Vector projStart, int aimerror)
{
	return Rotation;
	return;
}

function ReceiveWarning(Pawn shooter, float projSpeed, Vector FireDir)
{
	return;
}

function SetPawnClass(string inClass, string inCharacter)
{
	local Class<Pawn> pClass;

	pClass = Class<Pawn>(DynamicLoadObject(inClass, Class'Core.Class'));
	if(NotEqual_ObjectObject(pClass, none))
	{
		PawnClass = pClass;
	}
	return;
}

function ServerReStartPlayer()
{
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		return;
	}
	if(NotEqual_ObjectObject(Pawn, none))
	{
		ServerGivePawn();
	}
	return;
}

function ServerGivePawn()
{
	return;
}

event MonitoredPawnAlert()
{
	return;
}

function StartMonitoring(Pawn P, float MaxDist)
{
	MonitoredPawn = P;
	MonitorStartLoc = P.Location;
	MonitorMaxDistSq = Multiply_FloatFloat(MaxDist, MaxDist);
	return;
}

function bool AutoTaunt()
{
	return false;
	return;
}

function bool DontReuseTaunt(int t)
{
	return false;
	return;
}

simulated function InterruptState(name Reason)
{
	return;
}

simulated function HandheldEquipment.EquipmentSlot GetEquipmentSlotForQualify()
{
	return 0;
	return;
}

state Dead
{
	ignores KilledBy;

	function PawnDied(Pawn P)
	{
		if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
		{
			Warn(Concat_StrStr(string(self), " Pawndied while dead"));
		}
		return;
	}

	function ServerReStartPlayer()
	{
		if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)))
		{
			return;
		}
		Level.Game.RestartPlayer(self);
		return;
	}
	stop;
}

state GameEnded
{
	ignores ReceiveWarning, PostTakeDamage, KilledBy;

	function BeginState()
	{
		if(NotEqual_ObjectObject(Pawn, none))
		{
			Pawn.bPhysicsAnimUpdate = false;
			Pawn.StopAnimating();
			Pawn.SetCollision(true, false, false);
			Pawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
			Pawn.SetPhysics(0);
			Pawn.UnPossessed();
			Pawn.bIgnoreForces = true;
		}
		if(Not_PreBool(bIsPlayer))
		{
			Destroy();
		}
		return;
	}
	stop;
}

defaultproperties
{
	FovAngle=90.0000000
	MinHitWall=-1.0000000
	AcquisitionYawRate=20000
	PlayerReplicationInfoClass=Class'Engine.PlayerReplicationInfo'
	bHidden=true
	RotationRate=(Pitch=3072,Yaw=30000,Roll=2048)
	bHiddenEd=true
}