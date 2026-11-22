class ScriptedAnimationSet extends Object
	native
	editinlinenew
	hidecategories(Object);

struct native ScriptedAnimation
{
	var() int Chance;
	var() name Animation;
};

var export editinline array<export editinline ScriptedAnimation> ScriptedAnimations;
var Range LoopCount;
var int TotalChance;

simulated function Initialize()
{
	local int i;

	if(EqualEqual_IntInt(ScriptedAnimations.Length, 0))
	{
		return;
	}
	i = 0;
	J0x15:

	if(Less_IntInt(i, ScriptedAnimations.Length))
	{
		AddEqual_IntInt(TotalChance, ScriptedAnimations[i].Chance);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x15;
	}
	AssertWithDescription(LessEqual_FloatFloat(LoopCount.Min, LoopCount.Max), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] ", string(Name)), " owned by "), string(Outer)), " specifies a LoopCount with Max < Min."));
	return;
}

simulated function name SelectAnimation()
{
	local int RandChance, AccumulatedChance, i;

	if(EqualEqual_IntInt(ScriptedAnimations.Length, 0))
	{
		return 'None';
	}
	if(EqualEqual_IntInt(TotalChance, 0))
	{
		Initialize();
	}
	AssertWithDescription(Greater_IntInt(TotalChance, 0), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] ", string(Name)), ", a ScriptedAnimationSet of ReactiveAnimatedMesh '"), string(Outer)), "',"), " has a TotalChance of zero.  Please add at least one non-zero Chance to it."));
	RandChance = Rand(TotalChance);
	i = 0;
	J0xED:

	if(Less_IntInt(i, ScriptedAnimations.Length))
	{
		AddEqual_IntInt(AccumulatedChance, ScriptedAnimations[i].Chance);
		if(GreaterEqual_IntInt(AccumulatedChance, RandChance))
		{
			return ScriptedAnimations[i].Animation;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0xED;
	}
	assert(false);
	return;
}

defaultproperties
{
	LoopCount=(Min=1.0000000,Max=1.0000000)
}