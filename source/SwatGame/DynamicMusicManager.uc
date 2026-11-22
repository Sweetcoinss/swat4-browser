class DynamicMusicManager extends DynamicMusicManagerBase implements IInterested_GameEvent_GrenadeDetonated, IInterested_GameEvent_EnemyFiredWeapon
	config(SwatGame)
	hidecategories(Karma);

var Timer DynamicMusicTimer;
var config float DynamicMusicTime;
var config name DynamicContextName;
var config name MusicEffectEvent;

simulated function PostBeginPlay()
{
	local SwatGameInfo GameInfo;

	super(Actor).PostBeginPlay();
	DynamicMusicTimer = Spawn(Class'Engine.Timer');
	DynamicMusicTimer.__TimerDelegate__Delegate = DynamicMusicTimerTimeout;
	GameInfo = SwatGameInfo(Level.Game);
	if(AndAnd_BoolBool(NotEqual_ObjectObject(GameInfo, none), NotEqual_ObjectObject(GameInfo.GameEvents, none)))
	{
		GameInfo.GameEvents.GrenadeDetonated.Register(self);
		GameInfo.GameEvents.EnemyFiredWeapon.Register(self);
	}
	return;
}

function OnGrenadeDetonated(Pawn GrenadeOwner, SwatGrenadeProjectile Grenade)
{
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		TriggerDynamicMusic();
	}
	else
	{
		SwatGameReplicationInfo(Level.GetGameReplicationInfo()).ServerTriggerDynamicMusic();
	}
	return;
}

function OnEnemyFiredWeapon(Pawn Enemy, Actor Target)
{
	if(OrOr_BoolBool(Target.IsA('SwatPlayer'), Target.IsA('SwatOfficer')))
	{
		if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
		{
			TriggerDynamicMusic();
		}
		else
		{
			SwatGameReplicationInfo(Level.GetGameReplicationInfo()).ServerTriggerDynamicMusic();
		}
	}
	return;
}

simulated function TriggerDynamicMusic()
{
	local MusicMarker LastMusicMarker;

	DynamicMusicTimer.StartTimer(DynamicMusicTime, false, true);
	Level.EffectsSystem.AddPersistentContext(DynamicContextName);
	LastMusicMarker = SoundEffectsSubsystem(EffectsSystem(Level.EffectsSystem).GetSubsystem('SoundEffectsSubsystem')).LastMusicMarker;
	if(NotEqual_ObjectObject(LastMusicMarker, none))
	{
		LastMusicMarker.TriggerEffectEvent(MusicEffectEvent);
	}
	else
	{
		TriggerEffectEvent(MusicEffectEvent);
	}
	return;
}

simulated function DynamicMusicTimerTimeout()
{
	local MusicMarker LastMusicMarker;

	LastMusicMarker = SoundEffectsSubsystem(EffectsSystem(Level.EffectsSystem).GetSubsystem('SoundEffectsSubsystem')).LastMusicMarker;
	if(NotEqual_ObjectObject(LastMusicMarker, none))
	{
		EffectsSystem(Level.EffectsSystem).RemovePersistentContext(DynamicContextName);
		LastMusicMarker.TriggerEffectEvent(MusicEffectEvent);
	}
	else
	{
		UnTriggerEffectEvent(MusicEffectEvent);
	}
	return;
}

simulated event Destroyed()
{
	local SwatGameInfo GameInfo;

	GameInfo = SwatGameInfo(Level.Game);
	if(AndAnd_BoolBool(NotEqual_ObjectObject(GameInfo, none), NotEqual_ObjectObject(GameInfo.GameEvents, none)))
	{
		GameInfo.GameEvents.GrenadeDetonated.UnRegister(self);
		GameInfo.GameEvents.EnemyFiredWeapon.UnRegister(self);
	}
	if(NotEqual_ObjectObject(DynamicMusicTimer, none))
	{
		DynamicMusicTimer.Destroy();
		DynamicMusicTimer = none;
	}
	super(Actor).Destroyed();
	return;
}

defaultproperties
{
	DynamicMusicTime=5.0000000
	DynamicContextName="Dynamic"
	MusicEffectEvent="GameStateMusic"
}