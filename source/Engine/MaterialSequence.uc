class MaterialSequence extends Modifier
	native
	editinlinenew
	collapsecategories
	hidecategories(Object,Material,Modifier);

cpptext
{
	virtual void PostEditChange();
	virtual UBOOL CheckCircularReferences( TArray<class UMaterial*>& History );
	virtual void PreSetMaterial(FLOAT TimeSeconds);
	virtual void Serialize(FArchive& Ar);
#if IG_SHARED // ckline: support glow in material sequences
    virtual UBOOL IsGlowMaterial()
    {
	    return (SequenceItems.Num() && SequenceItems(0).Material) ? SequenceItems(0).Material->IsGlowMaterial() : 0;
    }
    virtual UBOOL IsBumpMapped()
    {
	    return (SequenceItems.Num() && SequenceItems(0).Material) ? SequenceItems(0).Material->IsBumpMapped() : 0;
    }
#endif

}

enum EMaterialSequenceAction
{
	MSA_ShowMaterial,               // 0
	MSA_FadeToMaterial              // 1
};

enum EMaterialSequenceTriggerActon
{
	MSTA_Ignore,                    // 0
	MSTA_Reset,                     // 1
	MSTA_Pause,                     // 2
	MSTA_Stop                       // 3
};

struct native MaterialSequenceItem
{
	var() editinlineuse Material Material;
	var() float Time;
	var() MaterialSequence.EMaterialSequenceAction Action;
};

var array<MaterialSequenceItem> SequenceItems;
var MaterialSequence.EMaterialSequenceTriggerActon TriggerAction;
var bool Loop;
var bool Paused;
var transient float CurrentTime;
var transient float LastTime;
var float TotalTime;

function Reset()
{
	CurrentTime = 0.0000000;
	LastTime = 0.0000000;
	Paused = default.Paused;
	return;
}

function Trigger(Actor Other, Actor EventInstigator)
{
	switch(TriggerAction)
	{
		case 1:
			CurrentTime = 0.0000000;
			LastTime = 0.0000000;
			break;
		case 2:
			Paused = Not_PreBool(Paused);
			break;
		case 3:
			Paused = true;
			break;
		default:
			break;
	}
	return;
}

defaultproperties
{
	Loop=true
	MaterialType=8
}