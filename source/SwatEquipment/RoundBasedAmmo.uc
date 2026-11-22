class RoundBasedAmmo extends Ammunition
	config(SwatEquipment)
	hidecategories(Karma);

var(Ammo) config int DefaultEnemyRounds;
var(Ammo) config int DefaultOfficerRounds;
var int CurrentRounds;
var int ReserveRounds;

replication
{
	// Pos:0x000
	reliable if(AndAnd_BoolBool(bNetInitial, EqualEqual_IntInt(int(Role), int(ROLE_Authority))))
		CurrentRounds, ReserveRounds;
}

simulated function Initialize()
{
	local RoundBasedWeapon Weapon;
	local Pawn Pawn;

	super.Initialize();
	Weapon = RoundBasedWeapon(Owner);
	assert(NotEqual_ObjectObject(Weapon, none));
	Pawn = Pawn(Weapon.Owner);
	assert(NotEqual_ObjectObject(Pawn, none));
	if(Pawn.IsA('SwatEnemy'))
	{
		ReserveRounds = DefaultEnemyRounds;
	}
	else
	{
		if(OrOr_BoolBool(Pawn.IsA('SwatOfficer'), Pawn.IsA('SwatPlayer')))
		{
			ReserveRounds = DefaultOfficerRounds;
		}
		else
		{
			AssertWithDescription(false, Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] RoundBasedAmmo::Initialize() (class ", string(Class.Name)), ") expected Pawn Owner to be either a SwatEnemy or a SwatOfficer, but "), string(Pawn)), " is neither. (Owner Weapon is "), string(Weapon)), ")"));
		}
	}
	AssertWithDescription(GreaterEqual_IntInt(ReserveRounds, Weapon.MagazineSize), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] RoundBasedAmmo::Initialize() (class ", string(Class.Name)), ") can't fill "), string(Weapon)), "'s Magazine. MagazineSize is "), string(Weapon.MagazineSize)), ", but the ammo only has "), string(ReserveRounds)), " rounds."));
	CurrentRounds = Weapon.MagazineSize;
	SubtractEqual_IntInt(ReserveRounds, CurrentRounds);
	return;
}

simulated function bool IsEmpty()
{
	return AndAnd_BoolBool(EqualEqual_IntInt(CurrentRounds, 0), EqualEqual_IntInt(ReserveRounds, 0));
	return;
}

simulated function bool IsFull()
{
	local RoundBasedWeapon Weapon;

	Weapon = RoundBasedWeapon(Owner);
	assert(NotEqual_ObjectObject(Weapon, none));
	return EqualEqual_IntInt(CurrentRounds, Weapon.MagazineSize);
	return;
}

simulated function bool IsLastRound()
{
	return EqualEqual_IntInt(CurrentRounds, 1);
	return;
}

simulated function bool CanReload()
{
	return Greater_IntInt(ReserveRounds, 0);
	return;
}

simulated function bool NeedsReload()
{
	local RoundBasedWeapon Weapon;

	Weapon = RoundBasedWeapon(Owner);
	assert(NotEqual_ObjectObject(Weapon, none));
	assert(LessEqual_IntInt(CurrentRounds, Weapon.MagazineSize));
	return EqualEqual_IntInt(CurrentRounds, 0);
	return;
}

simulated function int RoundsRemainingBeforeReload()
{
	return GetCurrentRounds();
	return;
}

simulated function OnRoundUsed()
{
	AssertWithDescription(Greater_IntInt(CurrentRounds, 0), "[tcohen] RoundBasedAmmo::OnRoundUsed() tried to use a round, but the magazine is empty.");
	SubtractSubtract_Int(CurrentRounds);
	UpdateHUD();
	return;
}

simulated function OnReloaded()
{
	local RoundBasedWeapon Weapon;

	Weapon = RoundBasedWeapon(Owner);
	assert(NotEqual_ObjectObject(Weapon, none));
	AssertWithDescription(Greater_IntInt(ReserveRounds, 0), "[tcohen] RoundBasedAmmo::OnReloaded() tried to reload, but it is empty.");
	if(EqualEqual_IntInt(CurrentRounds, Weapon.MagazineSize))
	{
		return;
	}
	AddAdd_Int(CurrentRounds);
	if(Not_PreBool(Level.IsTraining))
	{
		SubtractSubtract_Int(ReserveRounds);
	}
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

function int GetCurrentRounds()
{
	return CurrentRounds;
	return;
}

function int GetMagazineSize()
{
	local RoundBasedWeapon Weapon;

	Weapon = RoundBasedWeapon(Owner);
	assert(NotEqual_ObjectObject(Weapon, none));
	return Weapon.MagazineSize;
	return;
}

function int GetReserveRounds()
{
	return ReserveRounds;
	return;
}

function int GetInitialReserveRounds()
{
	return Subtract_IntInt(DefaultOfficerRounds, GetMagazineSize());
	return;
}

simulated function int GetClip(int Index)
{
	if(EqualEqual_IntInt(Index, 0))
	{
		return CurrentRounds;
	}
	else
	{
		if(EqualEqual_IntInt(Index, 1))
		{
			return ReserveRounds;
		}
	}
	return 0;
	return;
}

simulated function SetClip(int Index, int amount)
{
	if(EqualEqual_IntInt(Index, 0))
	{
		CurrentRounds = amount;
	}
	else
	{
		if(EqualEqual_IntInt(Index, 1))
		{
			ReserveRounds = amount;
		}
	}
	return;
}

simulated function int GetCurrentClip()
{
	return -1;
	return;
}

simulated function SetCurrentClip(int Clip)
{
	return;
}
