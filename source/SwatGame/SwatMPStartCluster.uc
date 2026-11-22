class SwatMPStartCluster extends Actor
	native
	config
	placeable
	hidecategories(Karma);

cpptext
{
	virtual void CheckForErrors();
    virtual void PostEditAdd(GroupFactory& Grouper);
	virtual void UpdateIcons();
	virtual void PostEditChange();
	virtual void PostEditLoad();

}

var(StartCluster) SwatGameInfo.EMPTeam ClusterTeam "In multiplayer games, defines the team that may spawn at this cluster";
var(StartCluster) bool UseInBarricadedSuspects "Set to true if this start cluster can be used in the Barricaded Suspects game mode";
var(StartCluster) bool UseInVIPEscort "Set to true if this start cluster can be used in the VIP Escort game mode";
var(StartCluster) bool UseInRapidDeployment "Set to true if this start cluster can be used in the Rapid Deploymentgame mode";
var(StartCluster) bool NeverFirstSpawnInBSRound "If true, this cluster should not be used for the first spawn of a Barricaded Suspects round.";
var(StartCluster) bool NeverFirstSpawnInVIPRound "If true, this cluster should not be used for the first spawn of a VIP Escort round.";
var(StartCluster) bool NeverFirstSpawnInRDRound "If true, this cluster should not be used for the first spawn of a Rapid Deployment round.";
var(StartCluster) bool IsPrimaryEntryPoint "If true, this cluster can be used for primary spawns in COOP mode.";
var(StartCluster) bool IsSecondaryEntryPoint "If true, this cluster can be used for secondary spawns in COOP mode.";
var bool IsEnabled "If true, this spawn cluster is currently enabled.";
var int NumberOfStartPoints;
var const SwatMPStartPoint StartPoints[16];
var private string MPStartPointIconNamePrefix;
var private string MPStartClusterIconNamePrefix;

defaultproperties
{
	UseInBarricadedSuspects=true
	UseInVIPEscort=true
	UseInRapidDeployment=true
	IsEnabled=true
	NumberOfStartPoints=16
	MPStartPointIconNamePrefix="EditorSprites.MPSpawnCluster_Start"
	MPStartClusterIconNamePrefix="EditorSprites.SwatMPStartCluster"
	bStatic=true
	bHidden=true
	bNoDelete=true
	Texture=Texture'EditorSprites.SwatMPStartCluster'
	bCollideWhenPlacing=true
	CollisionRadius=30.0000000
	CollisionHeight=80.0000000
	bCollideActors=true
}