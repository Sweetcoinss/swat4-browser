class ClearRoutePoint extends PathNode
	native
	config
	hidecategories(Karma,Lighting,LightColor,Karma,Force);

cpptext
{
	virtual void CheckForErrors();
	virtual void RenderEditorSelected(FLevelSceneNode* SceneNode,FRenderInterface* RI, FDynamicActor* FDA);

}

var edfindable ClearPoint ClearPoint "The ClearPoint we are associated with";
var int ClearRoutePriority "The priority of our point out of all ClearRoutePoints to our ClearPoint";

defaultproperties
{
	Texture=Texture'SWAT4editorTex.ClearRoutePoint'
}