class AwarenessProxy extends Object implements IVisionNotification, IHearingNotification, IInterestedActorDestroyed, IInterestedPawnDied
	native
	noexport;

struct native AwarenessKnowledge
{
	var AwarenessPoint aboutAwarenessPoint;
	var float Confidence;
	var float threat;
};

var private int m_implPadding;

// Export UAwarenessProxy::execInit(FFrame&, void* const)
native function Init(array<Pawn> outerPawns);

// Export UAwarenessProxy::execTerm(FFrame&, void* const)
native function Term();

// Export UAwarenessProxy::execForceViewerSawPawn(FFrame&, void* const)
native function ForceViewerSawPawn(Pawn Viewer, Pawn Seen);

// Export UAwarenessProxy::execGetKnowledge(FFrame&, void* const)
native function AwarenessKnowledge GetKnowledge(AwarenessPoint aboutAwarenessPoint);

// Export UAwarenessProxy::execGetPotentiallyVisibleKnowledge(FFrame&, void* const)
native function array<AwarenessKnowledge> GetPotentiallyVisibleKnowledge(optional Pawn visibilityFromPawn);

// Export UAwarenessProxy::execGetVisibleKnowledge(FFrame&, void* const)
native function array<AwarenessKnowledge> GetVisibleKnowledge(optional Pawn visibilityFromPawn);

// Export UAwarenessProxy::execDrawDebugInfo(FFrame&, void* const)
native function DrawDebugInfo(HUD HUD);

// Export UAwarenessProxy::execOnViewerSawPawn(FFrame&, void* const)
native function OnViewerSawPawn(Pawn Viewer, Pawn Seen);

// Export UAwarenessProxy::execOnViewerLostPawn(FFrame&, void* const)
native function OnViewerLostPawn(Pawn Viewer, Pawn Seen);

// Export UAwarenessProxy::execOnListenerHeardNoise(FFrame&, void* const)
native function OnListenerHeardNoise(Pawn Listener, Actor SoundMaker, Vector SoundOrigin, name SoundCategory);

// Export UAwarenessProxy::execOnOtherActorDestroyed(FFrame&, void* const)
native function OnOtherActorDestroyed(Actor ActorBeingDestroyed);

// Export UAwarenessProxy::execOnOtherPawnDied(FFrame&, void* const)
native function OnOtherPawnDied(Pawn DeadPawn);
