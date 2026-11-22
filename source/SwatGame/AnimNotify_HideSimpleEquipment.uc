class AnimNotify_HideSimpleEquipment extends AnimNotify_Scripted
	editinlinenew
	collapsecategories
	hidecategories(Object);

var Class<SimpleEquipment> SimpleEquipmentClass;

simulated event Notify(Actor Owner)
{
	local SwatAICharacter AI;
	local CharacterArchetypeInstance Instance;
	local int i;

	AI = SwatAICharacter(Owner);
	AssertWithDescription(NotEqual_ObjectObject(AI, none), Concat_StrStr(Concat_StrStr("[tcohen] AnimNotify_ShowSimpleEquipment was called on ", string(Owner)), " which cannot have SimpleEquipment."));
	Instance = CharacterArchetypeInstance(AI.GetArchetypeInstance());
	assert(NotEqual_ObjectObject(Instance, none));
	i = 0;
	J0xB2:

	if(Less_IntInt(i, Instance.Equipment.Length))
	{
		if(EqualEqual_ObjectObject(Instance.Equipment[i].Class, SimpleEquipmentClass))
		{
			SimpleEquipment(Instance.Equipment[i]).UnEquip();
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0xB2;
	}
	return;
}
