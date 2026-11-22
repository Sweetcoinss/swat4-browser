class AwarenessFactory extends Object;

static function AwarenessProxy CreateAwarenessForPawn(Pawn outerPawn)
{
	local array<Pawn> outerPawns;

	outerPawns[0] = outerPawn;
	return CreateAwarenessForMultiplePawns(outerPawns);
	return;
}

static function AwarenessProxy CreateAwarenessForMultiplePawns(array<Pawn> outerPawns)
{
	local AwarenessProxy AwarenessProxy;

	AwarenessProxy = Class'SwatAIAwareness.AwarenessProxy'.static.Allocate(self).;
	Construct_Void();
	AwarenessProxy.Init(outerPawns);
	return AwarenessProxy;
	return;
}
