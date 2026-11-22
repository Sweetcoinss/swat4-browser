class SwatMPStartPoint extends Actor
	native
	config
	notplaceable
	hidecategories(Karma);

cpptext
{
	virtual void CheckForErrors();
	virtual void PostEditChange();
	virtual void RenderEditorSelected(FLevelSceneNode* SceneNode,FRenderInterface* RI, FDynamicActor* FDA);
	virtual void FindBase();
	virtual UBOOL ShouldBeBased();

}

var editconst float LastSpawnCampTime;
var editconst SwatMPStartCluster Cluster "This is the start cluster with which this start point is associated";
var const bool bNotBased;

defaultproperties
{
	bHidden=true
	bNoDelete=true
	bStasis=true
	Texture=Texture'EditorSprites.SwatMPStartPoint'
	bCollideWhenPlacing=true
	CollisionRadius=24.0000000
	CollisionHeight=68.0000000
	bCollideActors=true
	bBlockZeroExtentTraces=false
	bDirectional=true
}