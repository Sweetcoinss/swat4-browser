class SoundSet extends Object
	native;

cpptext
{
    // Returns true if there are no available sounds to play
    UBOOL IsAvailableEmpty();
    // Free up the soundref to be picked
    void  MakeSoundAvailable (class USoundRef* inSoundRef);
    // Make all sounds used, so this SoundSet will no longer return sounds
    void MakeNoSoundsAvailable ();
    // Free up all sounds to be picked
    void  MakeAllSoundsAvailable();
    // Pick a random sound from the available list of sounds
    class USoundRef* PickRandomSound (class USoundRef* inExcludedSoundRef = NULL);
    // Use up a sound
    void  UseSound (class USoundRef* inSoundRef);

    // Return the specific sound ref specified, will NOT use up the sound.  Client is required to do all setup work.
    class USoundRef* GetSoundRef( INT Index );

    // Add sounds to the set...
    void  AddSound (USound* inSound);
    void  AddStream (FString inStream);
    void  AddSoundRef (class USoundRef* inRef);

}

enum ESoundStatus
{
	SS_Available,                   // 0
	SS_Used                         // 1
};

var array<SoundRef> AllSounds;
var array<SoundSet.ESoundStatus> StatusArray;
var private SoundRef LastSoundUsed;

// Export USoundSet::execAddSoundRef(FFrame&, void* const)
native final function AddSoundRef(SoundRef inRef);
