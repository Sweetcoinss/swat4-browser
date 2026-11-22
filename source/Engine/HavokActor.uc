class HavokActor extends Actor
	native
	config(SwatGame)
	placeable
	hidecategories(Karma);

cpptext
{
#ifdef UNREAL_HAVOK
	virtual void Spawned();
#endif

}

var(Havok) bool bAcceptsShotImpulse "If true, an impulse will be imparted to this object when it takes damage";
var config float MomentumToHavokImpulseConversionFactor;
var(Ballistics) private float OverrideMomentumToPenetrate "If this is > -1, then OverrideMomentumToPenetrate is used instead of its Material's MomentumToPenetrate when calculating impact ballistics.";
var(Ballistics) private config float MaxImpulseToMassRatio "If this object receives a ballistic impact, the magnitude of the applied impulse will be capped such that Magnitude(Impulse)/hkMassOfThisObject) is less than this value";

simulated function float GetMomentumToPenetrate(Vector HitLocation, Vector HitNormal, Material MaterialHit)
{
	if(LessEqual_FloatFloat(OverrideMomentumToPenetrate, float(-1)))
	{
		return MaterialHit.MomentumToPenetrate;
	}
	else
	{
		return OverrideMomentumToPenetrate;
	}
	return;
}

simulated event TakeHitImpulse(Vector HitLocation, Vector Momentum, Class<DamageType> DamageType)
{
	local Vector impulseDir;
	local float impulseMag;
	local HavokRigidBody rb;

	if(bAcceptsShotImpulse)
	{
		impulseDir = Normal(Momentum);
		impulseMag = VSize(Momentum);
		if(Less_FloatFloat(impulseMag, 0.0010000))
		{
			return;
		}
		MultiplyEqual_FloatFloat(impulseMag, MomentumToHavokImpulseConversionFactor);
		rb = HavokRigidBody(HavokData);
		if(Level.AnalyzeBallistics)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[BALLISTICS] The HavokActor (HavokIsActive=", string(HavokIsActive())), ") named "), string(Name)), " took a shot from a gun:"));
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("   Momentum magnitude = ", string(VSize(Momentum))), ", direction = "), string(Normal(Momentum))));
			Log(Concat_StrStr("   MomentumToHavokImpulseConversionFactor = ", string(MomentumToHavokImpulseConversionFactor)));
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("   Converted impulse mag = ", string(VSize(Momentum))), " * "), string(MomentumToHavokImpulseConversionFactor)), " = "), string(impulseMag)));
			if(NotEqual_ObjectObject(rb, none))
			{
				Log(Concat_StrStr("     Mass of actor =", string(rb.hkMass)));
				Log(Concat_StrStr("     Impulse/Mass  =", string(Divide_FloatFloat(impulseMag, rb.hkMass))));
				Log(Concat_StrStr("     MaxImpulseToMassRatio  =", string(MaxImpulseToMassRatio)));
			}
		}
		if(AndAnd_BoolBool(Greater_FloatFloat(Divide_FloatFloat(impulseMag, rb.hkMass), MaxImpulseToMassRatio), NotEqual_ObjectObject(rb, none)))
		{
			impulseMag = Multiply_FloatFloat(MaxImpulseToMassRatio, rb.hkMass);
			if(Level.AnalyzeBallistics)
			{
				Log(Concat_StrStr("     After clamping to ", string(MaxImpulseToMassRatio)));
				Log(Concat_StrStr("       -> Impulse mag  = ", string(impulseMag)));
				Log(Concat_StrStr("       -> Impulse/Mass = ", string(Divide_FloatFloat(impulseMag, rb.hkMass))));
			}
		}
		if(Level.AnalyzeBallistics)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("   Velocity of actor prior to impulse:  Linear = ", string(VSize(HavokGetLinearVelocity()))), ", Angular = "), string(VSize(HavokGetAngularVelocity()))));
		}
		HavokImpartImpulse(Multiply_FloatVector(impulseMag, impulseDir), HitLocation);
		if(Level.AnalyzeBallistics)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("   Velocity of actor after the impulse: Linear = ", string(VSize(HavokGetLinearVelocity()))), ", Angular = "), string(VSize(HavokGetAngularVelocity()))));
		}
	}
	return;
}

simulated function Trigger(Actor Other, Pawn EventInstigator)
{
	HavokActivate();
	return;
}

defaultproperties
{
	bAcceptsShotImpulse=true
	MomentumToHavokImpulseConversionFactor=2.0000000
	OverrideMomentumToPenetrate=-1.0000000
	MaxImpulseToMassRatio=100.0000000
	Physics=15
	DrawType=8
	bNoDelete=true
	bStasis=true
	bAlwaysRelevant=true
	RemoteRole=0
	Texture=Texture'Engine_res.Havok.S_HkActor'
	CollisionRadius=1.0000000
	CollisionHeight=1.0000000
	bCollideActors=true
	bBlockActors=true
	bBlockPlayers=true
	bProjTarget=true
	bBlockKarma=true
	bBlockHavok=true
	bEdShouldSnap=true
}