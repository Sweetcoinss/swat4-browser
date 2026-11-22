class NormalSoundEffectSpecification extends SoundEffectSpecification
	native
	config(SoundEffects)
	perobjectconfig;

struct native FlaggedSound
{
	var config Sound SoundToPlay;
	var config int Flag;
};

var config array<FlaggedSound> FlaggedSounds;

protected simulated event SetNativeFlagsHook()
{
	local int i;

	if(IsSeamlessLoop)
	{
		AddEqual_IntInt(NativeFlags, 2);
		i = 0;
		J0x19:

		if(Less_IntInt(i, FlaggedSounds.Length))
		{
			if(NotEqual_ObjectObject(FlaggedSounds[i].SoundToPlay, none))
			{
				Class'IGSoundEffectsSubsystem.SoundEffectsSubsystem'.static.SetNativeLooping(Level, FlaggedSounds[i].SoundToPlay);
			}
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x19;
		}
	}
	return;
}

protected simulated event InitHook()
{
	if(AndAnd_BoolBool(OrOr_BoolBool(NoRepeat, NeverRepeat), Not_PreBool(Greater_IntInt(FlaggedSounds.Length, 1))))
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("[SOUND] WARNING!: Schema <", ":"), string(Name)), "> has NoRepeat/NeverRepeat but only has 1 sound!"));
		NoRepeat = false;
		NeverRepeat = false;
	}
	return;
}

protected simulated event PopulateSoundsHook()
{
	local int i, iSetToInsert;
	local NormalSoundRef newNormalRef;

	if(EqualEqual_IntInt(FlaggedSounds.Length, 0))
	{
		AssertWithDescription(false, Concat_StrStr(Concat_StrStr("NormalSoundEffectSpecification ", string(Name)), " has no FlaggedSounds specified. This will cause a crash if ignored."));
		assert(false);
	}
	i = 0;
	J0x90:

	if(Less_IntInt(i, FlaggedSounds.Length))
	{
		AssertWithDescription(NotEqual_ObjectObject(FlaggedSounds[i].SoundToPlay, none), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("The sound at index ", string(i)), " in SoundEffectSpecification '"), string(Name)), "' was not found."));
		iSetToInsert = FlaggedSounds[i].Flag;
		if(LessEqual_IntInt(SoundSets.Length, iSetToInsert))
		{
			SoundSets.Length = Add_IntInt(iSetToInsert, 1);
		}
		if(EqualEqual_ObjectObject(SoundSets[iSetToInsert], none))
		{
			SoundSets[iSetToInsert] = Class'IGSoundEffectsSubsystem.SoundSet'.static.Allocate(self, self).;
			Construct_Void();
		}
		newNormalRef = Class'IGSoundEffectsSubsystem.NormalSoundRef'.static.Allocate(self, self).;
		Construct_Void();
		newNormalRef.Sound = FlaggedSounds[i].SoundToPlay;
		SoundSets[iSetToInsert].AddSoundRef(newNormalRef);
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x90;
	}
	return;
}
