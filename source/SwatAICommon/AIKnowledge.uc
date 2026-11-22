class AIKnowledge extends Object implements IVisionNotification
	native
	noexport;

struct native KnowledgeAboutPawn
{
	var Vector Location;
	var bool bHasEverSeenPawn;
};

var private int m_knowledgeMap;
var private Pawn m_thisPawn;
var private VisionNotifier m_visionNotifier;

function Init(Pawn thisPawn, VisionNotifier VisionNotifier)
{
	assert(NotEqual_ObjectObject(thisPawn, none));
	assert(EqualEqual_ObjectObject(m_visionNotifier, none));
	m_thisPawn = thisPawn;
	if(NotEqual_ObjectObject(VisionNotifier, none))
	{
		m_visionNotifier = VisionNotifier;
		m_visionNotifier.RegisterVisionNotification(self);
	}
	return;
}

function Term()
{
	m_thisPawn = none;
	if(NotEqual_ObjectObject(m_visionNotifier, none))
	{
		m_visionNotifier.UnregisterVisionNotification(self);
		m_visionNotifier = none;
	}
	return;
}

// Export UAIKnowledge::execGetLastKnownKnowledgeAboutPawn(FFrame&, void* const)
native function bool GetLastKnownKnowledgeAboutPawn(Pawn otherPawn, out KnowledgeAboutPawn outKnowledge);

// Export UAIKnowledge::execHasKnownKnowledgeAboutPawn(FFrame&, void* const)
native function bool HasKnownKnowledgeAboutPawn(Pawn otherPawn);

// Export UAIKnowledge::execUpdateKnowledgeAboutPawn(FFrame&, void* const)
native function UpdateKnowledgeAboutPawn(Pawn otherPawn);

// Export UAIKnowledge::execOnViewerSawPawn(FFrame&, void* const)
native function OnViewerSawPawn(Pawn Viewer, Pawn Seen);

// Export UAIKnowledge::execOnViewerLostPawn(FFrame&, void* const)
native function OnViewerLostPawn(Pawn Viewer, Pawn Seen);
