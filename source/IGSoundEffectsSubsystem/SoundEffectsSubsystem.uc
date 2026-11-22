class SoundEffectsSubsystem extends EffectsSubsystem implements IInterestedActorDestroyed, IInterestedActorDestroyed
	native
	config(SoundEffects)
	hidecategories(Karma);

cpptext
{
private:
    void RemoveFromCurrentSounds (ASoundInstance* inInstance);
    // Handles cases where a new sound can overwrite an old sound
    UBOOL HandleOverlap (ASoundInstance* inExistingSound, ASoundInstance* inNewSound);
    UBOOL IsBeingDelayed(ASoundInstance* inInstance);
    UBOOL IsSchemaPlaying(AActor* inSource, FName schemaName);
    class USoundEffectSpecification* GetSpecificationByName( FName SchemaName );
    UBOOL CanStartInstance(ASoundInstance* inInstance);

    // Stop instance will just stop the sample playing, while leaving the SoundInstance updating, this
    // should NEVER be called by anything outside of ASoundInstance of ASoundEffectsSubsystem.  This is used
    // for non-seamless loops where there is a random delay between loop iterations.
    void StopInstance (ASoundInstance* inInstance);
    // Requires ASoundInstance to be a friend...
    friend class ASoundInstance;

    // When the UAudioSubsystem stops a sound sample for whatever reason, we need to make sure and cleanup SoundInstance's
    // that reference the sample
    void OnSubsystemStoppedSound( int StoppedHandle );
    // Requires this function to be a friend...
    friend static void GlobalSoundStoppedByAudioSubsystem( int SoundIndex );

    static UAudioSubsystem* AudioSubsystem;

public:
    // Used to register names for events in this package
    void InitExecution();
    void PostScriptDestroyed();

    // Returns the duration of the sound
    static FLOAT GetSoundInstanceDuration(ASoundInstance* inInstance);

    // Returns the current UAudioSubsystem...
    static UAudioSubsystem* GetAudio();

    // Stops a sound from playing the actual sound, though it still updates.  Used when a sound is too far away to hear
    void MuteInstance (ASoundInstance* inInstance);
    void UnMuteInstance (ASoundInstance* inInstance);

    // Instance handling functions
    void PlayInstance (ASoundInstance* inInstance);
    void KillInstance (ASoundInstance* inInstance);
#if IG_SWAT
    virtual UBOOL HasContext(AActor* Subject, FName Context);
    virtual INT GetNumAlternateContexts();
#endif

    //declaration of script-side
    //  var private native noexport const int PrecacheNormalSoundEffects[5];
    TSet<USound*> PrecacheNormalSoundEffects;
    //  var private native noexport const int PrecacheStreamingSoundEffects[5];
    TSet<FString> PrecacheStreamingSoundEffects;

    //overridden from EffectsSubsystem
    void PrecacheEffectSpecification(UEffectSpecification* Spec);

    //instruct the engine to precache all assets related to the specified sound effect.
    void PrecacheNormalSoundEffect(USound* SoundEffect);
    void PrecacheStreamingSoundEffect(FString SoundEffect);

}

const kMaxSounds = 80;
const kMaxInstances = 80;
const kNoTime = 1000000000.0;

var private transient ActorBank SoundInstanceBank;
var transient array<SoundInstance> CurrentSounds;
var private bool bSoundsArePaused;
var private bool GameStarted;
var private config bool bDebugSounds;
var private name MusicContext;
var private string MusicManagerClassName;
var private DynamicMusicManagerBase MusicManager;
var MusicMarker LastMusicMarker;
var Speakers Speakers;
var string OverrideCaptionSpeakerNameForNextEffectEvent;
var private native const noexport int PrecacheStreamingSoundEffects[5];
var private native const noexport int PrecacheNormalSoundEffects[5];

// Export USoundEffectsSubsystem::execSetNativeLooping(FFrame&, void* const)
native static function SetNativeLooping(Level inSoundLevel, Sound inSound);

// Export USoundEffectsSubsystem::execGetSoundDebugText(FFrame&, void* const)
native final function string GetSoundDebugText();

// Export USoundEffectsSubsystem::execStopSound(FFrame&, void* const)
native final function bool StopSound(Actor Source, Sound Sound);

// Export USoundEffectsSubsystem::execStopMySchemas(FFrame&, void* const)
native final function StopMySchemas(Actor inSource);

// Export USoundEffectsSubsystem::execStopAllSchemas(FFrame&, void* const)
native final function StopAllSchemas();

// Export USoundEffectsSubsystem::execStopAllLoopingSchemas(FFrame&, void* const)
native final function StopAllLoopingSchemas();

// Export USoundEffectsSubsystem::execStopMyLoopingSchemas(FFrame&, void* const)
native final function StopMyLoopingSchemas(Actor inSource);

// Export USoundEffectsSubsystem::execIsSchemaPlaying(FFrame&, void* const)
native final function bool IsSchemaPlaying(Actor inSource, name SpecificationName);

// Export USoundEffectsSubsystem::execCanStartInstance(FFrame&, void* const)
private native final function bool CanStartInstance(SoundInstance inInstance);

// Export USoundEffectsSubsystem::execKillInstance(FFrame&, void* const)
private native final function KillInstance(SoundInstance inInstance);

// Export USoundEffectsSubsystem::execAddToCurrentSounds(FFrame&, void* const)
private native final function AddToCurrentSounds(SoundInstance inInstance);

// Export USoundEffectsSubsystem::execCreateSoundInstance(FFrame&, void* const)
private native final function SoundInstance CreateSoundInstance();

// Export USoundEffectsSubsystem::execNativeInitialize(FFrame&, void* const)
private native final function NativeInitialize();

// Export USoundEffectsSubsystem::execHasAudioHardware(FFrame&, void* const)
native function bool HasAudioHardware();

// Export USoundEffectsSubsystem::execPostLoaded(FFrame&, void* const)
native function PostLoaded();

function OnBankWithdrawn(Actor inActorWithdrawn)
{
	AssertWithDescription(inActorWithdrawn.IsA('SoundInstance'), "Withdrawing a non-SoundInstance from the bank!");
	inActorWithdrawn.OptimizeIn();
	return;
}

function OnBankDeposited(Actor inActorDeposited)
{
	local SoundInstance BankedInstance;

	AssertWithDescription(inActorDeposited.IsA('SoundInstance'), "Depositing a non-SoundInstance from the bank!");
	BankedInstance = SoundInstance(inActorDeposited);
	if(NotEqual_IntInt(BankedInstance.SoundHandle, -1))
	{
		AssertWithDescription(false, Concat_StrStr(Concat_StrStr("Error, SoundInstance ", string(BankedInstance)), " is being deposited in the bank but it wasn't stopped."));
	}
	if(bDebugSounds)
	{
		Log(Concat_StrStr(Concat_StrStr("Actor: ", string(BankedInstance)), " was deposited"));
	}
	inActorDeposited.OptimizeOut();
	return;
}

simulated function DynamicMusicManagerBase GetMusicManager()
{
	return MusicManager;
	return;
}

simulated function PreBeginPlay()
{
	local Class<DynamicMusicManagerBase> ManagerClass;

	super.PreBeginPlay();
	RegisterNotifyGameStarted();
	Level.RegisterNotifyActorDestroyed(self);
	SoundInstanceBank = Spawn(Class'IGSoundEffectsSubsystem.ActorBank');
	SoundInstanceBank.Initialize(Class'IGSoundEffectsSubsystem.SoundInstance');
	SoundInstanceBank.__OnWithdrawn__Delegate = OnBankWithdrawn;
	SoundInstanceBank.__OnDeposited__Delegate = OnBankDeposited;
	NativeInitialize();
	ManagerClass = Class<DynamicMusicManagerBase>(DynamicLoadObject(MusicManagerClassName, Class'Core.Class'));
	MusicManager = Spawn(ManagerClass);
	return;
}

function OnOtherActorDestroyed(Actor ActorBeingDestroyed)
{
	Log(Concat_StrStr(Concat_StrStr("Actor", string(ActorBeingDestroyed)), " was destroyed"));
	StopMyLoopingSchemas(ActorBeingDestroyed);
	return;
}

simulated function OnGameStarted()
{
	GameStarted = true;
	return;
}

simulated function int GetSoundMaterialFlags(Material inMaterial)
{
	if(NotEqual_ObjectObject(inMaterial, none))
	{
		if(NotEqual_IntInt(inMaterial.MaterialSoundType, 0))
		{
			return inMaterial.MaterialSoundType;
		}
		else
		{
			return int(inMaterial.MaterialVisualType);
		}
	}
	return 0;
	return;
}

simulated event Actor PlayEffectSpecification(EffectSpecification GenericSchema, Actor Source, optional Actor Target, optional Material TargetMaterial, optional Vector overrideWorldLocation, optional Rotator overrideWorldRotation, optional IEffectObserver Observer)
{
	local SoundInstance NewInstance;
	local SoundEffectSpecification Schema;
	local bool bInstanceValid;

	if(EqualEqual_ObjectObject(GenericSchema, none))
	{
		return none;
	}
	Schema = SoundEffectSpecification(GenericSchema);
	assert(NotEqual_ObjectObject(Schema, none));
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer)))
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(Source, none), Greater_FloatFloat(Schema.GetAISoundRadius(), 0.0000000)))
		{
			Source.SimulateSoundOnDedicatedServer(Schema.GetNativeFlags(), Not_PreBool(Schema.IsLocal()), Schema.GetAISoundRadius(), Schema.GetSoundCategory());
		}
		return none;
	}
	if(Not_PreBool(HasAudioHardware()))
	{
		return none;
	}
	if(bDebugSounds)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[SOUNDEFFECTS] - EffectSpecification Triggered!  Specification: ", string(GenericSchema)), ", on Actor: "), string(Source)), " and Material: "), string(TargetMaterial)));
	}
	NewInstance = CreateSoundInstance();
	if(NotEqual_ObjectObject(NewInstance, none))
	{
		bInstanceValid = Schema.ConstructSoundInstance(NewInstance, GetSoundMaterialFlags(TargetMaterial), Source, GameStarted, overrideWorldLocation);
		if(NotEqual_ObjectObject(Observer, none))
		{
			NewInstance.SetObserver(Observer);
		}
		if(OrOr_BoolBool(Not_PreBool(bInstanceValid), Not_PreBool(CanStartInstance(NewInstance))))
		{
			if(bDebugSounds)
			{
				Log("[SOUNDEFFECTS] - ERROR! Sound could not be started!");
			}
			KillInstance(NewInstance);
			return none;
		}
		if(bDebugSounds)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("New Instance:", string(NewInstance)), " Instantiated: "), NewInstance.toString()));
		}
		AddToCurrentSounds(NewInstance);
		if(bDebugSounds)
		{
			Log(Concat_StrStr("About to play New Instance: ", NewInstance.toString()));
		}
		NewInstance.OnFinishedInitialized();
		NewInstance.Play();
	}
	return NewInstance;
	return;
}

simulated event Actor PlaySpecificSoundFromSchema(EffectSpecification GenericSchema, Actor Source, int SpecificSoundRef, optional Actor Target, optional Material TargetMaterial, optional Vector overrideWorldLocation, optional Rotator overrideWorldRotation, optional IEffectObserver Observer)
{
	local SoundInstance NewInstance;
	local SoundEffectSpecification Schema;
	local bool bInstanceValid;

	if(EqualEqual_ObjectObject(GenericSchema, none))
	{
		return none;
	}
	Schema = SoundEffectSpecification(GenericSchema);
	assert(NotEqual_ObjectObject(Schema, none));
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer)))
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(Source, none), Greater_FloatFloat(Schema.GetAISoundRadius(), 0.0000000)))
		{
			Source.SimulateSoundOnDedicatedServer(Schema.GetNativeFlags(), Not_PreBool(Schema.IsLocal()), Schema.GetAISoundRadius(), Schema.GetSoundCategory());
		}
		return none;
	}
	if(Not_PreBool(HasAudioHardware()))
	{
		return none;
	}
	if(bDebugSounds)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[SOUNDEFFECTS] - EffectSpecification Triggered!  Specification: ", string(GenericSchema)), ", on Actor: "), string(Source)), " and Material: "), string(TargetMaterial)));
	}
	NewInstance = CreateSoundInstance();
	if(NotEqual_ObjectObject(NewInstance, none))
	{
		bInstanceValid = Schema.ConstructSoundInstance(NewInstance, GetSoundMaterialFlags(TargetMaterial), Source, GameStarted, overrideWorldLocation, SpecificSoundRef);
		if(NotEqual_ObjectObject(Observer, none))
		{
			NewInstance.SetObserver(Observer);
		}
		if(OrOr_BoolBool(Not_PreBool(bInstanceValid), Not_PreBool(CanStartInstance(NewInstance))))
		{
			if(bDebugSounds)
			{
				Log("[SOUNDEFFECTS] - ERROR! Sound could not be started!");
			}
			KillInstance(NewInstance);
			return none;
		}
		if(bDebugSounds)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("New Instance:", string(NewInstance)), " Instantiated: "), NewInstance.toString()));
		}
		AddToCurrentSounds(NewInstance);
		if(bDebugSounds)
		{
			Log(Concat_StrStr("About to play New Instance: ", NewInstance.toString()));
		}
		NewInstance.OnFinishedInitialized();
		NewInstance.Play();
	}
	return NewInstance;
	return;
}

simulated event StopEffectSpecification(EffectSpecification EffectSpec, Actor Source)
{
	local int i;

	AssertWithDescription(NotEqual_ObjectObject(Source, none), "StopSchema called with NULL source.");
	i = Subtract_IntInt(CurrentSounds.Length, 1);
	J0x42:

	if(GreaterEqual_IntInt(i, 0))
	{
		if(NotEqual_ObjectObject(CurrentSounds[i], none))
		{
			if(AndAnd_BoolBool(EqualEqual_ObjectObject(CurrentSounds[i].Source, Source), EqualEqual_ObjectObject(CurrentSounds[i].Schema, EffectSpec)))
			{
				KillInstance(CurrentSounds[i]);
			}
		}
		SubtractSubtract_PreInt(i);
		// [Loop Continue]
		goto J0x42;
	}
	return;
}

simulated function PauseAllSchemas()
{
	if(Not_PreBool(bSoundsArePaused))
	{
		ConsoleCommand("PauseSounds");
		bSoundsArePaused = true;
	}
	return;
}

simulated function UnpauseAllSchemas()
{
	if(bSoundsArePaused)
	{
		ConsoleCommand("UnpauseSounds");
		bSoundsArePaused = false;
	}
	return;
}

simulated function PlayMarkerSounds(Actor inSource, string inSoundID1, string inSoundID2)
{
	local bool bPlaySound1, bPlaySound2;
	local int i;

	bPlaySound1 = true;
	bPlaySound2 = true;
	i = 0;
	J0x17:

	if(Less_IntInt(i, CurrentSounds.Length))
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(CurrentSounds[i], none), NotEqual_ObjectObject(CurrentSounds[i].Source, none)))
		{
			if(CurrentSounds[i].Source.IsA('SoundMarker'))
			{
				if(EqualEqual_StrStr(string(CurrentSounds[i].Schema.Name), inSoundID1))
				{
					bPlaySound1 = false;
					// [Explicit Continue]
					goto J0xF0;
				}
				if(EqualEqual_StrStr(string(CurrentSounds[i].Schema.Name), inSoundID2))
				{
					bPlaySound2 = false;
					// [Explicit Continue]
					goto J0xF0;
				}
				KillInstance(CurrentSounds[i]);
			}
		}
		J0xF0:

		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x17;
	}
	if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_StrStr(inSoundID1, ""), NotEqual_ObjectObject(GetSpecificationByString(inSoundID1), none)), bPlaySound1))
	{
		PlayEffectSpecification(GetSpecificationByString(inSoundID1), inSource);
	}
	if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_StrStr(inSoundID2, ""), NotEqual_ObjectObject(GetSpecificationByString(inSoundID2), none)), bPlaySound2))
	{
		PlayEffectSpecification(GetSpecificationByString(inSoundID2), inSource);
	}
	return;
}

simulated function SetMusicContext(name inMusicContext)
{
	MusicContext = inMusicContext;
	return;
}

simulated function LogState()
{
	local int i;
	local string StateString;

	Log("----------------------------------------------------------------");
	Log("|              SOUND EFFECTS SUBSYSTEM STATE                   |");
	Log("----------------------------------------------------------------");
	Log("| Existing sounds:");
	i = 0;
	J0xE9:

	if(Less_IntInt(i, CurrentSounds.Length))
	{
		StateString = "None";
		if(NotEqual_ObjectObject(CurrentSounds[i], none))
		{
			StateString = CurrentSounds[i].toString();
		}
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("|   #", string(i)), ": "), StateString));
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0xE9;
	}
	Log("----------------------------------------------------------------");
	return;
}

defaultproperties
{
	MusicManagerClassName="SwatGame.DynamicMusicManager"
	EffectSpecificationSubClass=Class'IGSoundEffectsSubsystem.SoundEffectSpecification'
	ShouldInitOnDedicatedServer=true
	IniFileName="SoundEffects.ini"
	ConfigPackageName="SoundEffectsConfig"
	ConfigPackageFullFileName="..\\..\\content\\system\\SoundEffectsConfig.u"
	EventResponseSubClass=Class'IGSoundEffectsSubsystem.EventResponse_SoundEffectsSubsystem'
}