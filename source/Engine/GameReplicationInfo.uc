class GameReplicationInfo extends ReplicationInfo
	native
	nativereplication
	config
	notplaceable
	hidecategories(Karma,Movement,Collision,Lighting,LightColor,Karma,Force);

enum ECarriedObjectState
{
	COS_Home,                       // 0
	COS_HeldFriendly,               // 1
	COS_HeldEnemy,                  // 2
	COS_Down                        // 3
};

var string GameName;
var string GameClass;
var bool bTeamGame;
var bool bStopCountDown;
var bool bMatchHasBegun;
var bool bTeamSymbolsUpdated;
var int RemainingTime;
var int ElapsedTime;
var int RemainingMinute;
var float SecondCount;
var int GoalScore;
var int TimeLimit;
var int MaxLives;
var TeamInfo Teams[2];
var globalconfig string ServerName;
var globalconfig string ShortName;
var globalconfig string AdminName;
var globalconfig string AdminEmail;
var globalconfig int ServerRegion;
var globalconfig string MOTDLine1;
var globalconfig string MOTDLine2;
var globalconfig string MOTDLine3;
var globalconfig string MOTDLine4;
var Actor Winner;
var array<PlayerReplicationInfo> PRIArray;
var Vector FlagPos;
var GameReplicationInfo.ECarriedObjectState CarriedObjectState[2];
var int MatchID;

replication
{
	// Pos:0x000
	reliable if(AndAnd_BoolBool(bNetDirty, EqualEqual_IntInt(int(Role), int(ROLE_Authority))))
		CarriedObjectState, FlagPos,
		MatchID, RemainingMinute,
		Teams, Winner,
		bMatchHasBegun, bStopCountDown;

	// Pos:0x018
	reliable if(AndAnd_BoolBool(bNetInitial, EqualEqual_IntInt(int(Role), int(ROLE_Authority))))
		AdminEmail, AdminName,
		ElapsedTime, GameClass,
		GameName, GoalScore,
		MOTDLine1, MOTDLine2,
		MOTDLine3, MOTDLine4,
		MaxLives, RemainingTime,
		ServerName, ServerRegion,
		ShortName, TimeLimit,
		bTeamGame;
}

simulated function SetCarriedObjectState(int Team, name NewState)
{
	switch(NewState)
	{
		case 'Down':
			CarriedObjectState[Team] = 3;
			break;
		case 'HeldEnemy ':
			CarriedObjectState[Team] = 2;
			break;
		case 'Home ':
			CarriedObjectState[Team] = 0;
			break;
		case 'HeldFriendly ':
			CarriedObjectState[Team] = 1;
			break;
		default:
			break;
	}
	return;
}

simulated function name GetCarriedObjectState(int Team)
{
	switch(CarriedObjectState[Team])
	{
		case 3:
			return 'Down';
		case 2:
			return 'HeldEnemy';
		case 0:
			return 'home';
		case 1:
			return 'HeldFriendly';
		default:
			return 'None';
			break;
	}
	return;
}

simulated function PostNetBeginPlay()
{
	local PlayerReplicationInfo PRI;

	foreach DynamicActors(Class'Engine.PlayerReplicationInfo', PRI)
	{
		AddPRI(PRI);
	}
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		TeamSymbolNotify();
	}
	return;
}

simulated function TeamSymbolNotify()
{
	local Actor A;

	if(OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(EqualEqual_ObjectObject(Teams[0], none), EqualEqual_ObjectObject(Teams[1], none)), EqualEqual_ObjectObject(Teams[0].TeamIcon, none)), EqualEqual_ObjectObject(Teams[1].TeamIcon, none)))
	{
		return;
	}
	bTeamSymbolsUpdated = true;
	foreach AllActors(Class'Engine.Actor', A)
	{
		A.SetGRI(self);
	}
	return;
}

simulated function PostBeginPlay()
{
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		ServerName = "";
		AdminName = "";
		AdminEmail = "";
		MOTDLine1 = "";
		MOTDLine2 = "";
		MOTDLine3 = "";
		MOTDLine4 = "";
	}
	SecondCount = Level.TimeSeconds;
	SetTimer(1.0000000, true);
	return;
}

function Reset()
{
	super(Actor).Reset();
	Winner = none;
	return;
}

simulated function Timer()
{
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		if(GreaterEqual_FloatFloat(Subtract_FloatFloat(Level.TimeSeconds, SecondCount), Level.TimeDilation))
		{
			AddAdd_Int(ElapsedTime);
			if(NotEqual_IntInt(RemainingMinute, 0))
			{
				RemainingTime = RemainingMinute;
				RemainingMinute = 0;
			}
			if(AndAnd_BoolBool(Greater_IntInt(RemainingTime, 0), Not_PreBool(bStopCountDown)))
			{
				SubtractSubtract_Int(RemainingTime);
			}
			AddEqual_FloatFloat(SecondCount, Level.TimeDilation);
		}
		if(Not_PreBool(bTeamSymbolsUpdated))
		{
			TeamSymbolNotify();
		}
	}
	return;
}

simulated function AddPRI(PlayerReplicationInfo PRI)
{
	PRIArray[PRIArray.Length] = PRI;
	return;
}

simulated function RemovePRI(PlayerReplicationInfo PRI)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, PRIArray.Length))
	{
		if(EqualEqual_ObjectObject(PRIArray[i], PRI))
		{
			// [Explicit Break]
			goto J0x39;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	J0x39:

	if(EqualEqual_IntInt(i, PRIArray.Length))
	{
		Log(Concat_StrStr(Concat_StrStr("GameReplicationInfo::RemovePRI() pri=", string(PRI)), " not found."), 'Error');
		return;
	}
	PRIArray.Remove(i, 1);
	return;
}

simulated function GetPRIArray(out array<PlayerReplicationInfo> pris)
{
	local int i, Num;

	pris.Remove(0, pris.Length);
	i = 0;
	J0x14:

	if(Less_IntInt(i, PRIArray.Length))
	{
		if(NotEqual_ObjectObject(PRIArray[i], none))
		{
			pris[AddAdd_Int(Num)] = PRIArray[i];
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x14;
	}
	return;
}

function int ServerChooseSoundEffectToPlay(name EffectSpecification, Actor Source, Actor Target, Material TargetMaterial)
{
	return;
}

function ServerBroadcastSoundEffectSpecification(name EffectSpecification, Actor Source, Actor Target, optional Material Material, optional Vector overrideWorldLocation, optional Rotator overrideWorldRotation, optional IEffectObserver Observer, optional bool SameOnAllMachines)
{
	local Controller Itr;
	local int SpecificSoundRefIndex;

	SpecificSoundRefIndex = -1;
	if(EqualEqual_FloatFloat(VSize(overrideWorldLocation), float(0)))
	{
		overrideWorldLocation = Source.Location;
	}
	Itr = Level.ControllerList;
	J0x42:

	if(NotEqual_ObjectObject(Itr, none))
	{
		if(SameOnAllMachines)
		{
			SpecificSoundRefIndex = ServerChooseSoundEffectToPlay(EffectSpecification, Source, Target, Material);
		}
		if(Itr.IsA('PlayerController'))
		{
			PlayerController(Itr).ClientBroadcastSoundEffectSpecification(EffectSpecification, Source, Target, SpecificSoundRefIndex, Material, overrideWorldLocation, overrideWorldRotation, Observer);
		}
		Itr = Itr.nextController;
		// [Loop Continue]
		goto J0x42;
	}
	return;
}

function ServerBroadcastEffectEvent(Actor SourceActor, string UniqueIdentifier, name EffectEvent, optional Actor Other, optional Material TargetMaterial, optional Vector HitLocation, optional Rotator HitNormal, optional bool PlayOnOther, optional bool QueryOnly, optional IEffectObserver Observer, optional name ReferenceTag)
{
	local Controller Itr;

	if(Level.GetEngine().EnableDevTools)
	{
		Log(Concat_StrStr(Concat_StrStr(string(self), "::ServerBroadcastEffectEvent( "), string(SourceActor)));
	}
	Itr = Level.ControllerList;
	J0x60:

	if(NotEqual_ObjectObject(Itr, none))
	{
		if(Itr.IsA('PlayerController'))
		{
			if(Level.GetEngine().EnableDevTools)
			{
				Log(Concat_StrStr(Concat_StrStr(string(self), "::ServerBroadcastEffectEvent() ... sending ClientBroadcastEffectEvent to: "), string(PlayerController(Itr))));
			}
			PlayerController(Itr).ClientBroadcastEffectEvent(SourceActor, UniqueIdentifier, string(EffectEvent), Other, TargetMaterial, HitLocation, HitNormal, PlayOnOther, QueryOnly, Observer, string(ReferenceTag));
		}
		Itr = Itr.nextController;
		// [Loop Continue]
		goto J0x60;
	}
	return;
}

function ServerBroadcastUnTriggerEffectEvent(Actor SourceActor, string UniqueIdentifier, name EffectEvent, optional name ReferenceTag)
{
	local Controller Itr;

	if(Level.GetEngine().EnableDevTools)
	{
		Log(Concat_StrStr(Concat_StrStr(string(self), "::ServerBroadcastUnTriggerEffectEvent( "), string(SourceActor)));
	}
	Itr = Level.ControllerList;
	J0x69:

	if(NotEqual_ObjectObject(Itr, none))
	{
		if(Itr.IsA('PlayerController'))
		{
			if(Level.GetEngine().EnableDevTools)
			{
				Log(Concat_StrStr(Concat_StrStr(string(self), "::ServerBroadcastUnTriggerEffectEvent() ... sending ClientBroadcastUnTriggerEffectEvent to: "), string(PlayerController(Itr))));
			}
			PlayerController(Itr).ClientBroadcastUnTriggerEffectEvent(SourceActor, UniqueIdentifier, string(EffectEvent), string(ReferenceTag));
		}
		Itr = Itr.nextController;
		// [Loop Continue]
		goto J0x69;
	}
	return;
}

function ServerBroadcastTrigger(Actor SourceActor, string UniqueIdentifier, Actor Other, Pawn EventInstigator)
{
	local Controller Itr;

	Itr = Level.ControllerList;
	J0x14:

	if(NotEqual_ObjectObject(Itr, none))
	{
		if(Itr.IsA('PlayerController'))
		{
			PlayerController(Itr).ClientBroadcastTrigger(SourceActor, UniqueIdentifier, Other, EventInstigator);
		}
		Itr = Itr.nextController;
		// [Loop Continue]
		goto J0x14;
	}
	return;
}

defaultproperties
{
	bStopCountDown=true
	ServerName="Another Swat4 Server"
	ShortName="Swat4 Server"
	bNetNotify=true
}