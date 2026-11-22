class DamageCategory extends Actor implements DamageType
	abstract
	config(SwatEquipment)
	notplaceable
	hidecategories(Karma,Advanced,Collision,Events,Force,LightColor,Lighting,Movement,Object,Sound,Display);

var localized string DeathString;
var localized string FemaleSuicide;
var localized string MaleSuicide;
var float ViewFlash;
var Vector ViewFog;
var Class<Effects> DamageEffect;
var string DamageWeaponName;
var bool bArmorStops;
var bool bInstantHit;
var bool bFastInstantHit;
var bool bAlwaysGibs;
var bool bNoSpecificLocation;
var bool bSkeletize;
var bool bCausesBlood;
var bool bKUseOwnDeathVel;
var float GibModifier;
var Class<Effects> PawnDamageEffect;
var Class<Emitter> PawnDamageEmitter;
var array<Sound> PawnDamageSounds;
var Class<Effects> LowGoreDamageEffect;
var Class<Emitter> LowGoreDamageEmitter;
var array<Sound> LowGoreDamageSounds;
var Class<Effects> LowDetailEffect;
var Class<Emitter> LowDetailEmitter;
var float FlashScale;
var Vector FlashFog;
var int DamageDesc;
var int DamageThreshold;
var Vector DamageKick;
var float KDamageImpulse;
var float KDeathVel;
var float KDeathUpKick;
var float hkHitImpulseScale;
var private config float RagdollDeathImpactMomentumMultiplier;

static function IncrementKills(Controller Killer)
{
	return;
}

static function string DeathMessage(PlayerReplicationInfo Killer, PlayerReplicationInfo Victim)
{
	return default.DeathString;
	return;
}

static function string SuicideMessage(PlayerReplicationInfo Victim)
{
	if(Victim.bIsFemale)
	{
		return default.FemaleSuicide;
	}
	else
	{
		return default.MaleSuicide;
	}
	return;
}

static function Class<Effects> GetPawnDamageEffect(Vector HitLocation, float Damage, Vector Momentum, Pawn Victim, bool bLowDetail)
{
	if(Class'Engine.GameInfo'.static.UseLowGore())
	{
		if(NotEqual_ObjectObject(default.LowGoreDamageEffect, none))
		{
			return default.LowGoreDamageEffect;
		}
		else
		{
			return Victim.LowGoreBlood;
		}
	}
	else
	{
		if(bLowDetail)
		{
			if(NotEqual_ObjectObject(default.LowDetailEffect, none))
			{
				return default.LowDetailEffect;
			}
			else
			{
				return Victim.BloodEffect;
			}
		}
		else
		{
			if(NotEqual_ObjectObject(default.PawnDamageEffect, none))
			{
				return default.PawnDamageEffect;
			}
			else
			{
				return Victim.BloodEffect;
			}
		}
	}
	return;
}

static function Class<Emitter> GetPawnDamageEmitter(Vector HitLocation, float Damage, Vector Momentum, Pawn Victim, bool bLowDetail)
{
	if(Class'Engine.GameInfo'.static.UseLowGore())
	{
		if(NotEqual_ObjectObject(default.LowGoreDamageEmitter, none))
		{
			return default.LowGoreDamageEmitter;
		}
		else
		{
			return none;
		}
	}
	else
	{
		if(bLowDetail)
		{
			if(NotEqual_ObjectObject(default.LowDetailEmitter, none))
			{
				return default.LowDetailEmitter;
			}
			else
			{
				return none;
			}
		}
		else
		{
			if(NotEqual_ObjectObject(default.PawnDamageEmitter, none))
			{
				return default.PawnDamageEmitter;
			}
			else
			{
				return none;
			}
		}
	}
	return;
}

static function Sound GetPawnDamageSound()
{
	if(Class'Engine.GameInfo'.static.UseLowGore())
	{
		if(Greater_IntInt(default.LowGoreDamageSounds.Length, 0))
		{
			return default.LowGoreDamageSounds[Rand(default.LowGoreDamageSounds.Length)];
		}
		else
		{
			return none;
		}
	}
	else
	{
		if(Greater_IntInt(default.PawnDamageSounds.Length, 0))
		{
			return default.PawnDamageSounds[Rand(default.PawnDamageSounds.Length)];
		}
		else
		{
			return none;
		}
	}
	return;
}

static function bool IsOfType(int Description)
{
	local int Result;

	Result = And_IntInt(Description, default.DamageDesc);
	return EqualEqual_IntInt(Result, Description);
	return;
}

static function string GetWeaponClass()
{
	return "";
	return;
}

static function string GetFriendlyName()
{
	return default.DeathString;
	return;
}

static function float GetRagdollDeathImpactMomentumMultiplier()
{
	return default.RagdollDeathImpactMomentumMultiplier;
	return;
}

defaultproperties
{
	DeathString="%o was killed by %k."
	FemaleSuicide="%o killed herself."
	MaleSuicide="%o killed himself."
	bArmorStops=true
	bCausesBlood=true
	GibModifier=1.0000000
	FlashScale=0.5000000
	FlashFog=(X=900.0000000,Y=0.0000000,Z=0.0000000)
	DamageDesc=1
	KDamageImpulse=8000.0000000
	hkHitImpulseScale=1.0000000
	RagdollDeathImpactMomentumMultiplier=30.0000000
}