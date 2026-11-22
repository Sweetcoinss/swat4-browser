class SoundInstance extends Actor
	native
	config
	notplaceable
	hidecategories(Karma);

cpptext
{
private:
    // Returns wether the sound was stopped during the update
    UBOOL   HandleUpdating(FLOAT DeltaTime);
    void    UpdateSourceLocation();
    void    HandleDistanceMuting();

    void    CalculateNextPlayTime(FLOAT inCurrentTime);
    friend class USoundEffectSpecification;

public:
    virtual UBOOL Tick( FLOAT DeltaTime, enum ELevelTick TickType );
    void    PlaySound();
    void    StopSound();

    void    MuteSound();
    void    UnMuteSound();

    UBOOL    WantsToLoop();
    FLOAT    GetDuration();

    void    CleanupForDeposit();

}

var const transient IEffectObserver Observer;
var const transient SoundEffectsSubsystem Manager;
var const transient SoundRef ActualSound;
var const SoundEffectSpecification Schema;
var const transient Actor Source;
var const transient Vector SavedSourceLocation;
var const float StartTime;
var const float EndTime;
var const float NextPlayTime;
var const float NextStopTime;
var const float Delay;
var const int CurrentLoopCount;
var const Range LoopRange;
var const float FadeInTime;
var const float FadeOutTime;
var float Pitch;
var float Volume;
var const float OuterRadius;
var const float InnerRadius;
var const bool Retriggerable;
var const bool Paused;
var const bool Muted;
var const bool Local;
var const bool IsEndPredictable;
var const bool IsMonoloop;
var const bool IsPolyloop;
var const bool IsSeamlessLoop;
var const float AISoundRadius;
var const name SoundCategory;
var const int Monophonic;
var const int MonophonicPriority;
var const int Priority;
var const bool MonophonicToClass;
var const int NativeFlags;
var const int SoundHandle;
var const bool IsPlaying;
var const bool IsUpdating;

// Export USoundInstance::execPlay(FFrame&, void* const)
native final function Play();

// Export USoundInstance::execStop(FFrame&, void* const)
native final function Stop();

// Export USoundInstance::execSetObserver(FFrame&, void* const)
native final function SetObserver(IEffectObserver inObserver);

// Export USoundInstance::execSetPitch(FFrame&, void* const)
native final function SetPitch(float inPitch);

// Export USoundInstance::execSetVolume(FFrame&, void* const)
native final function SetVolume(float inVolume);

// Export USoundInstance::execGetDuration(FFrame&, void* const)
native final function float GetDuration();

simulated event string toString()
{
	local string SourceString, StringRep;

	SourceString = Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("{", string(self)), ", Name="), string(Source.Name)), ", Class="), string(Source.Class.Name)), "}");
	StringRep = Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[In Use: Source=", SourceString), ", Spec="), string(Schema.Name)), ", Updating="), string(IsUpdating)), ", Paused="), string(Paused)), ", Muted="), string(Muted)), "]");
	if(EqualEqual_ObjectObject(ActualSound, none))
	{
		StringRep = Concat_StrStr(StringRep, "SoundRef is NONE");
	}
	else
	{
		StringRep = Concat_StrStr(Concat_StrStr(StringRep, " SoundRef Playing is: "), ActualSound.toString());
	}
	return StringRep;
	return;
}

simulated function OnFinishedInitialized()
{
	if(NotEqual_ObjectObject(Observer, none))
	{
		Observer.OnEffectInitialized(self);
	}
	return;
}

defaultproperties
{
	Pitch=1.0000000
	SoundHandle=-1
	DrawType=0
	bHidden=true
	RemoteRole=0
	bAlwaysTick=true
}