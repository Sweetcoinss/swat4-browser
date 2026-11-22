class GameEngine extends Engine
	transient
	native
	config
	noexport;

struct URL
{
	var string Protocol;
	var string Host;
	var int Port;
	var string Map;
	var array<string> Op;
	var string Portal;
	var int Valid;
};

var Level GLevel;
var Level GEntry;
var PendingLevel GPendingLevel;
var private const int LevelLoadingTotalActorCount;
var private const int LevelLoadingActorCount;
var URL LastURL;
var config array<string> ServerActors;
var config array<string> ServerPackages;
var array<Object> DummyArray;
var Object DummyObject;
var bool bCheatProtection;
var bool InitialMapLoaded;
var config string HUDMenuClass;
var config string InitialMenuClass;
var config string GameSpyManagerClass;
var GameSpyManager GameSpyManager;

defaultproperties
{
	ServerActors[0]="IpDrv.MasterServerUplink"
	ServerPackages[0]="Core"
	ServerPackages[1]="Engine"
	ServerPackages[2]="IGEffectsSystem"
	ServerPackages[3]="IGVisualEffectsSubsystem"
	ServerPackages[4]="IGSoundEffectsSubsystem"
	ServerPackages[5]="Editor"
	ServerPackages[6]="UWindow"
	ServerPackages[7]="GamePlay"
	ServerPackages[8]="GUI"
	ServerPackages[9]="SwatEd"
	ServerPackages[10]="IpDrv"
	ServerPackages[11]="Tyrion"
	ServerPackages[12]="AICommon"
	ServerPackages[13]="Scripting"
	ServerPackages[14]="SwatAIAwareness"
	ServerPackages[15]="SwatAICommon"
	ServerPackages[16]="RWOSupport"
	ServerPackages[17]="SwatGame"
	ServerPackages[18]="SwatEffects"
	ServerPackages[19]="SwatEquipment"
	ServerPackages[20]="SwatProtectiveEquipment"
	ServerPackages[21]="SwatSimpleEquipment"
	ServerPackages[22]="SwatObjectives"
	ServerPackages[23]="SwatProcedures"
	ServerPackages[24]="SwatGui"
	ServerPackages[25]="SwatEquipmentModels"
	ServerPackages[26]="SWATofficerTex"
	ServerPackages[27]="mp_OfficerTex"
	ServerPackages[28]="SwatAmmo"
	ServerPackages[29]="SwatCameraEffects"
	ServerPackages[30]="SW_Objects"
	ServerPackages[31]="SW_Bounce"
	ServerPackages[32]="SW_Ambients"
	ServerPackages[33]="SW_Bullets"
	ServerPackages[34]="SW_Feet"
	ServerPackages[35]="SW_Hits"
	ServerPackages[36]="SW_Meta"
	ServerPackages[37]="SW_VO"
	ServerPackages[38]="SW_Weapons"
	ServerPackages[39]="SWATMaleAnimation"
	ServerPackages[40]="FemaleAnimation"
	ServerPackages[41]="SwatBadguyTex"
	ServerPackages[42]="FemaleCasual1Tex"
	ServerPackages[43]="FemaleCasual2Tex"
	ServerPackages[44]="FemaleCasual3Tex"
	ServerPackages[45]="FemaleHeavyTex"
	ServerPackages[46]="FemaleNurseTex"
	ServerPackages[47]="FemaleOfficeTex"
	ServerPackages[48]="CultLeaderTextureSet"
	ServerPackages[49]="LeoMelTextureSet"
	ServerPackages[50]="MaleCasual1Tex"
	ServerPackages[51]="MaleCasual2Tex"
	ServerPackages[52]="MaleCasual3Tex"
	ServerPackages[53]="MaleCasual4Tex"
	ServerPackages[54]="MaleCasualArmorTex"
	ServerPackages[55]="MaleChubbyTex"
	ServerPackages[56]="MaleDoctorTex"
	ServerPackages[57]="MaleGang1Tex"
	ServerPackages[58]="MaleJanitorTextureSet"
	ServerPackages[59]="MaleSuitTex"
	HUDMenuClass="SwatGui.HUDPage"
	InitialMenuClass="SwatGui.SwatMainMenu"
	GameSpyManagerClass="SwatGame.SwatGameSpyManager"
	Console=Class'Engine.Console'
	RepoClassName="SwatGame.SwatRepo"
	CacheSizeMegs=32
	UsePerforce=0
}