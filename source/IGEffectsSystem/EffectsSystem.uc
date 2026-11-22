class EffectsSystem extends IGEffectsSystemBase
	native
	config(EffectsSystem);

cpptext
{
    virtual void Init(AActor* Owner);

}

var config array< Class<EffectsSubsystem> > EffectsSubsystem;
var array<EffectsSubsystem> AllEffectsSubsystems;
var config array<string> PreloadActorClass;
var config bool LogEffectEvents;
var private int CurrentSeed;
var array<name> TemporaryContexts;
var array<name> PersistentContexts;
var private bool QueueingEvents;
var array<Actor> QueuedSource;
var array<name> QueuedEffectEvent;
var array<Actor> QueuedTarget;
var array<Material> QueuedTargetMaterial;
var array<Vector> QueuedOverrideWorldLocation;
var array<Rotator> QueuedOverrideWorldRotation;
var array<byte> QueuedUnTriggered;
var config array<name> DebugEffectEvent;

// Export UEffectsSystem::execInit(FFrame&, void* const)
native simulated function Init(Actor Owner);

simulated function EffectsSubsystem GetSubsystem(name inSubsystem)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, AllEffectsSubsystems.Length))
	{
		if(EqualEqual_NameName(AllEffectsSubsystems[i].Tag, inSubsystem))
		{
			return AllEffectsSubsystems[i];
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return none;
	return;
}

simulated function SetSeedForNextEffectEvent(int newSeed)
{
	CurrentSeed = newSeed;
	return;
}

simulated function AddContextForNextEffectEvent(name Context)
{
	TemporaryContexts[TemporaryContexts.Length] = Context;
	return;
}

simulated function AddPersistentContext(name Context)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, PersistentContexts.Length))
	{
		if(EqualEqual_NameName(PersistentContexts[i], Context))
		{
			return;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	PersistentContexts[PersistentContexts.Length] = Context;
	return;
}

simulated function RemovePersistentContext(name Context)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, PersistentContexts.Length))
	{
		if(EqualEqual_NameName(PersistentContexts[i], Context))
		{
			PersistentContexts.Remove(i, 1);
			return;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

simulated function ClearPersistentContexts()
{
	PersistentContexts.Remove(0, PersistentContexts.Length);
	return;
}

simulated function QueueEvents()
{
	QueueingEvents = true;
	return;
}

simulated event FlushQueuedEvents()
{
	local int i;

	QueueingEvents = false;
	i = 0;
	J0x0F:

	if(Less_IntInt(i, QueuedSource.Length))
	{
		if(NotEqual_ObjectObject(QueuedSource[i], none))
		{
			EffectEventTriggered(QueuedSource[i], QueuedEffectEvent[i], QueuedTarget[i], QueuedTargetMaterial[i], QueuedOverrideWorldLocation[i], QueuedOverrideWorldRotation[i], NotEqual_IntInt(int(QueuedUnTriggered[i]), 0));
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x0F;
	}
	QueuedSource.Remove(0, QueuedSource.Length);
	QueuedEffectEvent.Remove(0, QueuedEffectEvent.Length);
	QueuedTarget.Remove(0, QueuedTarget.Length);
	QueuedTargetMaterial.Remove(0, QueuedTargetMaterial.Length);
	QueuedOverrideWorldLocation.Remove(0, QueuedOverrideWorldLocation.Length);
	QueuedOverrideWorldRotation.Remove(0, QueuedOverrideWorldRotation.Length);
	QueuedUnTriggered.Remove(0, QueuedUnTriggered.Length);
	return;
}

simulated function bool EffectEventTriggered(Actor Source, name EffectEvent, optional Actor Target, optional Material TargetMaterial, optional Vector overrideWorldLocation, optional Rotator overrideWorldRotation, optional bool unTriggered, optional bool PlayOnTarget, optional bool QueryOnly, optional IEffectObserver Observer, optional name Tag, optional name SkipSubsystemWithThisName)
{
	local int i, j, k, M;
	local bool AnySubsystemFoundMatch;
	local string DebugString;
	local bool ThisSubsystemFoundMatch;

	if(QueueingEvents)
	{
		i = QueuedSource.Length;
		assert(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(EqualEqual_IntInt(QueuedEffectEvent.Length, i), EqualEqual_IntInt(QueuedTarget.Length, i)), EqualEqual_IntInt(QueuedTargetMaterial.Length, i)), EqualEqual_IntInt(QueuedOverrideWorldLocation.Length, i)), EqualEqual_IntInt(QueuedOverrideWorldRotation.Length, i)), EqualEqual_IntInt(QueuedUnTriggered.Length, i)));
		QueuedSource[i] = Source;
		QueuedEffectEvent[i] = EffectEvent;
		QueuedTarget[i] = Target;
		QueuedTargetMaterial[i] = TargetMaterial;
		QueuedOverrideWorldLocation[i] = overrideWorldLocation;
		QueuedOverrideWorldRotation[i] = overrideWorldRotation;
		QueuedUnTriggered[i] = byte(unTriggered);
	}
	else
	{
		if(EqualEqual_IntInt(AllEffectsSubsystems.Length, 0))
		{
			return false;
		}
		i = 0;
		J0x111:

		if(Less_IntInt(i, AllEffectsSubsystems.Length))
		{
			if(EqualEqual_ObjectObject(AllEffectsSubsystems[i], none))
			{
				// [Explicit Continue]
				goto J0x1E8;
			}
			if(AndAnd_BoolBool(AnySubsystemFoundMatch, QueryOnly))
			{
				return AnySubsystemFoundMatch;
				// [Explicit Continue]
				goto J0x1E8;
			}
			if(NotEqual_NameName(SkipSubsystemWithThisName, AllEffectsSubsystems[i].Class.Name))
			{
				ThisSubsystemFoundMatch = AllEffectsSubsystems[i].EffectEventTriggered(Source, EffectEvent, Target, TargetMaterial, overrideWorldLocation, overrideWorldRotation, unTriggered, PlayOnTarget, QueryOnly, Observer, Tag);
				AnySubsystemFoundMatch = OrOr_BoolBool(ThisSubsystemFoundMatch, AnySubsystemFoundMatch);
			}
			J0x1E8:

			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0x111;
		}
	}
	i = 0;
	J0x1F9:

	if(Less_IntInt(i, DebugEffectEvent.Length))
	{
		if(EqualEqual_NameName(DebugEffectEvent[i], EffectEvent))
		{
			DebugString = " EffectsSystem::EffectEventTriggered() ";
			DebugString = Concat_StrStr(Concat_StrStr(Concat_StrStr(DebugString, " EffectEvent="), string(EffectEvent)), ": ");
			DebugString = Concat_StrStr(Concat_StrStr(DebugString, "AnythingMatched="), string(AnySubsystemFoundMatch));
			if(NotEqual_ObjectObject(Source, none))
			{
				DebugString = Concat_StrStr(Concat_StrStr(DebugString, ", Source.Class="), string(Source.Class.Name));
			}
			else
			{
				DebugString = Concat_StrStr(DebugString, ", Source.Class=None");
			}
			if(NotEqual_ObjectObject(Target, none))
			{
				DebugString = Concat_StrStr(Concat_StrStr(DebugString, ", Target="), string(Target.Class.Name));
			}
			else
			{
				DebugString = Concat_StrStr(DebugString, ", Target=None");
			}
			if(NotEqual_ObjectObject(TargetMaterial, none))
			{
				DebugString = Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(DebugString, ", TargetMaterial.MaterialSoundType="), string(TargetMaterial.MaterialSoundType)), ", TargetMaterial.MaterialVisualType="), string(GetEnum(Enum'Engine.Material.EMaterialVisualType', int(TargetMaterial.MaterialVisualType)))), " ("), string(TargetMaterial.MaterialVisualType)), ")");
			}
			else
			{
				DebugString = Concat_StrStr(DebugString, ", TargetMaterial.MaterialSoundType=Unknown, TargetMaterial.MaterialVisualType=Unknown");
			}
			DebugString = Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(DebugString, ", UnTriggered="), string(unTriggered)), ", PlayOnTarget="), string(PlayOnTarget)), ", QueryOnly="), string(QueryOnly)), ", Observer="), string(Observer)), ", Tag="), string(Tag));
			DebugString = Concat_StrStr(DebugString, " ZoneContexts=[");
			j = 0;
			J0x52F:

			if(Less_IntInt(j, Source.Region.Zone.EffectsContexts.Length))
			{
				DebugString = Concat_StrStr(Concat_StrStr(DebugString, " "), string(Source.Region.Zone.EffectsContexts[j]));
				AddAdd_Int(j);
				// [Loop Continue]
				goto J0x52F;
			}
			DebugString = Concat_StrStr(DebugString, " ]");
			DebugString = Concat_StrStr(DebugString, " PersistentContexts=[");
			k = 0;
			J0x5D2:

			if(Less_IntInt(k, PersistentContexts.Length))
			{
				DebugString = Concat_StrStr(Concat_StrStr(DebugString, " "), string(PersistentContexts[k]));
				AddAdd_Int(k);
				// [Loop Continue]
				goto J0x5D2;
			}
			DebugString = Concat_StrStr(DebugString, " ]");
			DebugString = Concat_StrStr(DebugString, " TemporaryContexts=[");
			M = 0;
			J0x646:

			if(Less_IntInt(M, TemporaryContexts.Length))
			{
				DebugString = Concat_StrStr(Concat_StrStr(DebugString, " "), string(TemporaryContexts[M]));
				AddAdd_Int(M);
				// [Loop Continue]
				goto J0x646;
			}
			DebugString = Concat_StrStr(DebugString, " ]");
			Log(DebugString);
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x1F9;
	}
	TemporaryContexts.Remove(0, TemporaryContexts.Length);
	return AnySubsystemFoundMatch;
	return;
}

exec function DumpEffects(name SubsystemName)
{
	local EffectsSubsystem SubSys;
	local name ClassName;

	if(EqualEqual_NameName(SubsystemName, 'Sound'))
	{
		ClassName = 'SoundEffectsSubsystem';
	}
	else
	{
		if(EqualEqual_NameName(SubsystemName, 'VISUAL'))
		{
			ClassName = 'VisualEffectsSubsystem';
		}
	}
	SubSys = GetSubsystem(ClassName);
	if(EqualEqual_ObjectObject(SubSys, none))
	{
		Warn(Concat_StrStr("WARNING: Cannot dump effects; subsystem not found: ", string(ClassName)));
		return;
	}
	SubSys.LogState();
	return;
}

defaultproperties
{
	QueueingEvents=true
}