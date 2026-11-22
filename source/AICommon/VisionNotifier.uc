class VisionNotifier extends RefCount implements IInterestedPawnDied
	native
	noexport;

var Pawn Viewer;
var private const transient int SeenListPadding;
var private const transient int CurrentSeenListPadding;
var private const transient int NotificationListPadding;

function InitializeVisionNotifier(Pawn InViewer)
{
	assert(NotEqual_ObjectObject(InViewer, none));
	Viewer = InViewer;
	Viewer.Level.RegisterNotifyPawnDied(self);
	return;
}

function CleanupVisionNotifier()
{
	Viewer.Level.UnRegisterNotifyPawnDied(self);
	return;
}

function OnOtherActorDestroyed(Actor ActorBeingDestroyed)
{
	if(ActorBeingDestroyed.IsA('Pawn'))
	{
		RemoveAnyReferencesToPawn(Pawn(ActorBeingDestroyed));
	}
	return;
}

function OnOtherPawnDied(Pawn DeadPawn)
{
	RemoveAnyReferencesToPawn(DeadPawn);
	return;
}

// Export UVisionNotifier::execRemoveAnyReferencesToPawn(FFrame&, void* const)
protected native function RemoveAnyReferencesToPawn(Pawn PawnBeingRemoved);

function bool isVisible(Pawn TestPawn)
{
	return IsOnSeenList(TestPawn);
	return;
}

// Export UVisionNotifier::execIsOnCurrentSeenList(FFrame&, void* const)
protected native function bool IsOnCurrentSeenList(Pawn TestPawn);

// Export UVisionNotifier::execIsOnSeenList(FFrame&, void* const)
protected native function bool IsOnSeenList(Pawn TestPawn);

// Export UVisionNotifier::execRegisterVisionNotification(FFrame&, void* const)
native function RegisterVisionNotification(IVisionNotification Registrant);

// Export UVisionNotifier::execUnregisterVisionNotification(FFrame&, void* const)
native function UnregisterVisionNotification(IVisionNotification Registrant);

// Export UVisionNotifier::execlogSeenList(FFrame&, void* const)
native function logSeenList();
