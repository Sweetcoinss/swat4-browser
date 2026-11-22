class VisualEffectsSubsystem extends EffectsSubsystem
	native
	config(VisualEffects)
	hidecategories(Karma);

cpptext
{
    //declaration of script-side
    //  var private native noexport const int PrecacheVisualEffects[5];
    TSet<UClass*> PrecacheVisualEffects;

    //overridden from EffectsSubsystem
    void PrecacheEffectSpecification(UEffectSpecification* Spec);

    //instruct the engine to precache all assets related to the specified Effect class.
    //Effect can theoretically be any class<Actor>, but is usually one of:
    //  Emitter, Projector, DynamicLight.
    void PrecacheVisualEffect(UClass* EffectClass);

}

enum MatchResult
{
	MatchResult_None,               // 0
	MatchResult_Matched,            // 1
	MatchResult_UseDefault          // 2
};

var array< Class<Actor> > MatchingEffectClasses;
var array< Class<Actor> > DefaultEffectClasses;
var array< Class<Actor> > SelectedEffectClasses;
var private int CurrentDecal;
var private native const noexport int PrecacheVisualEffects[5];

// Export UVisualEffectsSubsystem::execPostLoaded(FFrame&, void* const)
native function PostLoaded();

simulated event Actor PlayEffectSpecification(EffectSpecification EffectSpec, Actor Source, optional Actor Target, optional Material TargetMaterial, optional Vector overrideWorldLocation, optional Rotator overrideWorldRotation, optional IEffectObserver Observer)
{
	local VisualEffectSpecification visualEffectSpec;
	local Actor effect;
	local int i;
	local VisualEffectsSubsystem.MatchResult Result;
	local Vector AdditionalLocationOffset;
	local Class<Actor> EffectSpecClass;

	if(EqualEqual_ObjectObject(EffectSpec, none))
	{
		return none;
	}
	visualEffectSpec = VisualEffectSpecification(EffectSpec);
	assert(NotEqual_ObjectObject(visualEffectSpec, none));
	MatchingEffectClasses.Remove(0, MatchingEffectClasses.Length);
	DefaultEffectClasses.Remove(0, DefaultEffectClasses.Length);
	i = 0;
	J0x49:

	if(Less_IntInt(i, visualEffectSpec.MaterialType.Length))
	{
		EffectSpecClass = visualEffectSpec.EffectClass[i];
		if(AndAnd_BoolBool(NotEqual_ObjectObject(TargetMaterial, none), EqualEqual_IntInt(int(visualEffectSpec.MaterialType[i]), int(TargetMaterial.MaterialVisualType))))
		{
			if(EqualEqual_ObjectObject(EffectSpecClass, none))
			{
				AssertWithDescription(false, Concat_StrStr(Concat_StrStr(Concat_StrStr("EffectsManager::PlayEffect(): Nonexistent EffectClass specified for effect named ", string(EffectSpec.Name)), " materialType "), string(TargetMaterial.MaterialVisualType)));
			}
			MatchingEffectClasses[MatchingEffectClasses.Length] = EffectSpecClass;
			Result = 1;
		}
		if(EqualEqual_IntInt(int(visualEffectSpec.MaterialType[i]), int(0)))
		{
			if(EqualEqual_ObjectObject(EffectSpecClass, none))
			{
				AssertWithDescription(false, Concat_StrStr("EffectsManager::PlayEffect(): Nonexistent *default* EffectClass specified for effect named ", string(EffectSpec.Name)));
			}
			DefaultEffectClasses[DefaultEffectClasses.Length] = EffectSpecClass;
			if(EqualEqual_IntInt(int(Result), int(0)))
			{
				Result = 2;
			}
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x49;
	}
	SelectedEffectClasses.Remove(0, SelectedEffectClasses.Length);
	switch(Result)
	{
		case 0:
			return none;
		case 1:
			i = 0;
			J0x264:

			if(Less_IntInt(i, MatchingEffectClasses.Length))
			{
				SelectedEffectClasses[SelectedEffectClasses.Length] = MatchingEffectClasses[i];
				AddAdd_PreInt(i);
				// [Loop Continue]
				goto J0x264;
			}
			break;
		case 2:
			i = 0;
			J0x2A5:

			if(Less_IntInt(i, DefaultEffectClasses.Length))
			{
				SelectedEffectClasses[SelectedEffectClasses.Length] = DefaultEffectClasses[i];
				AddAdd_PreInt(i);
				// [Loop Continue]
				goto J0x2A5;
			}
			break;
		default:
			break;
	}
	i = 0;
	J0x2E4:

	if(Less_IntInt(i, SelectedEffectClasses.Length))
	{
		if(OrOr_BoolBool(AndAnd_BoolBool(SelectedEffectClasses[i].default.bHighDetail, EqualEqual_IntInt(int(Level.DetailMode), int(0))), AndAnd_BoolBool(SelectedEffectClasses[i].default.bSuperHighDetail, NotEqual_IntInt(int(Level.DetailMode), int(2)))))
		{
			if(EffectsSystem.LogEffectEvents)
			{
				Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("**** ", string(Name)), " NOT spawning "), string(SelectedEffectClasses[i])), " because Level is DetailMode="), string(GetEnum(Enum'Engine.Actor.EDetailMode', int(Level.DetailMode)))), " and effect is (bHighDetail="), string(SelectedEffectClasses[i].default.bHighDetail)), ", bSuperHighDetail="), string(SelectedEffectClasses[i].default.bSuperHighDetail)), ")"));
			}
			// [Explicit Continue]
			goto J0x9F9;
		}
		else
		{
			if(EffectsSystem.LogEffectEvents)
			{
				Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("**** ", string(Name)), " SPAWNING "), string(SelectedEffectClasses[i])), "; Level is DetailMode="), string(GetEnum(Enum'Engine.Actor.EDetailMode', int(Level.DetailMode)))), " and effect is (bHighDetail="), string(SelectedEffectClasses[i].default.bHighDetail)), ", bSuperHighDetail="), string(SelectedEffectClasses[i].default.bSuperHighDetail)), ")"));
			}
		}
		if(NotEqual_ObjectObject(Source, none))
		{
			effect = ProxySpawn(SelectedEffectClasses[i], Source, EffectSpec.Name, vect(0.0000000, 0.0000000, 0.0000000));
		}
		else
		{
			if(EqualEqual_VectorVector(overrideWorldLocation, vect(0.0000000, 0.0000000, 0.0000000)))
			{
				AssertWithDescription(false, "EffectsManager::PlayEffect() was called with no Source and no overrideWorldLocation... I don't know where to put the effect!?");
			}
			effect = ProxySpawn(SelectedEffectClasses[i], GameInfo(Outer), EffectSpec.Name, vect(0.0000000, 0.0000000, 0.0000000));
		}
		if(EqualEqual_ObjectObject(effect, none))
		{
			AssertWithDescription(false, Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("VisualEffectsSubsystem.PlayEffectSpecification(): couldn't spawn effect ", string(EffectSpec.Name)), " with Source "), string(Source)), " (chose SelectedEffectClasses[i]="), string(SelectedEffectClasses[i])), ")"));
		}
		else
		{
			if(EffectsSystem.LogEffectEvents)
			{
				Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("**** ", string(Name)), " ---> Spawn returned: "), string(effect)));
			}
		}
		if(NotEqual_ObjectObject(effect, none))
		{
			if(EffectSpec.AttachToSource)
			{
				if(EqualEqual_ObjectObject(Source, none))
				{
					AssertWithDescription(false, Concat_StrStr(Concat_StrStr("EffectsManager: tried to attach effect ", string(EffectSpec.Name)), " to None Source"));
				}
				if(NotEqual_ObjectObject(Source, none))
				{
					if(OrOr_BoolBool(EqualEqual_NameName(EffectSpec.AttachmentBone, 'None'), EqualEqual_NameName(EffectSpec.AttachmentBone, 'PIVOT')))
					{
						effect.SetBase(Source);
					}
					else
					{
						if(EqualEqual_NameName(EffectSpec.AttachmentBone, 'Center'))
						{
							effect.SetBase(Source);
							AdditionalLocationOffset = Subtract_VectorVector(Source.GetRenderBoundingSphere(), Source.Location);
						}
						else
						{
							Source.AttachToBone(effect, EffectSpec.AttachmentBone);
						}
					}
				}
				effect.SetRelativeLocation(Add_VectorVector(EffectSpec.LocationOffset, AdditionalLocationOffset));
				effect.SetRelativeRotation(EffectSpec.RotationOffset);
			}
			else
			{
				if(NotEqual_VectorVector(overrideWorldLocation, vect(0.0000000, 0.0000000, 0.0000000)))
				{
					effect.SetLocation(overrideWorldLocation);
					effect.SetRotation(overrideWorldRotation);
				}
				else
				{
					if(NotEqual_ObjectObject(Source, none))
					{
						effect.SetLocation(Source.Location);
						effect.SetRotation(Source.Rotation);
					}
				}
			}
			if(effect.IsA('ProjectedDecal'))
			{
				ProjectedDecal(effect).Target = Target;
				ProjectedDecal(effect).SetRotation(Rotator(Multiply_VectorVector(Vector(effect.Rotation), vect(-1.0000000, -1.0000000, -1.0000000))));
				ProjectedDecal(effect).Init();
			}
			if(NotEqual_ObjectObject(Observer, none))
			{
				Observer.OnEffectStarted(effect);
			}
		}
		J0x9F9:

		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x2E4;
	}
	return effect;
	return;
}

simulated function Actor ProxySpawn(Class<Actor> SpawnClass, Actor SpawnOwner, name SpawnTag, Vector SpawnLocation)
{
	local Actor Result;

	Result = SpawnOwner.Spawn(SpawnClass, SpawnOwner, SpawnTag, SpawnLocation);
	return Result;
	return;
}

simulated event StopEffectSpecification(EffectSpecification EffectSpec, Actor Source)
{
	local Actor effect;

	foreach DynamicActors(Class'Engine.Actor', effect, EffectSpec.Name)
	{
		if(OrOr_BoolBool(EqualEqual_ObjectObject(Source, none), EqualEqual_ObjectObject(effect.Owner, Source)))
		{
			StopEffect(effect, true);
		}
	}
	return;
}

simulated function StopEffect(Actor it, bool stopOverTime)
{
	if(AndAnd_BoolBool(stopOverTime, it.IsA('Emitter')))
	{
		Emitter(it).Kill();
	}
	else
	{
		it.Destroy();
	}
	return;
}

simulated function LogState()
{
	Log("----------------------------------------------------------------");
	Log("|              VISUAL EFFECTS SUBSYSTEM STATE                   |");
	Log("----------------------------------------------------------------");
	Log("| WARNING: LogState() not yet implemented for visual effects subsystem");
	Log("----------------------------------------------------------------");
	return;
}

simulated event OnEffectSpawned(Actor SpawnedEffect)
{
	if(AndAnd_BoolBool(NotEqual_ObjectObject(SpawnedEffect, none), SpawnedEffect.bNeedLifetimeEffectEvents))
	{
		SpawnedEffect.TriggerEffectEvent('Spawned');
		SpawnedEffect.TriggerEffectEvent('Alive');
	}
	return;
}

defaultproperties
{
	EffectSpecificationSubClass=Class'IGVisualEffectsSubsystem.VisualEffectSpecification'
	IniFileName="VisualEffects.ini"
	ConfigPackageName="VisualEffectsConfig"
	ConfigPackageFullFileName="..\\..\\content\\system\\VisualEffectsConfig.u"
	EventResponseSubClass=Class'IGVisualEffectsSubsystem.EventResponse_VisualEffectsSubsystem'
}