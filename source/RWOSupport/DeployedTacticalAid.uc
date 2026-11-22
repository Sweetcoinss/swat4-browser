class DeployedTacticalAid extends ReactiveStaticMesh
	native
	config(SwatGame)
	hidecategories(Karma,Force,LightColor,Lighting,Object,Sound);

cpptext
{
    // To ensure when deployed on a door the object is lit by lights
    // in neighboring zones (make the object bigger than it actually
    // is for lighting purposes)
    void PredictedBoxAdjustmentHook(FBox& PredictedBox);

}

// Export UDeployedTacticalAid::execIsDeployed(FFrame&, void* const)
native simulated event bool IsDeployed();

defaultproperties
{
	bHidden=true
	bNoDelete=false
	RemoteRole=1
	bCollideActors=false
	bUseCylinderCollision=true
	bBlockHavok=false
}