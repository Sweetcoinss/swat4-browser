class StreamSoundEffectSpecification extends SoundEffectSpecification
	native
	config(SoundEffects)
	perobjectconfig;

cpptext
{
    // This function registers the streams and precaches any necessary data
    UBOOL UStreamSoundEffectSpecification::RegisterStream(const FString& Filename, INT SampleRate=48000, INT Flags=0  );

}

enum ESoundStreamType
{
	ADPCM,                          // 0
	PCM                             // 1
};

var config array<string> Streams;
var private config StreamSoundEffectSpecification.ESoundStreamType StreamType;

protected simulated event InitHook()
{
	return;
}

protected simulated event SetNativeFlagsHook()
{
	AddEqual_IntInt(NativeFlags, 4);
	if(IsSeamlessLoop)
	{
		AddEqual_IntInt(NativeFlags, 8);
	}
	return;
}

// Export UStreamSoundEffectSpecification::execPopulateSoundsHook(FFrame&, void* const)
protected native simulated event PopulateSoundsHook();
