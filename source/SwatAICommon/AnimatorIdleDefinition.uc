class AnimatorIdleDefinition extends IdleDefinition within IdleActionsList
	config
	perobjectconfig;

var config name AnimationName;
var config float AnimationTweenTime;
var config int MinNumberOfTimesToPlay;
var config int MaxNumberOfTimesToPlay;

function int GetRandomNumberOfTimeToPlay()
{
	return int(RandRange(float(MinNumberOfTimesToPlay), float(MaxNumberOfTimesToPlay)));
	return;
}

defaultproperties
{
	AnimationTweenTime=0.2000000
	MinNumberOfTimesToPlay=1
	MaxNumberOfTimesToPlay=1
}