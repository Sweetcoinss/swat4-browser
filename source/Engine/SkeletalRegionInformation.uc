class SkeletalRegionInformation extends Object
	config(SkeletalRegionInformation)
	perobjectconfig;

var config Range DamageModifier;
var config Range AimErrorPenalty;
var config Range LimpModifier;
var config float MomentumToPenetrate;

defaultproperties
{
	DamageModifier=(Min=1.0000000,Max=1.0000000)
	AimErrorPenalty=(Min=1.0000000,Max=1.0000000)
	LimpModifier=(Min=1.0000000,Max=1.0000000)
	MomentumToPenetrate=100.0000000
}