class Repo extends Object
	transient
	native;

enum EMPMode
{
	MPM_BarricadedSuspects,         // 0
	MPM_VIPEscort,                  // 1
	MPM_RapidDeployment,            // 2
	MPM_COOP                        // 3
};

var LevelInfo Level;
var BaseGUIController GUIController;
var bool InitAsListenServer;
var bool InitAsDedicatedServer;
var bool InitWithoutIntroMenu;
var string SplashSceneMapName "Name of the map to load behind the GUI";
var float MPTimeOut "Time (in seconds) to wait before declaring a timeout";
var float MomentumImpartedOnPenetrationFraction;
var float MomentumToDamageConversionFactor;

function bool IsLANOnlyGame()
{
	return;
}

function Initialize()
{
	return;
}

event PreLevelChange(Player thePlayer, string MapName)
{
	return;
}

event PostLevelChange(Player thePlayer, string MapName)
{
	return;
}

event OnDisconnected()
{
	return;
}

event Tick(float DeltaSeconds)
{
	return;
}

function float GetExternalDamageModifier(Actor Damager, Actor Victim)
{
	return 1.0000000;
	return;
}

event PreBeginPlay()
{
	return;
}

event PostBeginPlay()
{
	return;
}

event PostGameEngineInit()
{
	return;
}

event bool ShouldShowSubtitles()
{
	return;
}

defaultproperties
{
	SplashSceneMapName="swat_splashscene"
	MPTimeOut=120.0000000
	MomentumImpartedOnPenetrationFraction=0.5000000
	MomentumToDamageConversionFactor=0.1000000
}