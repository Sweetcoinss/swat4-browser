class Reaction_KillAllMySounds extends Reaction
	editinlinenew
	collapsecategories
	hidecategories(Object);

protected simulated function execute(Actor Owner, Actor Other)
{
	SoundEffectsSubsystem(EffectsSystem(Owner.Level.EffectsSystem).GetSubsystem('SoundEffectsSubsystem')).StopMySchemas(Owner);
	return;
}
