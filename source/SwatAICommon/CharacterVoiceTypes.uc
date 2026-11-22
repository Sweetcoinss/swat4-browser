class CharacterVoiceTypes extends Object within CharacterTypesList
	config
	perobjectconfig;

var config array<name> VoiceTypes;
var array<int> VoiceTypesUsed;

overloaded function Construct()
{
	super.Construct_Void();
	assert(Greater_IntInt(VoiceTypes.Length, 0));
	VoiceTypesUsed.Length = VoiceTypes.Length;
	return;
}

function name GetUniqueVoiceType()
{
	local int i, HighestCount, VoiceTypeIndex;
	local array<name> UsableVoiceTypes;
	local name UniqueVoiceType;

	assert(EqualEqual_IntInt(VoiceTypes.Length, VoiceTypesUsed.Length));
	assert(Greater_IntInt(VoiceTypes.Length, 0));
	i = 0;
	J0x24:

	if(Less_IntInt(i, VoiceTypesUsed.Length))
	{
		if(Greater_IntInt(VoiceTypesUsed[i], HighestCount))
		{
			HighestCount = VoiceTypesUsed[i];
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x24;
	}
	i = 0;
	J0x6B:

	if(Less_IntInt(i, VoiceTypesUsed.Length))
	{
		if(Less_IntInt(VoiceTypesUsed[i], HighestCount))
		{
			UsableVoiceTypes[UsableVoiceTypes.Length] = VoiceTypes[i];
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x6B;
	}
	if(EqualEqual_IntInt(UsableVoiceTypes.Length, 0))
	{
		UsableVoiceTypes = VoiceTypes;
	}
	VoiceTypeIndex = Rand(UsableVoiceTypes.Length);
	UniqueVoiceType = UsableVoiceTypes[VoiceTypeIndex];
	i = 0;
	J0xEF:

	if(Less_IntInt(i, VoiceTypes.Length))
	{
		if(EqualEqual_NameName(VoiceTypes[i], UniqueVoiceType))
		{
			AddEqual_IntInt(VoiceTypesUsed[i], 1);
			// [Explicit Break]
			goto J0x12F;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0xEF;
	}
	J0x12F:

	return UniqueVoiceType;
	return;
}

function bool HasVoiceType(name inVoiceType)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, VoiceTypes.Length))
	{
		if(EqualEqual_NameName(VoiceTypes[i], inVoiceType))
		{
			return true;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return false;
	return;
}
