class EffectSpecification extends Object
	abstract
	native
	config;

var config bool Precache;
var config bool AttachToSource;
var config name AttachmentBone;
var config Vector LocationOffset;
var config Rotator RotationOffset;
var transient Level Level;

simulated function Init(EffectsSubsystem EffectsSubsystem)
{
	return;
}
