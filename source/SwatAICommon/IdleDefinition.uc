class IdleDefinition extends Object within IdleActionsList
	config
	perobjectconfig;

enum EIdleCharacterType
{
	AllTypesIdle,                   // 0
	OnlyWeaponUsersIdle,            // 1
	EnemyIdle,                      // 2
	OfficerIdle,                    // 3
	HostageIdle                     // 4
};

enum EIdleTime
{
	IdleAnytimeExceptAiming,        // 0
	IdleAiming,                     // 1
	IdleAnytime                     // 2
};

enum EIdleCharacterAggression
{
	AggressionDoesNotMatter,        // 0
	PassiveCharactersOnly,          // 1
	AggressiveCharactersOnly        // 2
};

enum EIdleWeaponStatus
{
	IdleWeaponDoesNotMatter,        // 0
	IdleWithMachineGun,             // 1
	IdleWithG36,                    // 2
	IdleWithSubMachineGun,          // 3
	IdleWithUMP,                    // 4
	IdleWithHandgun,                // 5
	IdleWithShotgun,                // 6
	IdleWithPaintballGun,           // 7
	IdleWithGrenade,                // 8
	IdleWithAnyWeapon,              // 9
	IdleWithoutWeapon               // 10
};

enum ECharacterIdlePosition
{
	IdlePositionDoesNotMatter,      // 0
	IdleStanding,                   // 1
	IdleCrouching                   // 2
};

var config IdleDefinition.EIdleCharacterType IdleCharacterType;
var config IdleDefinition.EIdleTime IdleTime;
var config IdleDefinition.EIdleWeaponStatus IdleWeaponStatus;
var config IdleDefinition.ECharacterIdlePosition CharacterIdlePosition;
var config name IdleCategory;
var config IdleDefinition.EIdleCharacterAggression IdleCharacterAggression;
var config float Weight;
