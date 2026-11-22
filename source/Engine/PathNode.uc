class PathNode extends NavigationPoint
	native
	config
	placeable
	hidecategories(Karma,Lighting,LightColor,Karma,Force);

cpptext
{
	virtual UBOOL ReviewPath(APawn* Scout);
	virtual void CheckSymmetry(ANavigationPoint* Other);
	virtual INT AddMyMarker(AActor *S);

}

defaultproperties
{
	bPropagatesSound=true
	Texture=Texture'Engine_res.S_Pickup'
}