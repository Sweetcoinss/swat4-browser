class SoundEffectSpecification extends EffectSpecification
	abstract
	native
	config(SoundEffects)
	perobjectconfig;

cpptext
{
    ULevel*         GetLevel();
    void            ParseVariables();
    void            SetNativeFlags();
    void            PopulateSoundSets();
    class USoundRef* PickSoundToPlay(INT inTextureFlags, INT SpecificSoundRef=-1);
    void            HandleLazyInitialization();
    void            HandleLoopingSoundInstance(ASoundInstance* inInstance, FLOAT inCurrentTime);
    void            HandleStartTimeSoundInstance(ASoundInstance* inInstance, FLOAT inCurrentTime, UBOOL inGameStarted);
    void            HandleEndTimeSoundInstance(ASoundInstance* inInstance, FLOAT inCurrentTime);
    void            UpdateHistory(USoundRef* inSoundJustPlayed, INT inTextureFlags);
    USoundSet*      GetAppropriateSoundSet(INT inTextureFlags);
    UBOOL           WantsToLoop();

}

const kNoTime = 1000000000.0;
const SF_Looping = 2;
const SF_Streaming = 4;
const SF_LoopingStream = 8;
const SF_No3D = 16;
const SF_UpdatePitch = 32;
const SF_NoUpdates = 64;
const SF_RootMotion = 128;
const SF_NoOverride = 256;
const SF_VolumePriority = 512;
const SF_Ambient = 1024;
const SF_Voice = 2048;
const SF_Music = 4096;

enum EVolumeCategory
{
	VOL_Normal,                     // 0
	VOL_Ambient,                    // 1
	VOL_Voice,                      // 2
	VOL_Music                       // 3
};

struct native PolyLoopStruct
{
	var config Range PolyLoopRange;
	var config int LoopSoundLimit;
};

var private config SoundEffectSpecification.EVolumeCategory VolumeCategory;
var private config int SampleRate;
var private config float OuterRadius;
var private config float InnerRadius;
var private config int Volume;
var private config float Pitch;
var private config float Delay;
var private config float Pan;
var private config Range PitchRange;
var private config Range PanRange;
var private config Range Monoloop;
var private config PolyLoopStruct Polyloop;
var private config int LoopCount;
var private config float AISoundRadius;
var private config name SoundCategory;
var private config bool Local;
var private config bool NoRepeat;
var private config bool NeverRepeat;
var private config bool PlayOnce;
var private config bool Retriggerable;
var private config float FadeInTime;
var private config float FadeOutTime;
var private config int Monophonic;
var private config int MonophonicPriority;
var private config bool MonophonicToClass;
var private config int Priority;
var private config localized string Caption;
var private config name Speaker;
var private bool IsPitchRange;
var private bool IsPanRange;
var private bool IsMonoloop;
var private bool IsPolyloop;
var private bool IsSeamlessLoop;
var private bool IsEndPredictable;
var private bool Killable;
var private Range LoopDelayRange;
var private int LoopSoundLimit;
var private int NativeFlags;
var array<SoundSet> SoundSets;
var private bool IsFullyInitialized;

// Export USoundEffectSpecification::execNativeInitialize(FFrame&, void* const)
private native final function NativeInitialize(SoundEffectsSubsystem SoundEffectsSubsystem);

// Export USoundEffectSpecification::execConstructSoundInstance(FFrame&, void* const)
native final function bool ConstructSoundInstance(SoundInstance inInstance, int inTextureFlags, Actor inSource, bool inGameStarted, Vector inWorldLocation, optional int SpecificSoundRef);

// Export USoundEffectSpecification::execWantsToLoop(FFrame&, void* const)
native final function bool WantsToLoop();

protected simulated event SetNativeFlagsHook()
{
	return;
}

protected simulated event InitHook()
{
	return;
}

protected simulated event PopulateSoundsHook()
{
	return;
}

// Export USoundEffectSpecification::execPickSoundToPlay(FFrame&, void* const)
native final simulated function SoundRef PickSoundToPlay(int inTextureFlags, optional int SpecificSoundRef);

simulated function Init(EffectsSubsystem inSubsystem)
{
	NativeInitialize(SoundEffectsSubsystem(inSubsystem));
	return;
}

simulated function string ExtractToken(out string ioSourceString, string inDelimiter)
{
	local string strToken;
	local int iOffset;

	if(EqualEqual_IntInt(Len(ioSourceString), 0))
	{
		Warn("[SOUND]: WARNING: Ran out of tokens!");
	}
	iOffset = InStr(ioSourceString, inDelimiter);
	if(NotEqual_IntInt(iOffset, -1))
	{
		strToken = Left(ioSourceString, iOffset);
		ioSourceString = Mid(ioSourceString, Add_IntInt(iOffset, Len(inDelimiter)));
	}
	else
	{
		strToken = ioSourceString;
		ioSourceString = "";
	}
	return strToken;
	return;
}

simulated function string toString()
{
	return Concat_StrStr(Concat_StrStr("{Name=\"", string(Name)), "}");
	return;
}

function float GetOuterRadius()
{
	return OuterRadius;
	return;
}

function bool IsLocal()
{
	return Local;
	return;
}

function int GetNativeFlags()
{
	return NativeFlags;
	return;
}

function float GetAISoundRadius()
{
	return AISoundRadius;
	return;
}

function name GetSoundCategory()
{
	return SoundCategory;
	return;
}

defaultproperties
{
	VolumeCategory=2
	SampleRate=24000
	OuterRadius=3000.0000000
	Volume=100
	Pitch=1.0000000
	Retriggerable=true
	MonophonicPriority=2
	Priority=1
	Killable=true
}