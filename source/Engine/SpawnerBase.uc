class SpawnerBase extends Actor
	abstract
	native
	config
	notplaceable
	hidecategories(Karma);

cpptext
{
	virtual void BuildDebugPatrolInfo(APawn* pScout) {}

}
