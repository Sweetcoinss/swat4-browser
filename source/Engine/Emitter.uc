class Emitter extends Actor
	native
	config
	placeable
	hidecategories(Karma);

var export editinline array<export editinline ParticleEmitter> Emitters;
var(Global) bool AutoDestroy;
var(Global) bool AutoReset;
var(Global) bool DisableFogging;
var(Global) bool RotationAndVelocityFromOwner;
var(Global) RangeVector GlobalOffsetRange;
var(Global) Range TimeTillResetRange;
var transient int Initialized;
var transient Box BoundingBox;
var transient float EmitterRadius;
var transient float EmitterHeight;
var transient bool ActorForcesEnabled;
var transient Vector GlobalOffset;
var transient float TimeTillReset;
var transient bool UseParticleProjectors;
var transient ParticleMaterial ParticleMaterial;
var transient bool DeleteParticleEmitters;
var bool bPlaying;
var bool bStoppedOverTime;

event PlayEmitters()
{
	local byte i;

	if(Not_PreBool(bPlaying))
	{
		i = 0;
		J0x13:

		if(Less_IntInt(int(i), Emitters.Length))
		{
			if(bStoppedOverTime)
			{
				Emitters[int(i)].RespawnDeadParticles = true;
				Emitters[int(i)].KillPending = 0;
			}
			Emitters[int(i)].Disabled = false;
			Emitters[int(i)].ResetParticles();
			AddAdd_PreByte(i);
			// [Loop Continue]
			goto J0x13;
		}
		bStoppedOverTime = false;
		bPlaying = true;
	}
	return;
}

event StopEmitters(optional bool bStopOverTime)
{
	local byte i;

	if(bPlaying)
	{
		i = 0;
		J0x11:

		if(Less_IntInt(int(i), Emitters.Length))
		{
			if(bStopOverTime)
			{
				Emitters[int(i)].RespawnDeadParticles = false;
				Emitters[int(i)].KillPending = 1;
				bStoppedOverTime = true;
				// [Explicit Continue]
				goto J0x81;
			}
			Emitters[int(i)].Disabled = true;
			J0x81:

			AddAdd_PreByte(i);
			// [Loop Continue]
			goto J0x11;
		}
		bPlaying = false;
	}
	return;
}

// Export UEmitter::execKill(FFrame&, void* const)
native function Kill();

simulated function UpdatePrecacheRenderData()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Emitters.Length))
	{
		if(NotEqual_ObjectObject(Emitters[i], none))
		{
			if(NotEqual_ObjectObject(Emitters[i].Texture, none))
			{
				Level.AddPrecacheMaterial(Emitters[i].Texture);
			}
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

event Trigger(Actor Other, Pawn EventInstigator)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Emitters.Length))
	{
		if(NotEqual_ObjectObject(Emitters[i], none))
		{
			Emitters[i].Trigger();
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

event PreAutoDestroyed()
{
	if(bNeedLifetimeEffectEvents)
	{
		UnTriggerEffectEvent('Alive');
		TriggerEffectEvent('Destroyed');
	}
	return;
}

defaultproperties
{
	bPlaying=true
	DrawType=10
	bNoDelete=true
	RemoteRole=0
	Texture=Texture'Engine_res.S_Emitter'
	Style=8
	bUnlit=true
}