class CharacterArchetypeInstance extends ArchetypeInstance
	abstract;

var Mesh Mesh;
var Material FleshMaterial;
var Material ClothesMaterial;
var Material FaceMaterial;
var Material VestMaterial;
var Material NameMaterial;
var Material PantsMaterial;
var float Morale;
var array<Equipment> Equipment;
var name CharacterType;
var name VoiceTypeOverride;
var bool IsAggressive;
var Class<Equipment> SelectedEquipment1Class;
var Class<Equipment> SelectedEquipment2Class;
var Class<Equipment> SelectedEquipment3Class;
var Class<Equipment> SelectedEquipment4Class;

function DestroyEquipment()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Equipment.Length))
	{
		if(NotEqual_ObjectObject(Equipment[i], none))
		{
			Equipment[i].Destroy();
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

function UpdateInstancePrecachables()
{
	local SwatGameInfo SGI;

	if(Not_PreBool(Owner.Level.IsCOOPServer))
	{
		return;
	}
	SGI = SwatGameInfo(Owner.Level.Game);
	assert(NotEqual_ObjectObject(SGI, none));
	SGI.AddMesh(Mesh);
	SGI.AddMaterial(FleshMaterial);
	SGI.AddMaterial(ClothesMaterial);
	SGI.AddMaterial(FaceMaterial);
	SGI.AddMaterial(VestMaterial);
	SGI.AddMaterial(NameMaterial);
	SGI.AddMaterial(PantsMaterial);
	SGI.AddStaticMesh(SelectedEquipment1Class.default.StaticMesh);
	SGI.AddStaticMesh(SelectedEquipment2Class.default.StaticMesh);
	SGI.AddStaticMesh(SelectedEquipment3Class.default.StaticMesh);
	SGI.AddStaticMesh(SelectedEquipment4Class.default.StaticMesh);
	if(IsFemale())
	{
		SGI.SetLevelHasFemaleCharacters();
	}
	return;
}

function bool IsFemale()
{
	return AndAnd_BoolBool(NotEqual_NameName(CharacterType, 'None'), SwatAIRepository(Owner.Level.AIRepo).IsAFemaleCharacterType(CharacterType));
	return;
}
