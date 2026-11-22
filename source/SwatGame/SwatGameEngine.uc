class SwatGameEngine extends GameEngine implements IInterestedActorDestroyed
	transient
	native
	config;

// Export USwatGameEngine::execOnOtherActorDestroyed(FFrame&, void* const)
native function OnOtherActorDestroyed(Actor ActorBeingDestroyed);
