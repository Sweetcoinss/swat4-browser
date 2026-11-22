class DeployedC2ChargeBase extends DeployedTacticalAid implements IAmUsedByToolkit, ICanBeDisabled, IDeployedC2Charge
	config(SwatEquipment)
	hidecategories(Karma,Force,LightColor,Lighting,Object,Sound);

var(C2Charge) StaticMesh PreviewStaticMesh;
var config float QualifyTimeForToolkit;
var config float Damage;
var config float DamageAngle;
var config float DamageRadius;
var config float StunAngle;
var config float StunRadius;
var config float StunDuration;
var config bool DebugBlast;
var private SwatDoor AssociatedDoor;
var private SwatPawn DeployedBy;
var Rotator BackwardVectorOffset;
var array<Pawn> Victims;

replication
{
	// Pos:0x000
	reliable if(EqualEqual_IntInt(int(Role), int(ROLE_Authority)))
		AssociatedDoor;
}

function SetAssociatedDoor(SwatDoor inAssociatedDoor)
{
	AssociatedDoor = inAssociatedDoor;
	return;
}

simulated function ISwatDoor GetDoorDeployedOn()
{
	if(IsDeployed())
	{
		return AssociatedDoor;
	}
	return none;
	return;
}

simulated function OnDeployed(SwatPawn inDeployedBy)
{
	SetCollision(true, false, false);
	Show();
	DeployedBy = inDeployedBy;
	return;
}

simulated function OnDetonated()
{
	MPLog(Concat_StrStr(string(self), "---DeployedC2ChargeBase::OnDetonated()."));
	AssertWithDescription(NotEqual_ObjectObject(AssociatedDoor, none), "[tcohen] DeployedC2ChargeBase::OnDetonated() AssociatedDoor=None");
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		AssertWithDescription(NotEqual_ObjectObject(DeployedBy, none), "[tcohen] DeployedC2ChargeBase::OnDetonated() DeployedBy=None");
	}
	TriggerEffectEvent('Detonated', AssociatedDoor, AssociatedDoor.GetCurrentMaterial(0));
	ICanUseC2Charge(DeployedBy).SetDeployedC2Charge(none);
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		AssociatedDoor.Breached(self);
		AffectVictims();
		Hide();
	}
	return;
}

function AffectVictims()
{
	local IReactToC2Detonation Victim;
	local Actor VictimActor;
	local Rotator AffectDirection;
	local Vector OriginForTrace, Momentum;
	local float DamageMomentumMagnitude;

	AffectDirection = Add_RotatorRotator(Rotation, BackwardVectorOffset);
	MultiplyEqual_FloatFloat(DamageMomentumMagnitude, Divide_FloatFloat(Damage, Level.GetRepo().MomentumToDamageConversionFactor));
	foreach RadiusActors(Class'Engine.IReactToC2Detonation', Victim, FMax(StunRadius, DamageRadius))
	{
		VictimActor = Actor(Victim);
		if(AndAnd_BoolBool(AndAnd_BoolBool(Less_FloatFloat(VSize(Subtract_VectorVector(VictimActor.Location, Location)), StunRadius), PointWithinInfiniteCone(Location, Vector(AffectDirection), VictimActor.Location, Multiply_FloatFloat(StunAngle, 0.0174533))), Less_FloatFloat(Abs(Subtract_FloatFloat(VictimActor.Location.Z, Location.Z)), float(150))))
		{
			Victim.ReactToC2Detonation(self, StunRadius, StunDuration);
		}
		if(AndAnd_BoolBool(Less_FloatFloat(VSize(Subtract_VectorVector(VictimActor.Location, Location)), DamageRadius), PointWithinInfiniteCone(Location, Vector(AffectDirection), VictimActor.Location, Multiply_FloatFloat(DamageAngle, 0.0174533))))
		{
			OriginForTrace = Add_VectorVector(Location, Multiply_VectorFloat(Vector(AffectDirection), float(10)));
			if(FastTrace(VictimActor.Location, OriginForTrace))
			{
				Momentum = Multiply_FloatVector(DamageMomentumMagnitude, Normal(Subtract_VectorVector(VictimActor.Location, OriginForTrace)));
				VictimActor.TakeDamage(int(Damage), DeployedBy, VictimActor.Location, Momentum, Class'SwatGame.ConcussiveDamageType');
				continue;
			}
		}
	}
	return;
}

simulated function bool CanBeUsedByToolkitNow()
{
	return true;
	return;
}

function OnUsingByToolkitBegan(Pawn User)
{
	return;
}

function OnUsedByToolkit(Pawn User)
{
	GotoState('Removed');
	return;
}

function OnUsingByToolkitInterrupted(Pawn User)
{
	return;
}

simulated function bool isActive()
{
	return true;
	return;
}

simulated function float GetQualifyTimeForToolkit()
{
	return QualifyTimeForToolkit;
	return;
}

state Removed
{Begin:

	ICanUseC2Charge(DeployedBy).SetDeployedC2Charge(none);
	Hide();
	stop;
}

defaultproperties
{
	BackwardVectorOffset=(Pitch=0,Yaw=16384,Roll=0)
	CollisionRadius=6.0000000
	CollisionHeight=5.0000000
}