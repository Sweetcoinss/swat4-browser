class EventResponse extends Object
	abstract
	native
	config
	perobjectconfig;

struct native SpecificationStruct
{
	var name SpecificationType;
	var Class SpecificationClass;
};

var config name Event;
var config name SourceClassName;
var Class<Actor> SourceClass;
var config name TargetClassName;
var config name StaticMesh;
var config name Tag;
var config array<int> Chance;
var config array<SpecificationStruct> Specification;
var array<EffectSpecification> SpecificationReference;
var config array<name> Context;
var config bool AlwaysInQM;
var private bool initDone;
var private int sum;

simulated function Init()
{
	local int i;

	assert(Not_PreBool(initDone));
	if(initDone)
	{
		return;
	}
	if(EqualEqual_IntInt(Add_IntInt(Chance.Length, Specification.Length), 0))
	{
		Warn(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("The ", string(Class.Name)), " named '"), string(Name)), "' has no Specification.  This will not cause a problem, but it should be corrected."));
		return;
	}
	if(EqualEqual_IntInt(Chance.Length, 0))
	{
		Chance[0] = 1;
	}
	AssertWithDescription(EqualEqual_IntInt(Chance.Length, Specification.Length), Concat_StrStr(Concat_StrStr("EventResponse ", string(Name)), ": The number of Chance(s) and Specifications(s) should match, but they don't (except if there's just one Specification, in which case, you may omit the Chance)."));
	i = 0;
	J0x19F:

	if(Less_IntInt(i, Chance.Length))
	{
		AddEqual_IntInt(sum, Chance[i]);
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x19F;
	}
	initDone = true;
	return;
}

simulated event EffectSpecification GetSpecification()
{
	local int subSum, Point, i;

	if(Not_PreBool(initDone))
	{
		Init();
	}
	if(EqualEqual_IntInt(Add_IntInt(Chance.Length, Specification.Length), 0))
	{
		return none;
	}
	Point = Rand(sum);
	i = 0;
	J0x3B:

	if(Less_IntInt(i, Chance.Length))
	{
		AddEqual_IntInt(subSum, Chance[i]);
		if(GreaterEqual_IntInt(subSum, Point))
		{
			// [Explicit Break]
			goto J0x79;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x3B;
	}
	J0x79:

	assert(Less_IntInt(i, Chance.Length));
	if(EqualEqual_ObjectObject(SpecificationReference[i], none))
	{
		AssertWithDescription(false, Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] The ", string(Class.Name)), " named "), string(Name)), " was called to GetSpecification(), but the SpecificationReference (at index "), string(i)), ") is None.  The Event Response's SourceClass ("), string(SourceClassName)), ") may need to be added to the PreloadActorClass list in EffectsSystem.ini.  "), "Effects will not be played on "), string(SourceClassName)), " instances.  "), "(This probably means that the SourceClass was dynamically loaded after the Effects System was initialized, and had not been previously loaded.  "), "Therefore the Effects System ignored the Event Response and didn't create any Effect Specifications for it.)"));
	}
	return SpecificationReference[i];
	return;
}
