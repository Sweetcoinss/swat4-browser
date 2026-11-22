class DoorAttachment extends StaticMeshActor
	native
	config
	hidecategories(Karma,Force,LightColor,Lighting,Object,Sound);

cpptext
{
    void PredictedBoxAdjustmentHook(FBox& PredictedBox);

}

defaultproperties
{
	bStatic=false
	bStasis=true
	bWorldGeometry=false
	bStaticLighting=false
	bCollideActors=false
	bBlockActors=false
	bBlockPlayers=false
	bBlockKarma=false
	bBlockHavok=false
}