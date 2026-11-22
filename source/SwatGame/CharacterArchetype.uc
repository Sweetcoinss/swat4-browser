class CharacterArchetype extends Archetype
	config
	perobjectconfig;

struct EquipmentChancePair
{
	var config string Equipment;
	var config int Chance;
};

var config Mesh Mesh;
var config name CharacterType;
var config name VoiceTypeOverride;
var config array<Material> FleshMaterial;
var config array<Material> ClothesMaterial;
var config array<Material> FaceMaterial;
var config array<Material> VestMaterial;
var config array<Material> NameMaterial;
var config array<Material> PantsMaterial;
var config Range Morale;
var config array<EquipmentChancePair> Equipment1;
var config array<EquipmentChancePair> Equipment2;
var config array<EquipmentChancePair> Equipment3;
var config array<EquipmentChancePair> Equipment4;
var array< Class<Equipment> > Equipment1Class;
var array< Class<Equipment> > Equipment2Class;
var array< Class<Equipment> > Equipment3Class;
var array< Class<Equipment> > Equipment4Class;
var config float AggressiveChance;
var Mesh OfficerMesh;

function Initialize(Actor inOwner)
{
	InitializeEquipment(Equipment1, Equipment1Class, "1");
	InitializeEquipment(Equipment2, Equipment2Class, "2");
	InitializeEquipment(Equipment3, Equipment3Class, "3");
	InitializeEquipment(Equipment4, Equipment4Class, "4");
	super.Initialize(inOwner);
	return;
}

private final function InitializeEquipment(array<EquipmentChancePair> Equipment, out array< Class<Actor> > EquipmentClasses, string Index)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Equipment.Length))
	{
		if(NotEqual_StrStr(Equipment[i].Equipment, ""))
		{
			EquipmentClasses[i] = Class<Actor>(DynamicLoadObject(Equipment[i].Equipment, Class'Core.Class'));
			AssertWithDescription(NotEqual_ObjectObject(EquipmentClasses[i], none), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] While initializing the character part of the ", string(Class.Name)), " instance named "), string(Name)), ", the class for Equipment"), Index), " option #"), string(i)), " ("), Equipment[i].Equipment), ")"), " couldn't be loaded."));
			// [Explicit Continue]
			goto J0x154;
		}
		EquipmentClasses[i] = none;
		J0x154:

		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

protected function Validate()
{
	local int i;

	super.Validate();
	ValidateCondition(NotEqual_ObjectObject(Mesh, none), "Mesh resolves to None");
	if(EqualEqual_ObjectObject(Mesh, OfficerMesh))
	{
		ValidateCondition(Greater_IntInt(FaceMaterial.Length, 0), "it is Missing a FaceMaterial");
		i = 0;
		J0x6E:

		if(Less_IntInt(i, FaceMaterial.Length))
		{
			ValidateCondition(NotEqual_ObjectObject(FaceMaterial[i], none), Concat_StrStr(Concat_StrStr("FaceMaterial number ", string(Add_IntInt(i, 1))), " resolves to None"));
			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0x6E;
		}
		ValidateCondition(Greater_IntInt(VestMaterial.Length, 0), "it is Missing a VestMaterial");
		i = 0;
		J0x107:

		if(Less_IntInt(i, VestMaterial.Length))
		{
			ValidateCondition(NotEqual_ObjectObject(VestMaterial[i], none), Concat_StrStr(Concat_StrStr("VestMaterial number ", string(Add_IntInt(i, 1))), " resolves to None"));
			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0x107;
		}
		ValidateCondition(Greater_IntInt(NameMaterial.Length, 0), "it is Missing a NameMaterial");
		i = 0;
		J0x1A0:

		if(Less_IntInt(i, NameMaterial.Length))
		{
			ValidateCondition(NotEqual_ObjectObject(NameMaterial[i], none), Concat_StrStr(Concat_StrStr("NameMaterial number ", string(Add_IntInt(i, 1))), " resolves to None"));
			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0x1A0;
		}
		ValidateCondition(Greater_IntInt(PantsMaterial.Length, 0), "it is Missing a PantsMaterial");
		i = 0;
		J0x23A:

		if(Less_IntInt(i, PantsMaterial.Length))
		{
			ValidateCondition(NotEqual_ObjectObject(PantsMaterial[i], none), Concat_StrStr(Concat_StrStr("PantsMaterial number ", string(Add_IntInt(i, 1))), " resolves to None"));
			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0x23A;
		}
		ValidateCondition(EqualEqual_IntInt(FleshMaterial.Length, 0), "it uses the SwatOfficer mesh but it specifies a FleshMaterial");
		ValidateCondition(EqualEqual_IntInt(ClothesMaterial.Length, 0), "it uses the SwatOfficer mesh but it specifies a ClothesMaterial");
	}
	else
	{
		ValidateCondition(Greater_IntInt(FleshMaterial.Length, 0), "it is Missing a FleshMaterial");
		i = 0;
		J0x376:

		if(Less_IntInt(i, FleshMaterial.Length))
		{
			ValidateCondition(NotEqual_ObjectObject(FleshMaterial[i], none), Concat_StrStr(Concat_StrStr("FleshMaterial number ", string(Add_IntInt(i, 1))), " resolves to None"));
			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0x376;
		}
		ValidateCondition(Greater_IntInt(ClothesMaterial.Length, 0), "it is Missing a ClothesMaterial");
		i = 0;
		J0x413:

		if(Less_IntInt(i, ClothesMaterial.Length))
		{
			ValidateCondition(NotEqual_ObjectObject(ClothesMaterial[i], none), Concat_StrStr(Concat_StrStr("ClothesMaterial number ", string(Add_IntInt(i, 1))), " resolves to None"));
			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0x413;
		}
		ValidateCondition(EqualEqual_IntInt(FaceMaterial.Length, 0), "it doesn't use the SwatOfficer mesh but it specifies a FaceMaterial");
		ValidateCondition(EqualEqual_IntInt(VestMaterial.Length, 0), "it doesn't use the SwatOfficer mesh but it specifies a VestMaterial");
		ValidateCondition(EqualEqual_IntInt(NameMaterial.Length, 0), "it doesn't use the SwatOfficer mesh but it specifies a NameMaterial");
		ValidateCondition(EqualEqual_IntInt(PantsMaterial.Length, 0), "it doesn't use the SwatOfficer mesh but it specifies a PantsMaterial");
	}
	ValidateEquipment("Equipment1", Equipment1, Equipment1Class);
	ValidateEquipment("Equipment2", Equipment2, Equipment2Class);
	ValidateEquipment("Equipment3", Equipment3, Equipment3Class);
	ValidateEquipment("Equipment4", Equipment4, Equipment4Class);
	return;
}

function ValidateEquipment(string WhichOne, array<EquipmentChancePair> Equipment, array< Class<Actor> > EquipmentClasses)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, EquipmentClasses.Length))
	{
		ValidateCondition(OrOr_BoolBool(EqualEqual_StrStr(Equipment[i].Equipment, ""), NotEqual_ObjectObject(EquipmentClasses[i], none)), Concat_StrStr(Concat_StrStr(Concat_StrStr(WhichOne, " (choice #"), string(i)), ") resolves to None"));
		ValidateCondition(OrOr_BoolBool(EqualEqual_ObjectObject(EquipmentClasses[i], none), ClassIsChildOf(EquipmentClasses[i], Class'Engine.Equipment')), Concat_StrStr(Concat_StrStr(Concat_StrStr(WhichOne, " (choice #"), string(i)), ") resolves to a valid class, but not a kind of Equipment"));
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

function InitializeInstance(ArchetypeInstance inInstance)
{
	local CharacterArchetypeInstance Instance;

	Instance = CharacterArchetypeInstance(inInstance);
	super.InitializeInstance(Instance);
	Instance.Mesh = Mesh;
	if(EqualEqual_ObjectObject(Mesh, OfficerMesh))
	{
		Instance.FaceMaterial = FaceMaterial[Rand(FaceMaterial.Length)];
		Instance.VestMaterial = VestMaterial[Rand(VestMaterial.Length)];
		Instance.NameMaterial = NameMaterial[Rand(NameMaterial.Length)];
		Instance.PantsMaterial = PantsMaterial[Rand(PantsMaterial.Length)];
	}
	else
	{
		Instance.FleshMaterial = FleshMaterial[Rand(FleshMaterial.Length)];
		Instance.ClothesMaterial = ClothesMaterial[Rand(ClothesMaterial.Length)];
	}
	Instance.Morale = RandRange(Morale.Min, Morale.Max);
	Instance.Equipment[3] = none;
	Instance.SelectedEquipment1Class = InitializeInstanceEquipment(Instance.Equipment[0], Equipment1, Equipment1Class, Instance);
	Instance.SelectedEquipment2Class = InitializeInstanceEquipment(Instance.Equipment[1], Equipment2, Equipment2Class, Instance);
	Instance.SelectedEquipment3Class = InitializeInstanceEquipment(Instance.Equipment[2], Equipment3, Equipment3Class, Instance);
	Instance.SelectedEquipment4Class = InitializeInstanceEquipment(Instance.Equipment[3], Equipment4, Equipment4Class, Instance);
	Instance.VoiceTypeOverride = VoiceTypeOverride;
	Instance.CharacterType = CharacterType;
	Instance.IsAggressive = Less_FloatFloat(FRand(), AggressiveChance);
	Instance.UpdateInstancePrecachables();
	return;
}

private final function Class<Equipment> InitializeInstanceEquipment(out Equipment Equipment, array<EquipmentChancePair> Options, array< Class<Equipment> > OptionClasses, CharacterArchetypeInstance Instance)
{
	local int TotalChance, RandChance, AccumulatedChance;
	local Class<Equipment> Chosen;
	local int i;

	if(EqualEqual_IntInt(Options.Length, 0))
	{
		return none;
	}
	i = 0;
	J0x15:

	if(Less_IntInt(i, Options.Length))
	{
		AddEqual_IntInt(TotalChance, Options[i].Chance);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x15;
	}
	RandChance = Rand(TotalChance);
	i = 0;
	J0x5A:

	if(Less_IntInt(i, Options.Length))
	{
		AddEqual_IntInt(AccumulatedChance, Options[i].Chance);
		if(GreaterEqual_IntInt(AccumulatedChance, RandChance))
		{
			Chosen = OptionClasses[i];
			if(NotEqual_ObjectObject(Chosen, none))
			{
				Equipment = Owner.Spawn(Chosen, Instance.Owner);
				Equipment.OnGivenToOwner();
			}
			return Chosen;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x5A;
	}
	assert(false);
	return;
}

defaultproperties
{
	OfficerMesh=SkeletalMesh'SWATMaleAnimation.SwatOfficer'
}