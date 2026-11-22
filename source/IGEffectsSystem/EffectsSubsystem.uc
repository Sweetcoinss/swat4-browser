class EffectsSubsystem extends Actor
	abstract
	native
	config
	notplaceable
	hidecategories(Karma);

var EffectsSystem EffectsSystem;
var config array<name> EventResponse;
var Class EffectSpecificationSubClass;
var private bool debugSlow;
var bool ShouldInitOnDedicatedServer;
var bool IsPackagingEffectsConfig;
var string IniFileName;
var string ConfigPackageName;
var string ConfigPackageFullFileName;
var Class<EventResponse> EventResponseSubClass;
var private native const noexport int EventResponses[5];
var private native const noexport int EffectSpecifications[5];
var private native const noexport transient int ConfigPackageBeingBuilt;

simulated function PreBeginPlay()
{
	local EventResponse newEventResponse;
	local int i, j;
	local string LevelContext;
	local bool FoundNonMatchingLevelContext, UsingCustomScenario;

	UsingCustomScenario = Level.UsingCustomScenario();
	super.PreBeginPlay();
	BeginLoadingSubsystemConfig();
	i = 0;
	J0x29:

	if(Less_IntInt(i, EventResponse.Length))
	{
		if(IsPackagingEffectsConfig)
		{
			newEventResponse = EventResponseSubClass.static.Allocate(self, self, string(EventResponse[i]), 0).;
			Construct_Void();
			AddEventResponse(string(Concat_StrStr(string(newEventResponse.SourceClassName), string(newEventResponse.Event))), newEventResponse);
			newEventResponse.Init();
			PackageEventResponse(newEventResponse);
			InitializeResponseSpecifications(newEventResponse);
			// [Explicit Continue]
			goto J0x390;
		}
		newEventResponse = EventResponse(DynamicLoadObject(Concat_StrStr(Concat_StrStr(ConfigPackageName, "."), string(EventResponse[i])), EventResponseSubClass));
		if(EqualEqual_NameName(newEventResponse.SourceClassName, 'Level'))
		{
			if(EqualEqual_NameName(Level.Label, newEventResponse.Event))
			{
				InitializeResponseSpecifications(newEventResponse);
			}
			// [Explicit Continue]
			goto J0x390;
		}
		FoundNonMatchingLevelContext = false;
		j = 0;
		J0x14E:

		if(Less_IntInt(j, newEventResponse.Context.Length))
		{
			LevelContext = string(newEventResponse.Context[j]);
			if(AndAnd_BoolBool(ComplementEqual_StrStr(Left(LevelContext, 6), "Level_"), Not_PreBool(ComplementEqual_StrStr(Right(LevelContext, Subtract_IntInt(Len(LevelContext), 6)), string(Level.Label)))))
			{
				if(AndAnd_BoolBool(newEventResponse.AlwaysInQM, UsingCustomScenario))
				{
					newEventResponse.Context.Remove(j, 1);
				}
				else
				{
					FoundNonMatchingLevelContext = true;
				}
				// [Explicit Break]
				goto J0x20E;
			}
			AddAdd_PreInt(j);
			// [Loop Continue]
			goto J0x14E;
		}
		J0x20E:

		if(FoundNonMatchingLevelContext)
		{
			if(debugSlow)
			{
				Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("TMC ", string(Class.Name)), "::PreBeginPlay() skipping EventResponse named "), string(newEventResponse)), " because it specifies the Context "), LevelContext), ", but the current level is "), string(Level.Label)), ". Left()="), Left(LevelContext, 6)), ", Right()="), Right(LevelContext, Subtract_IntInt(Len(LevelContext), 6))));
			}
			// [Explicit Continue]
			goto J0x390;
		}
		newEventResponse.SourceClass = Class<Actor>(DynamicFindObject(string(newEventResponse.SourceClassName), Class'Core.Class'));
		if(EqualEqual_ObjectObject(newEventResponse.SourceClass, none))
		{
			// [Explicit Continue]
			goto J0x390;
		}
		AddEventResponse(string(Concat_StrStr(string(newEventResponse.SourceClassName), string(newEventResponse.Event))), newEventResponse);
		InitializeResponseSpecifications(newEventResponse);
		J0x390:

		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x29;
	}
	if(Not_PreBool(IsPackagingEffectsConfig))
	{
		ConsoleCommand("OBJ GARBAGE");
	}
	EndLoadingSubsystemConfig();
	PostLoaded();
	if(debugSlow)
	{
		Log(Concat_StrStr(string(Name), " Loaded. "));
	}
	return;
}

// Export UEffectsSubsystem::execAddEventResponse(FFrame&, void* const)
native function AddEventResponse(name EventResponseName, EventResponse EventResponse);

// Export UEffectsSubsystem::execBeginLoadingSubsystemConfig(FFrame&, void* const)
native function BeginLoadingSubsystemConfig();

// Export UEffectsSubsystem::execPackageEventResponse(FFrame&, void* const)
native function PackageEventResponse(EventResponse EventResponse);

// Export UEffectsSubsystem::execPackageEffectSpecification(FFrame&, void* const)
native function PackageEffectSpecification(EffectSpecification EffectSpecification);

// Export UEffectsSubsystem::execEndLoadingSubsystemConfig(FFrame&, void* const)
native function EndLoadingSubsystemConfig();

function PostLoaded()
{
	return;
}

function InitializeResponseSpecifications(EventResponse EventResponse)
{
	local EffectSpecification newEffectSpecification;
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, EventResponse.Specification.Length))
	{
		if(NotEqual_NameName(EventResponse.Specification[i].SpecificationType, 'None'))
		{
			newEffectSpecification = FindEffectSpecification(EventResponse.Specification[i].SpecificationType);
			if(EqualEqual_ObjectObject(newEffectSpecification, none))
			{
				AssertWithDescription(NotEqual_ObjectObject(Class<EffectSpecification>(EventResponse.Specification[i].SpecificationClass), none), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] EffectsSubsystem::InitializeResponseSpecifications() The EventResponse ", string(EventResponse.Name)), " lists specification #"), string(i)), " (base zero) as "), string(EventResponse.Specification[i].SpecificationType)), ", but that's not a valid class of EffectSpecification."));
				if(IsPackagingEffectsConfig)
				{
					newEffectSpecification = EffectSpecification(EventResponse.Specification[i].SpecificationClass.static.Allocate(self, none, string(EventResponse.Specification[i].SpecificationType), 0).);
					Construct_Void();
					PackageEffectSpecification(newEffectSpecification);
				}
				else
				{
					newEffectSpecification = EffectSpecification(DynamicLoadObject(Concat_StrStr(Concat_StrStr(ConfigPackageName, "."), string(EventResponse.Specification[i].SpecificationType)), Class'IGEffectsSystem.EffectSpecification'));
				}
				assert(NotEqual_ObjectObject(newEffectSpecification, none));
				newEffectSpecification.Level = XLevel;
				newEffectSpecification.Init(self);
				AddEffectSpecification(newEffectSpecification.Name, newEffectSpecification);
			}
			EventResponse.SpecificationReference[i] = newEffectSpecification;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

// Export UEffectsSubsystem::execFindEffectSpecification(FFrame&, void* const)
native function EffectSpecification FindEffectSpecification(name EffectSpecificationName);

// Export UEffectsSubsystem::execAddEffectSpecification(FFrame&, void* const)
native function AddEffectSpecification(name EffectSpecificationName, EffectSpecification EffectSpecification);

// Export UEffectsSubsystem::execEffectEventTriggered(FFrame&, void* const)
native function bool EffectEventTriggered(Actor Source, name EffectEvent, optional Actor Target, optional Material TargetMaterial, optional Vector overrideWorldLocation, optional Rotator overrideWorldRotation, optional bool unTriggered, optional bool PlayOnTarget, optional bool QueryOnly, optional IEffectObserver Observer, optional name Tag);

simulated function EffectSpecification GetSpecificationByString(string Specification)
{
	return FindEffectSpecification(string(Specification));
	return;
}

simulated function LogState()
{
	Log(Concat_StrStr("LogState not implemented for subsystem: ", string(self)));
	return;
}

simulated event Actor PlayEffectSpecification(EffectSpecification EffectSpec, Actor Source, optional Actor Target, optional Material TargetMaterial, optional Vector overrideWorldLocation, optional Rotator overrideWorldRotation, optional IEffectObserver Observer)
{
	assert(false);
	return none;
	return;
}

simulated event StopEffectSpecification(EffectSpecification EffectSpec, Actor Source)
{
	return;
}

simulated event OnEffectSpawned(Actor SpawnedEffect)
{
	return;
}

defaultproperties
{
	bHidden=true
}