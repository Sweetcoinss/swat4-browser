class AICoverFinder extends Object
	native;

enum EShowCoverInfoDetail
{
	kSCID_PlaneAndExtrusionIntersection,// 0
	kSCID_IndividualExtrusions,     // 1
	kSCID_IndividualInverseExtrusions// 2
};

enum EAICoverLocationType
{
	kAICLT_NearestSide,             // 0
	kAICLT_NearestFront,            // 1
	kAICLT_NearFrontCorner,         // 2
	kAICLT_FarFrontCorner           // 3
};

enum EAICoverLocationInfo
{
	kAICLI_NotInCover,              // 0
	kAICLI_InLowCover,              // 1
	kAICLI_InCover                  // 2
};

enum EAICoverLocationSide
{
	kAICLS_NotApplicable,           // 0
	kAICLS_Left,                    // 1
	kAICLS_Right                    // 2
};

struct native AICoverResult
{
	var AICoverFinder.EAICoverLocationInfo coverLocationInfo;
	var Actor coverActor;
	var Vector coverLocation;
	var AICoverFinder.EAICoverLocationSide coverSide;
	var int coverYaw;
};

var private Pawn m_pawn;

// Export UAICoverFinder::execIsCoverAvailable(FFrame&, void* const)
native function bool IsCoverAvailable();

// Export UAICoverFinder::execFindCover(FFrame&, void* const)
native function AICoverResult FindCover(array<Pawn> otherPawns, AICoverFinder.EAICoverLocationType locationType);

// Export UAICoverFinder::execFindCoverBehindActor(FFrame&, void* const)
native function AICoverResult FindCoverBehindActor(array<Pawn> otherPawns, Actor coverActor, AICoverFinder.EAICoverLocationType locationType);

// Export UAICoverFinder::execIsLocationInCover(FFrame&, void* const)
native function AICoverResult IsLocationInCover(array<Pawn> otherPawns, Vector Location);

// Export UAICoverFinder::execIsLocationInCoverBehindActor(FFrame&, void* const)
native function AICoverResult IsLocationInCoverBehindActor(array<Pawn> otherPawns, Actor coverActor, Vector Location);

overloaded function Construct(Pawn Pawn)
{
	m_pawn = Pawn;
	assert(NotEqual_ObjectObject(m_pawn, none));
	return;
}

function Pawn GetOuterPawn()
{
	return m_pawn;
	return;
}
