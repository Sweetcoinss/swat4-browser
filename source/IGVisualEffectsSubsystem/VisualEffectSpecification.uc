class VisualEffectSpecification extends EffectSpecification
	native
	config(VisualEffects)
	perobjectconfig;

var config array<Material.EMaterialVisualType> MaterialType;
var config array< Class<Actor> > EffectClass;

simulated function Init(EffectsSubsystem EffectsSubsystem)
{
	assert(NotEqual_ObjectObject(EffectsSubsystem, none));
	if(EqualEqual_IntInt(MaterialType.Length, 0))
	{
		AssertWithDescription(EqualEqual_IntInt(EffectClass.Length, 1), Concat_StrStr(Concat_StrStr("The visual effect ", string(Name)), " has more than one EffectClass, but no MaterialTypes.  If an effect specifies more than one EffectClass, then it must have a MaterialType for *each* EffectClass"));
		MaterialType[0] = 0;
	}
	else
	{
		AssertWithDescription(EqualEqual_IntInt(EffectClass.Length, MaterialType.Length), Concat_StrStr(Concat_StrStr("The visual effect ", string(Name)), " does not specify the same number of MaterialTypes and EffectClasses.  If an Effect specifies any MaterialType(s), then the number of MaterialTypes specified must equal the number of EffectClasses specified."));
	}
	return;
}
