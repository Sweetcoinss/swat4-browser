class ReplicationInfo extends Info
	abstract
	native
	config
	notplaceable
	hidecategories(Karma,Movement,Collision,Lighting,LightColor,Karma,Force);

cpptext
{
	INT* GetOptimizedRepList( BYTE* Recent, FPropertyRetirement* Retire, INT* Ptr, UPackageMap* Map, UActorChannel* Channel );

}

defaultproperties
{
	bAlwaysRelevant=true
	RemoteRole=2
}