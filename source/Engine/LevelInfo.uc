class LevelInfo extends ZoneInfo
	native
	nativereplication
	config
	placeable
	hidecategories(Karma,Movement,Collision,Lighting,LightColor,Karma,Force);

enum EPhysicsDetailLevel
{
	PDL_Low,                        // 0
	PDL_Medium,                     // 1
	PDL_High                        // 2
};

enum EHavokSolverType
{
	HAVOKSOLVER_4ITERS_SOFT,        // 0
	HAVOKSOLVER_4ITERS_MEDIUM,      // 1
	HAVOKSOLVER_4ITERS_HARD         // 2
};

enum ELevelAction
{
	LEVACT_None,                    // 0
	LEVACT_Loading,                 // 1
	LEVACT_Saving,                  // 2
	LEVACT_Connecting,              // 3
	LEVACT_Precaching               // 4
};

enum ENetMode
{
	NM_Standalone,                  // 0
	NM_DedicatedServer,             // 1
	NM_ListenServer,                // 2
	NM_Client                       // 3
};

enum EPlatform
{
	PC,                             // 0
	PS2,                            // 1
	XBOX                            // 2
};

struct native RelevancyInfo
{
	var Pawn RelevantPawnViewer;
	var Actor RelevantActor;
	var bool bIsRelevant;
	var float RelevantUpdateTime;
};

var float TimeDilation;
var float TimeSeconds;
var transient int Year;
var transient int Month;
var transient int Day;
var transient int DayOfWeek;
var transient int Hour;
var transient int Minute;
var transient int Second;
var transient int Millisecond;
var float PauseDelay;
var(LevelSummary) localized string Title;
var(LevelSummary) string Author;
var(LevelSummary) Material Screenshot "Screenshot of the level to be displayed on the server setup menu";
var(LevelSummary) localized string Description "Description of the level to be displayed on the server setup menu";
var(LevelSummary) array<Repo.EMPMode> SupportedModes "Game modes supported by this map";
var(LevelSummary) int IdealPlayerCountMin "Recommended minimum number of players for this level.";
var(LevelSummary) int IdealPlayerCountMax "Recommended maximum number of players for this level.";
var config LevelInfo.EPhysicsDetailLevel PhysicsDetailLevel;
var(Karma) float KarmaTimeScale;
var(Karma) float RagdollTimeScale;
var(Karma) int MaxRagdolls;
var(Karma) float KarmaGravScale;
var(Karma) bool bKStaticFriction;
var bool bKNoInit;
var(Havok) bool bHavokDisabled;
var(Havok) float HavokStepTimeQuantum;
var(Havok) string HavokMoppCodeFilename;
var(Havok) int HavokBroadPhaseDimension;
var(Havok) LevelInfo.EHavokSolverType HavokSolverType "This controls how Havok resolves physical interactions and constraints. The 'harder' the solver, the greater the percentage of error it will try to resolve in one iteration." "" "So if you have a 'Hard' solver these values will be quite high and the constraints might seem quite abrupt in how they solve, they could also handle unstable situations more aggresively. On the downside, where a medium constraint might relax in an unstable situation, a hard constraint could continually fight to fix itself, possibly causing jitter. ";
var config float DecalStayScale;
var localized string LevelEnterText;
var string LocalizedPkg;
var PlayerReplicationInfo Pauser;
var LevelSummary Summary;
var string VisibleGroups;
var transient string SelectedGroups;
var(LevelSummary) bool HideFromMenus;
var bool bLonePlayer;
var bool bBegunPlay;
var bool bPlayersOnly;
var const Actor.EDetailMode DetailMode;
var bool bDropDetail;
var bool bAggressiveLOD;
var bool bStartup;
var config bool bLowSoundDetail;
var bool bPathsRebuilt;
var bool bHasPathNodes;
var globalconfig bool bCapFramerate;
var bool bLevelChange;
var config bool bNeverPrecache;
var Vector CameraLocationDynamic;
var Vector CameraLocationTop;
var Vector CameraLocationFront;
var Vector CameraLocationSide;
var Rotator CameraRotationDynamic;
var(Audio) string Song;
var(Audio) float PlayerDoppler;
var(Audio) float MusicVolumeOverride;
var float Brightness;
var Texture DefaultTexture;
var Texture WireframeTexture;
var Texture WhiteSquareTexture;
var Texture LargeVertex;
var int HubStackLevel;
var transient LevelInfo.ELevelAction LevelAction;
var transient GameReplicationInfo GRI;
var LevelInfo.ENetMode NetMode;
var string ComputerName;
var string EngineVersion;
var string MinNetVersion;
var string BuildVersion;
var string ModName;
var array<RelevancyInfo> RelevancyInformation;
var string DefaultGameType;
var string PreCacheGame;
var GameInfo Game;
var float DefaultGravity;
var const NavigationPoint NavigationPointList;
var const Controller ControllerList;
var private PlayerController LocalPlayerController;
var const Pawn PawnList;
var const array<AwarenessPoint> AwarenessPointList;
var string NextURL;
var bool bNextItems;
var float NextSwitchCountdown;
var transient ObjectPool ObjectPool;
var transient array<Material> PrecacheMaterials;
var transient array<StaticMesh> PrecacheStaticMeshes;
var transient array<Mesh> PrecacheMeshes;
var config LevelInfo.EPlatform Platform;
var IGEffectsSystemBase EffectsSystem;
var array<Actor> InterestedActorsGameStarted;
var MessageDispatcher MessageDispatcher;
var Tyrion_Setup AI_Setup;
var private bool bGameStarted;
var config string AIRepositoryClassName;
var AIRepository AIRepo;
var bool EnemiesAlwaysTalkToHostages;
var bool IsCOOPServer;
var bool IsPlayingCOOP;
var Actor CurrentServerSettings;
var Actor PendingServerSettings;
var bool TickSpecialEnabled;
var editinline ISpawningManager SpawningManager;
var config bool AnalyzeBallistics;
var bool IsTraining "Indicates whether or not this is a Training mission. If true, you will have unlimited ammo and tactical aids";
var bool DebugFlag;
var bool NoEnemyHostageConversations "Specifies that enemies and hostages should not play conversations";
var float MoveRepSize;
var const PlayerController ReplicationViewer;
var const Actor ReplicationViewTarget;

replication
{
	// Pos:0x000
	reliable if(EqualEqual_IntInt(int(Role), int(ROLE_Authority)))
		CurrentServerSettings, PendingServerSettings;

	// Pos:0x00D
	reliable if(AndAnd_BoolBool(bNetDirty, EqualEqual_IntInt(int(Role), int(ROLE_Authority))))
		DefaultGravity, Pauser,
		TimeDilation;

	// Pos:0x025
	reliable if(AndAnd_BoolBool(bNetInitial, EqualEqual_IntInt(int(Role), int(ROLE_Authority))))
		KarmaGravScale, KarmaTimeScale,
		RagdollTimeScale;
}

// Export ULevelInfo::execGetGameSpyManager(FFrame&, void* const)
native final function GameSpyManager GetGameSpyManager();

// Export ULevelInfo::execHavokSetCollisionLayerEnabled(FFrame&, void* const)
native final function HavokSetCollisionLayerEnabled(int layerA, int layerB, bool Enabled, bool updateWorldInfo);

// Export ULevelInfo::execHavokGetNextFreeSystemLayer(FFrame&, void* const)
native final function HavokGetNextFreeSystemLayer(out int systemLayer);

// Export ULevelInfo::execDetailChange(FFrame&, void* const)
native simulated function DetailChange(Actor.EDetailMode NewDetailMode);

// Export ULevelInfo::execIsEntry(FFrame&, void* const)
native simulated function bool IsEntry();

// Export ULevelInfo::execIsTheEntryLevel(FFrame&, void* const)
native simulated function bool IsTheEntryLevel();

simulated function PostBeginPlay()
{
	super(Actor).PostBeginPlay();
	DecalStayScale = FClamp(DecalStayScale, 0.0000000, 2.0000000);
	return;
}

simulated function CreateEffectsSystem()
{
	local Class<IGEffectsSystemBase> EffectsSystemClass;

	EffectsSystemClass = Class'Engine.IGEffectsSystemBase'.static.GetEffectsSystemClass();
	EffectsSystem = EffectsSystemClass.static.Allocate(self, self, "EffectsSystem", 0).;
	Construct_Void();
	AssertWithDescription(NotEqual_ObjectObject(EffectsSystem, none), Concat_StrStr(Concat_StrStr("The EffectsSystem could not be created.  (LevelInfo tried to create a new instance of class ", string(EffectsSystemClass)), ")"));
	return;
}

simulated function InitializeEffectsSystem()
{
	local float Time;

	Time = AppSeconds();
	EffectsSystem.Init(self);
	Time = Subtract_FloatFloat(AppSeconds(), Time);
	Log(Concat_StrStr(Concat_StrStr("LevelInfo::InitializeEffectsSystem() called. Initialised in ", string(Time)), " seconds."));
	return;
}

private function CreateAIRepository()
{
	local Class<AIRepository> AIRepositoryClass;

	if(Level.GetEngine().EnableDevTools)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("dkaplan: CreateAIRepository() ... Level.IsCOOPServer = ", string(Level.IsCOOPServer)), ", NetMode = "), string(GetEnum(Enum'Engine.LevelInfo.ENetMode', int(NetMode)))));
	}
	if(OrOr_BoolBool(EqualEqual_IntInt(int(NetMode), int(NM_Standalone)), Level.IsCOOPServer))
	{
		AIRepositoryClass = Class<AIRepository>(DynamicLoadObject(AIRepositoryClassName, Class'Core.Class'));
		assert(NotEqual_ObjectObject(AIRepositoryClass, none));
		AIRepo = Spawn(AIRepositoryClass, self);
		assert(NotEqual_ObjectObject(AIRepo, none));
	}
	return;
}

// Export ULevelInfo::execGetEngine(FFrame&, void* const)
native function Engine GetEngine();

simulated function Repo GetRepo()
{
	local Engine GameEngine;

	GameEngine = GetEngine();
	assert(NotEqual_ObjectObject(GameEngine, none));
	return GameEngine.super(LevelInfo).GetRepo();
	return;
}

function bool UsingCustomScenario()
{
	return Game.UsingCustomScenario();
	return;
}

simulated function Class<GameInfo> GetGameClass()
{
	local Class<GameInfo> G;

	if(NotEqual_ObjectObject(Level.Game, none))
	{
		return Level.Game.Class;
	}
	if(AndAnd_BoolBool(NotEqual_ObjectObject(GRI, none), NotEqual_StrStr(GRI.GameClass, "")))
	{
		G = Class<GameInfo>(DynamicLoadObject(GRI.GameClass, Class'Core.Class'));
	}
	if(NotEqual_ObjectObject(G, none))
	{
		return G;
	}
	if(NotEqual_StrStr(DefaultGameType, ""))
	{
		G = Class<GameInfo>(DynamicLoadObject(DefaultGameType, Class'Core.Class'));
	}
	return G;
	return;
}

simulated event FillRenderPrecacheArrays()
{
	local Actor A;
	local Class<GameInfo> G;

	if(EqualEqual_IntInt(int(NetMode), int(NM_DedicatedServer)))
	{
		return;
	}
	if(EqualEqual_ObjectObject(Level.Game, none))
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(GRI, none), NotEqual_StrStr(GRI.GameClass, "")))
		{
			G = Class<GameInfo>(DynamicLoadObject(GRI.GameClass, Class'Core.Class'));
		}
		if(AndAnd_BoolBool(EqualEqual_ObjectObject(G, none), NotEqual_StrStr(DefaultGameType, "")))
		{
			G = Class<GameInfo>(DynamicLoadObject(DefaultGameType, Class'Core.Class'));
		}
		if(EqualEqual_ObjectObject(G, none))
		{
			G = Class<GameInfo>(DynamicLoadObject(PreCacheGame, Class'Core.Class'));
		}
		if(NotEqual_ObjectObject(G, none))
		{
			G.static.PrecacheGameRenderData(self);
		}
	}
	foreach AllActors(Class'Engine.Actor', A)
	{
		A.UpdatePrecacheRenderData();
	}
	return;
}

simulated event AddPrecacheMesh(Mesh Mesh)
{
	local int i, Index;

	if(EqualEqual_IntInt(int(NetMode), int(NM_DedicatedServer)))
	{
		return;
	}
	if(EqualEqual_ObjectObject(Mesh, none))
	{
		return;
	}
	i = 0;
	J0x26:

	if(Less_IntInt(i, PrecacheMeshes.Length))
	{
		if(EqualEqual_ObjectObject(PrecacheMeshes[i], Mesh))
		{
			return;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x26;
	}
	Index = Level.PrecacheMeshes.Length;
	PrecacheMeshes.Insert(Index, 1);
	PrecacheMeshes[Index] = Mesh;
	return;
}

simulated event AddPrecacheMaterial(Material Mat)
{
	local int i, Index;

	if(EqualEqual_IntInt(int(NetMode), int(NM_DedicatedServer)))
	{
		return;
	}
	if(EqualEqual_ObjectObject(Mat, none))
	{
		return;
	}
	i = 0;
	J0x26:

	if(Less_IntInt(i, PrecacheMaterials.Length))
	{
		if(EqualEqual_ObjectObject(PrecacheMaterials[i], Mat))
		{
			return;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x26;
	}
	Index = Level.PrecacheMaterials.Length;
	PrecacheMaterials.Insert(Index, 1);
	PrecacheMaterials[Index] = Mat;
	return;
}

simulated event AddPrecacheStaticMesh(StaticMesh stat)
{
	local int i, Index;

	if(EqualEqual_IntInt(int(NetMode), int(NM_DedicatedServer)))
	{
		return;
	}
	if(EqualEqual_ObjectObject(stat, none))
	{
		return;
	}
	i = 0;
	J0x26:

	if(Less_IntInt(i, PrecacheStaticMeshes.Length))
	{
		if(EqualEqual_ObjectObject(PrecacheStaticMeshes[i], stat))
		{
			return;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x26;
	}
	Index = Level.PrecacheStaticMeshes.Length;
	PrecacheStaticMeshes.Insert(Index, 1);
	PrecacheStaticMeshes[Index] = stat;
	return;
}

// Export ULevelInfo::execGetLocalURL(FFrame&, void* const)
native simulated function string GetLocalURL();

// Export ULevelInfo::execIsDemoBuild(FFrame&, void* const)
native final simulated function bool IsDemoBuild();

// Export ULevelInfo::execGetAddressURL(FFrame&, void* const)
native simulated function string GetAddressURL();

event ServerTravel(string URL, bool bItems)
{
	if(EqualEqual_StrStr(NextURL, ""))
	{
		bLevelChange = true;
		bNextItems = bItems;
		NextURL = URL;
		if(NotEqual_ObjectObject(Game, none))
		{
			Game.ProcessServerTravel(URL, bItems);
		}
		else
		{
			NextSwitchCountdown = 0.0000000;
		}
	}
	return;
}

function ThisIsNeverExecuted()
{
	local DefaultPhysicsVolume P;

	P = none;
	return;
}

function Reset()
{
	ConsoleCommand("OBJ GARBAGE");
	super(Actor).Reset();
	return;
}

simulated function InternalRegisterNotifyGameStarted(Actor registeree)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, InterestedActorsGameStarted.Length))
	{
		if(EqualEqual_ObjectObject(InterestedActorsGameStarted[i], registeree))
		{
			AssertWithDescription(false, Concat_StrStr(string(registeree), " is re-registering for NotifyGameStarted"));
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	InterestedActorsGameStarted[InterestedActorsGameStarted.Length] = registeree;
	return;
}

simulated function NotifyGameStarted()
{
	local int i;

	if(Level.GetEngine().EnableDevTools)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("LevelInfo::NotifyGameStarted() called on Level '", string(Outer.Name)), "' that has Label '"), string(Label)), "'"));
	}
	if(NotEqual_NameName(Outer.Name, 'Entry'))
	{
		Level.InitializeEffectsSystem();
		EffectsSystem.AddPersistentContext(string(Concat_StrStr("Level_", string(Label))));
		Log(Concat_StrStr(Concat_StrStr("Added persistent context ", string(string(Concat_StrStr("Level_", string(Label))))), " to EffectsSystem"));
		i = 0;
		J0x11F:

		if(Less_IntInt(i, InterestedActorsGameStarted.Length))
		{
			if(Level.GetEngine().EnableDevTools)
			{
				MPLog(Concat_StrStr("LevelInfo Calling OnGameStarted on: ", string(InterestedActorsGameStarted[i])));
			}
			InterestedActorsGameStarted[i].OnGameStarted();
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x11F;
		}
	}
	return;
}

simulated function GuardSlow(string GuardString)
{
	assert(false);
	return;
}

// Export ULevelInfo::execRegisterNotifyPawnDied(FFrame&, void* const)
native final function RegisterNotifyPawnDied(IInterestedPawnDied ObjectToNotify);

// Export ULevelInfo::execUnRegisterNotifyPawnDied(FFrame&, void* const)
native final function UnRegisterNotifyPawnDied(IInterestedPawnDied RegisteredObject);

// Export ULevelInfo::execRegisterNotifyActorDestroyed(FFrame&, void* const)
native final function RegisterNotifyActorDestroyed(IInterestedActorDestroyed ObjectToNotify);

// Export ULevelInfo::execUnRegisterNotifyActorDestroyed(FFrame&, void* const)
native final function UnRegisterNotifyActorDestroyed(IInterestedActorDestroyed RegisteredObject);

simulated event PreBeginPlay()
{
	local Class<Actor> ServerSettingsClass;

	if(Level.GetEngine().EnableDevTools)
	{
		Log(Concat_StrStr(string(self), "::PreBeginPlay() ..... "));
	}
	if(Greater_IntInt(SupportedModes.Length, 0))
	{
		IsPlayingCOOP = EqualEqual_IntInt(int(SupportedModes[0]), int(3));
	}
	AssertWithDescription(OrOr_BoolBool(Not_PreBool(IsPlayingCOOP), EqualEqual_IntInt(SupportedModes.Length, 1)), "CO-OP was specified as a supported mode; no other modes may be specified for this map!");
	IsCOOPServer = AndAnd_BoolBool(IsPlayingCOOP, OrOr_BoolBool(EqualEqual_IntInt(int(NetMode), int(NM_ListenServer)), EqualEqual_IntInt(int(NetMode), int(NM_DedicatedServer))));
	if(NotEqual_IntInt(int(NetMode), int(NM_Client)))
	{
		ServerSettingsClass = Class<Actor>(DynamicLoadObject("SwatGame.ServerSettings", Class'Core.Class'));
		assert(NotEqual_ObjectObject(ServerSettingsClass, none));
		CurrentServerSettings = Spawn(ServerSettingsClass, self);
		PendingServerSettings = Spawn(ServerSettingsClass, self);
	}
	ObjectPool = Class'Engine.ObjectPool'.static.Allocate(self, none).;
	Construct_Void();
	MessageDispatcher = Class'Engine.MessageDispatcher'.static.Allocate(self).;
	Construct_Void();
	AI_Setup = Spawn(Class<Tyrion_Setup>(DynamicLoadObject("Tyrion.Setup", Class'Core.Class')));
	RegisterNotifyGameStarted();
	CreateEffectsSystem();
	if(Not_PreBool(IsTheEntryLevel()))
	{
		CreateAIRepository();
	}
	super.PreBeginPlay();
	return;
}

simulated function OnGameStarted()
{
	bGameStarted = true;
	return;
}

simulated function bool HasGameStarted()
{
	return bGameStarted;
	return;
}

// Export ULevelInfo::execGetLocalPlayerController(FFrame&, void* const)
native simulated function PlayerController GetLocalPlayerController();

simulated function GameReplicationInfo GetGameReplicationInfo()
{
	if(EqualEqual_IntInt(int(NetMode), int(NM_Client)))
	{
		return GetLocalPlayerController().GameReplicationInfo;
	}
	else
	{
		return Game.GameReplicationInfo;
	}
	return;
}

defaultproperties
{
	TimeDilation=1.0000000
	Title="Untitled"
	PhysicsDetailLevel=2
	KarmaTimeScale=0.9000000
	RagdollTimeScale=1.0000000
	MaxRagdolls=16
	KarmaGravScale=1.0000000
	bKStaticFriction=true
	HavokBroadPhaseDimension=524288
	HavokSolverType=1
	DecalStayScale=1.0000000
	VisibleGroups="None"
	DetailMode=2
	bCapFramerate=true
	MusicVolumeOverride=-1.0000000
	Brightness=1.0000000
	DefaultTexture=Texture'Engine_res.DefaultTexture'
	WireframeTexture=Texture'Engine_res.WireframeTexture'
	WhiteSquareTexture=Texture'Engine_res.WhiteSquareTexture'
	LargeVertex=Texture'Engine_res.LargeVertex'
	PreCacheGame="Engine.GameInfo"
	DefaultGravity=-1500.0000000
	AIRepositoryClassName="Engine.AIRepository"
	TickSpecialEnabled=true
	MoveRepSize=64.0000000
	bWorldGeometry=true
	bAlwaysRelevant=true
	RemoteRole=1
	bHiddenEd=true
}