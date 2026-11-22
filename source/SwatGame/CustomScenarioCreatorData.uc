class CustomScenarioCreatorData extends Object
	config(CustomScenarioCreator);

struct ArchetypePresentation
{
	var config name Archetype;
	var config bool ByDefault;
};

struct WeaponPresentation
{
	var config name category;
	var config string Weapon;
};

var config string ScenariosPath;
var config string PackExtension;
var config array<name> AvailableObjective;
var config array<string> AvailableObjectiveClass;
var config localized array<localized string> PredefinedRedOneLoadOut;
var config localized array<localized string> PredefinedRedTwoLoadOut;
var config localized array<localized string> PredefinedBlueOneLoadOut;
var config localized array<localized string> PredefinedBlueTwoLoadOut;
var config array<ArchetypePresentation> HostageArchetype;
var config array<ArchetypePresentation> EnemyArchetype;
var config array<name> PrimaryWeaponCategory;
var config localized array<localized string> PrimaryWeaponCategoryDescription;
var config array<name> BackupWeaponCategory;
var config localized array<localized string> BackupWeaponCategoryDescription;
var config array<WeaponPresentation> PrimaryWeapon;
var config array<WeaponPresentation> BackupWeapon;
var config localized string AnyString;
var config localized string AnyLoadoutString;
var config localized string NoneString;
var config localized string CopyOfString;
var config localized string NewScenarioString;
var config localized string DefaultPackString;
var config localized string UnavailableString;
var config localized string LowString;
var config localized string MediumString;
var config localized string HighString;
var config localized string EasyString;
var config localized string NormalString;
var config localized string HardString;
var config localized string EliteString;
var config localized string NumberOfHostagesString;
var config localized string NumberOfEnemiesString;
var config localized string CommaIncludingString;
var config localized string CampaignObjectivesString;
var config float DefaultTimeLimit;
var private SwatGUIConfig GC;
var private bool bCurrentMissionDirty;
var array<CustomScenarioCreatorMissionSpecificData> MissionData;

function bool IsCurrentMisisonDirty()
{
	return bCurrentMissionDirty;
	return;
}

function SetCurrentMissionDirty()
{
	bCurrentMissionDirty = true;
	return;
}

function ClearCurrentMissionDirty()
{
	bCurrentMissionDirty = false;
	return;
}

function Init(SwatGUIConfig inGC)
{
	local int i;

	GC = inGC;
	assert(NotEqual_ObjectObject(GC, none));
	i = 0;
	J0x1D:

	if(Less_IntInt(i, GC.MissionName.Length))
	{
		MissionData[i] = Class'SwatGame.CustomScenarioCreatorMissionSpecificData'.static.Allocate(self, none, string(GC.MissionName[i])).;
		Construct_Void();
		assert(NotEqual_ObjectObject(MissionData[i], none));
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x1D;
	}
	return;
}

function CustomScenarioCreatorMissionSpecificData GetMissionData_Slow(name inMission)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, GC.MissionName.Length))
	{
		if(EqualEqual_NameName(GC.MissionName[i], inMission))
		{
			assert(Greater_IntInt(MissionData.Length, i));
			return MissionData[i];
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	AssertWithDescription(false, Concat_StrStr(Concat_StrStr("[tcohen] CustomScenarioCreatorData::GetMissionData_Slow() the specified Mission named ", string(inMission)), " was not found."));
	return;
}

defaultproperties
{
	ScenariosPath="..\\..\\Content\\Scenarios\\"
	PackExtension="pak"
	PredefinedRedOneLoadOut[0]="Assaulter_JHP"
	PredefinedRedOneLoadOut[1]="Assaulter_FMJ"
	PredefinedRedOneLoadOut[2]="CQB_Specialist"
	PredefinedRedOneLoadOut[3]="Breacher"
	PredefinedRedOneLoadOut[4]="Scout"
	PredefinedRedOneLoadOut[5]="Pacifier"
	PredefinedRedOneLoadOut[6]="LessLethal"
	PredefinedRedTwoLoadOut[0]="Assaulter_JHP"
	PredefinedRedTwoLoadOut[1]="Assaulter_FMJ"
	PredefinedRedTwoLoadOut[2]="CQB_Specialist"
	PredefinedRedTwoLoadOut[3]="Breacher"
	PredefinedRedTwoLoadOut[4]="Scout"
	PredefinedRedTwoLoadOut[5]="Pacifier"
	PredefinedRedTwoLoadOut[6]="LessLethal"
	PredefinedBlueOneLoadOut[0]="Assaulter_JHP"
	PredefinedBlueOneLoadOut[1]="Assaulter_FMJ"
	PredefinedBlueOneLoadOut[2]="CQB_Specialist"
	PredefinedBlueOneLoadOut[3]="Breacher"
	PredefinedBlueOneLoadOut[4]="Scout"
	PredefinedBlueOneLoadOut[5]="Pacifier"
	PredefinedBlueOneLoadOut[6]="LessLethal"
	PredefinedBlueTwoLoadOut[0]="Assaulter_JHP"
	PredefinedBlueTwoLoadOut[1]="Assaulter_FMJ"
	PredefinedBlueTwoLoadOut[2]="CQB_Specialist"
	PredefinedBlueTwoLoadOut[3]="Breacher"
	PredefinedBlueTwoLoadOut[4]="Scout"
	PredefinedBlueTwoLoadOut[5]="Pacifier"
	PredefinedBlueTwoLoadOut[6]="LessLethal"
	HostageArchetype[0]=(Archetype="Custom_Terrorists",ByDefault=false)
	HostageArchetype[1]=(Archetype="Custom_TerroristsWithBodyArmor",ByDefault=false)
	HostageArchetype[2]=(Archetype="Custom_MaleCasual_BodyArmor",ByDefault=false)
	HostageArchetype[3]=(Archetype="Custom_GangMembers",ByDefault=false)
	HostageArchetype[4]=(Archetype="Custom_FatGuy",ByDefault=false)
	HostageArchetype[5]=(Archetype="Custom_MaleSuit1",ByDefault=false)
	HostageArchetype[6]=(Archetype="Custom_MaleSuit2",ByDefault=false)
	HostageArchetype[7]=(Archetype="Custom_MaleCasual1",ByDefault=false)
	HostageArchetype[8]=(Archetype="Custom_MaleCasual2",ByDefault=false)
	HostageArchetype[9]=(Archetype="Custom_MaleCasual3",ByDefault=false)
	HostageArchetype[10]=(Archetype="Custom_MaleCasual4",ByDefault=false)
	HostageArchetype[11]=(Archetype="Custom_LeoMel",ByDefault=false)
	HostageArchetype[12]=(Archetype="Custom_MaleCasual_Beefy",ByDefault=false)
	HostageArchetype[13]=(Archetype="Custom_Doctor",ByDefault=false)
	HostageArchetype[14]=(Archetype="Custom_Janitor",ByDefault=false)
	HostageArchetype[15]=(Archetype="Custom_Homeless_Male",ByDefault=false)
	HostageArchetype[16]=(Archetype="Custom_PoliceCadet",ByDefault=false)
	HostageArchetype[17]=(Archetype="Custom_FemaleCasual1",ByDefault=true)
	HostageArchetype[18]=(Archetype="Custom_FemaleCasual2",ByDefault=false)
	HostageArchetype[19]=(Archetype="Custom_FemaleCasual3",ByDefault=false)
	HostageArchetype[20]=(Archetype="Custom_FemaleOffice",ByDefault=false)
	HostageArchetype[21]=(Archetype="Custom_Female_Heavy",ByDefault=false)
	HostageArchetype[22]=(Archetype="Custom_Nurse",ByDefault=false)
	HostageArchetype[23]=(Archetype="Custom_Female_Homeless",ByDefault=false)
	HostageArchetype[24]=(Archetype="Silence_Mother",ByDefault=false)
	HostageArchetype[25]=(Archetype="RedLibrary_Rooney",ByDefault=false)
	HostageArchetype[26]=(Archetype="Hotel_Adams",ByDefault=false)
	HostageArchetype[27]=(Archetype="Hotel_Bettencourt",ByDefault=false)
	HostageArchetype[28]=(Archetype="Hospital_Diplomat",ByDefault=false)
	HostageArchetype[29]=(Archetype="DNA_Sterling",ByDefault=false)
	HostageArchetype[30]=(Archetype="Silence_Victim1",ByDefault=false)
	HostageArchetype[31]=(Archetype="Training_SWATInstructor",ByDefault=false)
	EnemyArchetype[0]=(Archetype="Custom_Terrorists",ByDefault=false)
	EnemyArchetype[1]=(Archetype="Custom_TerroristsWithBodyArmor",ByDefault=false)
	EnemyArchetype[2]=(Archetype="Custom_Terrorist_GasMask",ByDefault=false)
	EnemyArchetype[3]=(Archetype="Custom_Terrorist_HockeyMask",ByDefault=false)
	EnemyArchetype[4]=(Archetype="Custom_MaleCasual_BodyArmor",ByDefault=false)
	EnemyArchetype[5]=(Archetype="Custom_GangMembers",ByDefault=true)
	EnemyArchetype[6]=(Archetype="Custom_FatGuy",ByDefault=false)
	EnemyArchetype[7]=(Archetype="Custom_MaleSuit1",ByDefault=false)
	EnemyArchetype[8]=(Archetype="Custom_MaleSuit2",ByDefault=false)
	EnemyArchetype[9]=(Archetype="Custom_MaleCasual1",ByDefault=false)
	EnemyArchetype[10]=(Archetype="Custom_MaleCasual2",ByDefault=false)
	EnemyArchetype[11]=(Archetype="Custom_MaleCasual3",ByDefault=false)
	EnemyArchetype[12]=(Archetype="Custom_MaleCasual4",ByDefault=false)
	EnemyArchetype[13]=(Archetype="Custom_LeoMel",ByDefault=false)
	EnemyArchetype[14]=(Archetype="Custom_MaleCasual_Beefy",ByDefault=false)
	EnemyArchetype[15]=(Archetype="Custom_Doctor",ByDefault=false)
	EnemyArchetype[16]=(Archetype="Custom_Janitor",ByDefault=false)
	EnemyArchetype[17]=(Archetype="Custom_Homeless_Male",ByDefault=false)
	EnemyArchetype[18]=(Archetype="Custom_PoliceCadet",ByDefault=false)
	EnemyArchetype[19]=(Archetype="Custom_FemaleCasual1",ByDefault=false)
	EnemyArchetype[20]=(Archetype="Custom_FemaleCasual2",ByDefault=false)
	EnemyArchetype[21]=(Archetype="Custom_FemaleCasual3",ByDefault=false)
	EnemyArchetype[22]=(Archetype="Custom_FemaleOffice",ByDefault=false)
	EnemyArchetype[23]=(Archetype="Custom_Female_Heavy",ByDefault=false)
	EnemyArchetype[24]=(Archetype="Custom_Nurse",ByDefault=false)
	EnemyArchetype[25]=(Archetype="Custom_Female_Homeless",ByDefault=false)
	EnemyArchetype[26]=(Archetype="Custom_Training_SWATInstructor",ByDefault=false)
	EnemyArchetype[27]=(Archetype="FoodWall_Jimenez",ByDefault=false)
	EnemyArchetype[28]=(Archetype="Silence_Killer",ByDefault=false)
	EnemyArchetype[29]=(Archetype="Conv_Alice_Jenkins",ByDefault=false)
	EnemyArchetype[30]=(Archetype="Tenement_Cult_Leader",ByDefault=false)
	EnemyArchetype[31]=(Archetype="DNA_Terror_Leader",ByDefault=false)
	EnemyArchetype[32]=(Archetype="Custom_MelindaKline",ByDefault=false)
	PrimaryWeaponCategory[0]="MachineGun"
	PrimaryWeaponCategory[1]="SubMachineGun"
	PrimaryWeaponCategory[2]="Shotgun"
	PrimaryWeaponCategory[3]="Handgun"
	PrimaryWeaponCategoryDescription[0]="Machineguns"
	PrimaryWeaponCategoryDescription[1]="Submachineguns"
	PrimaryWeaponCategoryDescription[2]="Shotguns"
	PrimaryWeaponCategoryDescription[3]="Handguns"
	BackupWeaponCategory[0]="MachineGun"
	BackupWeaponCategory[1]="SubMachineGun"
	BackupWeaponCategory[2]="Shotgun"
	BackupWeaponCategory[3]="Handgun"
	BackupWeaponCategoryDescription[0]="Machineguns"
	BackupWeaponCategoryDescription[1]="Submachineguns"
	BackupWeaponCategoryDescription[2]="Shotguns"
	BackupWeaponCategoryDescription[3]="Handguns"
	PrimaryWeapon[0]=(category="Handgun",Weapon="SwatEquipment.ColtM1911HG")
	PrimaryWeapon[1]=(category="Handgun",Weapon="SwatEquipment.BerettaM9HG")
	PrimaryWeapon[2]=(category="Handgun",Weapon="SwatEquipment.ScorpionHG")
	PrimaryWeapon[3]=(category="Handgun",Weapon="SwatEquipment.USP40HG")
	PrimaryWeapon[4]=(category="Handgun",Weapon="SwatEquipment.PythonRevolverHG")
	PrimaryWeapon[5]=(category="Handgun",Weapon="SwatEquipment.IngramHG")
	PrimaryWeapon[6]=(category="SubMachineGun",Weapon="SwatEquipment.BadguyMP5SMG")
	PrimaryWeapon[7]=(category="SubMachineGun",Weapon="SwatEquipment.BadguySilencedMP5SMG")
	PrimaryWeapon[8]=(category="SubMachineGun",Weapon="SwatEquipment.HK53SMG")
	PrimaryWeapon[9]=(category="SubMachineGun",Weapon="SwatEquipment.UMP45SMG")
	PrimaryWeapon[10]=(category="SubMachineGun",Weapon="SwatEquipment.UZISMG")
	PrimaryWeapon[11]=(category="MachineGun",Weapon="SwatEquipment.AK47MG")
	PrimaryWeapon[12]=(category="MachineGun",Weapon="SwatEquipment.AK74MG")
	PrimaryWeapon[13]=(category="MachineGun",Weapon="SwatEquipment.AK74suMG")
	PrimaryWeapon[14]=(category="MachineGun",Weapon="SwatEquipment.G36KMG")
	PrimaryWeapon[15]=(category="MachineGun",Weapon="SwatEquipment.M4MG")
	PrimaryWeapon[16]=(category="Shotgun",Weapon="SwatEquipment.BadguyM4Super90SG")
	PrimaryWeapon[17]=(category="Shotgun",Weapon="SwatEquipment.M1Super90SG")
	PrimaryWeapon[18]=(category="Shotgun",Weapon="SwatEquipment.Pump1SG")
	PrimaryWeapon[19]=(category="Shotgun",Weapon="SwatEquipment.Pump2RifleGripSG")
	PrimaryWeapon[20]=(category="Shotgun",Weapon="SwatEquipment.SawedOffSG")
	BackupWeapon[0]=(category="Handgun",Weapon="SwatEquipment.ColtM1911HG")
	BackupWeapon[1]=(category="Handgun",Weapon="SwatEquipment.BerettaM9HG")
	BackupWeapon[2]=(category="Handgun",Weapon="SwatEquipment.ScorpionHG")
	BackupWeapon[3]=(category="Handgun",Weapon="SwatEquipment.USP40HG")
	BackupWeapon[4]=(category="Handgun",Weapon="SwatEquipment.PythonRevolverHG")
	BackupWeapon[5]=(category="Handgun",Weapon="SwatEquipment.IngramHG")
	BackupWeapon[6]=(category="SubMachineGun",Weapon="SwatEquipment.BadguyMP5SMG")
	BackupWeapon[7]=(category="SubMachineGun",Weapon="SwatEquipment.BadguySilencedMP5SMG")
	BackupWeapon[8]=(category="SubMachineGun",Weapon="SwatEquipment.HK53SMG")
	BackupWeapon[9]=(category="SubMachineGun",Weapon="SwatEquipment.UMP45SMG")
	BackupWeapon[10]=(category="SubMachineGun",Weapon="SwatEquipment.UZISMG")
	BackupWeapon[11]=(category="MachineGun",Weapon="SwatEquipment.AK47MG")
	BackupWeapon[12]=(category="MachineGun",Weapon="SwatEquipment.AK74MG")
	BackupWeapon[13]=(category="MachineGun",Weapon="SwatEquipment.AK74suMG")
	BackupWeapon[14]=(category="MachineGun",Weapon="SwatEquipment.G36KMG")
	BackupWeapon[15]=(category="MachineGun",Weapon="SwatEquipment.M4MG")
	BackupWeapon[16]=(category="Shotgun",Weapon="SwatEquipment.BadguyM4Super90SG")
	BackupWeapon[17]=(category="Shotgun",Weapon="SwatEquipment.M1Super90SG")
	BackupWeapon[18]=(category="Shotgun",Weapon="SwatEquipment.Pump1SG")
	BackupWeapon[19]=(category="Shotgun",Weapon="SwatEquipment.Pump2RifleGripSG")
	BackupWeapon[20]=(category="Shotgun",Weapon="SwatEquipment.SawedOffSG")
	AnyString="Any"
	AnyLoadoutString="Any Loadout"
	NoneString="None"
	CopyOfString="Copy of"
	NewScenarioString="New Scenario"
	DefaultPackString="Default"
	UnavailableString="[ Unavailable ]"
	LowString="Low"
	MediumString="Medium"
	HighString="High"
	EasyString="Easy"
	NormalString="Normal"
	HardString="Hard"
	EliteString="Elite"
	NumberOfHostagesString="NUMBER OF HOSTAGES"
	NumberOfEnemiesString="NUMBER OF SUSPECTS"
	CommaIncludingString=", INCLUDING"
	CampaignObjectivesString="CAMPAIGN OBJECTIVES."
	DefaultTimeLimit=5.0000000
}