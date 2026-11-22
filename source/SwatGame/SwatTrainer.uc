class SwatTrainer extends SwatAICharacter
	native
	config(SwatPawn)
	hidecategories(Karma);

cpptext
{
    virtual bool ShouldPlayerLowReadyWhenPointingAtMe(ASwatPlayer* Player);

}

event PostBeginPlay()
{
	super.PostBeginPlay();
	SetIdleCategory('Trainer');
	return;
}

simulated function Died(Controller Killer, Class<DamageType> DamageType, Vector HitLocation, Vector HitMomentum)
{
	SoundEffectsSubsystem(EffectsSystem(Owner.Level.EffectsSystem).GetSubsystem('SoundEffectsSubsystem')).StopMySchemas(self);
	super.Died(Killer, DamageType, HitLocation, HitMomentum);
	return;
}

function AnimationSetManager.EAnimationSet GetMovementAnimSet()
{
	return 19;
	return;
}

protected function ConstructCharacterAI()
{
	local AI_Resource characterResource;

	characterResource = AI_Resource(CharacterAI);
	assert(NotEqual_ObjectObject(characterResource, none));
	characterResource.addAbility(Class'SwatAICommon.TrainerCommanderAction'.static.Allocate(self)., Construct_Void());
	characterResource.addAbility(Class'SwatAICommon.CharacterSpeechManagerAction'.static.Allocate(self)., Construct_Void());
	super.ConstructCharacterAI();
	return;
}

protected function bool ShouldReactToNonLethals()
{
	return false;
	return;
}

private function AddIdleActions()
{
	return;
}

function bool ShouldPlayFullBodyHitAnimation()
{
	return false;
	return;
}

defaultproperties
{
	bCollisionAvoidanceEnabled=false
	Mesh=SkeletalMesh'SWATMaleAnimation.SWATinstructor'
	Skins=/* Array type was not detected. */
}