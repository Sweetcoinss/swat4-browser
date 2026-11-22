class SoundRef extends Object
	abstract
	native;

cpptext
{
    // These can't be abstract virtual functions because unreal instantiates a uobject in
    // a declare class macro.  I could make this class noexport and use DECLARE_ABSTRACT_CLASS
    // but that's a major pain in the ass.
    // TODO: Make these functions either static or truely immutable...
    virtual INT Play(ASoundInstance* inInstance)   { check(false); return 0; }
    virtual void Stop(ASoundInstance* inInstance)   { check(false); }
    virtual void Mute(ASoundInstance* inInstance)   { check(false); }
    virtual void UnMute(ASoundInstance* inInstance) { check(false); }

    virtual void SetPitch(ASoundInstance* inInstance, FLOAT inPitch) { check(false); }
    virtual void SetVolume(ASoundInstance* inInstance, FLOAT inVolume) { check(false); }

    virtual FLOAT GetDuration(ASoundInstance* inInstance) { check(false); return 0.0f; }

    // TODO: make the uscrip Equals call the c++ Equals...
    virtual UBOOL Equals(class USoundRef* inOther)
    {
        return this == inOther;
    }

}

var int SoundSetIndex;

simulated function bool Equals(SoundRef inOtherRef)
{
	return EqualEqual_ObjectObject(self, inOtherRef);
	return;
}

simulated event string toString()
{
	return;
}
