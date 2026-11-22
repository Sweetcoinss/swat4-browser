class SwatGUIConfig extends Object
	native
	config(SwatGuiState)
	hidecategories(Object);

enum eDifficultyLevel
{
	DIFFICULTY_Easy,                // 0
	DIFFICULTY_Normal,              // 1
	DIFFICULTY_Hard,                // 2
	DIFFICULTY_Elite                // 3
};

enum eNetworkValidity
{
	NETVALID_None,                  // 0
	NETVALID_SPOnly,                // 1
	NETVALID_MPOnly,                // 2
	NETVALID_All                    // 3
};

enum eCommandCategory
{
	COMCAT_Movement,                // 0
	COMCAT_Interactions,            // 1
	COMCAT_Chat,                    // 2
	COMCAT_Reserved                 // 3
};

enum eVoiceType
{
	VOICETYPE_Random,               // 0
	VOICETYPE_Lead,                 // 1
	VOICETYPE_OfficerRedOne,        // 2
	VOICETYPE_OfficerRedTwo,        // 3
	VOICETYPE_OfficerBlueOne,       // 4
	VOICETYPE_OfficerBlueTwo,       // 5
	VOICETYPE_VIP                   // 6
};

enum ECommandInterfaceStyle
{
	CommandInterface_Invalid,       // 0
	CommandInterface_Classic,       // 1
	CommandInterface_Graphic        // 2
};

enum eConnectionType
{
	CONNECTION_Modem,               // 0
	CONNECTION_Cable,               // 1
	CONNECTION_DSL,                 // 2
	CONNECTION_T1,                  // 3
	CONNECTION_T3,                  // 4
	CONNECTION_OC3                  // 5
};

enum eSwatGameState
{
	GAMESTATE_None,                 // 0
	GAMESTATE_EntryLoading,         // 1
	GAMESTATE_LevelLoading,         // 2
	GAMESTATE_PreGame,              // 3
	GAMESTATE_MidGame,              // 4
	GAMESTATE_PostGame,             // 5
	GAMESTATE_ClientTravel,         // 6
	GAMESTATE_ConnectionFailed      // 7
};

enum eSwatGameRole
{
	GAMEROLE_None,                  // 0
	GAMEROLE_SP_Campaign,           // 1
	GAMEROLE_SP_Custom,             // 2
	GAMEROLE_SP_Other,              // 3
	GAMEROLE_MP_Host,               // 4
	GAMEROLE_MP_Client              // 5
};

struct native ServerFilters
{
	var() config int MaxPing "Filter by max ping, -1 = dont filter by ping";
	var() config bool bFull "Filter out full servers if true";
	var() config bool bPassworded "Filter out passworded servers if true";
	var() config bool bFilterGametype "Filter out gametype servers if true";
	var() config Repo.EMPMode GameType "What game type to filter by";
	var() config bool bHideIncompatibleVersions "Filter out incompatible by version servers if true";
	var() config bool bHideIncompatibleMods "Filter out incompatible by mod servers if true";
};

var(Difficulty) config localized string DifficultyString[4];
var(Difficulty) config int DifficultyScoreRequirement[4];
var(Difficulty) config SwatGUIConfig.eDifficultyLevel CurrentDifficulty;
var(Missions) editconst editinline SwatMission CurrentMission "The current mission selected for Single Player";
var(Missions) config array<name> MissionName "Name used for this mission";
var(Missions) config localized array<localized string> FriendlyName "Friendly name to display in the gui";
var(Missions) private config name LastMissionPlayedName "The Name of the last mission that was played in Single Player";
var(Missions) private config string LastMissionPlayedFriendlyName "The friendly name of the last mission that was played in Single Player";
var(Missions) private config CustomScenario LastMissionPlayedCustomScenario "The last Custom Scenario that was played in Single Player";
var(Missions) private name CurrentMissionName "The Name of the last mission that was played in Single Player";
var(Missions) private string CurrentMissionFriendlyName "The friendly name of the last mission that was played in Single Player";
var(Missions) private CustomScenario CurrentMissionCustomScenario "The last Custom Scenario that was played in Single Player";
var(Missions) config array<name> MissionResultNames;
var(Missions) array<MissionResults> MissionResults;
var(Missions) private editconst editinline CustomScenarioPack CurrentCustomScenarioPack "The current CustomScenarioPack selected for Single Player";
var(Missions) private editconst editinline string PakName "The name of the current CustomScenarioPack selected for Single Player";
var(Missions) private editconst editinline string PakFriendlyName "The name of the current CustomScenarioPack selected for Single Player in friendly display format (without extension)";
var(Missions) private editconst editinline string PakExtension "The extension of the current CustomScenarioPack selected for Single Player";
var(Missions) private editconst editinline string ScenarioName "The current CustomScenario selected for Single Player";
var(Missions) private SwatStartPointBase.EEntryType DesiredSPEntryPoint;
var(Missions) config bool bEverRanTraining "true if the player ever ran training or click through it";
var(Equipment) editconst array<SwatEquipmentSpec> AvailableEquipmentPockets "Specifies other available equipment";
var(Equipment) config array<string> CustomEquipmentLoadouts "Specifies custom equipment loadouts";
var(Equipment) config localized array<localized string> CustomEquipmentLoadoutFriendlyNames "Specifies custom equipment loadouts";
var(Equipment) config array<bool> LoadoutIsUndeletable "Specifies whether the loadout is undeletable";
var(KeyConfigSettings) config array<string> CommandString "The string corresponding to the command this Input Function struct is representing";
var(KeyConfigSettings) config localized array<localized string> LocalizedCommandString "The localized string corresponding to the command this Input Function struct is representing";
var(KeyConfigSettings) config array<SwatGUIConfig.eCommandCategory> CommandCategory "The category of this command";
var(AudioSettings) config localized array<localized string> AudioVirtualizationChoices "Choices for audio virtualization";
var(AudioSettings) config localized array<localized string> SoundQualityChoices "Choices for sound quality";
var(VideoSettings) config localized array<localized string> ScreenResolutionChoices "Choices for screen resolution";
var(VideoSettings) config localized array<localized string> TextureDetailChoices "Choices for texture detail";
var(VideoSettings) config localized array<localized string> OtherDetailChoices "Choices for other detail";
var(VideoSettings) config localized array<localized string> RenderDetailChoices "Choices for generic render detail";
var(VideoSettings) config localized array<localized string> PixelShaderChoices "Choices for pixel shaders";
var(VideoSettings) config localized array<localized string> RealtimeMirrorChoices "Choices for Realtime Mirrors";
var(MPSettings) config localized array<localized string> VoiceTypeChoices "Choices for network voicetypes";
var(MPSettings) config SwatGUIConfig.eVoiceType PreferredVoiceType "Selected voicetype for network games";
var(MPSettings) config localized array<localized string> NetworkConnectionChoices "Choices for network connection";
var(MPSettings) config array<int> NetworkConnectionSpeeds "Speeds for network connection";
var(MPSettings) config int NetSpeedSelection "Selected speed for network connection";
var(MPSettings) config float MPPostMissionTime "Time (in seconds) between when the round has been completed and the MPPage is brought up";
var(MPSettings) config float MPPollingDelay "Time (in seconds) between information polls in MP";
var(MPSettings) bool FirstTimeThrough "Simple switch to determine if the player is entering the server";
var(MPSettings) array<string> AvailableMPMaps "Choices for MP maps to play";
var(MPSettings) private config string SwatMapFileExtension "File extension for swat maps";
var(MPSettings) private config string SwatMPMapNamePrefix "Prefix for multiplayer maps (typically MP)";
var(MPSettings) config localized string TDMDescription "Gametype Team Deathmatch game description. Newlines should be seperated by | (for now)";
var(MPSettings) config localized string VIPDescription "Gametype VIP Escort game description. Newlines should be seperated by | (for now)";
var(MPSettings) config localized string BombDescription "Gametype Diffuse Da Bomb game description. Newlines should be seperated by | (for now)";
var(MPSettings) config localized string COOPDescription "Gametype COOP description. Newlines should be seperated by | (for now)";
var(MPSettings) config localized string TDMFriendlyName "Gametype Team Deathmatch game FriendlyName.";
var(MPSettings) config localized string VIPFriendlyName "Gametype VIP Escort game FriendlyName.";
var(MPSettings) config localized string BombFriendlyName "Gametype Diffuse Da Bomb game FriendlyName.";
var(MPSettings) config localized string COOPFriendlyName "Gametype COOP FriendlyName.";
var(MPSettings) config localized string MPSuspectsWinMessage "The message to display when the suspects win";
var(MPSettings) config localized string MPSWATWinMessage "The message to display when the SWAT team wins";
var(MPSettings) config localized string MPTieMessage "The message to display when the game ends in a tie";
var(GameSettings) config localized string MPName "The name the player will use for Multiplayer Games";
var(GameSettings) config bool bShowSubtitles "If true, subtitles will be displayed for in-game audio";
var(GameSettings) config bool bShowHelp "If true, help text will be displayed for each control";
var(GameSettings) config bool bAlwaysRun "If true, the player will run by default rather than walk";
var(GameSettings) int MPNameLength "The max length of the name the player will use for Multiplayer Games";
var(GameSettings) localized string MPNameAllowableCharSet "The allowable character set for the name the player will use for Multiplayer Games";
var(HUDSettings) config SwatGUIConfig.ECommandInterfaceStyle CommandInterfaceStyle;
var(HUDSettings) editconst SwatGUIConfig.ECommandInterfaceStyle CurrentCommandInterfaceStyle;
var(HUDSettings) config int MessageDisplayTime "Time (in seconds) for messages to be displayed on the hud";
var(HUDSettings) config int GCIButtonMode "Button Mode currently selected for the Graphical Command Interface";
var(HUDSettings) config bool bUseExitMenu "Exit pad displayed the Graphical Command Interface";
var config string AdminPassword "Admin Password for the server for authenticating users";
var(ServerSettings) editinline array<editinline MapRotation> MapList "Maplists to cycle through - 1 per gametype";
var(ServerSettings) config ServerFilters theServerFilters "The current server filters";
var(ServerSettings) config bool bViewingGameSpy "If true, the client is viewing the server list provided by GameSpy";
var(SwatGame) SwatGUIConfig.eSwatGameState SwatGameState;
var(SwatGame) SwatGUIConfig.eSwatGameRole SwatGameRole;
var(SwatGame) config float CriticalMomentDelay "The amount of time after a critical moment to wait until popping out of the action (eg. to give players time to die)";

overloaded function Construct()
{
	local int i;

	AssertWithDescription(EqualEqual_IntInt(MissionName.Length, FriendlyName.Length), "The number of campaign MissionNames specified in SwatGUIState.ini does not match the number of FriendlyNames");
	AssertWithDescription(Greater_IntInt(MissionName.Length, 0), "There must be at least one valid campaign MissionNames specified in SwatGUIState.ini");
	i = 0;
	J0xEE:

	if(Less_IntInt(i, int(25)))
	{
		AvailableEquipmentPockets[i] = Class'SwatGame.SwatEquipmentSpec'.static.Allocate(self,, string(GetEnum(Enum'Engine.HandheldEquipment.Pocket', i))).;
		Construct_Void();
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0xEE;
	}
	AssertWithDescription(EqualEqual_IntInt(CustomEquipmentLoadoutFriendlyNames.Length, CustomEquipmentLoadouts.Length), "The number of Custom Loadouts does not match the number of Friendly Names specified in SwatGUIState.ini!");
	LoadLastMissionPlayed();
	i = 0;
	J0x1CB:

	if(Less_IntInt(i, MissionResultNames.Length))
	{
		MissionResults[i] = Class'SwatGame.MissionResults'.static.Allocate(self,, string(MissionResultNames[i])).;
		Construct_Void();
		assert(NotEqual_ObjectObject(MissionResults[i], none));
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x1CB;
	}
	i = 0;
	J0x232:

	if(Less_IntInt(i, int(4)))
	{
		MapList[i] = Class'SwatGame.MapRotation'.static.Allocate(self,, string(GetEnum(Enum'Engine.Repo.EMPMode', i))).;
		Construct_Void();
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x232;
	}
	return;
}

function SetCurrentMission(name MissionName, optional string FriendlyName, optional CustomScenario CustomScenario)
{
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[ckline] >>> SwatGUIConfig::SetCurrentMission('", string(MissionName)), "', '"), FriendlyName), "', '"), string(CustomScenario)), "')"));
	if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(CurrentMission, none), EqualEqual_NameName(CurrentMission.Name, MissionName)), EqualEqual_StrStr(CurrentMission.FriendlyName, FriendlyName)), EqualEqual_ObjectObject(CurrentMission.CustomScenario, CustomScenario)))
	{
		Log("[carlos] >>> SwatGUIConfig::SetCurrentMission() desired mission is already the current mission");
		return;
	}
	if(NotEqual_ObjectObject(CurrentMission, none))
	{
		CurrentMission.Release();
		CurrentMission = none;
	}
	if(EqualEqual_NameName(MissionName, 'None'))
	{
		Log("[ckline] >>> SwatGUIConfig::SetCurrentMission(): CurrentMission is now None");
		return;
	}
	CurrentMission = Class'SwatGame.SwatMission'.static.Allocate(self, none, string(MissionName)).;
	Construct_Void();
	assert(NotEqual_ObjectObject(CurrentMission, none));
	CurrentMission.AddRef();
	if(NotEqual_ObjectObject(CustomScenario, none))
	{
		SetScenarioName(FriendlyName);
	}
	CurrentMission.Initialize(FriendlyName, CustomScenario);
	CurrentMissionName = CurrentMission.Name;
	CurrentMissionFriendlyName = CurrentMission.FriendlyName;
	CurrentMissionCustomScenario = CurrentMission.CustomScenario;
	if(Less_IntInt(CurrentMission.EntryOptionTitle.Length, 2))
	{
		SetDesiredEntryPoint(0);
	}
	else
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(CustomScenario, none), CustomScenario.SpecifyStartPoint))
		{
			if(CustomScenario.UseSecondaryStartPoint)
			{
				SetDesiredEntryPoint(1);
			}
			else
			{
				SetDesiredEntryPoint(0);
			}
		}
	}
	Log(Concat_StrStr(Concat_StrStr("[ckline] >>> SwatGUIConfig::SetCurrentMission(): CurrentMission is now '", string(CurrentMission)), "'"));
	SetCurrentCommandInterfaceStyle(CommandInterfaceStyle);
	return;
}

function ResetCurrentMission()
{
	SetCurrentMission(CurrentMissionName, CurrentMissionFriendlyName, CurrentMissionCustomScenario);
	return;
}

function ClearCurrentMission()
{
	SetCurrentMission('None');
	return;
}

function LoadLastMissionPlayed()
{
	if(AndAnd_BoolBool(NotEqual_NameName(LastMissionPlayedName, 'None'), NotEqual_NameName(LastMissionPlayedName, 'SP-Training')))
	{
		SetCurrentMission(LastMissionPlayedName, LastMissionPlayedFriendlyName, LastMissionPlayedCustomScenario);
	}
	else
	{
		SetCurrentMission(MissionName[0], FriendlyName[0]);
	}
	AssertWithDescription(NotEqual_ObjectObject(CurrentMission, none), "Failed to load a CurrentMission on GuiConfig LoadLastMissionPlayed().  The InstantAction option may not be available.");
	return;
}

function SaveLastMissionPlayed()
{
	LastMissionPlayedName = CurrentMissionName;
	LastMissionPlayedFriendlyName = CurrentMissionFriendlyName;
	LastMissionPlayedCustomScenario = CurrentMissionCustomScenario;
	SaveConfig();
	return;
}

function string GetGameDescription(Repo.EMPMode Type)
{
	switch(Type)
	{
		case 0:
			return TDMDescription;
			break;
		case 1:
			return VIPDescription;
			break;
		case 2:
			return BombDescription;
			break;
		case 3:
			return COOPDescription;
			break;
		default:
			break;
	}
	return;
}

function string GetGameModeName(Repo.EMPMode Type)
{
	switch(Type)
	{
		case 0:
			return TDMFriendlyName;
			break;
		case 1:
			return VIPFriendlyName;
			break;
		case 2:
			return BombFriendlyName;
			break;
		case 3:
			return COOPFriendlyName;
			break;
		default:
			break;
	}
	return;
}

function string GetGameModeNameFromNonlocalizedString(string NonlocalizedString)
{
	if(EqualEqual_StrStr(NonlocalizedString, "Rapid Deployment"))
	{
		return BombFriendlyName;
	}
	else
	{
		if(EqualEqual_StrStr(NonlocalizedString, "VIP Escort"))
		{
			return VIPFriendlyName;
		}
		else
		{
			if(EqualEqual_StrStr(NonlocalizedString, "CO-OP"))
			{
				return COOPFriendlyName;
			}
			else
			{
				return TDMFriendlyName;
			}
		}
	}
	return;
}

function string GetDifficultyString(SwatGUIConfig.eDifficultyLevel Difficulty)
{
	return DifficultyString[int(Difficulty)];
	return;
}

final function MissionEnded(name Mission, SwatGUIConfig.eDifficultyLevel Difficulty, bool Completed, int Score)
{
	local int Index;

	Index = GetMissionIndex(Mission);
	if(GreaterEqual_IntInt(Index, MissionResults.Length))
	{
		MissionResults[Index] = Class'SwatGame.MissionResults'.static.Allocate(self,, string(Mission)).;
		Construct_Void();
		MissionResultNames[Index] = Mission;
	}
	assert(NotEqual_ObjectObject(MissionResults[Index], none));
	MissionResults[Index].AddResult(Difficulty, Completed, Score);
	SaveConfig();
	return;
}

final function MissionResults GetMissionResults(name Mission)
{
	local int Index;

	Index = GetMissionIndex(Mission);
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("[dkaplan] getting mission results for mission ", string(Mission)), ", index = "), string(Index)));
	return MissionResults[Index];
	return;
}

private function int GetMissionIndex(name Mission)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, MissionResults.Length))
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(MissionResults[i], none), EqualEqual_NameName(MissionResultNames[i], Mission)))
		{
			// [Explicit Break]
			goto J0x4C;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	J0x4C:

	return i;
	return;
}

function name GetCurrentMissionName()
{
	return CurrentMissionName;
	return;
}

function SetCustomScenarioPackData(CustomScenarioPack Pak, optional string pakN, optional string pakFN, optional string pakExt)
{
	CurrentCustomScenarioPack = Pak;
	PakName = pakN;
	PakFriendlyName = pakFN;
	PakExtension = pakExt;
	return;
}

function CustomScenarioPack GetCustomScenarioPack()
{
	return CurrentCustomScenarioPack;
	return;
}

function string GetPakName()
{
	return PakName;
	return;
}

function SetScenarioName(string inScenarioName)
{
	ScenarioName = inScenarioName;
	return;
}

function string GetScenarioName()
{
	return ScenarioName;
	return;
}

function string GetPakFriendlyName()
{
	return PakFriendlyName;
	return;
}

function string GetPakExtension()
{
	return PakExtension;
	return;
}

function SetCurrentCommandInterfaceStyle(SwatGUIConfig.ECommandInterfaceStyle Style)
{
	if(OrOr_BoolBool(EqualEqual_ObjectObject(CurrentMission, none), NotEqual_NameName(CurrentMission.Name, 'SP-Training')))
	{
		CurrentCommandInterfaceStyle = Style;
	}
	else
	{
		CurrentCommandInterfaceStyle = 2;
	}
	return;
}

final function SetDesiredEntryPoint(SwatStartPointBase.EEntryType EntrySet)
{
	DesiredSPEntryPoint = EntrySet;
	if(EqualEqual_IntInt(int(EntrySet), int(0)))
	{
		Log("Desired entry point was set to PRIMARY");
	}
	else
	{
		Log("Desired entry point was set to SECONDARY");
	}
	return;
}

final function SwatStartPointBase.EEntryType GetDesiredEntryPoint()
{
	return DesiredSPEntryPoint;
	return;
}

final function name GetTagForVoiceType(SwatGUIConfig.eVoiceType Type)
{
	switch(Type)
	{
		case 6:
			return 'VIP';
		case 1:
			return 'Lead';
		case 2:
			return 'OfficerRedOne';
		case 3:
			return 'OfficerRedTwo';
		case 4:
			return 'OfficerBlueOne';
		case 5:
			return 'OfficerBlueTwo';
		default:
			return 'None';
			break;
	}
	return;
}

final function SwatGUIConfig.eVoiceType GetVoiceTypeForCurrentPlayer()
{
	if(EqualEqual_IntInt(int(PreferredVoiceType), int(0)))
	{
		return byte(Add_IntInt(Rand(Subtract_IntInt(int(7), 2)), 1));
	}
	return PreferredVoiceType;
	return;
}

defaultproperties
{
	DifficultyString[0]="Easy"
	DifficultyString[1]="Normal"
	DifficultyString[2]="Hard"
	DifficultyString[3]="Elite"
	DifficultyScoreRequirement[1]=50
	DifficultyScoreRequirement[2]=75
	DifficultyScoreRequirement[3]=95
	CurrentDifficulty=1
	MissionName[0]="SP-FoodWall"
	MissionName[1]="SP-FairfaxResidence"
	MissionName[2]="SP-ConvenienceStore"
	MissionName[3]="SP-ABomb"
	MissionName[4]="SP-AutoGarage"
	MissionName[5]="SP-RedLibrary"
	MissionName[6]="SP-Casino"
	MissionName[7]="SP-JewelryHeist"
	MissionName[8]="SP-Tenement"
	MissionName[9]="SP-Hospital"
	MissionName[10]="SP-ArmsDeal"
	MissionName[11]="SP-Hotel"
	MissionName[12]="SP-DNA"
	FriendlyName[0]="Food Wall Restaurant"
	FriendlyName[1]="Fairfax Residence"
	FriendlyName[2]="Qwik Fuel Convenience Store"
	FriendlyName[3]="A-Bomb Nightclub"
	FriendlyName[4]="Victory Imports Auto Center"
	FriendlyName[5]="Red Library Offices"
	FriendlyName[6]="Northside Vending and Amusements"
	FriendlyName[7]="DuPlessis Wholesale Diamond Center"
	FriendlyName[8]="Children of Taronne Tenement"
	FriendlyName[9]="St. Michael's Medical Center"
	FriendlyName[10]="The Wolcott Projects"
	FriendlyName[11]="Old Granite Hotel"
	FriendlyName[12]="Mt. Threshold Research Center"
	LastMissionPlayedName="SP-Training"
	LastMissionPlayedFriendlyName="Training"
	CustomEquipmentLoadouts[0]="Assaulter_JHP"
	CustomEquipmentLoadouts[1]="Assaulter_FMJ"
	CustomEquipmentLoadouts[2]="CQB_Specialist"
	CustomEquipmentLoadouts[3]="Breacher"
	CustomEquipmentLoadouts[4]="Scout"
	CustomEquipmentLoadouts[5]="Pacifier"
	CustomEquipmentLoadouts[6]="LessLethal"
	CustomEquipmentLoadoutFriendlyNames[0]="Assaulter (JHP)"
	CustomEquipmentLoadoutFriendlyNames[1]="Assaulter (FMJ)"
	CustomEquipmentLoadoutFriendlyNames[2]="CQB Specialist"
	CustomEquipmentLoadoutFriendlyNames[3]="Breacher"
	CustomEquipmentLoadoutFriendlyNames[4]="Scout"
	CustomEquipmentLoadoutFriendlyNames[5]="Pacifier"
	CustomEquipmentLoadoutFriendlyNames[6]="Less Lethal Specialist"
	LoadoutIsUndeletable[0]=true
	LoadoutIsUndeletable[1]=true
	LoadoutIsUndeletable[2]=true
	LoadoutIsUndeletable[3]=true
	LoadoutIsUndeletable[4]=true
	LoadoutIsUndeletable[5]=true
	LoadoutIsUndeletable[6]=true
	CommandString[0]="CommandOrEquip Row_FunctionKeys 1"
	CommandString[1]="CommandOrEquip Row_FunctionKeys 2"
	CommandString[2]="CommandOrEquip Row_FunctionKeys 3"
	CommandString[3]="CommandOrEquip Row_FunctionKeys 4"
	CommandString[4]="CommandOrEquip Row_FunctionKeys 5"
	CommandString[5]="CommandOrEquip Row_FunctionKeys 6"
	CommandString[6]="CommandOrEquip Row_FunctionKeys 7"
	CommandString[7]="CommandOrEquip Row_FunctionKeys 8"
	CommandString[8]="CommandOrEquip Row_FunctionKeys 9"
	CommandString[9]="CommandOrEquip Row_FunctionKeys 10"
	CommandString[10]="CommandOrEquip Row_NumberKeys 1"
	CommandString[11]="CommandOrEquip Row_NumberKeys 2"
	CommandString[12]="CommandOrEquip Row_NumberKeys 3"
	CommandString[13]="CommandOrEquip Row_NumberKeys 4"
	CommandString[14]="CommandOrEquip Row_NumberKeys 5"
	CommandString[15]="CommandOrEquip Row_NumberKeys 6"
	CommandString[16]="CommandOrEquip Row_NumberKeys 7"
	CommandString[17]="CommandOrEquip Row_NumberKeys 8"
	CommandString[18]="CommandOrEquip Row_NumberKeys 9"
	CommandString[19]="CommandOrEquip Row_NumberKeys 10"
	CommandString[20]="PlayerCommandInterfaceBack"
	CommandString[21]="Dash"
	CommandString[22]="GUICloseMenu"
	CommandString[23]="Fire"
	CommandString[24]="Reload"
	CommandString[25]="EquipSlot 11"
	CommandString[26]="NextFireMode"
	CommandString[27]="ToggleZoom"
	CommandString[28]="ToggleFlashlight"
	CommandString[29]="IssueComplianceOrInteract"
	CommandString[30]="CommandInterfaceNextGroup"
	CommandString[31]="ShowViewport Red"
	CommandString[32]="ShowViewport Blue"
	CommandString[33]="ShowViewport Sniper"
	CommandString[34]="HideViewport"
	CommandString[35]="ControlViewportAlias"
	CommandString[36]="ShowInGamePopup"
	CommandString[37]="OpenGraphicCommandInterface | RightMouseAlias"
	CommandString[38]="GiveDefaultCommand"
	CommandString[39]="EquipNextSlot"
	CommandString[40]="EquipPrevSlot"
	CommandString[41]="ScrollCommand Up"
	CommandString[42]="ScrollCommand Down"
	CommandString[43]="MoveForward"
	CommandString[44]="MoveBackward"
	CommandString[45]="StrafeLeft"
	CommandString[46]="StrafeRight"
	CommandString[47]="LeanLeft"
	CommandString[48]="LeanRight"
	CommandString[49]="Running"
	CommandString[50]="Duck"
	CommandString[51]="ToggleRunning 0"
	CommandString[52]="ToggleCrouching 0"
	CommandString[53]="OpenHudChat 1"
	CommandString[54]="OpenHudChat 0"
	CommandString[55]="ScrollChatUp"
	CommandString[56]="ScrollChatDown"
	CommandString[57]="ScrollChatPageUp"
	CommandString[58]="ScrollChatPageDown"
	CommandString[59]="ScrollChatToHome"
	CommandString[60]="ScrollChatToEnd"
	LocalizedCommandString[0]="Classic: Primary Weapon"
	LocalizedCommandString[1]="Classic: Secondary Weapon"
	LocalizedCommandString[2]="Classic: Flashbang Grenade"
	LocalizedCommandString[3]="Classic: CS Gas Grenade"
	LocalizedCommandString[4]="Classic: Sting Grenade"
	LocalizedCommandString[5]="Classic: Pepper Spray"
	LocalizedCommandString[6]="Classic: Breaching"
	LocalizedCommandString[7]="Classic: Toolkit"
	LocalizedCommandString[8]="Classic: Optiwand"
	LocalizedCommandString[9]="Classic: Wedge"
	LocalizedCommandString[10]="Graphic: Primary Weapon"
	LocalizedCommandString[11]="Graphic: Secondary Weapon"
	LocalizedCommandString[12]="Graphic: Flashbang Grenade"
	LocalizedCommandString[13]="Graphic: CS Gas Grenade"
	LocalizedCommandString[14]="Graphic: Sting Grenade"
	LocalizedCommandString[15]="Graphic: Pepper Spray"
	LocalizedCommandString[16]="Graphic: Breaching"
	LocalizedCommandString[17]="Graphic: Toolkit"
	LocalizedCommandString[18]="Graphic: Optiwand"
	LocalizedCommandString[19]="Graphic: Wedge"
	LocalizedCommandString[20]="Classic: Back"
	LocalizedCommandString[21]="Classic: Deploy"
	LocalizedCommandString[22]="Open/Close Menus"
	LocalizedCommandString[23]="Fire"
	LocalizedCommandString[24]="Reload"
	LocalizedCommandString[25]="Equip Handcuffs"
	LocalizedCommandString[26]="Change Firing Mode"
	LocalizedCommandString[27]="Zoom"
	LocalizedCommandString[28]="Toggle Flashlight"
	LocalizedCommandString[29]="Use"
	LocalizedCommandString[30]="Change command group"
	LocalizedCommandString[31]="Toggle Red team Viewports"
	LocalizedCommandString[32]="Toggle Blue team Viewports"
	LocalizedCommandString[33]="Toggle Sniper Viewports"
	LocalizedCommandString[34]="Deactivate Viewports"
	LocalizedCommandString[35]="Control Viewports"
	LocalizedCommandString[36]="Display Objectives & Scores"
	LocalizedCommandString[37]="Open Graphic Command Interface"
	LocalizedCommandString[38]="Give Quick Command"
	LocalizedCommandString[39]="Equip Next Weapon"
	LocalizedCommandString[40]="Equip Previous Weapon"
	LocalizedCommandString[41]="Scroll Command Up"
	LocalizedCommandString[42]="Scroll Command Down"
	LocalizedCommandString[43]="Move Forward"
	LocalizedCommandString[44]="Move Backward"
	LocalizedCommandString[45]="Sidestep Left"
	LocalizedCommandString[46]="Sidestep Right"
	LocalizedCommandString[47]="Lean Left"
	LocalizedCommandString[48]="Lean Right"
	LocalizedCommandString[49]="Run/Walk"
	LocalizedCommandString[50]="Crouch"
	LocalizedCommandString[51]="Toggle Run/Walk"
	LocalizedCommandString[52]="Toggle Crouch"
	LocalizedCommandString[53]="Say"
	LocalizedCommandString[54]="Team Say"
	LocalizedCommandString[55]="Scroll Chat Up"
	LocalizedCommandString[56]="Scroll Chat Down"
	LocalizedCommandString[57]="Scroll Chat Page Up"
	LocalizedCommandString[58]="Scroll Chat Page Down"
	LocalizedCommandString[59]="Scroll Chat To Home"
	LocalizedCommandString[60]="Scroll Chat To End"
	CommandCategory[0]=3
	CommandCategory[1]=3
	CommandCategory[2]=3
	CommandCategory[3]=3
	CommandCategory[4]=3
	CommandCategory[5]=3
	CommandCategory[6]=3
	CommandCategory[7]=3
	CommandCategory[8]=3
	CommandCategory[9]=3
	CommandCategory[10]=3
	CommandCategory[11]=3
	CommandCategory[12]=3
	CommandCategory[13]=3
	CommandCategory[14]=3
	CommandCategory[15]=3
	CommandCategory[16]=3
	CommandCategory[17]=3
	CommandCategory[18]=3
	CommandCategory[19]=3
	CommandCategory[20]=3
	CommandCategory[21]=3
	CommandCategory[22]=3
	CommandCategory[23]=1
	CommandCategory[24]=1
	CommandCategory[25]=1
	CommandCategory[26]=1
	CommandCategory[27]=1
	CommandCategory[28]=1
	CommandCategory[29]=1
	CommandCategory[30]=2
	CommandCategory[31]=2
	CommandCategory[32]=2
	CommandCategory[33]=2
	CommandCategory[34]=2
	CommandCategory[35]=2
	CommandCategory[36]=1
	CommandCategory[37]=2
	CommandCategory[38]=2
	CommandCategory[39]=1
	CommandCategory[40]=1
	CommandCategory[41]=2
	CommandCategory[42]=2
	CommandCategory[43]=0
	CommandCategory[44]=0
	CommandCategory[45]=0
	CommandCategory[46]=0
	CommandCategory[47]=0
	CommandCategory[48]=0
	CommandCategory[49]=0
	CommandCategory[50]=0
	CommandCategory[51]=0
	CommandCategory[52]=0
	CommandCategory[53]=2
	CommandCategory[54]=2
	CommandCategory[55]=2
	CommandCategory[56]=2
	CommandCategory[57]=2
	CommandCategory[58]=2
	CommandCategory[59]=2
	CommandCategory[60]=2
	AudioVirtualizationChoices[0]="None"
	AudioVirtualizationChoices[1]="Low HRTF"
	AudioVirtualizationChoices[2]="High HRTF"
	SoundQualityChoices[0]="Low"
	SoundQualityChoices[1]="High"
	ScreenResolutionChoices[0]="800x600"
	ScreenResolutionChoices[1]="1024x768"
	ScreenResolutionChoices[2]="1280x1024"
	ScreenResolutionChoices[3]="1600x1200"
	TextureDetailChoices[0]="Low"
	TextureDetailChoices[1]="Medium"
	TextureDetailChoices[2]="High"
	OtherDetailChoices[0]="Off"
	OtherDetailChoices[1]="Low"
	OtherDetailChoices[2]="Medium"
	OtherDetailChoices[3]="High"
	RenderDetailChoices[0]="Custom"
	RenderDetailChoices[1]="Low"
	RenderDetailChoices[2]="Medium"
	RenderDetailChoices[3]="High"
	RenderDetailChoices[4]="Very High"
	PixelShaderChoices[0]="No"
	PixelShaderChoices[1]="Yes"
	RealtimeMirrorChoices[0]="No"
	RealtimeMirrorChoices[1]="Yes"
	VoiceTypeChoices[0]="Random"
	VoiceTypeChoices[1]="Lead"
	VoiceTypeChoices[2]="Reynolds"
	VoiceTypeChoices[3]="Girard"
	VoiceTypeChoices[4]="Fields"
	VoiceTypeChoices[5]="Jackson"
	NetworkConnectionChoices[0]="Modem"
	NetworkConnectionChoices[1]="ISDN"
	NetworkConnectionChoices[2]="Cable/ADSL"
	NetworkConnectionChoices[3]="LAN/T1"
	NetworkConnectionSpeeds[0]=2600
	NetworkConnectionSpeeds[1]=5000
	NetworkConnectionSpeeds[2]=10000
	NetworkConnectionSpeeds[3]=15000
	NetSpeedSelection=2
	MPPostMissionTime=9.0000000
	MPPollingDelay=0.2500000
	FirstTimeThrough=true
	SwatMapFileExtension=".s4m"
	SwatMPMapNamePrefix="MP"
	TDMDescription="The goal is to kill or arrest as many members of the opposite team as possible.  Kills are worth 1 point, arrests are worth 5 points.||The first team to reach the score limit wins.  If the time limit is reached, the team with the most points at the end of the round wins."
	VIPDescription="One player on the SWAT team is randomly chosen to be the VIP.  SWAT must escort the VIP to the escape point on the other side of the map.  The suspects must capture the VIP.  They must then hold him hostage for 2 minutes.  SWAT players can use the toolkit to release the VIP.  After the two minutes are up, the suspects must assassinate the VIP to win the game.||SWAT wins if the VIP escapes, or if the suspects kill the VIP before capturing and holding him."
	BombDescription="Three to five bombs are randomly spawned in the map.  SWAT must use the toolkit to defuse all of the bombs before the round ends.  The Suspects must defend the bombs and prevent them from being disabled.  Once all of the bombs are defused SWAT wins.  If the round timer expires while a bomb is still active, the Suspects win."
	COOPDescription="Play single player missions with a group of up to five officers."
	TDMFriendlyName="Barricaded Suspects"
	VIPFriendlyName="VIP Escort"
	BombFriendlyName="Rapid Deployment"
	COOPFriendlyName="CO-OP"
	MPSuspectsWinMessage="The Suspects have won the round!"
	MPSWATWinMessage="SWAT has won the round!"
	MPTieMessage="The game ended in a tie."
	MPName="Player"
	bShowHelp=true
	bAlwaysRun=true
	MPNameLength=30
	MPNameAllowableCharSet="abcdefghijklmnopqrstuvwxyz1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ()<>{}|_!^"
	CommandInterfaceStyle=2
	MessageDisplayTime=15
	GCIButtonMode=2
	bUseExitMenu=true
	theServerFilters=(MaxPing=-1,bFull=false,bPassworded=false,bFilterGametype=false,GameType=0,bHideIncompatibleVersions=false,bHideIncompatibleMods=false)
	CriticalMomentDelay=5.0000000
}