class IGEffectsSystemBase extends Object
	native;

cpptext
{
    virtual void Init(AActor* Owner);

}

var bool ShowCaptions;

function Init(Actor Owner)
{
	return;
}

simulated function SetSeedForNextEffectEvent(int newSeed)
{
	return;
}

simulated function AddPersistentContext(name Context)
{
	return;
}

simulated function RemovePersistentContext(name Context)
{
	return;
}

simulated function AddContextForNextEffectEvent(name Context)
{
	return;
}

function bool EffectEventTriggered(Actor Source, name EffectEvent, optional Actor Target, optional Material TargetMaterial, optional Vector overrideWorldLocation, optional Rotator overrideWorldRotation, optional bool unTriggered, optional bool PlayOnTarget, optional bool QueryOnly, optional IEffectObserver Observer, optional name Tag, optional name SkipSubsystemWithThisName)
{
	return;
}

static final function Class<IGEffectsSystemBase> GetEffectsSystemClass()
{
	return Class<IGEffectsSystemBase>(DynamicLoadObject("IGEffectsSystem.EffectsSystem", Class'Core.Class'));
	return;
}
