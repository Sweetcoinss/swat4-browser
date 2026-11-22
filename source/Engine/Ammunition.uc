class Ammunition extends Actor implements ICanBeSelectedInTheGUI, IAmmunition
	abstract
	native
	config(SwatEquipment)
	notplaceable
	hidecategories(Karma);

var bool bInstantHit;
var Class<Projectile> ProjectileClass;
var(Ammo) config localized string Description;
var(Ammo) config localized string FriendlyName;
var(Ammo) config localized Material GUIImage;
var(Ammo) config int InternalDamage "Extra Damage imparted to an actor when a bullet gets buried in the actor.";
var(Ammo) config int ImpactMomentum "Amount by which the bullet's direction is scaled to create the physics impact momentum.";
var(Ammo) config int ShotsPerRound "The number of shots fired each time the weapon is used, eg. pellets for a shotgun";
var(Ammo) config bool RoundsNeverPenetrate "If true, then impact will always cause round to lose all momentum to its victim";

simulated function Initialize()
{
	return;
}

simulated function bool NeedsReload()
{
	assert(false);
	return false;
	return;
}

simulated function bool CanReload()
{
	assert(false);
	return false;
	return;
}

simulated function bool IsEmpty()
{
	assert(false);
	return false;
	return;
}

simulated function bool IsFull()
{
	assert(false);
	return false;
	return;
}

simulated function bool IsLastRound()
{
	assert(false);
	return false;
	return;
}

simulated function int RoundsRemainingBeforeReload()
{
	assert(false);
	return 0;
	return;
}

simulated function OnRoundUsed()
{
	assert(false);
	return;
}

simulated function OnReloaded()
{
	assert(false);
	return;
}

simulated function UpdateHUD()
{
	assert(false);
	return;
}

function string GetAmmoCountString()
{
	return;
}

static function string GetDescription()
{
	return default.Description;
	return;
}

static function string GetFriendlyName()
{
	return default.FriendlyName;
	return;
}

static function Material GetGUIImage()
{
	return default.GUIImage;
	return;
}

static function Class<Actor> GetRenderableActorClass()
{
	return default.Class;
	return;
}

simulated function int GetClip(int Index)
{
	assert(false);
	return 0;
	return;
}

simulated function SetClip(int Index, int amount)
{
	assert(false);
	return;
}

simulated function int GetCurrentClip()
{
	assert(false);
	return 0;
	return;
}

simulated function SetCurrentClip(int Clip)
{
	assert(false);
	return;
}

defaultproperties
{
	ShotsPerRound=1
	DrawType=0
	bStasis=true
	RemoteRole=0
}