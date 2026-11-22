class CharacterTypesList extends Actor
	config(CharacterTypes)
	notplaceable
	hidecategories(Karma);

var config array<name> CharacterTypes;
var array<CharacterVoiceTypes> CharacterVoiceTypes;
var config array<name> FemaleCharacterTypes;

event PreBeginPlay()
{
	super.PreBeginPlay();
	VerifyFemaleCharacterTypes();
	CreateVoiceTypes();
	return;
}

private function VerifyFemaleCharacterTypes()
{
	local int i;
	local array<string> Problems;

	i = 0;
	J0x07:

	if(Less_IntInt(i, FemaleCharacterTypes.Length))
	{
		if(Not_PreBool(VerifyCharacterTypeExists(FemaleCharacterTypes[i])))
		{
			Problems[Problems.Length] = Concat_StrStr("Could not find CharacterType that was found in FemaleCharacterTypes: ", string(FemaleCharacterTypes[i]));
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	if(Greater_IntInt(Problems.Length, 0))
	{
		i = 0;
		J0xAD:

		if(Less_IntInt(i, Problems.Length))
		{
			Log(Problems[i]);
			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0xAD;
		}
		AssertWithDescription(false, "Problems were found with character types.  Check the Swat4.log for details!");
	}
	return;
}

function bool IsAFemaleCharacterType(name CharacterType)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, FemaleCharacterTypes.Length))
	{
		if(EqualEqual_NameName(FemaleCharacterTypes[i], CharacterType))
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

private function CreateVoiceTypes()
{
	local int i;
	local CharacterVoiceTypes NewCharacterVoiceTypes;

	i = 0;
	J0x07:

	if(Less_IntInt(i, CharacterTypes.Length))
	{
		NewCharacterVoiceTypes = Class'SwatAICommon.CharacterVoiceTypes'.static.Allocate(self, self, string(CharacterTypes[i]), 0).;
		Construct_Void();
		assert(NotEqual_ObjectObject(NewCharacterVoiceTypes, none));
		CharacterVoiceTypes[i] = NewCharacterVoiceTypes;
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

function name GetVoiceTypeForCharacterType(name inCharacterType)
{
	local int i;

	assert(EqualEqual_IntInt(CharacterTypes.Length, CharacterVoiceTypes.Length));
	i = 0;
	J0x18:

	if(Less_IntInt(i, CharacterTypes.Length))
	{
		if(EqualEqual_NameName(CharacterTypes[i], inCharacterType))
		{
			return CharacterVoiceTypes[i].GetUniqueVoiceType();
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x18;
	}
	assert(false);
	return 'None';
	return;
}

function bool VerifyVoiceTypeExists(name inVoiceType)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, CharacterVoiceTypes.Length))
	{
		if(CharacterVoiceTypes[i].HasVoiceType(inVoiceType))
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

function bool VerifyCharacterTypeExists(name inCharacterType)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, CharacterTypes.Length))
	{
		if(EqualEqual_NameName(CharacterTypes[i], inCharacterType))
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

defaultproperties
{
	bHidden=true
}