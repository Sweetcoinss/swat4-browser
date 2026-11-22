class StreamSoundRef extends SoundRef
	native;

cpptext
{
    INT Play(ASoundInstance* inInstance);
    void Stop(ASoundInstance* inInstance);
    FLOAT GetDuration(ASoundInstance* inInstance);

    void Mute(ASoundInstance* inInstance);
    void UnMute(ASoundInstance* inInstance);
    void SetPitch(ASoundInstance* inInstance, FLOAT inPitch);
    void SetVolume(ASoundInstance* inInstance, FLOAT inVolume);
    void Recompile();
private:
    INT PlayStream(AActor* Actor, FString Filename, INT SampleRate, FLOAT Volume, FLOAT InnerRadius, FLOAT OuterRadius, FLOAT Pitch, INT Priority, INT Flags, FLOAT FadeInTime, FLOAT AISoundRadius, FName SoundCategory);
    void StopStream(ASoundInstance* inInstance);

}

var string Stream;
var float StreamDuration;

// Export UStreamSoundRef::execPlayStream(FFrame&, void* const)
private native final function PlayStream(Actor Actor, string FileName, optional int SampleRate, optional float Volume, optional float InnerRadius, optional float OuterRadius, optional float Pitch, optional int Priority, optional int flags, optional float FadeInTime, optional float AISoundRadius, optional name SoundCategory);

// Export UStreamSoundRef::execStopStream(FFrame&, void* const)
private native final function StopStream(Actor Source, string FileName);

// Export UStreamSoundRef::execPauseStream(FFrame&, void* const)
private native function bool PauseStream(Actor inActor, string inFilename);

// Export UStreamSoundRef::execResumeStream(FFrame&, void* const)
private native function bool ResumeStream(Actor inActor, string inFilename);

simulated event string toString()
{
	return Concat_StrStr("StreamSoundRef playing Stream: ", Stream);
	return;
}
