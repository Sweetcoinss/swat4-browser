class ClipBasedAmmo extends Ammunition
	config(SwatEquipment)
	hidecategories(Karma);

const MAX_CLIPS = 10;
const INVALID_CLIP = -2;

var(Ammo) config int ClipSize;
var(Ammo) config int DefaultEnemyClipCount;
var(Ammo) config int DefaultOfficerClipCount;
var private int ClipRoundsRemaining[10];
var private int CurrentClip;

replication
{
	// Pos:0x000
	reliable if(AndAnd_BoolBool(AndAnd_BoolBool(OrOr_BoolBool(Not_PreBool(bSkipActorPropertyReplication), bNetInitial), bReplicateMovement), OrOr_BoolBool(OrOr_BoolBool(AndAnd_BoolBool(EqualEqual_IntInt(int(RemoteRole), int(ROLE_AutonomousProxy)), bNetInitial), AndAnd_BoolBool(AndAnd_BoolBool(EqualEqual_IntInt(int(RemoteRole), int(ROLE_SimulatedProxy)), OrOr_BoolBool(bNetInitial, bUpdateSimulatedPosition)), OrOr_BoolBool(EqualEqual_ObjectObject(Base, none), Base.bWorldGeometry))), AndAnd_BoolBool(EqualEqual_IntInt(int(RemoteRole), int(ROLE_DumbProxy)), OrOr_BoolBool(EqualEqual_ObjectObject(Base, none), Base.bWorldGeometry)))))
		ClipRoundsRemaining, CurrentClip;
}

simulated function Initialize()
{
	local ClipBasedWeapon Weapon;
	local Pawn Pawn;
	local int ClipCount, i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, 10))
	{
		ClipRoundsRemaining[i] = -2;
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	Weapon = ClipBasedWeapon(Owner);
	assert(NotEqual_ObjectObject(Weapon, none));
	Pawn = Pawn(Weapon.Owner);
	assert(NotEqual_ObjectObject(Pawn, none));
	AssertWithDescription(Greater_IntInt(DefaultEnemyClipCount, 0), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] The ClipBasedAmmo ", string(Class.Name)), " is missing a DefaultEnemyClipCount.  Please set this in SwatEquipment.ini, section [SwatEquipment."), string(Class.Name)), "]"));
	assert(LessEqual_IntInt(DefaultEnemyClipCount, 10));
	AssertWithDescription(Greater_IntInt(DefaultOfficerClipCount, 0), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] The ClipBasedAmmo ", string(Class.Name)), " is missing a DefaultOfficerClipCount.  Please set this in SwatEquipment.ini, section [SwatEquipment."), string(Class.Name)), "]"));
	assert(LessEqual_IntInt(DefaultOfficerClipCount, 10));
	AssertWithDescription(Greater_IntInt(ClipSize, 0), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] The ClipBasedAmmo ", string(Class.Name)), " is missing a ClipSize.  Please set this in SwatEquipment.ini, section [SwatEquipment."), string(Class.Name)), "]"));
	if(Pawn.IsA('SwatEnemy'))
	{
		ClipCount = DefaultEnemyClipCount;
	}
	else
	{
		if(OrOr_BoolBool(OrOr_BoolBool(Pawn.IsA('SwatOfficer'), Pawn.IsA('SwatPlayer')), Pawn.IsA('SniperPawn')))
		{
			ClipCount = DefaultOfficerClipCount;
		}
		else
		{
			AssertWithDescription(false, Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] ClipBasedAmmo::Initialize() (class ", string(Class.Name)), ") expected Pawn Owner to be a SwatEnemy, SwatPlayer, SniperPawn, or SwatOfficer, but "), string(Pawn.Name)), " (class "), string(Pawn.Class)), ") is none of those. (Owner Weapon is "), string(Weapon)), ")"));
		}
	}
	i = 0;
	J0x429:

	if(Less_IntInt(i, ClipCount))
	{
		ClipRoundsRemaining[i] = ClipSize;
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x429;
	}
	return;
}

simulated function bool IsEmpty()
{
	return EqualEqual_IntInt(FullestClip(), -1);
	return;
}

simulated function bool IsFull()
{
	return EqualEqual_IntInt(ClipRoundsRemaining[CurrentClip], ClipSize);
	return;
}

simulated function bool IsLastRound()
{
	return EqualEqual_IntInt(ClipRoundsRemaining[CurrentClip], 1);
	return;
}

simulated function bool CanReload()
{
	return Greater_IntInt(FullestClip(), -1);
	return;
}

simulated function int FullestClip()
{
	local int i, Max, Clip;

	Clip = -1;
	i = 0;
	J0x12:

	if(AndAnd_BoolBool(Less_IntInt(i, 10), NotEqual_IntInt(ClipRoundsRemaining[i], -2)))
	{
		if(Greater_IntInt(ClipRoundsRemaining[i], Max))
		{
			Max = ClipRoundsRemaining[i];
			Clip = i;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x12;
	}
	return Clip;
	return;
}

simulated function bool NeedsReload()
{
	assert(AndAnd_BoolBool(GreaterEqual_IntInt(ClipRoundsRemaining[CurrentClip], 0), LessEqual_IntInt(ClipRoundsRemaining[CurrentClip], ClipSize)));
	return EqualEqual_IntInt(ClipRoundsRemaining[CurrentClip], 0);
	return;
}

simulated function OnRoundUsed()
{
	AssertWithDescription(Greater_IntInt(ClipRoundsRemaining[CurrentClip], 0), "[tcohen] ClipBasedAmmo::OnRoundUsed() tried to use a round, but the current clip is empty.");
	SubtractSubtract_Int(ClipRoundsRemaining[CurrentClip]);
	if(AndAnd_BoolBool(Level.IsTraining, IsEmpty()))
	{
		TrainingRefill();
	}
	UpdateHUD();
	return;
}

simulated function int GetCurrentClip()
{
	return CurrentClip;
	return;
}

simulated function SetCurrentClip(int Clip)
{
	CurrentClip = Clip;
	return;
}

simulated function OnReloaded()
{
	local int NewClip;

	AssertWithDescription(Not_PreBool(IsEmpty()), "[tcohen] ClipBasedAmmo::OnReloaded() tried to reload, but it is empty.");
	NewClip = FullestClip();
	assert(Greater_IntInt(NewClip, -1));
	CurrentClip = NewClip;
	UpdateHUD();
	return;
}

simulated function UpdateHUD()
{
	local SwatGamePlayerController LPC;

	LPC = SwatGamePlayerController(Level.GetLocalPlayerController());
	if(NotEqual_ObjectObject(Pawn(Owner.Owner).Controller, LPC))
	{
		return;
	}
	LPC.GetHUDPage().AmmoStatus.SetWeaponStatus(self);
	return;
}

function int GetMagazineSize()
{
	return ClipSize;
	return;
}

function int GetClipCount()
{
	return DefaultOfficerClipCount;
	return;
}

simulated function int GetClip(int Index)
{
	return ClipRoundsRemaining[Index];
	return;
}

simulated function SetClip(int Index, int amount)
{
	ClipRoundsRemaining[Index] = amount;
	return;
}

simulated function int RoundsRemainingBeforeReload()
{
	return GetClip(CurrentClip);
	return;
}

function string GetAmmoCountString()
{
	return Concat_StrStr(Concat_StrStr(string(GetClip(GetCurrentClip())), "/"), string(GetMagazineSize()));
	return;
}

function TrainingRefill()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, DefaultOfficerClipCount))
	{
		if(NotEqual_IntInt(i, CurrentClip))
		{
			ClipRoundsRemaining[i] = ClipSize;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}
