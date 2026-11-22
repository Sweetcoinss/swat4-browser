class EnemyArchetype extends CharacterArchetype
	config(EnemyArchetypes)
	perobjectconfig;

struct EnemySkillChancePair
{
	var config ISwatEnemy.EnemySkill Skill;
	var config int Chance;
};

struct WeaponClipcountChanceSet
{
	var config string Weapon;
	var config int Chance;
};

var config array<EnemySkillChancePair> Skill;
var config array<WeaponClipcountChanceSet> PrimaryWeapon;
var config array<WeaponClipcountChanceSet> BackupWeapon;
var array< Class<FiredWeapon> > PrimaryWeaponClass;
var array< Class<FiredWeapon> > BackupWeaponClass;
var config bool InvestigatorOverride;
var config Class<Actor> actorClass;

function Initialize(Actor inOwner)
{
	local CustomScenario CustomScenario;

	CustomScenario = SwatGameInfo(inOwner.Level.Game).GetCustomScenario();
	if(NotEqual_ObjectObject(CustomScenario, none))
	{
		CustomScenario.MutateEnemyWeapons(PrimaryWeapon, CustomScenario.EnemyPrimaryWeaponOptions);
		CustomScenario.MutateEnemyWeapons(BackupWeapon, CustomScenario.EnemyBackupWeaponOptions);
	}
	InitializeEquipment(PrimaryWeapon, PrimaryWeaponClass, "Primary");
	InitializeEquipment(BackupWeapon, BackupWeaponClass, "Backup");
	super.Initialize(inOwner);
	return;
}

private final function InitializeEquipment(array<WeaponClipcountChanceSet> Weapons, out array< Class<FiredWeapon> > WeaponClasses, string Which)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Weapons.Length))
	{
		if(NotEqual_StrStr(Weapons[i].Weapon, ""))
		{
			WeaponClasses[i] = Class<FiredWeapon>(DynamicLoadObject(Weapons[i].Weapon, Class'Core.Class'));
			AssertWithDescription(NotEqual_ObjectObject(WeaponClasses[i], none), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] While initializing the enemy part of the ", string(Class.Name)), " instance named "), string(Name)), ", the class for "), Which), "Weapon option #"), string(i)), " ("), Weapons[i].Weapon), ")"), " couldn't be loaded."));
			// [Explicit Continue]
			goto J0x14D;
		}
		WeaponClasses[i] = none;
		J0x14D:

		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

protected function Validate()
{
	local bool PrimaryWeaponCanBeNone, BackupWeaponCanBeNone;
	local int i;

	super.Validate();
	ValidateCondition(Greater_IntInt(Skill.Length, 0), "AI's Skill is not set (Crombie says: Designers should set the skill for this archetype as soon as possible, or they will all be amateur criminals)");
	if(EqualEqual_IntInt(PrimaryWeapon.Length, 0))
	{
		PrimaryWeaponCanBeNone = true;
	}
	else
	{
		i = 0;
		J0xC7:

		if(Less_IntInt(i, PrimaryWeaponClass.Length))
		{
			if(EqualEqual_ObjectObject(PrimaryWeaponClass[i], none))
			{
				PrimaryWeaponCanBeNone = true;
			}
			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0xC7;
		}
	}
	if(EqualEqual_IntInt(BackupWeapon.Length, 0))
	{
		BackupWeaponCanBeNone = true;
	}
	else
	{
		i = 0;
		J0x118:

		if(Less_IntInt(i, BackupWeaponClass.Length))
		{
			if(EqualEqual_ObjectObject(BackupWeaponClass[i], none))
			{
				BackupWeaponCanBeNone = true;
			}
			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0x118;
		}
	}
	return;
}

function InitializeInstance(ArchetypeInstance inInstance)
{
	local EnemyArchetypeInstance Instance;

	Instance = EnemyArchetypeInstance(inInstance);
	super.InitializeInstance(Instance);
	InitializeSkill(Instance);
	Instance.InvestigatorOverride = InvestigatorOverride;
	InitializeWeapon(PrimaryWeapon, PrimaryWeaponClass, Instance.SelectedPrimaryWeaponClass, Instance.SelectedPrimaryWeaponAmmoClass, Instance.PrimaryWeapon, Instance);
	InitializeWeapon(BackupWeapon, BackupWeaponClass, Instance.SelectedBackupWeaponClass, Instance.SelectedBackupWeaponAmmoClass, Instance.BackupWeapon, Instance);
	return;
}

private function InitializeSkill(EnemyArchetypeInstance inInstance)
{
	local int i, TotalChance, RandChance, AccumulatedChance;

	assert(Greater_IntInt(Skill.Length, 0));
	i = 0;
	J0x13:

	if(Less_IntInt(i, Skill.Length))
	{
		AddEqual_IntInt(TotalChance, Skill[i].Chance);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x13;
	}
	RandChance = Rand(TotalChance);
	i = 0;
	J0x58:

	if(Less_IntInt(i, Skill.Length))
	{
		AddEqual_IntInt(AccumulatedChance, Skill[i].Chance);
		if(GreaterEqual_IntInt(AccumulatedChance, RandChance))
		{
			inInstance.Skill = Skill[i].Skill;
			// [Explicit Break]
			goto J0xBA;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x58;
	}
	J0xBA:

	return;
}

private function InitializeWeapon(array<WeaponClipcountChanceSet> Options, array< Class<FiredWeapon> > OptionClasses, out Class<FiredWeapon> theSelectedWeaponClass, out Class<Ammunition> theSelectedAmmoClass, out FiredWeapon Weapon, EnemyArchetypeInstance Instance)
{
	local int i, TotalChance, RandChance, AccumulatedChance;
	local Class<FiredWeapon> WeaponClass;

	if(EqualEqual_IntInt(Options.Length, 0))
	{
		return;
	}
	i = 0;
	J0x15:

	if(Less_IntInt(i, Options.Length))
	{
		AddEqual_IntInt(TotalChance, Options[i].Chance);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x15;
	}
	RandChance = Rand(TotalChance);
	i = 0;
	J0x5A:

	if(Less_IntInt(i, Options.Length))
	{
		AddEqual_IntInt(AccumulatedChance, Options[i].Chance);
		if(GreaterEqual_IntInt(AccumulatedChance, RandChance))
		{
			WeaponClass = OptionClasses[i];
			// [Explicit Break]
			goto J0xAE;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x5A;
	}
	J0xAE:

	if(NotEqual_ObjectObject(WeaponClass, none))
	{
		Weapon = Owner.Spawn(WeaponClass, Instance.Owner);
		Weapon.OnGivenToOwner();
	}
	theSelectedWeaponClass = WeaponClass;
	theSelectedAmmoClass = Weapon.AmmoClass;
	return;
}

function Class<Actor> PickClass()
{
	Log(Concat_StrStr("[ARCHETYPE] .. Class SwatEnemy selected to spawn from Archetype ", string(Name)));
	return actorClass;
	return;
}

defaultproperties
{
	actorClass=Class'SwatGame.SwatEnemy'
	CharacterType="EnemyMaleDefault"
	InstanceClass=Class'SwatGame.EnemyArchetypeInstance'
}