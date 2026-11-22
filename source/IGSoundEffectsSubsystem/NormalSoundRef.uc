class NormalSoundRef extends SoundRef
	native;

cpptext
{
    virtual INT Play(ASoundInstance* inInstance);
    virtual void Stop(ASoundInstance* inInstance);

    virtual void Mute(ASoundInstance* inInstance);
    virtual void UnMute(ASoundInstance* inInstance);

    virtual FLOAT GetDuration(ASoundInstance* inInstance);

    virtual void SetPitch(ASoundInstance* inInstance, FLOAT inPitch);
    virtual void SetVolume(ASoundInstance* inInstance, FLOAT inVolume);

}

var Sound Sound;

private simulated event int PlayMySound(SoundInstance inInstance)
{
	if(NotEqual_ObjectObject(Sound, none))
	{
		return inInstance.Source.PlaySound(Sound, Divide_FloatFloat(inInstance.Volume, 100.0000000), false, inInstance.InnerRadius, inInstance.OuterRadius, inInstance.Pitch, inInstance.NativeFlags, inInstance.FadeInTime, Not_PreBool(inInstance.Local), inInstance.AISoundRadius, inInstance.SoundCategory);
	}
	else
	{
		return -1;
	}
	return;
}

simulated event string toString()
{
	return Concat_StrStr("NormalSoundRef playing USound: ", string(Sound));
	return;
}
