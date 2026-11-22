class EnemyArchetypeInstance extends CharacterArchetypeInstance;

var ISwatEnemy.EnemySkill Skill;
var bool InvestigatorOverride;
var FiredWeapon PrimaryWeapon;
var FiredWeapon BackupWeapon;
var Class<FiredWeapon> SelectedPrimaryWeaponClass;
var Class<FiredWeapon> SelectedBackupWeaponClass;
var Class<Ammunition> SelectedPrimaryWeaponAmmoClass;
var Class<Ammunition> SelectedBackupWeaponAmmoClass;

function DestroyEquipment()
{
	super.DestroyEquipment();
	if(NotEqual_ObjectObject(PrimaryWeapon, none))
	{
		PrimaryWeapon.Destroy();
	}
	if(NotEqual_ObjectObject(BackupWeapon, none))
	{
		BackupWeapon.Destroy();
	}
	return;
}
