class IdleActionsList extends Actor
	config(IdleActionsList)
	notplaceable
	hidecategories(Karma);

var config array<name> AnimatorIdleNames;
var array<AnimatorIdleDefinition> AnimatorIdleDefinitions;
var config array<name> ProceduralIdleNames;
var array<ProceduralIdleDefinition> ProceduralIdleDefinitions;

event PreBeginPlay()
{
	super.PreBeginPlay();
	CreateAnimatorIdleActionDefinitions();
	return;
}

private function CreateAnimatorIdleActionDefinitions()
{
	local int i, j;
	local AnimatorIdleDefinition NewAnimatorIdleDefinition;

	i = 0;
	J0x07:

	if(Less_IntInt(i, AnimatorIdleNames.Length))
	{
		j = Add_IntInt(i, 1);
		J0x25:

		if(Less_IntInt(j, AnimatorIdleNames.Length))
		{
			if(EqualEqual_NameName(AnimatorIdleNames[i], AnimatorIdleNames[j]))
			{
				Warn(Concat_StrStr(Concat_StrStr("IdleActionsList::CreateAnimatorIdleActionDefinitions - Animator Idle Named ", string(AnimatorIdleNames[i])), " duplicated in IdleActionsList.ini"));
			}
			AddAdd_PreInt(j);
			// [Loop Continue]
			goto J0x25;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	i = 0;
	J0xEF:

	if(Less_IntInt(i, AnimatorIdleNames.Length))
	{
		NewAnimatorIdleDefinition = Class'SwatAICommon.AnimatorIdleDefinition'.static.Allocate(self, self, string(AnimatorIdleNames[i]), 0).;
		Construct_Void();
		assert(NotEqual_ObjectObject(NewAnimatorIdleDefinition, none));
		AnimatorIdleDefinitions[i] = NewAnimatorIdleDefinition;
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0xEF;
	}
	return;
}

private function CreateProceduralIdleActionDefinitions()
{
	local int i;
	local ProceduralIdleDefinition NewProceduralIdleDefinition;

	i = 0;
	J0x07:

	if(Less_IntInt(i, ProceduralIdleNames.Length))
	{
		NewProceduralIdleDefinition = Class'SwatAICommon.ProceduralIdleDefinition'.static.Allocate(self, self, string(ProceduralIdleNames[i]), 0).;
		Construct_Void();
		assert(NotEqual_ObjectObject(NewProceduralIdleDefinition, none));
		ProceduralIdleDefinitions[i] = NewProceduralIdleDefinition;
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

defaultproperties
{
	bHidden=true
}